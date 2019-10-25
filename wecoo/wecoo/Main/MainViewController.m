//
//  MainViewController.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/19.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "MainViewController.h"


#import "HomeViewController.h"
#import "ProjectController.h"
#import "FinderViewController.h"
#import "MyController.h"

#import "BaseNavgationController.h"

@interface MainViewController ()<UINavigationControllerDelegate>
{
    UIImageView *_selectImageView;
    UIImageView *_tabbarView;
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
}
@property (nonatomic,strong)UIButton *tabButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    NSLog(@"macinviewcontroller");
    self.view.backgroundColor = C2UIColorGray;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建子控制器
    [self _initViewControll];
    
    //自定义分栏控制器
    [self _initTabBar];
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
    labeltextArray = [NSArray arrayWithObjects:@"首页", @"项目", @"发现",@"我的", nil];
    
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
    
    
    
}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",(long)sender.view.tag);
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
- (void)selectorAction:(UIButton *)butt
{
    
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



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"checkVersion" object:nil];
    
}

@end
