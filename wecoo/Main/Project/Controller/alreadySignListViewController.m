//
//  alreadySignListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/7/14.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "alreadySignListViewController.h"
#import "BaseTableView.h"
#import "AlreadySignTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "noContent.h"

@interface alreadySignListViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    
    NSMutableArray *data;
    AlreadySignTableViewCell *cell;
    int current_page;
    int total_count;
    
}
@property(nonatomic,strong)BaseTableView * myTableView;
@property(nonatomic,strong)noWifiView *failView;
@property(nonatomic,strong)noContent *nocontent;
@end

@implementation alreadySignListViewController

- (void)viewDidLoad {
    self.titles =@"已签约列表";
    [super viewDidLoad];
    [self initdata];
    [self loadData];
    [self layoutSubView];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

-(void)layoutSubView
{
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.failView];
    [self.view addSubview:self.nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    
    [self loadData];
}

-(void)loadData
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];
    
    NSDictionary *dic = @{
                          @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchAlreadyReportListDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [self.myTableView.head endRefreshing];
        [self.myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];
            }
            [self.myTableView reloadData];
            if (data.count>0) {
                self.nocontent.hidden = YES;
            }else{
                self.nocontent.hidden = NO;
            }
            self.failView.hidden = YES;
            if (data.count ==total_count) {
                [self.myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.failView.hidden = NO;
            self.nocontent.hidden = YES;
        }
    }failuer:^(NSError *error){
        [self.myTableView.head endRefreshing];
        [self.myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.failView.hidden = NO;
        self.nocontent.hidden = YES;
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
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    
    
    //        NSString * pageOffset = @"20";
    
    NSDictionary *dic = @{
                           @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                           @"_currentPage":page,
                           @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchAlreadyReportListDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        
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
            NSLog(@"%ld",data.count);
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                if (data.count>0) {
                    self.nocontent.hidden = YES;
                }else{
                    self.nocontent.hidden = NO;
                }
            }
            self.failView.hidden = YES;
            [self.myTableView reloadData];
            
            [refreshView endRefreshing];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [self.myTableView.head endRefreshing];
            }
            if (data.count == total_count) {
                [self.myTableView.foot finishRefreshing];
            }else{
                [self.myTableView.foot endRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            [refreshView endRefreshing];
        }
    } failuer:^(NSError *error) {
        [refreshView endRefreshing];
        self.failView.hidden = NO;
    }];
   
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"AlreadySignTableViewCell";
    cell =(AlreadySignTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell = [[AlreadySignTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTag:[indexPath row]];
    }
    cell.celldata = data[indexPath.row];
    [cell insertData];
    return cell;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kAlreadySignListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAlreadySignListPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BaseTableView *)myTableView{
    if (_myTableView == nil ) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _myTableView.backgroundColor = BGColorGray;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.delegate = self;
        _myTableView.delegates = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = 70*AUTO_SIZE_SCALE_X;
        _myTableView.estimatedRowHeight = 70*AUTO_SIZE_SCALE_X;
    }
    return _myTableView;
}

-(noContent *)nocontent{
    if (_nocontent == nil ) {
        _nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, self.myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight)];
        _nocontent.hidden = YES;
    }
    return _nocontent;
}

-(noWifiView *)failView{
    if (_failView == nil ) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

@end
