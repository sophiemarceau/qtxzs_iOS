//
//  HomeViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "HomeViewController.h"
#import "noWifiView.h"
#import "UIImageView+WebCache.h"
#import "publicTableViewCell.h"
#import "SDCycleScrollView.h"
//200 10像素空
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,SDCycleScrollViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    NSMutableArray * homeListArray;
    int _pageForHot;
    UIView *HomeTableHeadView;
    SDCycleScrollView  *cycleview;
    UIImageView *TitleView;
    NSTimer *_topPictureTimer;
    NSMutableArray *imagesURLStrings;
    NSMutableArray *_imgData;

}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView removeFromSuperview];
    
    homeListArray = [[NSMutableArray alloc] initWithCapacity:0];
    imagesURLStrings = [NSMutableArray arrayWithCapacity:0];
    [imagesURLStrings addObjectsFromArray: @[
                                            @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                            @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                            @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                            ]];
//    _imgData = [NSMutableArray arrayWithCapacity:0];
    [self initHeaderView];
    [self initCycleview];
    [self initTitleView];
    [self initTableView];
    
//    [self loadData];
//    [self showHudInView:self.view hint:@"正在加载"];
}

-(void)initHeaderView{
    HomeTableHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 275*AUTO_SIZE_SCALE_X)];
    HomeTableHeadView.backgroundColor = UIColorFromRGB(0xf4f4f4);
}

-(void)initCycleview
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    cycleview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 175*AUTO_SIZE_SCALE_X) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleview.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleview.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleview.imageURLStringsGroup = imagesURLStrings;
    [HomeTableHeadView addSubview:cycleview];
    
}

-(void)initTitleView{

    UIImageView *archView = [[UIImageView alloc] init];
    archView.frame = CGRectMake(0, cycleview.frame.size.height-10*AUTO_SIZE_SCALE_X, kScreenHeight, 10*AUTO_SIZE_SCALE_X);
//    archView.image = [UIImage imageNamed:@""];
    archView.backgroundColor = [UIColor blackColor];
    [HomeTableHeadView addSubview:archView];
    
    TitleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, archView.frame.origin.y+archView.frame.size.height, kScreenWidth, 95*AUTO_SIZE_SCALE_X)];
    TitleView.backgroundColor = UIColorFromRGB(0xffffff);
    TitleView.userInteractionEnabled = YES;
    [HomeTableHeadView addSubview:TitleView];
    
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    norArray = [NSArray arrayWithObjects:@"tab-home", @"tab-project", @"tab-discover", @"tab-user", nil];
    
    selectArray = [NSArray arrayWithObjects:@"tab-home-active", @"tab-project-active", @"tab-discover-active", @"tab-user-active", nil];
    labeltextArray = [NSArray arrayWithObjects:@"奖励活动", @"推荐好友", @"我的收藏",@"我的报备", nil];
    float with = kScreenWidth/labeltextArray.count;

    for (int i = 0;  i < labeltextArray.count ; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 6*AUTO_SIZE_SCALE_X, with, 70*AUTO_SIZE_SCALE_X)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-45*AUTO_SIZE_SCALE_X)/2, 0, 45*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-12*AUTO_SIZE_SCALE_X, with, 12*AUTO_SIZE_SCALE_X)];
        
        label.text = [labeltextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        imv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        [view addSubview:label];
        [view addSubview:imv];
        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:Viewtap];
        view.tag = i;
     
        [TitleView addSubview:view];
    }
}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 0:
            ;
            break;
        case 1:
            ;
            break;
        case 2:
            ;
            break;
        case 3:
            ;
            break;
        default:
            break;
    }
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 225*AUTO_SIZE_SCALE_X+1;
    
    
    [myTableView setTableHeaderView:HomeTableHeadView];

    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [homeListArray removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}

-(void)loadData
{
    //    [myTableView removeFromSuperview];
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           @"pageStart":@"1",
                           @"pageOffset":@"15",
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        NDLog(@"发现首页数据 -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            //            [activityIndicator stopAnimating];
            //            activityIndicator.hidden = YES;
            
            //            failView.hidden = YES;
            //            [failView.activityIndicatorView stopAnimating];
            //            failView.activityIndicatorView.hidden = YES;
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [homeListArray addObjectsFromArray:array];
            [myTableView reloadData];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        //        [myTableView.foot finishRefreshing];
        //        [myTableView.head finishRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
        //        [failView.activityIndicatorView stopAnimating];
        //        failView.activityIndicatorView.hidden = YES;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else{
        _pageForHot ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"15";
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
//                           @"cityCode":cityCode,
                           @"pageStart":page,
                           @"pageOffset":pageOffset,
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            //            failView.hidden = YES;
            //            [failView.activityIndicatorView stopAnimating];
            //            failView.activityIndicatorView.hidden = YES;
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [homeListArray removeAllObjects];
            }
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [homeListArray addObjectsFromArray:array];
            [myTableView reloadData];
            [refreshView endRefreshing];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        //        [myTableView.foot finishRefreshing];
        //        [myTableView.head finishRefreshing];
        
        //        failView.hidden = NO;
        //        [failView.activityIndicatorView stopAnimating];
        //        failView.activityIndicatorView.hidden = YES;
        [refreshView endRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return homeListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
//    NSString * type = [NSString stringWithFormat:@"%@",[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
//    //0 门店 1服务 2 技师 3图文
//    if ([type isEqualToString:@"3"]) {
//        //发现详情页
//        DetailFoundViewController * vc = [[DetailFoundViewController alloc] init];
//        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
//        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([type isEqualToString:@"0"]) {
//        //发现店铺详情页
//        StoreFoundViewController * vc = [[StoreFoundViewController alloc] init];
//        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
//        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([type isEqualToString:@"1"]) {
//        //发现服务详情页
//        ServiceFoundViewController * vc = [[ServiceFoundViewController alloc] init];
//        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
//        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([type isEqualToString:@"2"]) {
//        //发现技师详情页
//        WorkerFoundViewController * vc = [[WorkerFoundViewController alloc] init];
//        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
//        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}



@end
