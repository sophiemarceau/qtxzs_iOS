//
//  ForgetPwdViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitView.h"

@interface ForgetPwdViewController : BaseViewController

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UITextField *nameTextField;

@property (nonatomic,strong)UILabel *IDLabel;
@property (nonatomic,strong)UITextField *IDTextField;

@property (nonatomic,strong) UILabel *SettingLabel;
@property (nonatomic,strong) UITextField *SettingTextField;

@property (nonatomic,strong) UILabel *RepeatLabel;
@property (nonatomic,strong) UITextField *RepeatTextField;

@property (nonatomic,strong)UILabel *phoneLabel;

@property (nonatomic,strong)UITextField *verifyTextField;
@property (nonatomic,strong)UIButton *codeButton;

@property (nonatomic,strong)SubmitView *subview;



@property (nonatomic,assign)int isReturnMoneySubmitPage;
@end
