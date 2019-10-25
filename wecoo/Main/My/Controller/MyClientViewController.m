//
//  MyClientViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyClientViewController.h"
#import "BaseTableView.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "AddClientController.h"
#import "noWifiView.h"
#import "noContent.h"
#import "EditClientViewController.h"
@interface MyClientViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,AddSuccessDelegate,EditSuccessDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent *nocontent;
    NSMutableArray *data;
    UITableViewRowAction *deleteRowAction;
    int current_page;
    int total_count;
    int deadlineDay;
    NSString *_customer_islocked;
    int number;
}

@end

@implementation MyClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReloadClientList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadclient) name:kReloadClientList object:nil];
    [self initdata];
    [self initNavBarView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.subtitleView];
    [self initTableView];
    [self loadData];
}

-(void)initNavBarView{
    [self.navView addSubview:self.addClientButton];
    [self.addClientButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(65*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

-(void)reloadclient{
     [self loadData];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    _customer_islocked = @"";
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.subtitleView.frame.origin.y+self.subtitleView.frame.size.height, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.menuView.frame.size.height+self.subtitleView.frame.size.height))];
    
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 50*AUTO_SIZE_SCALE_X;
    
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight-self.menuView.size.height-self.subtitleView.frame.size.height)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    [self.view addSubview:failView];
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
                          @"_customer_islocked":_customer_islocked,
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] GetsearchCustomerResult:dic viewController:self successData:^(NSDictionary *result){
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
            if (data.count == total_count || data.count == 0) {
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
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic1 = @{};
    [[RequestManager shareRequestManager] GetReportLockTimeResult :dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            deadlineDay = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            self.subtitleView.text =[NSString stringWithFormat:@"客户被推荐后，将会被锁定，不可以再次推荐给其他项目，跟进的项目退回或签约后，自动解锁"];
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        failView.hidden = YES;
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
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
                          
                          @"_customer_islocked":_customer_islocked,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
        [[RequestManager shareRequestManager] GetsearchCustomerResult:dic viewController:self successData:^(NSDictionary *result) {
            
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
}
#pragma  addsuccess代理
- (void)addSuccessReturnClientPage{
     [self loadData];
}

-(void)edditSuccessReturnClientPage{
    [self loadData];
}

#pragma menu代理
-(void)menuViewDidSelect:(NSInteger)num{
    NSLog(@"number---%ld",num);
    number = num;
     _customer_islocked  = [NSString stringWithFormat:@"%ld",(long)num-2];
//    NSLog(@"menuViewDidSelect---%@",_customer_islocked);
    if(number-2==-1){
        _customer_islocked = @"";
    }
    [self loadData];
   
}


#pragma mark tableView代理
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return data.count;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除客户" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        NSLog(@"点击了删除");
        
        NSDictionary *dic = @{
                              
                              @"customer_id":[data[indexPath.row] objectForKey:@"customer_id"],
                              };
//        NSLog(@"dic---%@",dic);
        [[RequestManager shareRequestManager] DeleteClientResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                Boolean flag = [[[result objectForKey:@"data"] objectForKey:@"result"] boolValue];
                if (flag) {
                    [self loadData];
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }];
    
    deleteRowAction.backgroundColor = RedUIColorC1;
    return @[deleteRowAction];
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = FontUIColorGray;
    nameLabel.textAlignment = NSTextAlignmentLeft;
   
    nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    [bgView addSubview:nameLabel];
    [cell addSubview:bgView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height-1, kScreenWidth, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [bgView addSubview:lineImageView];
    
    if ((int)indexPath.row==data.count-1 ) {
        lineImageView.hidden = YES;
    }
    if (data.count>0) {
        nameLabel.text = [data[indexPath.row] objectForKey:@"customer_name"];

    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditClientViewController *vc = [[EditClientViewController alloc]init];
    vc.customerID = [data[indexPath.row] objectForKey:@"customer_id"];
    vc.delegate = self;
    vc.titles = @"客户信息";

    int islocked = [[data[indexPath.row] objectForKey:@"customer_islocked"] intValue];
    
    vc.isLocked = islocked;
  
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kMyClinetListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyClinetListPage];
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
        self.menuView.menuArray = @[@"全部", @"未锁定",@"锁定中"];
        
    }
    return _menuView;
}


- (UILabel *)subtitleView {
    if (_subtitleView == nil) {
        self.subtitleView = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.subtitleView.backgroundColor = [UIColor clearColor];
        
        self.subtitleView.numberOfLines = 2;
        self.subtitleView.textColor = FontUIColorGray;
        self.subtitleView.frame = CGRectMake(15, self.menuView.frame.origin.y+self.menuView.frame.size.height, kScreenWidth-30, 68*AUTO_SIZE_SCALE_X);
        
    }
    return _subtitleView;
}


- (UIButton *)addClientButton {
    if (_addClientButton == nil) {
        self.addClientButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addClientButton setTitle:@"添加客户" forState:UIControlStateNormal];
        [self.addClientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addClientButton setBackgroundColor:[UIColor clearColor]];
        [self.addClientButton addTarget:self action:@selector(adddButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.addClientButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.addClientButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addClientButton;
}

-(void)adddButtonClick{
    
    [MobClick event:kMyClientAddbuttonOnclick];
    AddClientController *vc = [[AddClientController alloc]init];
    vc.delegate = self;
    vc.titles = @"添加客户";
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
