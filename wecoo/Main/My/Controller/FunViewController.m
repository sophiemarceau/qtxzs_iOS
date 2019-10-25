//
//  FunViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "FunViewController.h"
#import "ShareQRCodeView.h"
#import "WXApi.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SharedView.h"

@interface FunViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,SelectSharedTypeDelegate>{
    UIWebView * webView;
    UITableView *tableView;
    UILabel *shareLabel;
    NSString *path;
}

@property (nonatomic,strong)UIButton *directButton;
@end

@implementation FunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarView];
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.view.backgroundColor =[UIColor whiteColor];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kShareOnclickFun object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareWechat:) name:kShareOnclickFun object:nil];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    webView.scrollView.bounces=NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.opaque = NO; //去掉下面黑线
    webView.backgroundColor =[UIColor clearColor];
    webView.delegate = self;
    path = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"wanZhuan.html"];
    NSURL *url = [NSURL URLWithString:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [webView sizeToFit];
   
    
    [self.view addSubview:tableView];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
}

-(void)shareClick:(UIButton *)sender{
    [MobClick event:kFunshareonclickButton];
    SharedView *show = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.dicarray = @[
                      @{@"icon-image":@"icon-shareWeixin",@"value":@"微信好友",@"shareflag":@"1"},
                      @{@"icon-image":@"icon-sharePyq",@"value":@"朋友圈",@"shareflag":@"2"},
                      @{@"icon-image":@"icon-shareQQ",@"value":@"QQ好友",@"shareflag":@"3"},
                      @{@"icon-image":@"icon-shareQzone@3x",@"value":@"QQ空间",@"shareflag":@"4"},
                      ] ;
    show.delegate = self;
    [show showView];
}

-(void)SelectSharedTypeDelegateReturnPage:(NSDictionary *)returnTypeDic{
    NSString *shared = returnTypeDic[@"shareflag"];
    if ([shared isEqualToString:@"1"]||[shared isEqualToString:@"2"]) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"您的设备没有安装微信"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if ([shared isEqualToString:@"1"]) {
        [MobClick event:kShareWechatFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    
    if ([shared isEqualToString:@"2"]) {
        [MobClick event:kShareWechatCircleOfFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if ([shared isEqualToString:@"3"]) {
        [self isQQInstall];
        [MobClick event:kShareQQFriendEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if ([shared isEqualToString:@"4"]) {
        [self isQQInstall];
        [MobClick event:kShareQQSpaceEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
    
}

-(void)isQQInstall{
    if (![QQApiInterface isQQInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的设备没有安装QQ"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

//-(void)shareWechat: (NSNotification *)notification{
//    
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *shared = userInfo[@"shareflag"];
//    if ([shared isEqualToString:@"0"]||[shared isEqualToString:@"1"]) {
//        if (![WXApi isWXAppInstalled]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"您的设备没有安装微信"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//    }
//    if ([shared isEqualToString:@"0"]) {
//        [MobClick event:kShareQRCODEToFriend];
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
//    }
//    
//    if ([shared isEqualToString:@"1"]) {
//        [MobClick event:kShareQRCODEToMoments];
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
//    }
//    
//}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    
    NSString *titles = @"玩转渠到天下只需3步";
    NSString *desc = @"玩转渠到天下，每天10分钟，每月1万赏金很轻松！";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"渠天下icon"]];
    
    //设置网页地址
//    NSString *joingstr = [NSString stringWithFormat:@"joinUs.html?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    shareObject.webpageUrl = path;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}



- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"" forState:UIControlStateNormal];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(60-21, 4.5, 17, 21)];
        imv.image = [UIImage imageNamed:@"icon-header-share"];
        [self.directButton addSubview:imv];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom).offset(-7);
        make.right.equalTo(self.navView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

#pragma mark TableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
    NSInteger height = [[web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    
    webView.frame=CGRectMake(0, 0, kScreenWidth,height);
    
    tableView.tableHeaderView = webView;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titles = title;
    [LZBLoadingView dismissLoadingView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"request----->%@",requestString);
    if([requestString containsString:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.wecoo.qutianxia"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FirstCONTROLLER object:nil];
        return NO;
    }
    
    return YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kFunQuPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kFunQuPage];
}


@end
