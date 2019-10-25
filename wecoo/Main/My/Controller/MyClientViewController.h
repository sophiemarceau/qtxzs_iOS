//
//  MyClientViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//
#import "BaseViewController.h"
#import "menuVIew.h"
@interface MyClientViewController : BaseViewController
@property (nonatomic,strong)menuVIew *menuView;
@property (nonatomic,strong)UILabel *subtitleView;
@property (nonatomic,strong)UIButton *addClientButton;
//菜单栏相关属性
@property (strong, nonatomic) NSString *menuTag;
@end
