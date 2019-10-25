//
//  WebViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController
@property(nonatomic,strong)NSString *webViewurl;
@property(nonatomic,strong)NSString *webtitle;
@property(nonatomic,strong)UIButton *directButton;
@property(nonatomic,strong)NSString *fromWhere;//从silk 进入的
@end
