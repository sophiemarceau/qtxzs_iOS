//
//  SelectClientViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SelectClientViewController.h"
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
#import "ClientTableViewCell.h"


@interface SelectClientViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    ZeroView *nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;
    NSDictionary *dto;
    
    NSDictionary  *authdto;
    
}

@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;

@property(nonatomic,strong)UIView *tableviewHeader;
@property(nonatomic,strong)UILabel *headerTitleLabel;
@property(nonatomic,strong)UIView *confirmView;
@property(nonatomic,strong)UILabel *confirmLabel;
@property(nonatomic,strong)UIButton *confirmButton;
@end

@implementation SelectClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initdata];
    [self loadListData];
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"活跃度"];
    rootItem1.menuflag = 1;
    NSArray *tempArray11 =@[
                           @{@"code":@"0",@"value":@"不限时间"},
                           @{@"code":@"1",@"value":@"一周末报备"},
                           @{@"code":@"2",@"value":@"一个月未报备"},
                           @{@"code":@"3",@"value":@"三个月未报备"},
                           ] ;
    NSArray *tempArray12 =@[
                            @{@"code":@"0",@"value":@"不限时间"},
                            @{@"code":@"1",@"value":@"一周末邀请"},
                            @{@"code":@"2",@"value":@"一个月未邀请"},
                            @{@"code":@"3",@"value":@"三个月未邀请"},
                            ] ;
    NSArray *arr1 = @[
                         @{@"最后报备时间":tempArray11},
                         @{@"最后邀请时间":tempArray12},
                      ];
    
    for (NSDictionary *itemDic in arr1) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem1 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"贡献度"];
    rootItem2.menuflag = 1;
    NSArray *tempArray20 =@[
                            @{@"code":@"0",@"value":@"本人贡献"},
                            @{@"code":@"1",@"value":@"下级人脉贡献"},
                            @{@"code":@"2",@"value":@"累计贡献"},
                            ] ;
    NSArray *tempArray21 =@[
                            @{@"code":@"0",@"value":@"不限金额"},
                            @{@"code":@"1",@"value":@"100以内"},
                            @{@"code":@"2",@"value":@"100-500"},
                            @{@"code":@"3",@"value":@"500-5000"},
                            @{@"code":@"4",@"value":@"5000以上"},
                            ] ;
    NSArray *tempArray22 =@[
                            @{@"code":@"0",@"value":@"不限人数"},
                            @{@"code":@"1",@"value":@"0"},
                            @{@"code":@"2",@"value":@"1-5人"},
                            @{@"code":@"3",@"value":@"10-20人"},
                            @{@"code":@"4",@"value":@"20人以上"},
                            ] ;
    NSArray *tempArray23 =@[
                            @{@"code":@"0",@"value":@"不限数量"},
                            @{@"code":@"1",@"value":@"0"},
                            @{@"code":@"2",@"value":@"1-5"},
                            @{@"code":@"3",@"value":@"5-10"},
                            @{@"code":@"4",@"value":@"10-15"},
                            @{@"code":@"5",@"value":@"15以上"},
                            ] ;
    NSArray *arr2= @[
                     @{@"贡献类型":tempArray20},
                     @{@"贡献赏金（元）":tempArray21},
                     @{@"贡献邀请人数":tempArray22},
                     @{@"贡献通过推荐数":tempArray23},
                     ];
    
    for (NSDictionary *itemDic in arr2) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem2 addNode:item4_A];
        for (NSDictionary *title in [itemDic.allValues lastObject]) {
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
        }
    }
    
    self.mutableArray = [NSMutableArray array];
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    
    self.comBoBoxView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
    self.comBoBoxView.dataSource = self;
    self.comBoBoxView.delegate = self;
    [self.view addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

-(void)initTableView{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+self.comBoBoxView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height-112/2*AUTO_SIZE_SCALE_X)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView = self.tableviewHeader;
    myTableView.rowHeight = 136/2*AUTO_SIZE_SCALE_X+1;
    myTableView.tableHeaderView = self.tableviewHeader;
    [myTableView registerClass:[ClientTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ClientTableViewCell class])];
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight+self.comBoBoxView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[ZeroView alloc]initWithFrame:CGRectMake(0, kNavHeight+self.comBoBoxView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.comBoBoxView.frame.size.height)];
    nocontent.noContentLabel.text = @"没有符合筛选条件的用户，请重新筛选！";
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    
    [self.view addSubview:self.confirmView];
    self.confirmView.frame = CGRectMake(0, kScreenHeight-112/2*AUTO_SIZE_SCALE_X,kScreenWidth, 112/2*AUTO_SIZE_SCALE_X);
    self.confirmView.backgroundColor = BGColorGray;
    [self.confirmView addSubview:self.confirmLabel];
    self.confirmLabel.frame = CGRectMake(15, 0, kScreenWidth/2-15, 112/2*AUTO_SIZE_SCALE_X);
    [self.confirmView addSubview:self.confirmButton];
    self.confirmButton.frame = CGRectMake(kScreenWidth-15-111*AUTO_SIZE_SCALE_X, (112-73)/4*AUTO_SIZE_SCALE_X, 111*AUTO_SIZE_SCALE_X, 73/2*AUTO_SIZE_SCALE_X);
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadListData];
}

-(void)loadListData{
    [myTableView.head endRefreshing];
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] GetMyInviteInformationResult:dic viewController:self successData:^(NSDictionary *result){
        NSLog(@"result-------->%@",result);
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
                
//                if (data.count>0) {
//                    nocontent.hidden = NO;
//                }else{
//                    nocontent.hidden = YES;
//                }
                
                [myTableView reloadData];
                failView.hidden = YES;
                if (data.count == total_count || data.count == 0) {
                    [myTableView.head finishRefreshing];
                }
            }else{
                
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
        nocontent.hidden = YES;
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
                          };
    [[RequestManager shareRequestManager] GetMyInviteInformationResult:dic viewController:self successData:^(NSDictionary *result) {
        
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

#pragma mark 提交
-(void)submitBtnPressed:(UIButton *)sender
{
    self.confirmButton.enabled = NO;
    [self.delegate SelectClientGroupDelegateReturnPage:nil];
    [self.navigationController popViewControllerAnimated:YES];
    self.confirmButton.enabled = YES;
}


#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    //    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClientTableViewCell class]) forIndexPath:indexPath];
    cell.dictionary = nil;
    //    cell.dictionary = data[indexPath.row];
    if(indexPath.row == data.count -1 ||data.count == 1){
        cell.lineImageView.hidden = YES;
    }else{
        cell.lineImageView.hidden = NO;
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
//                    NSLog(@"当title为%@时，所选字段为 %@",firstItem.title,SecondItem.title);
                }
            }];
            break;}
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kSelectSendClient];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.comBoBoxView dimissPopView];
    [MobClick endLogPageView:kSelectSendClient];
}

-(UIView *)confirmView{
    if (_confirmView == nil) {
        self.confirmView = [UIView new];
        self.confirmView.backgroundColor = BGColorGray;
    }
    return _confirmView;
}

-(UILabel *)confirmLabel{
    if (_confirmLabel == nil) {
        self.confirmLabel = [UILabel new];
        self.confirmLabel.backgroundColor = BGColorGray;
        self.confirmLabel.text = @"已选择56名用户";
        self.confirmLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _confirmLabel;
}

-(UIButton *)confirmButton{
    if (_confirmButton == nil) {
        self.confirmButton = [UIButton new];
        self.confirmButton.backgroundColor = RedUIColorC1;
        [self.confirmButton setTintColor:[UIColor whiteColor]];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = YES;
        [self.confirmButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.confirmButton.enabled = YES;
    }
    return _confirmButton;

}

@end
