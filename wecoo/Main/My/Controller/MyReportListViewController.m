//
//  MyReportListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/25.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyReportListViewController.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "timelineViewController.h"
#import "ReportDetailViewController.h"
#import "noContent.h"
#import "FollwupInfoViewController.h"

@interface MyReportListViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent * nocontent;
    NSMutableArray *data;
    int flagIndex;
    int current_page;
    int total_count;
}

@end

@implementation MyReportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self.view addSubview:self.menuView];
    UIButton *bb = [[UIButton alloc] init];
    NSLog(@"viewDidload----->%d",self.menuTag);
    bb.tag = self.menuTag ;
    [self.menuView tapped:bb];
    [self initTableView];
    
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    flagIndex = self.menuTag ;
    
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X))];
    
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 165/2*AUTO_SIZE_SCALE_X;

    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadDataWithFlagindex:flagIndex];
}

-(void)loadDataWithFlagindex:(int)Index
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];

    NSDictionary *dic = @{
                          
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    switch (Index) {
        case 1:
        {
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosVerifyingResult:dic viewController:self successData:^(NSDictionary *result){
                [LZBLoadingView dismissLoadingView];
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                
                if(IsSucess(result)){
                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    NSLog(@"array--我的报备-核实中--%@",result);
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        [data addObjectsFromArray:array];
                        
                        
                        //            failView.hidden = YES;
                    }else{
                        
                        
                        //            failView.hidden = NO;
                    }
                    
                    [myTableView reloadData];
                    if (data.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    
                    failView.hidden = YES;
                    if (data.count == total_count) {
                        [myTableView.foot finishRefreshing];
                    }
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }failuer:^(NSError *error){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                nocontent.hidden = YES;
            }];
            break;
        }
    
        case 2:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosFollowingResult:dic viewController:self successData:^(NSDictionary *result){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                if(IsSucess(result)){
                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                     NSLog(@"array--我的报备-跟进中--%@",result);
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        [data addObjectsFromArray:array];
                        
                    }else{
                        
                    }
                    
                    [myTableView reloadData];
                    if (data.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    
                    failView.hidden = YES;
                    if (data.count == total_count) {
                        [myTableView.foot finishRefreshing];
                    }
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }failuer:^(NSError *error){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                nocontent.hidden = YES;
            }];
           
            break;
            
        }
            
        case 3:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosSignedUpResult:dic viewController:self successData:^(NSDictionary *result){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                
                if(IsSucess(result)){
                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        [data addObjectsFromArray:array];
                        
                    }else{
                        
                    }
                    
                    [myTableView reloadData];
                    if (data.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    
                    failView.hidden = YES;
                    if (data.count == total_count) {
                        [myTableView.foot finishRefreshing];
                    }
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
                
            }failuer:^(NSError *error){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                nocontent.hidden = YES;
            }];
//            [[RequestManager shareRequestManager] SearchMyCustomerReportDtosInspectingResult:dic viewController:self successData:^(NSDictionary *result){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//
//                if(IsSucess(result)){
//                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    
//                    if(![array isEqual:[NSNull null]] && array !=nil)
//                    {
//                        [data addObjectsFromArray:array];
//                        
//                    }else{
//                        
//                    }
//                    if (data.count>0) {
//                        nocontent.hidden = YES;
//                    }else{
//                        nocontent.hidden = NO;
//                    }
//                    
//                    failView.hidden = YES;
//                    [myTableView reloadData];
//                    if (data.count == total_count) {
//                        [myTableView.foot finishRefreshing];
//                    }
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//                
//            }failuer:^(NSError *error){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//                failView.hidden = NO;
//                nocontent.hidden = YES;
//            }];
            
            break;
            
        }
            
        case 4:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosBackResult:dic viewController:self successData:^(NSDictionary *result){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                
                if(IsSucess(result)){
                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        [data addObjectsFromArray:array];
                        
                    }else{
                        
                    }
                    
                    [myTableView reloadData];
                    if (data.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    
                    failView.hidden = YES;
                    if (data.count == total_count) {
                        [myTableView.foot finishRefreshing];
                    }
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
                
            }failuer:^(NSError *error){
                [myTableView.head endRefreshing];
                [myTableView.foot endRefreshing];
                [LZBLoadingView dismissLoadingView];
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                nocontent.hidden = YES;
            }];
//            [[RequestManager shareRequestManager] SearchMyCustomerReportDtosSignedUpResult:dic viewController:self successData:^(NSDictionary *result){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//
//                if(IsSucess(result)){
//                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    
//                    if(![array isEqual:[NSNull null]] && array !=nil)
//                    {
//                        [data addObjectsFromArray:array];
//                        
//                    }else{
//                        
//                    }
//                    
//                    [myTableView reloadData];
//                    if (data.count>0) {
//                        nocontent.hidden = YES;
//                    }else{
//                        nocontent.hidden = NO;
//                    }
//                    
//                    failView.hidden = YES;
//                    if (data.count == total_count) {
//                        [myTableView.foot finishRefreshing];
//                    }
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//
//            }failuer:^(NSError *error){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//                failView.hidden = NO;
//                nocontent.hidden = YES;
//            }];
           
            break;
            
        }
//        case 5:{
//            [[RequestManager shareRequestManager] SearchMyCustomerReportDtosBackResult:dic viewController:self successData:^(NSDictionary *result){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//
//                if(IsSucess(result)){
//                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    
//                    if(![array isEqual:[NSNull null]] && array !=nil)
//                    {
//                        [data addObjectsFromArray:array];
//                        
//                    }else{
//                        
//                    }
//                    
//                    [myTableView reloadData];
//                    if (data.count>0) {
//                        nocontent.hidden = YES;
//                    }else{
//                        nocontent.hidden = NO;
//                    }
//                    
//                    failView.hidden = YES;
//                    if (data.count == total_count) {
//                        [myTableView.foot finishRefreshing];
//                    }
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//                
//            }failuer:^(NSError *error){
//                [myTableView.head endRefreshing];
//                [myTableView.foot endRefreshing];
//                [LZBLoadingView dismissLoadingView];
//                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//                failView.hidden = NO;
//                nocontent.hidden = YES;
//            }];
//           
//            break;
//            
//        }
        default:
            break;
    }
}


#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
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
    
    
    switch (flagIndex) {
        case 1:
        {
          
             [[RequestManager shareRequestManager] SearchParentCustomerReportDtosVerifyingResult:dic viewController:self successData:^(NSDictionary *result) {
                
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
                     if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                         if (data.count>0) {
                             nocontent.hidden = YES;
                         }else{
                             nocontent.hidden = NO;
                         }
                     }
                     failView.hidden = YES;
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

             
            break;
        }
            
        case 2:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosFollowingResult:dic viewController:self successData:^(NSDictionary *result) {
                
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
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        if (data.count>0) {
                            nocontent.hidden = YES;
                        }else{
                            nocontent.hidden = NO;
                        }
                    }
                    failView.hidden = YES;
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
            break;
            
        }
            
        case 3:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosSignedUpResult:dic viewController:self successData:^(NSDictionary *result) {
                
                
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
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        if (data.count>0) {
                            nocontent.hidden = YES;
                        }else{
                            nocontent.hidden = NO;
                        }
                    }
                    failView.hidden = YES;
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
//            [[RequestManager shareRequestManager] SearchMyCustomerReportDtosInspectingResult:dic viewController:self successData:^(NSDictionary *result) {
//                [refreshView endRefreshing];
//                if(IsSucess(result)){
//                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        [data removeAllObjects];
//                    }
//                    
//                    if(![array isEqual:[NSNull null]] && array !=nil)
//                    {
//                        [data addObjectsFromArray:array];
//                        
//                    }else{
//                        
//                    }
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        if (data.count>0) {
//                            nocontent.hidden = YES;
//                        }else{
//                            nocontent.hidden = NO;
//                        }
//                    }
//                    failView.hidden = YES;
//                    [myTableView reloadData];
//                    
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        [myTableView.head endRefreshing];
//                    }
//                    if (data.count == total_count) {
//                        [myTableView.foot finishRefreshing];
//                    }
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//                
//            } failuer:^(NSError *error) {
//
//                [refreshView endRefreshing];
//                
//                failView.hidden = NO;
//            }];
            
            break;
            
        }
            
        case 4:{
            [[RequestManager shareRequestManager] SearchParentCustomerReportDtosBackResult:dic viewController:self successData:^(NSDictionary *result) {
                
                //            [self hideHud];
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
                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                        if (data.count>0) {
                            nocontent.hidden = YES;
                        }else{
                            nocontent.hidden = NO;
                        }
                    }
                    failView.hidden = YES;
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
            break;
//             [[RequestManager shareRequestManager] SearchMyCustomerReportDtosSignedUpResult:dic viewController:self successData:^(NSDictionary *result) {
//                
//                 [refreshView endRefreshing];
//                 if(IsSucess(result)){
//                     current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                     total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                     NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                     
//                     if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                         [data removeAllObjects];
//                     }
//                     
//                     if(![array isEqual:[NSNull null]] && array !=nil)
//                     {
//                         [data addObjectsFromArray:array];
//                         
//                     }else{
//                         
//                     }
//                     if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                         if (data.count>0) {
//                             nocontent.hidden = YES;
//                         }else{
//                             nocontent.hidden = NO;
//                         }
//                     }
//                     failView.hidden = YES;
//                     [myTableView reloadData];
//                     
//                     if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                         [myTableView.head endRefreshing];
//                     }
//                     if (data.count == total_count) {
//                         [myTableView.foot finishRefreshing];
//                     }
//                 }else{
//                     [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                 }
//                
//                
//            } failuer:^(NSError *error) {
//                [refreshView endRefreshing];
//                failView.hidden = NO;
//            }];
            
            break;
            
        }
//        case 5:{
//            [[RequestManager shareRequestManager] SearchMyCustomerReportDtosBackResult:dic viewController:self successData:^(NSDictionary *result) {
//                [refreshView endRefreshing];
//                //            [self hideHud];
//                if(IsSucess(result)){
//                    current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                    total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                    NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        [data removeAllObjects];
//                    }
//                    
//                    if(![array isEqual:[NSNull null]] && array !=nil)
//                    {
//                        [data addObjectsFromArray:array];
//                        
//                    }else{
//                        
//                    }
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        if (data.count>0) {
//                            nocontent.hidden = YES;
//                        }else{
//                            nocontent.hidden = NO;
//                        }
//                    }
//                    failView.hidden = YES;
//                    [myTableView reloadData];
//                    
//                    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                        [myTableView.head endRefreshing];
//                    }
//                    if (data.count == total_count) {
//                        [myTableView.foot finishRefreshing];
//                    }
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//                
//                
//            } failuer:^(NSError *error) {
//                [refreshView endRefreshing];
//                failView.hidden = NO;
//            }];
//            break;
//            
//        }
        default:
            break;
    }
}


#pragma menu代理

-(void)menuViewDidSelect:(NSInteger)number{
//    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)number]);
    flagIndex = (int)number;
    [self loadDataWithFlagindex:flagIndex];
    
   
}
#pragma mark 查看进度
-(void)onClickAction:(UIButton *)sender{
    
    [MobClick event:kMyReportProgress];
    ReportDetailViewController *vc = [[ReportDetailViewController alloc] init];
    vc.titles = @"推荐客户详情";
    vc.menuTag = [NSString stringWithFormat:@"2"];
    vc.report_id = sender.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BGColorGray;
    }
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.frame = CGRectMake(0, 0, kScreenWidth, 75*AUTO_SIZE_SCALE_X);
    [cell addSubview:backgroundView];
    
    UILabel *nameLabel =  [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth/2+50*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = FontUIColorBlack;
    nameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    [backgroundView addSubview:nameLabel];
    
    UILabel *reportLabel = [[UILabel alloc] init];
    reportLabel.frame = CGRectMake(15, 27/2*AUTO_SIZE_SCALE_X+nameLabel.frame.origin.y+nameLabel.frame.size.height, 240*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
    
    reportLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    reportLabel.textAlignment = NSTextAlignmentLeft;
    reportLabel.textColor = FontUIColorGray;
    [backgroundView addSubview:reportLabel];
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",[data[indexPath.row] objectForKey:@"report_customer_name"],[data[indexPath.row] objectForKey:@"report_customer_tel"]];
    reportLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"project_industry_name"]];
   
    UIButton *progress = [UIButton buttonWithType:UIButtonTypeCustom];
    progress.showsTouchWhenHighlighted = YES;
    progress.tag = [[data[indexPath.row] objectForKey:@"report_id"] intValue];
    
    [progress setBackgroundImage:[UIImage imageNamed:@"btn-reportProgress"] forState:UIControlStateNormal];
    [progress setTitle:@"查看进度" forState:UIControlStateNormal];
    [progress setTitleColor:FontUIColorGray forState:UIControlStateNormal];
    progress.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    
    [progress addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    progress.frame = CGRectMake(kScreenWidth-15-75*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 74, 28);
     [backgroundView addSubview:progress];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MobClick event:kMyReportList label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"report_id"] integerValue]]];
    ReportDetailViewController *vc = [[ReportDetailViewController alloc] init];
    vc.titles = @"推荐客户详情";
    int tempid = [[data[indexPath.row] objectForKey:@"report_id"] intValue];
    vc.menuTag = [NSString stringWithFormat:@"1"];
    vc.report_id = tempid;
    vc.user_id = [[data[indexPath.row] objectForKey:@"user_id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyReportListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyReportListPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"审核中",
                                    @"跟进中",
//                                    @"考察中",
                                    @"已签约",
                                    @"已退回"];
    }
    return _menuView;
}
@end
