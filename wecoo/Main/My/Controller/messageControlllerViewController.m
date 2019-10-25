//
//  messageControlllerViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/31.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "messageControlllerViewController.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "messageCellTableViewCell.h"
#import "timelineViewController.h"
#import "BalanceViewController.h"
#import "noContent.h"
#import "ReportDetailViewController.h"
@interface messageControlllerViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent *nocontent;
    messageCellTableViewCell *cell;
    int current_page;
    int total_count;

    
}
@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation messageControlllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self loadData];
    [self initTableView];
}
-(void)initdata{
    self.data = [NSMutableArray arrayWithCapacity:0];
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth,kScreenHeight-kNavHeight)];
    
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    
    
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [self.data removeAllObjects];

    NSDictionary *dic = @{

                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchSysMsgDtosResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.data addObjectsFromArray:array];
            }else{
            }
            [myTableView reloadData];
            if (self.data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }            
            failView.hidden = YES;
            if (self.data.count == total_count) {
                [myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        nocontent.hidden = YES;
    }];

}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //        failView.activityIndicatorView.hidden = NO;
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
    [[RequestManager shareRequestManager] SearchSysMsgDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        //            [self hideHud];
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [self.data removeAllObjects];
            }
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.data addObjectsFromArray:array];
                
            }else{
                
            }
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                if (self.data.count>0) {
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
            if (self.data.count == total_count) {
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

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"timeTableViewCell";
    //按时间分组，假设这里[0,2],[3,5],[6,9]是同一天
    cell = [[messageCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    cell.mydata = self.data[[indexPath row]];
    return [cell setCellHeight:@""];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleIdentify = @"timeTableViewCell";

    cell =(messageCellTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[messageCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTag:[indexPath row]];
    }

    if (self.data.count > 0) {
        if (![[self.data[[indexPath row]] objectForKey:@"msg_page_to"] isEqualToString:@"0"] ) {
            [cell.clickView addTarget:self action:@selector(cellclickView:) forControlEvents:UIControlEventTouchUpInside];
            cell.clickView.tag = indexPath.row;
        }
        
        cell.mydata = self.data[[indexPath row]];
        [cell setCellHeight:@""];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)cellclickView:(UIButton *)sender{
    
    [MobClick event:kMyMessageCheck];
    if ([[self.data[[sender tag]] objectForKey:@"msg_page_to"] isEqualToString:@"2"] ) {
        
        BalanceViewController *vc = [[BalanceViewController alloc] init];
           vc.titles = @"账户明细";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *string = [self.data[[sender tag]] objectForKey:@"msg_page_to"];
        NSArray *temparray  = [string componentsSeparatedByString:@"|"];
        ReportDetailViewController *vc = [[ReportDetailViewController alloc] init];
        vc.titles = @"推荐客户详情";
        vc.report_id = [temparray[1] intValue];
        vc.menuTag = [NSString stringWithFormat:@"2"];        
//        vc.user_id = [[data[indexPath.row] objectForKey:@"user_id"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
//        timelineViewController *vc = [[timelineViewController alloc] init];
//        vc.titles = @"报备进度";
//        vc.report_id = [NSString stringWithFormat:@"%d",
//                        [temparray[1] intValue]];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kMessageLisPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMessageLisPage];
}

@end
