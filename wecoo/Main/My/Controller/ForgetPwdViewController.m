//
//  ForgetPwdViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "SubmitSuccessPwdViewController.h"

@interface ForgetPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong) UILabel *timeLabel;//60秒后重发
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
}

-(void)loadData{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetUserDetailResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]] && dto !=nil)
            {
                NSString *user_login = [dto objectForKey:@"us_tel"];
                
                int index ;
                NSString *string = nil;
                NSString *str = nil;
                NSString *des = @"当前绑定手机号为";
                string = [NSString stringWithFormat:@"%@", user_login];
                str = [NSString stringWithFormat:@"%@%@",des,string];
                index = (int)[des length] ;
                //                    NSLog(@"%d",index);
                //                    NSLog(@"%@",str);
                NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
                
                [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
                
                [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
                self.phoneLabel.attributedText = mutablestr;
                
                            
                self.nameTextField.text = [dto objectForKey:@"us_realname"];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        //        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}

-(void)initView{
    UIImageView *linImageView1 = [UIImageView new];
    linImageView1.backgroundColor = lineImageColor;
    UIImageView *linImageView2 = [UIImageView new];
    linImageView2.backgroundColor = lineImageColor;
    UIImageView *linImageView3 = [UIImageView new];
    linImageView3.backgroundColor = lineImageColor;
    UIImageView *linImageView4 = [UIImageView new];
    linImageView4.backgroundColor = lineImageColor;
    UIImageView *linImageView5 = [UIImageView new];
    linImageView5.backgroundColor = lineImageColor;
    UIImageView *linImageView6 = [UIImageView new];
    linImageView6.backgroundColor = lineImageColor;
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:linImageView1];
    
    [self.view addSubview:self.IDLabel];
    [self.view addSubview:self.IDTextField];
    [self.view addSubview:linImageView2];
    
    [self.view addSubview:self.SettingLabel];
    [self.view addSubview:self.SettingTextField];
    [self.view addSubview:linImageView3];
    
    [self.view addSubview:self.RepeatLabel];
    [self.view addSubview:self.RepeatTextField];
    [self.view addSubview:linImageView4];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:linImageView5];
    
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:linImageView6];
    
    [self.view addSubview:self.subview];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(155/2*AUTO_SIZE_SCALE_X, 51*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];

    [linImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];
    
    [self.IDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.IDTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.SettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];

    
    [self.SettingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];

    [linImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.SettingTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.RepeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];
    
    [self.RepeatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.RepeatTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30,51*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.phoneLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,51*AUTO_SIZE_SCALE_X));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView5.mas_bottom).offset(6*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X,37*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.verifyTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(linImageView6.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,84*AUTO_SIZE_SCALE_X));
    }];
}
#pragma mark 登录
-(void)submitBtnPressed:(UIButton *)sender
{
//    [MobClick event:kModifyPwdSubmitEvent];
    self.subview.subButton.enabled = NO;
    if (self.IDTextField.text.length==0||self.SettingTextField.text.length==0||self.RepeatTextField.text.length==0||self.verifyTextField.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    int flag = [self Chk18PaperId:self.IDTextField.text];
    if (flag==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您输入的身份证号码有误，请您重新输入" viewController:self];
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
    
    if (![self.SettingTextField.text isEqualToString:self.RepeatTextField.text]) {
        [[RequestManager shareRequestManager] tipAlert:@"两次输入的支付密码必须相同，请您重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    NSDictionary *dic = @{
                          @"us_id_number":self.IDTextField.text,
                          @"new_us_withdraw_pwd":
                              [[RequestManager shareRequestManager] md5:self.SettingTextField.text]
                             ,
                          @"repeat_us_withdraw_pwd":
                              [[RequestManager shareRequestManager] md5:self.RepeatTextField.text],
                          @"verifyCode":self.verifyTextField.text,
                          };
    [[RequestManager shareRequestManager] ResetWithdrawPwdResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"正在提交中" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subview.subButton.enabled = YES;
        }
        self.subview.subButton.enabled = YES;
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subview.subButton.enabled = YES;
    }];
}

-(void)returnListPage{
    SubmitSuccessPwdViewController *vc = [[SubmitSuccessPwdViewController alloc] init];
    vc.titles = @"重置成功";
    vc.submit1Label.text = @"重置成功";
    vc.isReturnMoneySubmitPage = self.isReturnMoneySubmitPage;
    [self.navigationController pushViewController:vc animated:YES];
    self.subview.subButton.enabled = YES;
}

-(BOOL)Chk18PaperId:(NSString *)IDCardNumber
{
    if ([IDCardNumber length] < 15 ||[IDCardNumber length] > 18) {
        return NO;
    }
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCardNumber length] != 18){
        return NO;
    }
    
    NSString *regex = [NSString stringWithFormat:@"%@", @"^(\\d{15})|^(\\d{17}([0-9]|X|x))$"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:IDCardNumber]){
        return NO;
    }else{
        return YES;
    }
}

-(void)loginBtnPressed:(UIButton *)sender
{
    sender.enabled = NO;
    //    if (self.alipayTextField.text.length==0){
    //        [[RequestManager shareRequestManager] tipAlert:@"支付宝账户 请您检查并输入" viewController:self];
    //        sender.enabled = YES;
    //        return;
    //    }
    //    if (self.moneyLabel.text.length==0){
    //        [[RequestManager shareRequestManager] tipAlert:@"提现金额 请您检查并输入" viewController:self];
    //        sender.enabled = YES;
    //        return;
    //    }
    
    NSDictionary * dic = @{};
    [[RequestManager shareRequestManager] SendValidateCodeSmsByUserIdResult:dic viewController:self successData:^(NSDictionary *result){
        sender.enabled = YES;
        if(IsSucess(result)){
            self.codeButton.enabled = NO;
            self.count = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loopClock) userInfo:nil repeats:YES];
        }else{
            //                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        sender.enabled = YES;
        [self showHint:[error networkErrorInfo]];
        
        //                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)loopClock{
    if (self.count != 1) {
        self.count -= 1;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode-dis"] forState:UIControlStateNormal];
        [self.codeButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        [self.codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
    } else {
        self.codeButton.enabled = YES;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode"] forState:UIControlStateNormal];
        [self.codeButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.count = 60;
        [self.timer invalidate];
    }
}

-(void)fieldChanged:(id)sender
{
    UITextField * textField=(UITextField*)sender;
    if(textField.text.length > 6){
        textField.text = [textField.text substringToIndex:6];
    }
}


-(void)fieldChanged
{
    UITextField *textField=self.IDTextField;
    
    NSString * temp = textField.text;
    
    
    
    if (textField.markedTextRange ==nil)
        
    {
        
        while(1)
            
        {
            
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 18) {
                
                break;
                
            }
            
            else
                
            {
                
                temp = [temp substringToIndex:temp.length-1];
                
            }
            
        }
        
        textField.text=temp;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        self.timer = [[NSTimer alloc]init];
    }
    return _timer;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = FontUIColorBlack;
        self.timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        self.timeLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 18*AUTO_SIZE_SCALE_X;
    }
    return _timeLabel;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"真实姓名" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.nameLabel.textColor = FontUIColorGray;
    }
    return _nameLabel;
}

-(UITextField *)nameTextField{
    if (_nameTextField == nil) {
        self.nameTextField = [UITextField new];
        self.nameTextField.placeholder = @"请输入收款人姓名";
//                self.nameTextField.delegate = self;
        self.nameTextField.textAlignment = NSTextAlignmentRight;
        self.nameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
        //        [self.nameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.nameTextField.backgroundColor = [UIColor clearColor];
        self.nameTextField.textColor = FontUIColorGray;
        self.nameTextField.userInteractionEnabled = NO;
    }
    return _nameTextField;
}

-(UILabel *)IDLabel{
    if (_IDLabel == nil) {
        self.IDLabel = [CommentMethod initLabelWithText:@"身份证号" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.IDLabel.textColor = FontUIColorGray;
    }
    return _IDLabel;
}

-(UITextField *)IDTextField{
    if (_IDTextField == nil) {
        self.IDTextField = [UITextField new];
        self.IDTextField.placeholder = @"请输入身份证号";
        self.IDTextField.delegate = self;
        self.IDTextField.textAlignment = NSTextAlignmentRight;
        self.IDTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.IDTextField.clearButtonMode = UITextFieldViewModeNever;
        [self.IDTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.IDTextField.backgroundColor = [UIColor clearColor];
        self.IDTextField.textColor = FontUIColorGray;
        //        self.alipayTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _IDTextField;
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
        self.SettingTextField.textColor = FontUIColorGray;
        self.SettingTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.SettingTextField.secureTextEntry = YES;
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

-(UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.phoneLabel.textColor = FontUIColorGray;
    }
    return _phoneLabel;
}

-(UITextField *)verifyTextField{
    if (_verifyTextField == nil) {
        self.verifyTextField = [UITextField new];
        self.verifyTextField.placeholder = @"输入验证码";
        //        self.verifyTextField.delegate = self;
        self.verifyTextField.textAlignment = NSTextAlignmentLeft;
        self.verifyTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.verifyTextField.clearButtonMode = UITextFieldViewModeNever;
        //        [self.nameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.verifyTextField.backgroundColor = [UIColor clearColor];
        self.verifyTextField.textColor = FontUIColorGray;
        self.verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _verifyTextField;
}

-(UIButton *)codeButton{
    if (_codeButton == nil ) {
        self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.codeButton.userInteractionEnabled = YES;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode"] forState:UIControlStateNormal];
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        self.codeButton.tag =1001;
        [self.codeButton addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
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
