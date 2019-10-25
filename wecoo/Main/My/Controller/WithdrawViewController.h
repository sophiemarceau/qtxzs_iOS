//
//  WithdrawViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"

@interface WithdrawViewController : BaseViewController
@property (nonatomic,strong)UIView *bgview;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UIImageView *nameImageView;
@property (nonatomic,strong)UIView *nameView;

@property (nonatomic,strong)UILabel *bankNamLabel;
@property (nonatomic,strong)UITextField *bankNameTextField;
@property (nonatomic,strong)UIView *bankNameView;

@property (nonatomic,strong)UILabel *openBankDistrictLabel;
@property (nonatomic,strong)UITextField *openBankDistrictTextField;
@property (nonatomic,strong)UIView *openBankDistrictView;

@property (nonatomic,strong)UILabel *openBankNameLabel;
@property (nonatomic,strong)UITextField *openBankNameTextField;
@property (nonatomic,strong)UIView *openBankNameView;

@property (nonatomic,strong)UILabel *bankAccountLabel;
@property (nonatomic,strong)UITextField *bacnkAccountTextField;
@property (nonatomic,strong)UIView *bankAccountView;

@property (nonatomic,strong)UILabel *sumLabel;
@property (nonatomic,strong)UITextField *sumTextField;
@property (nonatomic,strong)UIView *sumView;

@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UITextField *verifyTextField;
@property (nonatomic,strong)UIButton *codeButton;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *timeLabel;//60秒后重发

@property (nonatomic,strong)UIButton *submitButton;



@property(nonatomic,strong)NSString *swa_id;


@property(nonatomic,strong)NSString *us_realname;

@property (nonatomic,assign)int gotoWhere;

/*
 *0 我的赏金申请提现
 *1 个人身份认证信息提交后 去提现
 *2 个人身份认证信息审核失败 再次提交个人身份认证后 提现成功后 返回提现进度列表
 *3 个人身份认证信息审核通过 提现信息审核不通过 去修改提现信息提交成功后 返回提现进度列表
 */
@property (nonatomic,assign)int fromWhere;



@property(nonatomic,assign)int isFromSettingpwdpage;
@end
