//
//  efficiencyViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/27.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "efficiencyViewController.h"
#import "WZBSpeedDialView.h"
#import "noWifiView.h"
#import "SubmitView.h"
#import "efficiencyDetailListViewController.h"

@interface efficiencyViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIWebView * webView;
    UITableView *tableView;
    noWifiView *failView;
    UIView *headerView;
    CGFloat lineheight;
}

@property (nonatomic, strong) WZBSpeedDialView *circleProgressView;
@property (nonatomic, strong) SubmitView *subview;
@end

@implementation efficiencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-84*AUTO_SIZE_SCALE_X)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

    self.circleProgressView = [[WZBSpeedDialView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250*AUTO_SIZE_SCALE_X-64)];
    [headerView addSubview:self.circleProgressView];
    
    [self initDdata];

    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.circleProgressView.frame.origin.y+self.circleProgressView.frame.size.height+35*AUTO_SIZE_SCALE_X, 125*AUTO_SIZE_SCALE_X, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [headerView  addSubview:lineImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineImageView.frame.origin.x+lineImageView.frame.size.width, self.circleProgressView.frame.origin.y+self.circleProgressView.frame.size.height+20*AUTO_SIZE_SCALE_X, 190/2*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X)];
    titleLabel.text = @"规则说明";
    titleLabel.textColor = FontUIColorGray;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    [headerView addSubview:titleLabel];
    UIImageView *lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, self.circleProgressView.frame.origin.y+self.circleProgressView.frame.size.height+35*AUTO_SIZE_SCALE_X, 125*AUTO_SIZE_SCALE_X, 0.5)];
    lineImageView1.backgroundColor = lineImageColor;
    [headerView  addSubview:lineImageView1];
    lineheight = titleLabel.frame.origin.y+titleLabel.frame.size.height;

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, lineheight, kScreenWidth, 1)];
    webView.scrollView.bounces=NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.opaque = NO; //去掉下面黑线
    webView.backgroundColor =[UIColor clearColor];
    webView.delegate = self;
    NSString *path = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"guize.html"];
    NSURL *url = [NSURL URLWithString:path];

    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [headerView  addSubview:webView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.subview];
    self.subview.frame = CGRectMake(0, kScreenHeight-84*AUTO_SIZE_SCALE_X, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    self.subview.backgroundColor = [UIColor whiteColor];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self initDdata];
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


- (void)webViewDidFinishLoad:(UIWebView *)tempwebView
{
    NSInteger height = [[tempwebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
//        NSLog(@"find------height------%ld",height);
    webView.frame=CGRectMake(0, lineheight, kScreenWidth,height);
    headerView.frame = CGRectMake(0, 0, kScreenWidth,lineheight + height);
//    findwebView.frame=CGRectMake(0, 0, kScreenWidth,height);
//    
    tableView.tableHeaderView = headerView;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kEfficiencyPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kEfficiencyPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initDdata{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetReportEffectiveRateResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
               self.circleProgressView.percent = [[[result objectForKey:@"data"] objectForKey:@"result"] floatValue];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        failView.hidden = YES;
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
    }];
}


-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor clearColor];
        
        [self.subview.subButton setTitle:@"查看明细" forState:UIControlStateNormal];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _subview;
}

#pragma mark 提交
-(void)submitBtnPressed:(UIButton *)sender
{
    efficiencyDetailListViewController *vc = [[efficiencyDetailListViewController alloc] init];
    vc.titles = @"质量分明细";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
