//
//  BussinessTableView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/17.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BussinessTableView.h"
#import "YX.h"
#import "publicTableViewCell.h"

@implementation BussinessTableView
-(void)renderUIWithInfo:(NSDictionary *)info{
    [super renderUIWithInfo:info];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    _webView.scrollView.bounces=NO;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.scrollEnabled = NO;
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.opaque = NO; //去掉下面黑线
    
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
//    [self.webView loadHTMLString:self.info[@"data"] baseURL:nil];
    NSString *path = self.info[@"data"] ;
    NSLog(@"path:  error: %@",path);
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView sizeToFit];
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        
        NSLog(@"response:  error: %@",self.webView.title);
    }
    // 加载完成
    if (!self.webView.loading) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
        NSString *js = @"getPheight();";
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@",response,error);
            if(![response isEqual:[NSNull null]] && response !=nil){
                
                self.webView.frame=CGRectMake(0, 0, kScreenWidth,[response floatValue]);
                self.tableView.tableHeaderView =  self.webView;
                [self.tableView reloadData];
            }
        }];
    }
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
//    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"getPheight();"];
//    NSLog(@"str--招商详情--%@",str);
////    NSString *stttt =  [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"] ;
//    ////    NSString *stttt =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"] ;
//    
////    NSLog(@"stttt----%@",stttt);
//    //    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue];//
//    
//    
//    self.webView.frame=CGRectMake(0, 0, kScreenWidth,[str floatValue]);
//    
//    self.tableView.tableHeaderView = webView;
//    [self.tableView reloadData];
//    NSLog(@"str--tableView--%@",str);
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
      NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
   }

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
    }
}
@end
