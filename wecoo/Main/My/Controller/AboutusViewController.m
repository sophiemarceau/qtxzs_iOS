//
//  AboutusViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "AboutusViewController.h"

@interface AboutusViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIWebView * webView;
    UITableView *tableView;
}


@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"version----%@",app_Version);
    NSString *appversion = [NSString stringWithFormat:@"%@%@",@"?versionName=",app_Version];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",BaseURLHTMLString,@"aboutUs.html",appversion];
     NSLog(@"path----%@",path);
    NSURL *url = [NSURL URLWithString:path];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
   
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [webView sizeToFit];
    
    [self.view addSubview:tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kAboutUsPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAboutUsPage];
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
//    NSLog(@"find------height------%ld",height);
    webView.frame=CGRectMake(0, 0, kScreenWidth,height);
    
    tableView.tableHeaderView = webView;
     [LZBLoadingView dismissLoadingView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"request----->%@",requestString);
    if([requestString containsString:@"tel"]){
        [MobClick event:kAboutCallEvent];
    }
    
    return YES;
    
}

@end
