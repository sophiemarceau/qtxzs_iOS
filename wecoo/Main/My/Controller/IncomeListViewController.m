//
//  IncomeListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/21.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "IncomeListViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"
#import "MMSelectedPath.h"
#import "noWifiView.h"
#import "noContent.h"
#import "BaseTableView.h"
#import "MyConnectTableViewCell.h"
#import "ZeroView.h"
@interface IncomeListViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate>{
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
    
    
    
    
    NSString *_sil_level;
    NSString *_sal_partner_income_kind;
    NSString *_sal_createdtime;
    
}

@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;

@property(nonatomic,strong)UIView *tableviewHeader;
@property(nonatomic,strong)UILabel *headerTitleLabel;
@end

@implementation IncomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initdata];
    [self loadListData];
    //===============================================Package Data===============================================
    //first root
//    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
//    rootItem1.selectedType = MMPopupViewSingleSelection;
//    //    MMPopupViewMultilSeMultiSelection;
//    //first floor
//    for (int i = 0; i < 20; i ++) {
//        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
//    }
//    //second root
//    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"排序"];
//    //first floor
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
//    //third root
//    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
//    for (int i = 0; i < 30; i++){
//        MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d",i]];
//        [rootItem3 addNode:item3_A];
//        for (int j = 0; j < random()%30; j ++) {
//            if (i == 0 &&j == 0) {
//                [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
//            }else{
//                [item3_A addNodeWithoutMark:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
//            }
//        }
//    }
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"人脉"];
    //    rootItem4.menuflag =1;
    //    MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看免预约" isSelected:NO];
    //    MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"节假日可用" isSelected:YES];
    //    [rootItem4.alternativeArray addObject:alternativeItem1];
    //    [rootItem4.alternativeArray addObject:alternativeItem2];
    rootItem1.menuflag = 1;
    //    {@"value":@"110000",@"text":@"北京市"
    //    };
    NSArray *tempArray1 =@[
                          @{@"code":@"",@"value":@"全部人脉"},
                          @{@"code":@"1",@"value":@"一级人脉"},
                          @{@"code":@"2",@"value":@"二级人脉"},
                          @{@"code":@"3",@"value":@"三级人脉"},
                          ] ;
    NSArray *arr1 = @[
                     @{@"所在人脉":tempArray1},
                     
                     
                     //                     @{@"用餐时段":@[@"不限",@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"]},
                     //                     @{@"用餐人数":@[@"不限",@"单人餐",@"双人餐",@"3~4人餐",@"5~10人餐",@"10人以上",@"代金券",@"其他"]},
                     //                     @{@"餐厅服务":@[@"不限",@"优惠买单",@"在线点餐",@"外卖送餐",@"预定",@"食客推荐",@"在线排队"]}
                     ];
    
    for (NSDictionary *itemDic in arr1) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem1 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            //            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"]]];
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"类型"];
    //    rootItem4.menuflag =1;
    //    MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看免预约" isSelected:NO];
    //    MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"节假日可用" isSelected:YES];
    //    [rootItem4.alternativeArray addObject:alternativeItem1];
    //    [rootItem4.alternativeArray addObject:alternativeItem2];
    rootItem2.menuflag = 1;
    //    {@"value":@"110000",@"text":@"北京市"
    //    };
    NSArray *tempArray2 =@[
                           @{@"code":@"",@"value":@"全部类型"},
                           @{@"code":@"1",@"value":@"推荐通过"},
                           @{@"code":@"2",@"value":@"签约成功"},
                           @{@"code":@"3",@"value":@"活动奖励"},
                           
                           
                           ] ;
    NSArray *arr2= @[
                      @{@"赏金类型":tempArray2},
                      
                      
                      //                     @{@"用餐时段":@[@"不限",@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"]},
                      //                     @{@"用餐人数":@[@"不限",@"单人餐",@"双人餐",@"3~4人餐",@"5~10人餐",@"10人以上",@"代金券",@"其他"]},
                      //                     @{@"餐厅服务":@[@"不限",@"优惠买单",@"在线点餐",@"外卖送餐",@"预定",@"食客推荐",@"在线排队"]}
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
    //    rootItem4.menuflag =1;
    //    MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看免预约" isSelected:NO];
    //    MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"节假日可用" isSelected:YES];
    //    [rootItem4.alternativeArray addObject:alternativeItem1];
    //    [rootItem4.alternativeArray addObject:alternativeItem2];
    rootItem4.menuflag = 1;
    //    {@"value":@"110000",@"text":@"北京市"
    //    };
    NSArray *tempArray =@[
                          @{@"code":@"",@"value":@"全部时间"},
                          @{@"code":@"1",@"value":@"近7天"},
                          @{@"code":@"2",@"value":@"近1个月"},
                          @{@"code":@"3",@"value":@"近三个月"},
                          ] ;
    NSArray *arr4 = @[
                     @{@"赏金时间":tempArray},
                     
                     
                     //                     @{@"用餐时段":@[@"不限",@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"]},
                     //                     @{@"用餐人数":@[@"不限",@"单人餐",@"双人餐",@"3~4人餐",@"5~10人餐",@"10人以上",@"代金券",@"其他"]},
                     //                     @{@"餐厅服务":@[@"不限",@"优惠买单",@"在线点餐",@"外卖送餐",@"预定",@"食客推荐",@"在线排队"]}
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
    //    [self.mutableArray addObject:rootItem3];
    [self.mutableArray addObject:rootItem4];
    
    self.comBoBoxView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
    self.comBoBoxView.dataSource = self;
    self.comBoBoxView.delegate = self;
    [self.view addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    [self initTableView];
    
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    _sil_level =@"";
    _sal_partner_income_kind = @"";
    _sal_createdtime=@"";
    
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
    if (self.ZeroFlag) {
        nocontent.noContentLabel.text = @"您当前的人脉收益为0，通知您的人脉尽快去推荐吧";
    }else{
        nocontent.noContentLabel.text = @"没有符合筛选条件的收益流水，请重新筛选";
    }
    
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadListData];
}
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic = @{
                          @"_sil_level":_sil_level,
                          @"_sal_partner_income_kind":_sal_partner_income_kind,
                          @"_sal_createdtime":_sal_createdtime
                          };
    [[RequestManager shareRequestManager] GetMyContributionSumByLevelAndKindResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                NSString *sumStr =[NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
            
                [self returnlable:self.headerTitleLabel WithString:sumStr  Withindex:[@"当前筛选收益：" length] WithDocument:@"当前筛选收益：" WithDoc1:@"元"];
            }
            failView.hidden = YES;
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];
}

-(void)loadListData{
    [myTableView.head endRefreshing];
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"_sil_level":_sil_level,
                          @"_sal_partner_income_kind":_sal_partner_income_kind,
                          @"_sal_createdtime":_sal_createdtime
                          };
    [[RequestManager shareRequestManager] SearchConnectionContributionDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
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
                [self loadData];
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
                          @"_sal_partner_income_kind":_sal_partner_income_kind,
                          @"_sal_createdtime":_sal_createdtime
                          };
    [[RequestManager shareRequestManager] SearchConnectionContributionDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        failView.hidden = YES;
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
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
        cell.celltype = @"income";
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
    
    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [data[indexPath.row] objectForKey:@"imageLabel"];
//    MyConnectDetailViewController * vc = [[MyConnectDetailViewController alloc] init];
//    vc.titles =@"用户详情";
//    [self.navigationController pushViewController:vc animated:YES];
    
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
     NSLog(@"comBoBoxView");
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
//                    NSLog(@"当title为%@时，所选字段为 %@-----code----%@",firstItem.title,SecondItem.title,SecondItem.code);
                    
                    if ([firstItem.title isEqualToString:@"所在人脉"]) {
                        _sil_level = SecondItem.code ;
                    }
                    
                    if ([firstItem.title isEqualToString:@"赏金类型"]) {
                        _sal_partner_income_kind = SecondItem.code ;
                    }
                    
                    if ([firstItem.title isEqualToString:@"赏金时间"]) {
                        _sal_createdtime = SecondItem.code ;
                    }
                    
                    if (idx == array.count-1) {
                        [self loadListData];
                    }
                    [myTableView.foot endRefreshing];
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
        self.headerTitleLabel.frame = CGRectMake(15, 5, kScreenWidth-30, 30*AUTO_SIZE_SCALE_X);
    }
    return _tableviewHeader;
}


-(UILabel *)headerTitleLabel{
    if (_headerTitleLabel == nil) {
        self.headerTitleLabel = [CommentMethod initLabelWithText:@"当前筛选收益：" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        self.headerTitleLabel.textColor = FontUIColorBlack;
    }
    return _headerTitleLabel;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyIncomeListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.comBoBoxView dimissPopView];
    [MobClick endLogPageView:kMyIncomeListPage];
    
}
@end
