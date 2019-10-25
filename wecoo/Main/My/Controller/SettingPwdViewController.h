//
//  SettingPwdViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitView.h"
@interface SettingPwdViewController : BaseViewController




@property (nonatomic,strong) UILabel *WithdrawLabel;
@property (nonatomic,strong) UILabel *SettingLabel;
@property (nonatomic,strong) UILabel *RepeatLabel;

@property (nonatomic,strong) UITextField *WithdrawTextField;
@property (nonatomic,strong) UITextField *SettingTextField;
@property (nonatomic,strong) UITextField *RepeatTextField;
@property (nonatomic,strong) SubmitView *subview;

@property (nonatomic,assign)int gotoWhere;
/*
 *0 我的赏金申请提现
 *1 个人身份认证信息提交后 去提现
 *2 个人身份认证信息审核失败 再次提交个人身份认证后 提现成功后 返回提现进度列表
 *3 个人身份认证信息审核通过 提现信息审核不通过 去修改提现信息提交成功后 返回提现进度列表
 */
@property (nonatomic,assign)int fromWhere;
@end
