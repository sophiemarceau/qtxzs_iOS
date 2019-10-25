//
//  ConnectLisstViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/21.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ConnectLisstViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"
#import "MMSelectedPath.h"
#import "noWifiView.h"
#import "ZeroView.h"
#import "BaseTableView.h"
#import "MyConnectTableViewCell.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "MyConnectDetailViewController.h"

@interface ConnectLisstViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    ZeroView *nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;
    NSDictionary *dto;
    double balance;
    NSDictionary  *authdto;
    UIView *nocontentView;
    NSArray *_dataArray;
    
    
    
    
    
    NSString *_sil_level;
    NSString *_contribution_type;
    NSString *_contribution_sum;
    NSString *_invitation_count;
    NSString *_report_count;
    NSString *_signedup_count;
    NSString *_sortType;
    NSString *_sort_desc_or_asc;
    NSString *_sil_createdtime;
    
    BOOL FromTableSelect;
}
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;
@property (nonatomic, strong) UIButton *directButton;
@property (nonatomic, strong) UIView *tableviewHeader;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, assign) BOOL flag;
@end

@implementation ConnectLisstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initdata];
    
    [self initNavBarView];
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"人脉"];
    rootItem1.menuflag = 1;
    NSArray *tempArray1 =@[
                           @{@"code":@"",@"value":@"全部人脉"},
                           @{@"code":@"1",@"value":@"一级人脉"},
                           @{@"code":@"2",@"value":@"二级人脉"},
                           @{@"code":@"3",@"value":@"三级人脉"},
                           ] ;
    NSArray *arr1 = @[
                      @{@"所在人脉":tempArray1},
                      ];
    for (NSDictionary *itemDic in arr1) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem1 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            //            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"]]];
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"贡献"];
    rootItem2.menuflag = 1;
    NSArray *tempArray20 =@[
                           @{@"code":@"1",@"value":@"本人贡献"},
                           @{@"code":@"2",@"value":@"下级人脉贡献"},
                           @{@"code":@"3",@"value":@"累计贡献"},
                           ] ;
    NSArray *tempArray21 =@[
                            @{@"code":@"",@"value":@"不限金额"},
                            @{@"code":@"1",@"value":@"100以内"},
                            @{@"code":@"2",@"value":@"100-500"},
                            @{@"code":@"3",@"value":@"500-5000"},
                            @{@"code":@"4",@"value":@"5000以上"},
                            ] ;
    NSArray *tempArray22 =@[
                            @{@"code":@"",@"value":@"不限人数"},
                            @{@"code":@"1",@"value":@"1-5人"},
                            @{@"code":@"2",@"value":@"5-15人"},
                            @{@"code":@"3",@"value":@"15-30人"},
                            @{@"code":@"4",@"value":@"30人以上"},
                            ] ;
    NSArray *tempArray23 =@[
                            @{@"code":@"",@"value":@"不限数量"},
                            @{@"code":@"1",@"value":@"0"},
                            @{@"code":@"2",@"value":@"1-5"},
                            @{@"code":@"3",@"value":@"5-10"},
                            @{@"code":@"4",@"value":@"10-20"},
                            @{@"code":@"5",@"value":@"20以上"},
                            ] ;
    NSArray *tempArray24 =@[
                            @{@"code":@"",@"value":@"不限数量"},
                            @{@"code":@"1",@"value":@"0"},
                            @{@"code":@"2",@"value":@"1-5"},
                            @{@"code":@"3",@"value":@"5-10"},
                            @{@"code":@"4",@"value":@"10-20"},
                            @{@"code":@"5",@"value":@"20以上"},
                            ] ;

    
    NSArray *arr2= @[
                     @{@"贡献类型":tempArray20},
                     @{@"贡献赏金（元）":tempArray21},
                     @{@"贡献邀请人数":tempArray22},
                     @{@"贡献通过推荐数":tempArray23},
                     @{@"贡献签约数":tempArray24},
                     ];
    for (NSDictionary *itemDic in arr2) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem2 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            //            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"]]];
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    //fourth root
    MMItem *rootItem4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"时间"];
    rootItem4.menuflag = 1;
    NSArray *tempArray =@[
                          @{@"code":@"",@"value":@"全部时间"},
                          @{@"code":@"1",@"value":@"近7天"},
                          @{@"code":@"2",@"value":@"近1个月"},
                          @{@"code":@"3",@"value":@"近3个月"},
                          ] ;
    NSArray *arr4 = @[
                      @{@"注册时间":tempArray},
                      ];
    for (NSDictionary *itemDic in arr4) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem4 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            //            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"]]];
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    self.mutableArray = [NSMutableArray array];
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    [self.mutableArray addObject:rootItem4];
    
    self.comBoBoxView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
    self.comBoBoxView.dataSource = self;
    self.comBoBoxView.delegate = self;
    [self.view addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    
    self.flag = YES;
    
    [self initSortedMenuview];
    [self initTableView];
    [self loadListData];
}

-(void)initSortedMenuview{
    /**
     *  这些数据是菜单显示的图片名称和菜单文字，请各位大牛指教，如果有更好的方法：
     *  e-mail : KongPro@163.com，喜欢请在github上点颗星星，不胜感激！ 🙏
     *  GitHub : https://github.com/KongPro/PopMenuTableView
     */
    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
                            @"itemName" : @"赏金额度"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_recall",
                            @"itemName" : @"注册时间"
                            };
    //    NSDictionary *dict3 = @{@"imageName" : @"icon_button_record",
    //                             @"itemName" : @"记录"
    //                            };
    NSArray *dataArray = @[dict1,dict2
                           //                           ,dict3
                           ];
    _dataArray = dataArray;
    
    
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView clearMenu];

    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag,NSString *selectFlag) {
        
        _sort_desc_or_asc = selectFlag ;
        _sortType = [NSString stringWithFormat:@"%ld",tag];
        //        NSLog(@"_sortType---------->%@----------------selelctFlag------%@,",_sortType,_sort_desc_or_asc);
        [myTableView.foot endRefreshing];
        [CommonMenuView hidden];
        [self loadListData];
        self.directButton.selected = !self.directButton.selected;
    } backViewTap:^{
//        weakSelf.flag = YES; // 这里的目的是，让rightButton点击，可再次pop出menu
        self.directButton.selected = !self.directButton.selected;
    }];

}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    _sil_level =@"";
    _contribution_type  =@"1";
    _contribution_sum=@"";
    _invitation_count=@"";
    _report_count=@"";
    _signedup_count=@"";
    _sortType=@"";
    _sil_createdtime=@"";
    _sort_desc_or_asc = @"1";//DESC("1", "降序"), ASC("2", "升序");
}

-(void)initTableView{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+self.comBoBoxView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView = self.tableviewHeader;
    myTableView.rowHeight = 136/2*AUTO_SIZE_SCALE_X+1;
    myTableView.tableHeaderView = self.tableviewHeader;
    [myTableView registerClass:[MyConnectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyConnectTableViewCell class])];
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+self.comBoBoxView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    nocontent = [[ZeroView alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y+30*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height-30*AUTO_SIZE_SCALE_X)];
    nocontent.noContentLabel.text = @"您没有符合筛选条件的用户，请重新筛选";
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadListData];
}

-(void)loadListData{
    
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"_sil_level":_sil_level,
                          @"_contribution_type":_contribution_type,
                          @"_contribution_sum":_contribution_sum,
                          @"_invitation_count":_invitation_count,
                          @"_report_count":_report_count,
                          @"_signedup_count":_signedup_count,
                          @"_sortType":_sortType,
                          @"_sil_createdtime":_sil_createdtime,
                          @"_sort_desc_or_asc":_sort_desc_or_asc,

                          };
    
    [[RequestManager shareRequestManager] SearchConnectionDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                [self returnlable:self.headerTitleLabel WithString:[NSString stringWithFormat:@"%d",total_count] Withindex:[@"当前筛选人数：" length] WithDocument:@"当前筛选人数：" WithDoc1:@" 人"];
                self.headerTitleLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 30*AUTO_SIZE_SCALE_X);
                if(![array isEqual:[NSNull null]] && array !=nil)
                {
                    [data addObjectsFromArray:array];
                    
                }else{
                    
                }

                if (data.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
              
                [myTableView reloadData];
                failView.hidden = YES;
                if (data.count == total_count || total_count == 0) {
                    
                    [myTableView.foot finishRefreshing];
                }
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
        nocontent.hidden = YES;
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
        [self loadListData];
        return;
    }
    else{
        current_page ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          @"_sil_level":_sil_level,
                          @"_contribution_type":_contribution_type,
                          @"_contribution_sum":_contribution_sum,
                          @"_invitation_count":_invitation_count,
                          @"_report_count":_report_count,
                          @"_signedup_count":_signedup_count,
                          @"_sortType":_sortType,
                          @"_sil_createdtime":_sil_createdtime,
                          @"_sort_desc_or_asc":_sort_desc_or_asc,
                          };
    
    [[RequestManager shareRequestManager] SearchConnectionDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        failView.hidden = YES;
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            [self returnlable:self.headerTitleLabel WithString:[NSString stringWithFormat:@"%d",total_count] Withindex:[@"当前筛选人数：" length] WithDocument:@"当前筛选人数：" WithDoc1:@" 人"];
            self.headerTitleLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 30*AUTO_SIZE_SCALE_X);
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [data removeAllObjects];
            }
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];
            }else{
            }
            [myTableView reloadData];
            
            [refreshView endRefreshing];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [myTableView.head endRefreshing];
            }
            if (data.count == total_count) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            [refreshView endRefreshing];
        }
    } failuer:^(NSError *error) {
        [refreshView endRefreshing];
        failView.hidden = NO;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyConnectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyConnectTableViewCell class]) forIndexPath:indexPath];
    
    if (data.count > 0) {
        cell.dictionary = data[indexPath.row];
        if(indexPath.row == data.count -1 ||data.count == 1){
            cell.lineImageView.hidden = YES;
        }else{
            cell.lineImageView.hidden = NO;
        }
    }
    
    return cell;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 1;
    
    label.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyConnectDetailViewController * vc = [[MyConnectDetailViewController alloc] init];
    vc.titles =@"用户详情";
    
    vc.sil_id = [NSString stringWithFormat:@"%d",[[data[indexPath.row] objectForKey:@"sil_id"] intValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}


#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *rootItem = self.mutableArray[index];
    switch (rootItem.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeMultilayer:{
            //拼接选择项
            NSMutableString *title = [NSMutableString string];
            __block NSInteger firstPath;
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                [title appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findTitleBySelectedPath:path]]:[rootItem findTitleBySelectedPath:path]];
                if (idx == 0) {
                    firstPath = path.firstPath;
                }
            }];
//            NSLog(@"当title为%@时，所选字段为 %@",rootItem.title ,title);
            break;}
        case MMPopupViewDisplayTypeFilters:{
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                //当displayType为MMPopupViewDisplayTypeFilters时有MMAlternativeItem类型和MMItem类型两种
                if (path.isKindOfAlternative == YES) { //MMAlternativeItem类型
                    MMAlternativeItem *alternativeItem = rootItem.alternativeArray[path.firstPath];
//                    NSLog(@"当title为%@时，选中状态为 %d",alternativeItem.title,alternativeItem.isSelected);
                } else {
                    MMItem *firstItem = rootItem.childrenNodes[path.firstPath];
                    MMItem *SecondItem = rootItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    if ([firstItem.title isEqualToString:@"所在人脉"]) {
                        _sil_level = SecondItem.code ;
                    }
                    
                    if ([firstItem.title isEqualToString:@"贡献类型"]) {
                        _contribution_type = SecondItem.code ;
                    }
                    if ([firstItem.title isEqualToString:@"贡献赏金（元）"]) {
                        _contribution_sum = SecondItem.code ;
                    }
                    if ([firstItem.title isEqualToString:@"贡献邀请人数"]) {
                        _invitation_count = SecondItem.code ;
                        
                    }
                    if ([firstItem.title isEqualToString:@"贡献通过推荐数"]) {
                        _report_count = SecondItem.code ;
                    }
                    if ([firstItem.title isEqualToString:@"贡献签约数"]) {
                        _signedup_count = SecondItem.code ;
                    }
                    if ([firstItem.title isEqualToString:@"注册时间"]) {
                        _sil_createdtime = SecondItem.code ;
                    }
                    [myTableView.foot endRefreshing];

                    if (idx == array.count-1) {
                        [self loadListData];
                    }

                }
            }];
            break;}
        default:
            break;
    }
}

-(UIView *)tableviewHeader{
    if (_tableviewHeader ==nil) {
        self.tableviewHeader = [UIView new];
        self.tableviewHeader.frame = CGRectMake(0, 0, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
        self.tableviewHeader.backgroundColor = BGColorGray;
        [self.tableviewHeader addSubview:self.headerTitleLabel];
        
    }
    return _tableviewHeader;
}


-(UILabel *)headerTitleLabel{
    if (_headerTitleLabel == nil) {
        self.headerTitleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        self.headerTitleLabel.textColor = FontUIColorBlack;
        
    }
    return _headerTitleLabel;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"排序方式" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _directButton;
}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

#pragma mark -- Nav上的四个button
-(void)dButtonClick{
    [MobClick event:kConnectListSortedEvent];
    [self.comBoBoxView dimissPopView];
    
    [self popMenu:CGPointMake(self.directButton.frame.origin.x+45*AUTO_SIZE_SCALE_X, kNavHeight)];
    self.directButton.enabled = YES;
}

//-(void)dealloc{
//    [CommonMenuView clearMenu];   // 移除菜单
//}

- (void)popMenu:(CGPoint)point{
    self.directButton.enabled = NO;
    self.directButton.selected = !self.directButton.selected;
    if (self.directButton.selected) {
        [CommonMenuView showMenuAtPoint:point];
    }else{
        [CommonMenuView hidden];
        
    }
    
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:touch.view];
//    [CommonMenuView showMenuAtPoint:point];
//}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [MobClick beginLogPageView:kMyconnectListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.comBoBoxView dimissPopView];
    
    
    [MobClick endLogPageView:kMyconnectListPage];
    
}

@end
