//
//  SettingPwdViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SettingPwdViewController.h"
#import "AlipayWithdrawViewController.h"
#import "WithdrawViewController.h"

@interface SettingPwdViewController ()<UITextFieldDelegate>

@end

@implementation SettingPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    NSLog(@"ctrlArray----->%@------%d",ctrlArray,ctrlArray.count);
    UIImageView *linImageView2 = [UIImageView new];
    linImageView2.backgroundColor = lineImageColor;
    UIImageView *linImageView3 = [UIImageView new];
    linImageView3.backgroundColor = lineImageColor;
    
    
    [self.view addSubview:self.SettingLabel];
    [self.view addSubview:self.RepeatLabel];
    
    
    [self.view addSubview:self.SettingTextField];
    [self.view addSubview:self.RepeatTextField];
    
    
    
    [self.view addSubview:linImageView2];
    [self.view addSubview:linImageView3];
    
    [self.view addSubview:self.subview];
    
    
    
    
    [self.SettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(155/2*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.RepeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.SettingLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(155/2*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    
    
    [self.SettingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(250*AUTO_SIZE_SCALE_X,55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.RepeatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.SettingTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(250*AUTO_SIZE_SCALE_X,55*AUTO_SIZE_SCALE_X));
    }];
    

    [linImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.SettingLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.RepeatLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView3.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,84*AUTO_SIZE_SCALE_X));
    }];
    
}
#pragma mark 登录
-(void)submitBtnPressed:(UIButton *)sender
{
    [MobClick event:kModifyPwdSubmitEvent];
    self.subview.subButton.enabled = NO;
    if (self.SettingTextField.text.length==0||self.RepeatTextField.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    if (self.SettingTextField.text.length != 6) {
        [[RequestManager shareRequestManager] tipAlert:@"密码需为6位数字，请您检查并重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if (self.RepeatTextField.text.length != 6) {
        [[RequestManager shareRequestManager] tipAlert:@"密码需为6位数字，请您检查并重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if(![self.SettingTextField.text isEqualToString:self.RepeatTextField.text]){
        [[RequestManager shareRequestManager] tipAlert:@"您设置的密码和您重复输入的密码不一致，请您检查并重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    NSDictionary *dic = @{
                          @"us_withdraw_pwd":[[RequestManager shareRequestManager] md5:self.SettingTextField.text],
                          @"repeat_us_withdraw_pwd":[[RequestManager shareRequestManager] md5:self.RepeatTextField.text]
                          };
    
    [[RequestManager shareRequestManager] SetUpWithdrawPwdResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"提现密码设置成功" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subview.subButton.enabled = YES;
        }
    }failuer:^(NSError *error){
        
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subview.subButton.enabled = YES;
    }];
    
}

-(void)returnListPage{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    
    if (self.gotoWhere == 0) {
        AlipayWithdrawViewController *vc = [[AlipayWithdrawViewController alloc] init];
        vc.titles = @"支付宝提现";
        vc.swa_id = @"";
        vc.fromWhere = 1;
        vc.isFromSettingpwdpage = 1;

        [self.navigationController setViewControllers:@[ctrlArray[0],ctrlArray[1],vc] animated:YES];
    }else{
        WithdrawViewController *vc = [[WithdrawViewController alloc] init];
        vc.titles = @"个人银行卡提现";
        vc.swa_id = @"";
        vc.fromWhere = 1;
        
        vc.isFromSettingpwdpage = 1;

        [self.navigationController setViewControllers:@[ctrlArray[0],ctrlArray[1],vc] animated:YES];
    }
    self.subview.subButton.enabled = YES;
}

-(void)fieldChanged:(id)sender
{
    UITextField * textField=(UITextField*)sender;
    if(textField.text.length > 6){
        textField.text = [textField.text substringToIndex:6];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UILabel *)SettingLabel
{
    if (_SettingLabel == nil) {
        self.SettingLabel = [CommentMethod initLabelWithText:@"设置密码" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.SettingLabel.textColor = FontUIColorGray;
    }
    return _SettingLabel;
}
-(UILabel *)RepeatLabel{
    if (_RepeatLabel == nil) {
        self.RepeatLabel = [CommentMethod initLabelWithText:@"重复密码" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.RepeatLabel.textColor = FontUIColorGray;
    }
    return _RepeatLabel;
}

-(UITextField *)SettingTextField{
    if (_SettingTextField == nil) {
        self.SettingTextField = [UITextField new];
        self.SettingTextField.placeholder = @"请输入六位密码";
        self.SettingTextField.delegate = self;
        self.SettingTextField.textAlignment = NSTextAlignmentRight;
        self.SettingTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.SettingTextField.clearButtonMode = UITextFieldViewModeNever;
        [self.SettingTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.SettingTextField.backgroundColor = [UIColor clearColor];
        self.SettingTextField.secureTextEntry = YES;
        self.SettingTextField.textColor = FontUIColorGray;
        self.SettingTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _SettingTextField;
}

-(UITextField *)RepeatTextField{
    if (_RepeatTextField == nil) {
        self.RepeatTextField = [UITextField new];
        self.RepeatTextField.placeholder = @"请重复输入密码";
        self.RepeatTextField.delegate = self;
        self.RepeatTextField.textAlignment = NSTextAlignmentRight;
        self.RepeatTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.RepeatTextField.clearButtonMode = UITextFieldViewModeNever;
        [self.RepeatTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.RepeatTextField.backgroundColor = [UIColor clearColor];
        self.RepeatTextField.textColor = FontUIColorGray;
        self.RepeatTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.RepeatTextField.secureTextEntry = YES;

    }
    return _RepeatTextField;
}

-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor clearColor];
        [self.subview.subButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}

@end
