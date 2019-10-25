//
//  ReportDetailViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "menuVIew.h"
@interface ReportDetailViewController : BaseViewController
@property(nonatomic)int report_id;
@property(nonatomic)int user_id;


@property (nonatomic,strong)menuVIew *menuView;
//菜单栏相关属性
@property (strong, nonatomic) NSString *menuTag;










@end
