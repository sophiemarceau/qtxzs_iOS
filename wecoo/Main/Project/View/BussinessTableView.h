//
//  BussinessTableView.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/17.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "YXTabItemBaseView.h"
#import <WebKit/WebKit.h>
@interface BussinessTableView : YXTabItemBaseView <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>


@property(nonatomic,strong)WKWebView *webView;


@end
