//
//  WebViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "WebViewController.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShowShareView.h"
#import "WXApi.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface WebViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,SelectSharedTypeDelegate>{
    UITableView *tableView;
}

@property (nonatomic,strong)UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;//去掉下面黑线
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    NSString *path = self.webViewurl;
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    if(![self.webtitle isEqualToString:@""]){
         [self initNavBarView];
    }
    if ([self.webViewurl containsString:@"disclaimer.html"]) {
        self.directButton.hidden = YES;
    }
    if ([self.webViewurl containsString:@"guizeinvitation.html"]) {
        self.directButton.hidden = YES;
    }
    if ([self.webViewurl containsString:@"guizepartner.html"]) {
        self.directButton.hidden = YES;
    }
    
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [LZBLoadingView dismissLoadingView];
//    });

}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom).offset(-7);
        make.right.equalTo(self.navView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark share board
-(void)shareClick:(UIButton *)sender{
    NSLog(@"shareClick---------%@",self.webViewurl);

    if([self.fromWhere isEqualToString:@"silk"]){
        [MobClick event:kShareSlikBagEvent];
    }
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
    if ([shared isEqualToString:@"0"]) {
       
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

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    NSString *titles = self.webtitle;
    NSString *desc = self.webtitle;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"渠天下icon"]];
    //设置网页地址
    NSString *joingstr = [NSString stringWithFormat:@"%@",self.webViewurl];
    shareObject.webpageUrl = joingstr;
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titles = title;
    [self.view addSubview:self.webView];
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
        NSLog(@"request----->%@",requestString);
    
    if ([requestString containsString:@"appShare.html"]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        ShowShareView *show = [[ShowShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        show.sharefrom = @"friend";
//        [show showView];
        SharedView *show = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        show.dicarray = @[
                          @{@"icon-image":@"icon-shareWeixin",@"value":@"微信好友",@"shareflag":@"1"},
                          @{@"icon-image":@"icon-sharePyq",@"value":@"朋友圈",@"shareflag":@"2"},
                          @{@"icon-image":@"icon-shareQQ",@"value":@"QQ好友",@"shareflag":@"3"},
                          @{@"icon-image":@"icon-shareQzone@3x",@"value":@"QQ空间",@"shareflag":@"4"},
                          ] ;
        show.delegate = self;
        [show showView];
        return NO;
    }else if([requestString containsString:@"projectList.html"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SECONDCONTROLLER object:nil];
        return NO;
    }else if([requestString containsString:@"invitationlink2app.html"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FOURTHROLLER object:nil];
        return NO;
    }else{
        return YES;

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kLawPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kLawPage];
}


@end
