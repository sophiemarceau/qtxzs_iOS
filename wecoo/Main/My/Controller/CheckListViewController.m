//
//  CheckListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/25.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "CheckListViewController.h"
#import "menuVIew.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "noContent.h"
#import "checklistTableViewCell.h"
#import "alreadychecklistTableViewCell.h"
#import "ProgressRecordViewController.h"
#import "confirmreviewgobackViewController.h"
#import "confirmreviewpassViewController.h"
#import "Signup4MoneyViewController.h"

@interface CheckListViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,buttonclickDelegate,alreadybuttonclickDelegate>{
    BaseTableView *myTableView;
    BaseTableView *myTableView1;
    noWifiView * failView;
    noContent * nocontent;
    NSMutableArray *data;
    int flagIndex;
    int current_page;
    int total_count;
    checklistTableViewCell *cell1;
    alreadychecklistTableViewCell *cell2;
}

@property (nonatomic,strong)menuVIew *menuView;
@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kRefreshCheckList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadclient) name:kRefreshCheckList object:nil];
    [super viewDidLoad];
    self.titles = @"审核列表";
    [self initdata];
    [self.view addSubview:self.menuView];
   
    [self initTableView];
    [self creataTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    UIButton *bb = [[UIButton alloc] init];
    bb.tag = self.menuTag ;
    [self.menuView tapped:bb];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    flagIndex = self.menuTag ;
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height+self.menuView.frame.size.height+1*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.menuView.frame.size.height+1*AUTO_SIZE_SCALE_X))];
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.tag = 0;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 165/2*AUTO_SIZE_SCALE_X;
    
    UIView *grayView = [UIView new];
    grayView.size = CGSizeMake(kScreenWidth, 10*AUTO_SIZE_SCALE_X);
    grayView.backgroundColor = BGColorGray;
    [myTableView setTableHeaderView:grayView];
    myTableView.hidden = YES;
    [self.view addSubview:myTableView];
    
   
}

-(void)creataTableView
{
    myTableView1 = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height+self.menuView.frame.size.height+1*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.menuView.frame.size.height+1*AUTO_SIZE_SCALE_X))];
    
    myTableView1.backgroundColor = BGColorGray;
    myTableView1.showsVerticalScrollIndicator = NO;
    myTableView1.tag = 1;
    myTableView1.delegate = self;
    myTableView1.delegates = self;
    myTableView1.dataSource = self;
    myTableView1.rowHeight = 165/2*AUTO_SIZE_SCALE_X;
    UIView *grayView = [UIView new];
    grayView.size = CGSizeMake(kScreenWidth, 10*AUTO_SIZE_SCALE_X);
    grayView.backgroundColor = BGColorGray;
    [myTableView1 setTableHeaderView:grayView];
    myTableView.hidden = YES;

    [self.view addSubview:myTableView1];
}
-(void)reloadclient{
    [self loadDataWithFlagindex:flagIndex];
}


- (void)reloadButtonClick:(UIButton *)sender {
    [self loadDataWithFlagindex:flagIndex];
}

-(void)loadDataWithFlagindex:(int)Index
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];
    
    NSDictionary *dic;
    
    switch (Index) {
        case 1:
        {
            dic = @{
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"1",
                    @"_currentPage":@"",
                    @"_pageSize":@"",
                    };
            break;
        }
            
        case 2:{
            dic = @{
                    
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"3",
                    @"_currentPage":@"",
                    @"_pageSize":@"",
                    };
            break;
            
        }
            
        case 3:{
            dic = @{
                    
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"6",
                    @"_currentPage":@"",
                    @"_pageSize":@"",
                    };
            break;
            
        }
            
        case 4:{
            dic = @{
                    
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"7",
                    @"_currentPage":@"",
                    @"_pageSize":@"",
                    };
            break;
            
        }
        default:
            break;
    }
    
    [[RequestManager shareRequestManager] SearchCustomerReportDtosByProManager4AppResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(flagIndex == 1 ||flagIndex == 2){
            myTableView.hidden = NO;
            myTableView1.hidden =YES;
            [myTableView.head endRefreshing];
            [myTableView.foot endRefreshing];
        }else{
            myTableView.hidden = YES;
            myTableView1.hidden = NO;
            [myTableView1.head endRefreshing];
            [myTableView1.foot endRefreshing];
        }
        
        
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
            if(flagIndex == 1 || flagIndex == 2){
                [myTableView reloadData];
            }else{
                [myTableView1 reloadData];
            }
            NSLog(@"---count----->%d",data.count);
            if (data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            
            failView.hidden = YES;
            if (data.count == total_count) {
                if(flagIndex == 1 || flagIndex == 2){
                    [myTableView.foot finishRefreshing];
                }else{
                    [myTableView1.foot finishRefreshing];
                }
                
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            failView.hidden = NO;

        }
    }failuer:^(NSError *error){
        if(flagIndex == 1 ||flagIndex == 2){
            [myTableView.head endRefreshing];
            [myTableView.foot endRefreshing];
        }else{
            [myTableView1.head endRefreshing];
            [myTableView1.foot endRefreshing];
        }

        
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        nocontent.hidden = YES;
    }];
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
    
    NSDictionary *dic ;
    
    
    switch (flagIndex) {
        case 1:
        {
            dic = @{
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"1",
                    @"_currentPage":page,
                    @"_pageSize":@"",
                    };
            break;
        }
            
        case 2:{
            dic = @{
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"3",
                    @"_currentPage":page,
                    @"_pageSize":@"",
                    };
            break;
        }
            
        case 3:{
            dic = @{
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"6",
                    @"_currentPage":page,
                    @"_pageSize":@"",
                    };
            break;
            
        }
        case 4:{
            dic = @{
                    @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                    @"report_status":@"7",
                    @"_currentPage":page,
                    @"_pageSize":@"",
                    };
            break;
        }
        default:
            break;
    }
    
    [[RequestManager shareRequestManager] SearchCustomerReportDtosByProManager4AppResult:dic viewController:self successData:^(NSDictionary *result) {
        
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
            
            if(flagIndex == 1 || flagIndex == 2){
                [myTableView reloadData];
            }else{
                [myTableView1 reloadData];
            }
            
            
            [refreshView endRefreshing];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                if(flagIndex == 1 || flagIndex == 2){
                    [myTableView.head endRefreshing];
                }else{
                    [myTableView1.head endRefreshing];
                }
            }
            if (data.count == total_count) {
                if(flagIndex == 1 || flagIndex == 2){
                     [myTableView.foot finishRefreshing];
                }else{
                     [myTableView1.foot finishRefreshing];
                }
               
            }else{
                if(flagIndex == 1 || flagIndex == 2){
                    [myTableView.foot endRefreshing];
                }else{
                    [myTableView1.foot endRefreshing];
                }
               
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


#pragma menu代理
-(void)menuViewDidSelect:(NSInteger)number{
    //    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)number]);
    flagIndex = (int)number;
    [self loadDataWithFlagindex:flagIndex];
}

#pragma mark 查看进度
-(void)onClickAction:(UIButton *)sender{
    
//    [MobClick event:kMyReportProgress];
//    ReportDetailViewController *vc = [[ReportDetailViewController alloc] init];
//    vc.titles = @"推荐客户详情";
//    vc.menuTag = [NSString stringWithFormat:@"2"];
//    vc.report_id = sender.tag;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"--numberOfRowsInSection-count----->%d",data.count);
        return data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSLog(@"--heightForRowAtIndexPath-row----->%d",indexPath.row);
//    if (tableView.tag == 0) {
//        static NSString *simpleIdentify = @"checklistTableViewCell";
//        cell1 = [[checklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
//        cell1.delegate = self;
//        cell1.celldata = data[[indexPath row]];
//        return [cell1 setCellHeight:@""];
//
//    }else{
//        static NSString *simpleIdentify = @"alreadychecklistTableViewCell";
//        cell2 = [[alreadychecklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
//        cell2.delegate = self;
//        cell2.celldata = data[[indexPath row]];
//        return [cell1 setCellHeight:@""];
//
//    }
    static NSString *simpleIdentify = @"checklistTableViewCell";
    cell1 = [[checklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    cell1.delegate = self;
    cell1.celldata = data[[indexPath row]];
    return [cell1 setCellHeight:@"" withFlag:flagIndex];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--cellForRowAtIndexPath-row----->%d",indexPath.row);
//    if (tableView.tag == 0) {
//        static NSString *simpleIdentify = @"checklistTableViewCell";
////        cell1 =(checklistTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
//         cell1 =(checklistTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
//        if (cell1 == nil) {
//            cell1 = [[checklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
//            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell1 setTag:[indexPath row]];
//        }
//        cell1.delegate = self;
//        if (data.count > 0) {
//            cell1.celldata = data[indexPath.row];
//            [cell1 setCellHeight:@""];
//        }
//        if (flagIndex == 2) {
//            
//            [cell1.confirmPassButton setTitle:@"确定签约" forState:UIControlStateNormal];
//        }
//        return cell1;
//    }else{
//        static NSString *simpleIdentify = @"alreadychecklistTableViewCell";
//        cell2 =(alreadychecklistTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
////        [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
//        if (cell2 == nil) {
//            cell2 = [[alreadychecklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
//            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell2 setTag:[indexPath row]];
//        }
//        cell2.delegate = self;
//        if (data.count > 0) {
//            cell2.celldata = data[indexPath.row];
//            [cell2 setCellHeight:@""];
//        }
//        
//        return cell2;
//    }
    static NSString *simpleIdentify = @"checklistTableViewCell";
    //        cell1 =(checklistTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    cell1 =(checklistTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell1 == nil) {
        cell1 = [[checklistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell1 setTag:[indexPath row]];
    }
    cell1.delegate = self;
    if (data.count > 0) {
        cell1.celldata = data[indexPath.row];
        [cell1 setCellHeight:@"" withFlag:flagIndex];
    }
    if (flagIndex == 2) {
        
        [cell1.confirmPassButton setTitle:@"确定签约" forState:UIControlStateNormal];
    }
    return cell1;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [MobClick event:kMyReportList label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"report_id"] integerValue]]];
//    ReportDetailViewController *vc = [[ReportDetailViewController alloc] init];
//    vc.titles = @"推荐客户详情";
//    int tempid = [[data[indexPath.row] objectForKey:@"report_id"] intValue];
//    vc.menuTag = [NSString stringWithFormat:@"1"];
//    vc.report_id = tempid;
//    vc.user_id = [[data[indexPath.row] objectForKey:@"user_id"] intValue];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)buttononclick:(NSInteger)number WithID:(NSString *)iDstring WithReportString:(NSString *)reportstr WithProjectIDString:(NSString *)projectIDString{
    NSLog(@"number----->%d",number);
    //退回按钮 0  确认按钮 1 跟进记录 2 拨打电话 3
    if (number == 0) {
        [MobClick event:kChectListBackonClickEvent];
        confirmreviewgobackViewController *vc = [[confirmreviewgobackViewController alloc] init];
        vc.report_id = iDstring;
        [self.navigationController pushViewController:vc animated:YES];

    }
    if (number == 1) {
        if (flagIndex ==1) {
            [MobClick event:kChectListConfirmPassClickEvent];
            confirmreviewpassViewController *vc = [[confirmreviewpassViewController alloc] init];
            vc.report_id = iDstring;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (flagIndex ==2) {
            [MobClick event:kChectListConfirmSignonClickEvent];
            Signup4MoneyViewController *vc = [[Signup4MoneyViewController alloc] init];
            vc.report_id = iDstring;
            vc.project_id = projectIDString;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
    }
    if (number == 2) {
        ProgressRecordViewController *vc = [[ProgressRecordViewController alloc] init];
        
        if(flagIndex == 1 || flagIndex == 2){
            vc.fromtype = 0;
        }else{
            vc.fromtype = 1;
        }
        vc.report_str = reportstr;
        vc.report_id = iDstring;
        if (flagIndex ==2) {
            [vc.confirmPassButton setTitle:@"确认签约" forState:UIControlStateNormal];
            vc.project_id = projectIDString;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:kChectListPhoneonClickEvent];
    }
    
    if (number == 3) {
        ProgressRecordViewController *vc = [[ProgressRecordViewController alloc] init];
        
        if(flagIndex == 1 || flagIndex == 2){
            vc.fromtype = 0;
        }else{
            vc.fromtype = 1;
        }
        vc.report_str = reportstr;
        vc.report_id = iDstring;
        if (flagIndex ==2) {
            [vc.confirmPassButton setTitle:@"确认签约" forState:UIControlStateNormal];
            vc.project_id = projectIDString;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:kChectListPhoneonClickEvent];
    }
    
}

-(void)alreadybuttononclick:(NSInteger)number WithID:(NSString *)iDstring WithReportString:(NSString *)reportstr{
    ProgressRecordViewController *vc = [[ProgressRecordViewController alloc] init];
    if(flagIndex == 1 || flagIndex == 2){
        vc.fromtype = 0;
    }else{
        vc.fromtype = 1;
    }
    vc.report_id = iDstring;
    vc.report_str = reportstr;
    [self.navigationController pushViewController:vc animated:YES];
    [MobClick event:kChectListPhoneonClickEvent];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyCheckListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyCheckListPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"审核中",
                                    @"跟进中",
                                    @"已签约",
                                    @"已退回"];
    }
    return _menuView;
}

@end
