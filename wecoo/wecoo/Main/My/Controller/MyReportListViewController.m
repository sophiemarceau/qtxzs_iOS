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

@interface MyReportListViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    
    NSMutableArray *data;
}

@end

@implementation MyReportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self.view addSubview:self.menuView];
    [self initTableView];
    
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
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
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [data removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}

-(void)loadData
{
    //    [myTableView removeFromSuperview];
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
//    _pageForHot = 1;
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
//    NSDictionary * dic = @{
//                           @"cityCode":cityCode,
//                           @"pageStart":@"1",
//                           @"pageOffset":@"15",
//                           };
//    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
//        [self hideHud];
//        myTableView.hidden = NO;
//        failView.hidden = YES;
//        NDLog(@"发现首页数据 -- %@",result);
//        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            //            [activityIndicator stopAnimating];
//            //            activityIndicator.hidden = YES;
//            
//            //            failView.hidden = YES;
//            //            [failView.activityIndicatorView stopAnimating];
//            //            failView.activityIndicatorView.hidden = YES;
//            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
//            [homeListArray addObjectsFromArray:array];
//            [myTableView reloadData];
//            if (array.count<15 || array.count == 0) {
//                [myTableView.foot finishRefreshing];
//            }else{
//                [myTableView.foot endRefreshing];
//            }
//        }else {
//            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
//        }
//    } failuer:^(NSError *error) {
//        //        [myTableView.foot finishRefreshing];
//        //        [myTableView.head finishRefreshing];
//        [self hideHud];
//        myTableView.hidden = YES;
//        failView.hidden = NO;
//        //        [failView.activityIndicatorView stopAnimating];
//        //        failView.activityIndicatorView.hidden = YES;
//    }];
}


#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
//    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//        _pageForHot = 1;
//    }
//    else{
//        _pageForHot ++;
//    }
//    NSString * page = [NSString stringWithFormat:@"%d",_pageForHot];
//    NSString * pageOffset = @"15";
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    //    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
//    NSDictionary * dic = @{
//                           //                           @"cityCode":cityCode,
//                           @"pageStart":page,
//                           @"pageOffset":pageOffset,
//                           };
//    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
//        [self hideHud];
//        myTableView.hidden = NO;
//        failView.hidden = YES;
//        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            //            failView.hidden = YES;
//            //            [failView.activityIndicatorView stopAnimating];
//            //            failView.activityIndicatorView.hidden = YES;
//            
//            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                [homeListArray removeAllObjects];
//            }
//            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
//            [homeListArray addObjectsFromArray:array];
//            [myTableView reloadData];
//            [refreshView endRefreshing];
//            if (array.count<15 || array.count == 0) {
//                [myTableView.foot finishRefreshing];
//            }else{
//                [myTableView.foot endRefreshing];
//            }
//        }else {
//            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
//        }
//    } failuer:^(NSError *error) {
//        //        [myTableView.foot finishRefreshing];
//        //        [myTableView.head finishRefreshing];
//        
//        //        failView.hidden = NO;
//        //        [failView.activityIndicatorView stopAnimating];
//        //        failView.activityIndicatorView.hidden = YES;
//        [refreshView endRefreshing];
//        [self hideHud];
//        myTableView.hidden = YES;
//        failView.hidden = NO;
//    }];
}


#pragma menu代理

-(void)menuViewDidSelect:(NSInteger)number{
    self.menuTag = [NSString stringWithFormat:@"%ld",(long)number];
   
}


#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return data.count;
    return 1;
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
    nameLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, 180*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    
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
    
    nameLabel.text =@"quxiaobo";
    reportLabel.text =@"quxiaobo";
    
    UIButton *progress = [UIButton buttonWithType:UIButtonTypeCustom];
    progress.backgroundColor = [UIColor redColor];
    progress.showsTouchWhenHighlighted = YES;
    [progress setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [progress setTitle:@"查看进度" forState:UIControlStateNormal];
    progress.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    progress.titleLabel.textColor = FontUIColorBlack;
    [progress addTarget:self action:@selector(onClickAction) forControlEvents:UIControlEventTouchUpInside];
    progress.frame = CGRectMake(kScreenWidth-15-75*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
     [backgroundView addSubview:progress];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
  
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
        self.menuView.menuArray = @[@"核实中", @"跟进中", @"考察中", @"已签约",@"已退回"];
        
    }
    return _menuView;
}
@end
