//
//  ModifyPwdViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitView.h"

@interface ModifyPwdViewController : BaseViewController

@property (nonatomic,strong) UILabel *WithdrawLabel;
@property (nonatomic,strong) UILabel *SettingLabel;
@property (nonatomic,strong) UILabel *RepeatLabel;

@property (nonatomic,strong) UITextField *WithdrawTextField;
@property (nonatomic,strong) UITextField *SettingTextField;
@property (nonatomic,strong) UITextField *RepeatTextField;
@property (nonatomic,strong) SubmitView *subview;
@end
