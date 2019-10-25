//
//  AlipayWithdrawViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/3.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitView.h"

@interface AlipayWithdrawViewController : BaseViewController
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UIImageView *nameImageView;
@property (nonatomic,strong)UILabel *alipayLabel;
@property (nonatomic,strong)UITextField *alipayTextField;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UITextField *moneyTextField;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong) SubmitView *subview;
@property (nonatomic,strong)UITextField *verifyTextField;
@property (nonatomic,strong)UIButton *codeButton;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong) UILabel *timeLabel;//60秒后重发




@property(nonatomic,assign)int isFromSettingpwdpage;
@property(nonatomic,assign)int gotoWhere;
@property(nonatomic,strong)NSString *swa_id;
@property(nonatomic,strong)NSString *us_realname;





/*
 *0 我的赏金申请提现
 *1 个人身份认证信息提交后 去提现
 *2 个人身份认证信息审核失败 再次提交个人身份认证后 提现成功后 返回提现进度列表
 *3 个人身份认证信息审核通过 提现信息审核不通过 去修改提现信息提交成功后 返回提现进度列表
 */
@property (nonatomic,assign)int fromWhere;
@end
