//
//  PicAndTextIntroduceView.h
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTabItemBaseView.h"
#import <WebKit/WebKit.h>
@interface PicAndTextIntroduceView : YXTabItemBaseView <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>


@property(nonatomic,strong)WKWebView *webView;

@end
