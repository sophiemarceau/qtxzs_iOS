//
//  FinderViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "FinderViewController.h"
#import "FoundDetailViewController.h"


@interface FinderViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIWebView * findwebView;
    UITableView *tableView;
}
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation FinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-TABBAR_HEIGHT)];
    tableView.backgroundColor = BGColorGray;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = YES;
    self.titles =@"发现";
    findwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    findwebView.scrollView.bounces=NO;
    findwebView.scrollView.showsHorizontalScrollIndicator = NO;
    findwebView.scrollView.scrollEnabled = NO;
    findwebView.opaque = NO; //去掉下面黑线
    findwebView.backgroundColor =[UIColor clearColor];
    findwebView.delegate = self;
    [findwebView sizeToFit];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    NSLog(@"find------height------%ld",height);
    findwebView.frame=CGRectMake(0, 0, kScreenWidth,height);
    
    tableView.tableHeaderView = findwebView;
    
     
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"find------requestString------%@",requestString);
    
    if ([requestString containsString:@"Info.html"]) {
        FoundDetailViewController *vc = [[FoundDetailViewController alloc] init];
        vc.requestUrlStr = requestString;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }else{
        return YES;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kPageThree];//("PageOne"为页面名称，可自定义)

    NSString *path = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"discover.html?qtx_auth="];
    
    NSMutableString *finalPath = [NSMutableString string];
    
    [finalPath appendString:[NSString stringWithFormat:@"%@%@",path,[[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"]]];
    [finalPath appendString:@"&t="];
    NSMutableString *interval = [[NSMutableString alloc] init];
    
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;//毫秒数要乘以1000
    double i=time;      //NSTimeInterval返回的是double类型
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"Z"];
    NSString *timeZone = [format stringFromDate:date];
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%.f", i];
    
    [interval appendString:timeIntervalStr];
    [interval appendString:timeZone];
    
    [finalPath appendString:interval];
    
    NSURL *url = [NSURL URLWithString:finalPath];
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [LZBLoadingView dismissLoadingView];
//    });
    [findwebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [findwebView sizeToFit];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kPageThree];
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
