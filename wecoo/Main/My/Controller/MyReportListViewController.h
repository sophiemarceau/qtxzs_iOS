//
//  MyReportListViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/25.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "menuVIew.h"
@interface MyReportListViewController : BaseViewController
@property (nonatomic,strong)menuVIew *menuView;
//菜单栏相关属性
@property (nonatomic,assign) int menuTag;
@end
