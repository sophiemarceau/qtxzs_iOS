//
//  AdvertiseWebViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/25.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "AdvertiseWebViewController.h"

@interface AdvertiseWebViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
}
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation AdvertiseWebViewController

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
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.webView.scrollView.bounces=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.opaque = NO; //去掉下面黑线
    self.webView.backgroundColor =[UIColor clearColor];
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.advertiseUrlString];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.webView sizeToFit];
    
    [self.view addSubview:tableView];
    
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
    
    self.webView.frame=CGRectMake(0, 0, kScreenWidth,height);
    
    tableView.tableHeaderView = self.webView;
    NSString *title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titles = title;
     [LZBLoadingView dismissLoadingView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"request----->%@",requestString);
    if([requestString containsString:@"projectList.html"]){
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
    
}


@end
