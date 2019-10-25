//
//  AppDelegate.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "BaseNavgationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "ShowAnimationView.h"
#import <UMSocialCore/UMSocialCore.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "MyController.h"
#import "AdvertiseViewController.h"
#import "AdvertiseWebViewController.h"
#import "SDLaunchViewController.h"
#import "ConfigData.h"
#import "RequestManager.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "messageControlllerViewController.h"
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>{
    NSString * userID;
     int advitiesFlag;
    NSString *pic_url ;
    NSString *pic;

}

@end

@implementation AppDelegate

- (void)umengTrack {
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:NO];
    UMConfigInstance.appKey = kUmengAppkey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick setEncryptEnabled:YES];
    [MobClick startWithConfigure:UMConfigInstance];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    [self umengTrack];
    #pragma  添加初始化APNs代码
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
//            NSLog(@"------registrationID获取成功：%@",registrationID);
            
//            [[RequestManager shareRequestManager] tipAlert:registrationID];
        }
        else{
//            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    #pragma  获取iOS的推送内容需要在delegate类中注册通知并实现回调方法。
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:KJpushappKey
                          channel:KJpushchannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    #pragma  获取iOS的推送内容需要在delegate类中注册通知并实现回调方法。
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];

    //设置友盟appkey
    NSString *umengkey =[NSString stringWithFormat:@"%@",kUmengAppkey];
    [[UMSocialManager defaultManager] setUmSocialAppkey:umengkey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppKey appSecret:kWechatAppSecret redirectURL:kWechatAppSecretURL];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105896054"/*设置QQ平台的appID*/  appSecret:nil redirectURL:kWechatAppSecretURL];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    BOOL firstLaunch =[[ConfigData sharedInstance] isFirstLaunch];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startiOnclick) name:NOTIFICATION_NAME_USER_LOGOUT object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushsecondeview) name:NOTIFICATION_SECONDCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushsfirstview) name:NOTIFICATION_FirstCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushfourview) name:NOTIFICATION_FOURTHROLLER object:nil];
   
     if (firstLaunch) {//第一次装机启动进入 引导页面
//         firstLaunch = YES;
//         [userDefaults setBool:firstLaunch forKey:@"firstLaunch"];
//         [userDefaults synchronize];
          [self _intoGuideViewController];
     }else{
         [self startiOnclick];
     }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * qtx_auth = [userDefaults objectForKey:@"qtx_auth"];
    if (qtx_auth) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCheckVersionInMainPage object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCheckVersionInloginPage object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark- JPUSHRegisterDelegate

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
#pragma 前台收到远程通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        [self pushview];
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
//        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    #pragma 收到远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        [self pushview];
    }
    else {
        // 判断为本地通知
//        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


#pragma mark 实现回调方法 networkDidReceiveMessage
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];//content：获取推送的内容
    NSDictionary *extras = [userInfo valueForKey:@"extras"];//extras：获取用户自定义参数
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的 customizeField1：根据自定义key获取自定义的value
    
}

#pragma mark - init   GuideViewController

- (void)_intoGuideViewController
{
    GuideViewController *guid = [[GuideViewController alloc]init];
    self.window.rootViewController = guid;
}

- (void)startiOnclick{
    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"];
    if (userID) {
        if(!advitiesFlag) {
            advitiesFlag = TRUE;
            [self downLoadAdvertisement];
        }else{
            [self onMain];
        }
    }
    //未登录，需要先登录，然后跳转到推送页面
    else{
        if(!advitiesFlag) {
            advitiesFlag = TRUE;
            [self LoginWithAdvertisement];
        }else{
            [self gotoLoginViewController];
        }    
    }
    
}

#pragma mark 广告页加载
-(void)LoginWithAdvertisement{
    LoginViewController * loginvc = [[LoginViewController alloc] init];
    BaseNavgationController *baseNav =[[BaseNavgationController alloc] initWithRootViewController:loginvc];
    SDLaunchViewController *vc = [[SDLaunchViewController alloc] initWithMainVC:baseNav viewControllerType:ADLaunchViewController];
    vc.imageURL = @"广告图";
    self.window.rootViewController = vc;
}


#pragma mark 广告页加载
-(void)downLoadAdvertisement{
    MainViewController *main = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.mainController = main;
    BaseNavgationController *baseNav =[[BaseNavgationController alloc] initWithRootViewController:main];
    SDLaunchViewController *vc = [[SDLaunchViewController alloc] initWithMainVC:baseNav viewControllerType:ADLaunchViewController];
    vc.imageURL = @"广告图";
    self.window.rootViewController = vc;
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


-(void)pushview{    
    UIButton *b = [[UIButton alloc] init];
    b.tag = 3;
    [self.mainController selectorAction:b];
    MyController *mycontrol =  (MyController *)self.mainController.viewControllers[b.tag];
    [mycontrol pushview];
}

-(void)pushsecondeview{
    UIButton *b = [[UIButton alloc] init];
    b.tag = 1;
    [self.mainController selectorAction:b];    
}


-(void)pushsfirstview{
    UIButton *b = [[UIButton alloc] init];
    b.tag = 0;
    [self.mainController selectorAction:b];
}

-(void)pushfourview{
    UIButton *b = [[UIButton alloc] init];
    b.tag = 3;
    [self.mainController selectorAction:b];
    MyController *mycontrol =  (MyController *)self.mainController.viewControllers[b.tag];
    [mycontrol pushMyInviteView];
}

@end
