//
//  LoginViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.navView removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.appNameLabel];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/2-25*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(86*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/2-30*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        self.iconImageView = [UIImageView new];
        self.iconImageView.image =[UIImage imageNamed:@"logo-login"];
    }
    return _iconImageView;
}

- (UIImageView *)lineImageView1 {
    if (_lineImageView1 == nil) {
        self.lineImageView1 = [UIImageView new];
        self.lineImageView1.image =[UIImage imageNamed:@"icon-my-msg"];
    }
    return _lineImageView1;
}

-(UIView *)lineImageView2{
    if ( _lineImageView2== nil) {
        self.lineImageView2 = [UIImageView new];
        
        self.lineImageView2.backgroundColor = BGColorGray;
        
    }
    return _lineImageView2;
}

- (UILabel *)appNameLabel {
    if (_appNameLabel == nil) {
        self.appNameLabel = [CommentMethod initLabelWithText:@"渠天下" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.appNameLabel.textColor = FontUIColorBlack;
    }
    return _appNameLabel;
}

-(UIView *)phoneTextField{
    if (_phoneTextField == nil) {
        self.phoneTextField = [UITextField new];
        self.phoneTextField.placeholder = @"请输入手机号";
        self.phoneTextField.delegate = self;
        self.phoneTextField.font = [UIFont systemFontOfSize:13];
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phoneTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _phoneTextField;
}

-(UIView *)messagePasswordTextField{
    if (_messagePasswordTextField == nil) {
        self.phoneTextField = [UITextField new];
        self.phoneTextField.placeholder = @"请输入验证码";
        self.phoneTextField.delegate = self;
        self.phoneTextField.font = [UIFont systemFontOfSize:13];
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phoneTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _messagePasswordTextField;
}



-(UIView *)inviteCodeTextField{
    if (_inviteCodeTextField == nil) {
        self.inviteCodeTextField = [UITextField new];
        self.inviteCodeTextField.placeholder = @"请输入邀请码（选填）";
        self.inviteCodeTextField.delegate = self;
        self.inviteCodeTextField.font = [UIFont systemFontOfSize:13];
        self.inviteCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.inviteCodeTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _inviteCodeTextField;
}

-(UIView *)lineImageView3{
    if ( _lineImageView3== nil) {
        self.lineImageView3 = [UIImageView new];
        
        self.lineImageView3.backgroundColor = BGColorGray;
        
    }
    return _lineImageView3;
}

-(UIButton *)registerButton{
    if (_registerButton) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _registerButton;
}

-(UIButton *)codeButton{
    if (_codeButton) {
        self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _codeButton;
}

- (UILabel *)attentionLabel {
    if (_attentionLabel == nil) {
        self.attentionLabel = [CommentMethod initLabelWithText:@"屈小波" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.attentionLabel.textColor = [UIColor whiteColor];
    }
    return _attentionLabel;
}

@end
