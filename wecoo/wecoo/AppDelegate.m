//
//  AppDelegate.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "BaseNavgationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
@interface AppDelegate (){
    NSString * userID;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    BOOL isLaunch = [[ConfigData sharedInstance]isFirstLaunch];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    userID = [userDefaults   objectForKey:@"userID"];
    BOOL firstLaunch = [userDefaults   boolForKey:@"firstLaunch"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startiOnclick) name:NOTIFICATION_NAME_USER_LOGOUT object:nil];

    
   
    
     if (!firstLaunch) {
         firstLaunch = YES;
         [userDefaults setBool:firstLaunch forKey:@"firstLaunch"];
          [self _intoGuideViewController];
     }else{
         [self startiOnclick];
     }
//    if (firstLaunch) {
//        //第一次装机启动进入 引导页面
//        [self _intoGuideViewController];
//        
//    }else
//    {
//        firstLaunch = YES;
//        [userDefaults setBool:firstLaunch forKey:@"firstLaunch"];
//        //如果用户已登陆，跳转到推送页面
//        if (userID) {
//            [self onMain];
////            if (userInfo) {
////                [RequestManager shareRequestManager].setRootVC = YES;
////                [RequestManager shareRequestManager].canuUMPush = NO;
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
////                                                                    object:nil userInfo:userInfo];
////            }
//        }
//        //未登录，需要先登录，然后跳转到推送页面
//        else{
//            [self gotoLoginViewController];
////            if (userInfo) {
////                [RequestManager shareRequestManager].setRootVC = YES;
////                [RequestManager shareRequestManager].canuUMPush = NO;
////                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
////                //                                                                    object:nil userInfo:userInfo];
////            }
//        }
//    }
    [self.window makeKeyAndVisible];
    
    
    return YES;


//    
//    UIViewController *viewController = [[UIViewController alloc] init];
//    self.window.rootViewController = viewController;
//    
//    self.window.backgroundColor = [UIColor purpleColor];
//    [self.window makeKeyAndVisible];
//   
//      return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - init   GuideViewController

- (void)_intoGuideViewController
{
    GuideViewController *guid = [[GuideViewController alloc]init];
    self.window.rootViewController = guid;
}

- (void)startiOnclick{
//    userID =@"123123123";
            if (userID) {
                [self onMain];
    //            if (userInfo) {
    //                [RequestManager shareRequestManager].setRootVC = YES;
    //                [RequestManager shareRequestManager].canuUMPush = NO;
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
    //                                                                    object:nil userInfo:userInfo];
    //            }
            }
            //未登录，需要先登录，然后跳转到推送页面
            else{
                [self gotoLoginViewController];
    //            if (userInfo) {
    //                [RequestManager shareRequestManager].setRootVC = YES;
    //                [RequestManager shareRequestManager].canuUMPush = NO;
    //                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
    //                //                                                                    object:nil userInfo:userInfo];
                }
}

- (void)onMain
{
    MainViewController *main = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.mainController = main;
    BaseNavgationController *baseNav =[[BaseNavgationController alloc] initWithRootViewController:main];
    
    self.window.rootViewController =baseNav;
}

-(void)gotoLoginViewController
{
    LoginViewController * vc = [[LoginViewController alloc] init];
    BaseNavgationController *baseNav =[[BaseNavgationController alloc] initWithRootViewController:vc];
//    NSLog(@"userInfoDic %@",userInfoDic);
//    if (userInfoDic) {
//        [vc setUMPush:userInfoDic];
//    }
    self.window.rootViewController = baseNav ;
}

@end
