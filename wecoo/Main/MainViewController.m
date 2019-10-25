//
//  MainViewController.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/19.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "HomeViewController.h"
#import "ProjectController.h"
#import "FinderViewController.h"
#import "MyController.h"
#import "ShowRegisterSucceedView.h"
#import "BaseNavgationController.h"
#import "UIImageView+WebCache.h"
#import "AdvertiseViewController.h"
#import "AdvertiseWebViewController.h"
#import "noWifiView.h"
#import "FunViewController.h"
#import "DetailProjectViewController.h"

@interface MainViewController ()<UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIImageView *_selectImageView;
    UIImageView *_tabbarView;
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    NSString *new_downloadUrl;
    NSString *pic_url ;
    NSString *pic;
    noWifiView *failView;
}
@property (nonatomic,strong)UIButton *tabButton;
@property (nonatomic,strong)UIButton *directButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCheckVersionInMainPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:kCheckVersionInMainPage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHowTogeiMoneyPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoneyPage) name:kHowTogeiMoneyPage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kgotoDetailProjectPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoDetailProject:) name:kgotoDetailProjectPage object:nil];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * firstRun = [userDefaults objectForKey:@"firstRun"];
    //存在需要查看版本更新
    if (firstRun) {
        //提示升级客户端
        [self checkVersion];
    }
    //不存在,为第一次启动,不需要 版本更新
    else{
        firstRun = @"alreadyRun";
        [userDefaults setObject:firstRun forKey:@"firstRun"];
    }
    [super viewDidLoad];
    [self _initViewControll];
}

#pragma mark Alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //可以使用，更新
    if (alertView.tag == 101) {
        if (buttonIndex == 0){
            
        }
        else if (buttonIndex == 1){
            //            NSString *str = [NSString stringWithFormat:
            //                             @"http://fir.im/75xc" ];
            //
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:new_downloadUrl]];
        }
    }
    //不可使用，必须更新
    else if(alertView.tag == 102){
        //        NSString *str = [NSString stringWithFormat:
        //                         @"http://fir.im/75xc" ];
        //
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:new_downloadUrl]];
    }
}

//创建子控制器
-(void)_initViewControll
{
    //创建三级视图
    HomeViewController *home = [[HomeViewController alloc]init];
    ProjectController *project = [[ProjectController alloc]init];
    FinderViewController *finder = [[FinderViewController alloc]init];
    MyController *myself = [[MyController alloc]init];
   
    //存储三级控制器
    NSArray *viewCtrl = @[home,project,finder,myself];
    
//    //创建二级视图导航控制器
//    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
//    for (int i = 0; i < viewCtrl.count; i++) {
//        UIViewController *viewControll = viewCtrl[i];
//        viewControll.hidesBottomBarWhenPushed = NO;
//        //创建二级导航控制器
//        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:viewControll];
//        nav.delegate = self;
//        [viewControllers addObject:nav];
//    }
    //将二级导航器交给控制器
//    self.viewControllers = viewControllers;
    self.viewControllers = viewCtrl;
    [self _initTabBar];
}

//自定义分栏控制器
-(void)_initTabBar
{
    //隐藏状态栏
    self.tabBar.hidden = YES;
    //设置tabbar的背景颜色和位置
    /*
     kScreenHeight - 49 和 kScreenHeight - 49 - 20  后者由于加载到了DDMenuController上面
     二级控制器的frame是（0 ，0 ，320，460）;
     DDMenuController的frame是（0，20，320，460）;
     */
    _tabbarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
     _tabbarView.image =[UIImage imageNamed:@"tabbar_bg"];
//    _tabbarView.image =[ZCControl createImageWithColor:[UIColor whiteColor]];
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
    norArray = [NSArray arrayWithObjects:@"tab-home", @"tab-project", @"tab-discover", @"tab-user", nil];
    
    selectArray = [NSArray arrayWithObjects:@"tab-home-active", @"tab-project-active", @"tab-discover-active", @"tab-user-active", nil];
    labeltextArray = [NSArray arrayWithObjects:@"首页", @"悬赏", @"发现",@"我的", nil];
    
    self.buttons = [NSMutableArray arrayWithCapacity:0];
    self.imvArray = [NSMutableArray arrayWithCapacity:0];
    self.labelArray = [NSMutableArray arrayWithCapacity:0];
    float with = kScreenWidth/labeltextArray.count;

    for (int i = 0;  i < labeltextArray.count ; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 0, with, 49)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-26)/2, 5, 26, 26)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, with, 20)];
        label.text = [labeltextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        if (i == 0) {
            imv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
            label.textColor = RedUIColorC1;
            self.selectedIndex = 0;
        }else{
            imv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
            label.textColor = C6UIColorGray;
        }
        [view addSubview:label];
        [view addSubview:imv];
        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:Viewtap];
        view.tag = i;
        [self.imvArray addObject:imv];
        [self.labelArray addObject:label];
        [_tabbarView addSubview:view];
    }
    _tabbarView.hidden =NO;
}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag == 0) {
        [MobClick event:kTAB_HomeEvent];
    }
    else if (sender.view.tag == 1){
        [MobClick event:kTAB_ProjectEvent];
    }
    else if (sender.view.tag == 2){
        [MobClick event:kTAB_FindEvent];
    }
    else if (sender.view.tag == 3){
        [MobClick event:kTAB_MYEvent];
    }
   
//    NSLog(@"%ld",(long)sender.view.tag);
    self.selectedIndex = sender.view.tag;
    for (int i=0; i < self.imvArray.count; i++) {
        UIImageView * selectimv = (UIImageView *)[self.imvArray objectAtIndex:i];
        if (sender.view.tag == i) {
            selectimv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        }else
        {
            selectimv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
        }
    }
    for (int i=0; i < self.labelArray.count; i++) {
        UILabel * selectlabel = (UILabel *)[self.labelArray objectAtIndex:i];
        if (sender.view.tag == i) {
            selectlabel.textColor = RedUIColorC1;
        }else
        {
            selectlabel.textColor = C6UIColorGray;
        }
    }
}

//分栏按钮事件
- (void)selectorAction:(UIButton *)butt{
    self.selectedIndex = butt.tag;
    
    for (int i=0; i < self.imvArray.count; i++) {
        UIImageView * selectimv = (UIImageView *)[self.imvArray objectAtIndex:i];
        if (butt.tag == i) {
            selectimv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        }else
        {
            selectimv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
        }
    }
    for (int i=0; i < self.labelArray.count; i++) {
        UILabel * selectlabel = (UILabel *)[self.labelArray objectAtIndex:i];
        if (butt.tag == i) {
            selectlabel.textColor = RedUIColorC1;
        }else
        {
            selectlabel.textColor = C6UIColorGray;
        }
    }
    
    // 1.控制状态
    self.tabButton.selected = NO;
    for (UIButton *temp in self.buttons) {
        if (temp.tag ==butt.tag) {
            temp.selected = YES;
            self.tabButton = temp;
            [UIView animateWithDuration:0.35 animations:^{
                _selectImageView.center = temp.center;
            }];
        }
    }
}


//-(void)showTabbar
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    _tabbarView.left = 0;
//    [UIView commitAnimations];
//    
//}
//-(void)hideTabbar
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    _tabbarView.left = -kScreenWidth;
//    [UIView commitAnimations];
//    
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstLaunch = [userDefaults   boolForKey:@"firstGuide"];
    
    if (!firstLaunch) {
        firstLaunch = YES;
        [userDefaults setBool:firstLaunch forKey:@"firstGuide"];
        [userDefaults synchronize];
        
        ShowRegisterSucceedView *show = [[ShowRegisterSucceedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [show showView];
         _tabbarView.hidden =NO;
        return;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"checkVersion" object:nil];
}

#pragma mark 版本更新
-(void)checkVersion
{
    NSDictionary * versionDic = @{
                                  @"source":@"2",
                                  @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                  };
    [[RequestManager shareRequestManager] getVersionInfo:versionDic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"客户端版本信息 mainresult %@",result);
        failView.hidden = YES;
        if(IsSucess(result)){
            new_downloadUrl = @"";
            new_downloadUrl = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]];
            NSString *versionFlag = [[result objectForKey:@"data"] objectForKey:@"result"];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * VersionAletshow = [userDefaults objectForKey:@"VersionAletshow"];
            //0 已是最新 1 可更新 2必更新
            if([versionFlag isEqualToString:@"1"] ){
                //可更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本有新的更新，是否现在去更新" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alertView.tag = 101;
                if (VersionAletshow) {
                    //已提示
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *lastRunVersion = [defaults objectForKey:IS_UPDATE_VERSION];
                    NSLog(@"lastRunVersion--->%@",lastRunVersion);
                    if ([lastRunVersion isEqualToString:@"1"]) {
                        
                        [defaults setObject:@"0" forKey:IS_UPDATE_VERSION];
                        
                        [defaults synchronize];
                        NSString *version = [defaults objectForKey:IS_UPDATE_VERSION];
                        NSLog(@"lastRunVersion--->%@",version);
                        [alertView show];
                        
                    }

                }else{
                    
                    [alertView show];
                    VersionAletshow = @"1";
                    [userDefaults setObject:VersionAletshow forKey:@"VersionAletshow"];
                }
            }else if([versionFlag isEqualToString:@"2"]){
                //必须更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本已不可用，请更新后使用" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles: nil];
                alertView.tag = 102;
                [alertView show];
            }else{
                return ;
            }
        }
    } failuer:^(NSError *error) {
//        NSLog(@"%@",error);
        _tabbarView.hidden =NO;
//        [self checkVersion];
    }];
}

#pragma mark getMoneyPage
-(void)getMoneyPage{
//    AdvertiseWebViewController *vc = [[AdvertiseWebViewController alloc] init];
//    vc.advertiseUrlString = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"wanZhuan.html"];
//    [self.navigationController pushViewController:vc animated:NO];
    FunViewController *vc = [[FunViewController alloc] init];
    vc.titles =@"玩转渠到天下";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoDetailProject:(NSNotification *)notification {
    DetailProjectViewController *vc = [[DetailProjectViewController alloc] init];
    vc.project_id = [[notification.userInfo objectForKey:@"project_id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
