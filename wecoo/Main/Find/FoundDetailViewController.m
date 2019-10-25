//
//  FoundDetailViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/24.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "FoundDetailViewController.h"
#import "SharedView.h"
#import "WXApi.h"
#import "GuideView.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
@interface FoundDetailViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,SelectSharedTypeDelegate>{
    UIWebView * findwebView;
    UITableView *tableView;
}

@property(nonatomic,strong)UIButton *directButton;
@end

@implementation FoundDetailViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self initNavBarView];
//    
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
//    tableView.backgroundColor = [UIColor clearColor];
//    tableView.showsVerticalScrollIndicator = NO;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.bounces = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
    findwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    findwebView.delegate = self;
    findwebView.scrollView.bounces=NO;
    findwebView.scrollView.showsHorizontalScrollIndicator = NO;
    findwebView.backgroundColor = [UIColor whiteColor];
    findwebView.opaque = NO;//去掉下面黑线
    findwebView.scrollView.backgroundColor = [UIColor clearColor];
    
    NSURL *url = [NSURL URLWithString:self.requestUrlStr];
    [findwebView loadRequest:[NSURLRequest requestWithURL:url]];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.view addSubview:findwebView];
    
    
    
//    findwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
//    findwebView.scrollView.bounces=NO;
//    findwebView.scrollView.showsHorizontalScrollIndicator = NO;
//    findwebView.scrollView.scrollEnabled = NO;
//    findwebView.opaque = NO; //去掉下面黑线
//    findwebView.backgroundColor =[UIColor clearColor];
//    findwebView.delegate = self;
//    NSString *path = @"http://m.teteparts.com/discover.html?qtx_auth=";
//    NSMutableString *finalPath = [NSMutableString string];
//    
//    [finalPath appendString:[NSString stringWithFormat:@"%@%@",path,[[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"]]];
//    [finalPath appendString:@"&t="];
//    NSMutableString *interval = [[NSMutableString alloc] init];
//    
//    NSDate *date = [NSDate date];
//    NSTimeInterval time = [date timeIntervalSince1970]*1000;//毫秒数要乘以1000
//    double i=time;      //NSTimeInterval返回的是double类型
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"Z"];
//    NSString *timeZone = [format stringFromDate:date];
//    NSString *timeIntervalStr = [NSString stringWithFormat:@"%.f", i];
//    
//    [interval appendString:timeIntervalStr];
//    [interval appendString:timeZone];
//    
//    [finalPath appendString:interval];
//    
//    NSURL *url = [NSURL URLWithString:self.requestUrlStr];
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    [findwebView loadRequest:[NSURLRequest requestWithURL:url]];
//    
//    [findwebView sizeToFit];
//    
//    [self.view addSubview:tableView];
    
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

-(void)shareClick:(UIButton *)sender{
    [MobClick event:kShareProjectDetailEvent];
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
    NSString *titles = self.titles;
    NSString *desc = @"大众创业，万众创新，美好生活从发现好项目开始";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"activity"]];
    //设置网页地址"
//    NSString *tempproject = [NSString stringWithFormat:@"projectDetails.html?project_id=%ld&user_id=%@",self.project_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    
    shareObject.webpageUrl = self.requestUrlStr;
//    [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,tempproject];
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


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
//    NSLog(@"finddetail------height------%ld",height);
//    findwebView.frame=CGRectMake(0, 0, kScreenWidth,height);
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.titles = title;
//    tableView.tableHeaderView = findwebView;
//     [LZBLoadingView dismissLoadingView];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect=’none’;"];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.titles = title;
    
    [LZBLoadingView dismissLoadingView];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    NSString *requestString = [[request URL] absoluteString];
    
    
//    if ([requestString containsString:@"submitOk.html"]) {
//        
////////        FoundDetailViewController *vc = [[FoundDetailViewController alloc] init];
////////        vc.requestUrlStr = requestString;
////////        [self.navigationController pushViewController:vc animated:YES];
//////        return NO;
//////    }else{
//////        return YES;
//    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"url===============>%@",self.requestUrlStr);
    
    [super viewWillAppear:animated];
    if ([self.requestUrlStr containsString:@"recommendInfo.html"]) {
        [MobClick beginLogPageView:krecommendInfoPage];//("PageOne"为页面名称，可自定义)
    }
    if ([self.requestUrlStr containsString:@"joiningInfo.html"]) {
        [MobClick beginLogPageView:kjoiningInfoPage];//("PageOne"为页面名称，可自定义)
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.requestUrlStr containsString:@"recommendInfo.html"]) {
        [MobClick endLogPageView:krecommendInfoPage];//("PageOne"为页面名称，可自定义)
    }
    if ([self.requestUrlStr containsString:@"joiningInfo.html"]) {
        [MobClick endLogPageView:kjoiningInfoPage];//("PageOne"为页面名称，可自定义)
    }
}

@end
