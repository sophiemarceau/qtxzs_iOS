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
#import "ActivityListViewController.h"
#import "MyFavrioteViewController.h"
#import "MyReportListViewController.h"
#import "ShowAnimationView.h"
#import "DetailProjectViewController.h"
#import "ShowShareView.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "MyReportListViewController.h"
#import "WithdrawViewController.h"
#import "WebViewController.h"
#import "BaseNavgationController.h"
#import "BalanceViewController.h"
#import "WXApi.h"
#import "MyInviteViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,SDCycleScrollViewDelegate,UIGestureRecognizerDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    SDCycleScrollView  *cycleview;
    UIView *rookibgview;
    UIImageView *TitleView;
    NSTimer *_topPictureTimer;
    NSMutableArray * homeListArray;
    NSMutableArray *imagesURLStrings;
    NSMutableArray *imagesList;
    NSMutableArray *_imgData;
    int current_page;
    int total_count;
    int _pageForHot;
    Boolean isHeaderFreshflag;
    NSDictionary *dto;
    int newguideprojectid;
}

@property(nonatomic,strong)UIView *HomeTableHeadView;
@property(nonatomic,assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation HomeViewController

- (void)viewDidLoad {
    isHeaderFreshflag = false;
    [super viewDidLoad];
   
    homeListArray = [[NSMutableArray alloc] initWithCapacity:0];
    imagesURLStrings = [NSMutableArray arrayWithCapacity:0];
    imagesList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initTableView];
    
    [self loadData];
}




-(void)NewGuideViewTaped:(UITapGestureRecognizer *)sender
{
//    NSLog(@"%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 0:
        {
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            MainViewController  *mainVC= (MainViewController *)appDelegate.mainController;
//            UIButton *tempbutton =[[UIButton alloc]init];
//            tempbutton.tag =1;
//            [mainVC selectorAction:tempbutton];
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            BaseNavgationController *tab = (BaseNavgationController *)delegate.window.rootViewController;
//            tab.selectedIndex = 1;
            [MobClick event:kHomePageSelectMyProjectEvent];
                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SECONDCONTROLLER object:nil];
            break;
        }
            
        case 1:{
          [MobClick event:kHomePageSelectReportClientEvent];
            DetailProjectViewController *vc = [[DetailProjectViewController alloc] init];
            vc.project_id = newguideprojectid;
            vc.newGuideFlag = 1;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 2:{
            [MobClick event:kHomePageSelectRewardEvent];

            BalanceViewController *vc = [[BalanceViewController alloc] init];
            vc.titles = @"我的赏金";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }

}

- (void)reloadButtonClick:(UIButton *)sender {
    isHeaderFreshflag = NO;
    [self loadData];
}

-(void)loadData
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [homeListArray removeAllObjects];
    [imagesURLStrings removeAllObjects];
    [imagesList removeAllObjects];
    NSDictionary *dic1 = @{};
    [[RequestManager shareRequestManager] SearchAdDtoListResult:dic1 viewController:self successData:^(NSDictionary *result){
         failView.hidden = YES;
         [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            NSArray * imgArray = [NSArray arrayWithArray: [[result objectForKey:@"data"]objectForKey:@"list"]];
            [imagesList addObjectsFromArray:imgArray];
            for (NSDictionary * dic in imgArray) {
                [imagesURLStrings addObject:[dic objectForKey:@"ad_pic"]];
            }
            if(imagesURLStrings !=nil && imagesURLStrings.count !=0){
                 cycleview.imageURLStringsGroup = imagesURLStrings;
            }else{
            }
            [self loadListData];
            [self loadNewGuideViewData];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:[error networkErrorInfo] viewController:self];
        failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
    }];
}

-(void)loadListData{
    
    current_page = 0;
    [homeListArray removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchPromotingProjectsResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (isHeaderFreshflag==true) {
                [myTableView.head endRefreshing];
            }
//            NSLog(@"array----%@",array);
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [homeListArray addObjectsFromArray:array];
            }else{
            }
            [myTableView reloadData];
            if (homeListArray.count == total_count) {
                 [myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [myTableView.head finishRefreshing];
        [myTableView.foot finishRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:[error networkErrorInfo]  viewController:self];
        failView.hidden = NO;
    }];
}

-(void)loadNewGuideViewData{
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic1 = @{};
    
    [[RequestManager shareRequestManager] NewGuideResult:dic1 viewController:self successData:^(NSDictionary *result){
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
       

        
        if(IsSucess(result)){
            
            dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){
                int flag = [[dto objectForKey:@"isShowNewbieGuide"] intValue];
                if (flag==1) {
                    newguideprojectid = [[dto objectForKey:@"projectId"] intValue];
                    [self initRookieView];
                }else{
                    [rookibgview removeFromSuperview];
                    self.HomeTableHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 275*AUTO_SIZE_SCALE_X)];
                }

            }
//            if(![[[result objectForKey:@"data"] objectForKey:@"result"] isEqual:[NSNull null]] && [[result objectForKey:@"data"] objectForKey:@"result"] !=nil){
//                int flag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
//                if (flag==1) {
//                    [self initRookieView];
//                }else{
//                    [rookibgview removeFromSuperview];
//                    self.HomeTableHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 275*AUTO_SIZE_SCALE_X)];
//                }
//            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result  viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:[error networkErrorInfo] viewController:self];
        failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
        isHeaderFreshflag = true;
        [self loadData];
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
    [[RequestManager shareRequestManager] SearchPromotingProjectsResult:dic viewController:self successData:^(NSDictionary *result) {
        failView.hidden = YES;
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [homeListArray removeAllObjects];
            }
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [homeListArray addObjectsFromArray:array];
            }else{
            }
            [myTableView reloadData];

            [refreshView endRefreshing];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [self loadNewGuideViewData];
                [myTableView.head endRefreshing];
            }
            if (homeListArray.count == total_count) {
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
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"-------%@",[imagesList[index] objectForKey:@"ad_url"] );
    if ([[imagesList[index] objectForKey:@"ad_url"] isEqualToString:@""]) {
        return;
    }
    [MobClick event:kBannerEvent label:[NSString stringWithFormat:@"%ld",[[[imagesList objectAtIndex:index] objectForKey:@"ad_id"] integerValue]]];

    WebViewController *vc = [[WebViewController alloc] init];
    vc.webViewurl = [imagesList[index] objectForKey:@"ad_url"];
    vc.webtitle = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
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
    cell.backgroundColor = [UIColor clearColor];
    
    
//    NSLog(@"%lu",(unsigned long)homeListArray.count);
    
    if (homeListArray.count>0) {
        UIImageView *pic = [UIImageView new];
        pic.backgroundColor = [UIColor clearColor];
        [pic setImageWithURL:[NSURL URLWithString:[homeListArray[indexPath.row] objectForKey:@"project_pic_ad"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        pic.frame = CGRectMake(0, 0, kScreenWidth, 140*AUTO_SIZE_SCALE_X);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, pic.frame.size.height, kScreenWidth, 200*AUTO_SIZE_SCALE_X+1-pic.frame.size.height-10*AUTO_SIZE_SCALE_X)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel =  [CommentMethod initLabelWithText:[homeListArray[indexPath.row] objectForKey:@"project_name"] textAlignment:NSTextAlignmentLeft font:18*AUTO_SIZE_SCALE_X];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = FontUIColorBlack;
        titleLabel.frame = CGRectMake(15, 0, 240*AUTO_SIZE_SCALE_X, bgView.frame.size.height);
        
//        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, pic.frame.size.height-1, kScreenWidth, 0.5)];
//        lineImageView.backgroundColor = lineImageColor;
        
        UILabel *priceLabel =  [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:15*AUTO_SIZE_SCALE_X];
        priceLabel.textColor = FontUIColorBlack;
        priceLabel.numberOfLines = 1;
        priceLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        priceLabel.textAlignment =NSTextAlignmentRight;
        
        NSString *string = nil;
        int first = [[homeListArray[indexPath.row] objectForKey:@"project_commission_first"] intValue];
        int second = [[homeListArray[indexPath.row] objectForKey:@"project_commission_second"] intValue];
        NSString *str ;
        int index ;
        if (first==second) {
            string = [NSString stringWithFormat:@"%d元", [[homeListArray[indexPath.row] objectForKey:@"project_commission_first"] intValue]];
            str = [NSString stringWithFormat:@"%@%@",@"签约佣金",string];
            index = 4;
        }else{
            int temp ;
            if(first > second){
                temp=first;
            }else{
                temp=second;
            }
            string = [NSString stringWithFormat:@"%d元", temp ];
            str = [NSString stringWithFormat:@"%@%@",@"最高佣金",string];
            index = 4;
        }
        
        NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
        
        priceLabel.attributedText = mutablestr;
        [priceLabel sizeToFit];
        priceLabel.frame = CGRectMake(kScreenWidth-15-130*AUTO_SIZE_SCALE_X, 0, 130*AUTO_SIZE_SCALE_X, bgView.frame.size.height);
        
        UIImageView *line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x-25/2*AUTO_SIZE_SCALE_X, (50*AUTO_SIZE_SCALE_X-55/2*AUTO_SIZE_SCALE_X)/2, 0.5, 55/2*AUTO_SIZE_SCALE_X)];
        line1ImageView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        titleLabel.text  = [homeListArray[indexPath.row] objectForKey:@"project_name"];
        [cell addSubview:pic];
//        [cell addSubview:lineImageView];
        [cell addSubview:bgView];
        [bgView addSubview:titleLabel];
        [bgView addSubview:line1ImageView];
        [bgView addSubview:priceLabel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"project_id -- %ld",[[[homeListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]);
    [MobClick event:kHomePageListEvent label:[NSString stringWithFormat:@"%ld",[[[homeListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    DetailProjectViewController *vc = [[DetailProjectViewController alloc] init];
    
    vc.project_id = [[[homeListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=0) {
        //            imv.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
        self.navView.alpha = scrollView.contentOffset.y/(240.0*AUTO_SIZE_SCALE_X);
        
    }
    //        CGFloat xx = 0.0; //0-1
    //        xx = (-scrollView.contentOffset.y)/(65.0);
    //        myTableView.frame = CGRectMake(0, 20*(xx), kScreenWidth, kScreenHeight-20*(xx));
    
//    if (scrollView.contentOffset.y <= 0)
//    {
//        CGPoint offset = scrollView.contentOffset;
//        offset.y = 0;
//        scrollView.contentOffset = offset;
//    }
}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 0:
        {
            [MobClick event:kHomePageActivityEvent];
            ActivityListViewController  *vc = [[ActivityListViewController alloc] init];
            vc.titles = @"奖励活动";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 1:{
            [MobClick event:kHomePageShareFrientEvent];
            MyInviteViewController *vc = [[MyInviteViewController alloc] init];
            vc.titles = @"我的邀请";
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
            
        case 2:{
            [MobClick event:kHomePageMyCollectEvent];
            MyFavrioteViewController *vc = [[MyFavrioteViewController alloc] init];
            vc.titles = @"我的关注";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3:{
            [MobClick event:kHomePageMyReportEvent];
            MyReportListViewController * vc = [[MyReportListViewController alloc] init];
            vc.menuTag = 1;
            vc.titles =@"已推荐客户";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)initTableView
{
    [self.navView removeFromSuperview];
    self.titles = @"首页";
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = (200*AUTO_SIZE_SCALE_X)+1;
    [myTableView setTableHeaderView:self.HomeTableHeadView];
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    [self.view addSubview:self.navView];
    self.navView.alpha = 0;
}

-(UIView *)HomeTableHeadView{
    if (_HomeTableHeadView== nil) {
        self.HomeTableHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 275*AUTO_SIZE_SCALE_X)];
        self.HomeTableHeadView.backgroundColor = UIColorFromRGB(0xf4f4f4);
        // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
        cycleview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 175*AUTO_SIZE_SCALE_X) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cycleview.pageControlBottomOffset = 25*AUTO_SIZE_SCALE_X;
        cycleview.pageDotImage = [UIImage imageNamed:@"icon-indexBanner"];
        cycleview.currentPageDotImage = [UIImage imageNamed:@"icon-indexBannerActive"];
       
        [self.HomeTableHeadView addSubview:cycleview];
        [self initTitleView];
    }
    return _HomeTableHeadView;
}

-(void)initTitleView{
    UIImageView *archView = [[UIImageView alloc] init];
    archView.frame = CGRectMake(0, cycleview.frame.size.height-15*AUTO_SIZE_SCALE_X, kScreenWidth, 15*AUTO_SIZE_SCALE_X);
    UIImage * backImage;
    backImage = [UIImage imageNamed:@"cover-indexBanner1242"];
    archView.image = backImage;
    [self.HomeTableHeadView addSubview:archView];
    TitleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, archView.frame.origin.y+archView.frame.size.height, kScreenWidth, 95*AUTO_SIZE_SCALE_X)];
    TitleView.backgroundColor = UIColorFromRGB(0xffffff);
    TitleView.userInteractionEnabled = YES;
    [self.HomeTableHeadView addSubview:TitleView];
    
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    norArray = [NSArray arrayWithObjects:@"icon-indexMenu01", @"icon-indexMenu02", @"icon-indexMenu03", @"icon-indexMenu04", nil];
    selectArray = [NSArray arrayWithObjects:@"icon-indexMenu01", @"icon-indexMenu02", @"icon-indexMenu03", @"icon-indexMenu04", nil];
    labeltextArray = [NSArray arrayWithObjects:@"奖励活动", @"我的邀请", @"我的关注",@"已推荐客户", nil];
    float with = kScreenWidth/labeltextArray.count;
    
    for (int i = 0;  i < labeltextArray.count ; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 6*AUTO_SIZE_SCALE_X, with, 70*AUTO_SIZE_SCALE_X)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-56*AUTO_SIZE_SCALE_X)/2, 0, 56*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
        
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


-(void)initRookieView{
    self.HomeTableHeadView.frame =CGRectMake(self.HomeTableHeadView.frame.origin.x, self.HomeTableHeadView.frame.origin.y, self.HomeTableHeadView.frame.size.height, 773/2*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X);
    rookibgview = [[UIView alloc] initWithFrame:CGRectMake(0, 773/2*AUTO_SIZE_SCALE_X-237/2*AUTO_SIZE_SCALE_X, kScreenWidth, 237/2*AUTO_SIZE_SCALE_X)];
    rookibgview.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.HomeTableHeadView addSubview:rookibgview];
    
    UIView *rookview = [[UIView alloc] initWithFrame:CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 218/2*AUTO_SIZE_SCALE_X)];
    rookview.backgroundColor = [UIColor whiteColor];
    UIImageView * bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X)];
    bannerImageView.image = [UIImage imageNamed:@"bg-newcomer"];
    [rookview addSubview:bannerImageView];
    UILabel * bannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0*AUTO_SIZE_SCALE_X,22.5*AUTO_SIZE_SCALE_X,60*AUTO_SIZE_SCALE_X)];
    bannerLabel.numberOfLines = 0;
    bannerLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    bannerLabel.textColor = [UIColor whiteColor];
    bannerLabel.textAlignment = NSTextAlignmentCenter;
    bannerLabel.text = @"新手引导";
    bannerLabel.backgroundColor = [UIColor clearColor];
    [rookview addSubview:bannerLabel];
    
    [rookibgview addSubview:rookview];
    
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    norArray = [NSArray arrayWithObjects:@"icon-newcomerStep1", @"icon-newcomerStep2", @"icon-newcomerStep3",  nil];
    selectArray = [NSArray arrayWithObjects:@"icon-newcomerStep1", @"icon-newcomerStep2", @"icon-newcomerStep3", nil];
    labeltextArray = [NSArray arrayWithObjects:@"选项目", @"推荐客户", @"领赏金", nil];
    float with = kScreenWidth/labeltextArray.count;

    for (int i = 0;  i < labeltextArray.count; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 10, with, 218/2*AUTO_SIZE_SCALE_X)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-60*AUTO_SIZE_SCALE_X)/2, 0, 60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X)];
        view.backgroundColor = [UIColor clearColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((with-138/2*AUTO_SIZE_SCALE_X)/2, imv.frame.size.height+imv.frame.origin.y+7*AUTO_SIZE_SCALE_X, 138/2*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 9*AUTO_SIZE_SCALE_X;
        label.text = [labeltextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X];
        label.backgroundColor = UIColorFromRGB(0xffa63c);
        label.textColor = [UIColor whiteColor];
        imv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        [view addSubview:label];
        [view addSubview:imv];
        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewGuideViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:NewViewtap];
        view.tag = i;
        [rookview addSubview:view];
       
    }
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *_lineImg = [[UIImageView alloc] initWithFrame:CGRectMake((with-60*AUTO_SIZE_SCALE_X)/2+60*AUTO_SIZE_SCALE_X+10,
                                                                          30*AUTO_SIZE_SCALE_X+20,
                                                                          45*AUTO_SIZE_SCALE_X, 2)];
    // 调用方法 返回的iamge就是虚线
    _lineImg.image = [self drawLineByImageView:_lineImg];
    // 添加到控制器的view上
    [rookibgview addSubview:_lineImg];
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *_lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2+30*AUTO_SIZE_SCALE_X+10,
                                                                          30*AUTO_SIZE_SCALE_X+20,
                                                                          45*AUTO_SIZE_SCALE_X, 2)];
    // 调用方法 返回的iamge就是虚线
    _lineImg1.image = [self drawLineByImageView:_lineImg1];
    // 添加到控制器的view上
    [rookibgview addSubview:_lineImg1];
    
    [myTableView setTableHeaderView:self.HomeTableHeadView];
    [myTableView reloadData];
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度  1是高度
//    float lengths[] = {5,1};

    CGFloat lengths[] ={5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, UIColorFromRGB(0xb3b2b3).CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, kScreenWidth - 10, 2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kPageOne];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kPageOne];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}
/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
/*
 开启ios右滑返回
 */
- (void)startSideBack {
    self.isCanUseSideBack=YES;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanUseSideBack;
}

@end
