//
//  ProgressRecordViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/5/26.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "AddCommunicationRecordViewController.h"
@interface ProgressRecordViewController : BaseViewController
@property(nonatomic,strong)NSString *report_id;
@property(nonatomic,strong)NSString *report_str;
@property(nonatomic,strong)NSString *project_id;
@property(nonatomic,assign)int fromtype;
@property(nonatomic,strong)UIButton *confirmPassButton;
@end
