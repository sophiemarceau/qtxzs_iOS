//
//  AlipayWithdrawViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/3.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "AlipayWithdrawViewController.h"
#import "VerifyView.h"
#import "SubmitSuccessedViewController.h"
#import "WithdrawPwdShow.h"
#import "ForgetPwdViewController.h"

@interface AlipayWithdrawViewController (){
    int i;
    UIImageView *linImageView4;
    WithdrawPwdShow *show;
    NSString *msgString;
}
@property (nonatomic, assign) NSInteger count;
@end

@implementation AlipayWithdrawViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadData];
    UIImageView *linImageView1 = [UIImageView new];
    linImageView1.backgroundColor = lineImageColor;
    UIImageView *linImageView2 = [UIImageView new];
    linImageView2.backgroundColor = lineImageColor;
    UIImageView *linImageView3 = [UIImageView new];
    linImageView3.backgroundColor = lineImageColor;
    linImageView4 = [UIImageView new];
    linImageView4.backgroundColor = lineImageColor;
    UIImageView *linImageView5 = [UIImageView new];
    linImageView5.backgroundColor = lineImageColor;
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.nameImageView];
    [self.view addSubview:linImageView1];
    
    [self.view addSubview:self.alipayLabel];
    [self.view addSubview:self.alipayTextField];
    [self.view addSubview:linImageView2];
    
    [self.view addSubview:self.moneyLabel];
    [self.view addSubview:self.moneyTextField];
    [self.view addSubview:linImageView3];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:linImageView4];
    
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:linImageView5];

    [self.view addSubview:self.subview];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
   
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.navView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(18*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X));
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameImageView.mas_left).offset(-10);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15-18*AUTO_SIZE_SCALE_X,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [self.alipayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.alipayTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.moneyTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.phoneLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
   
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,96/2*AUTO_SIZE_SCALE_X));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView4.mas_bottom).offset(6*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X,36*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.verifyTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(linImageView5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,84*AUTO_SIZE_SCALE_X));
    }];

    
    if (self.gotoWhere == 1) {
        self.moneyTextField.userInteractionEnabled = NO;
    }
    
    
    
}

-(void)loadData{
    if ([self.swa_id isEqualToString:@""]) {
        
        NSDictionary *dic = @{
                              @"swa_type":@"2"//支付宝
                              };
        
        [[RequestManager shareRequestManager] GetLastWithdrawalRecordByTypeResult:dic viewController:self successData:^(NSDictionary *result){
            
            if(IsSucess(result)){
                NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                if(![dto isEqual:[NSNull null]] && dto !=nil)
                {
                    NSString *user_login = [dto objectForKey:@"user_login"];
                    //                    NSLog(@"dto swa_alipay_account-------------%@",[dto objectForKey:@"swa_alipay_account"]);
                    NSString *swa_alipay_account = [dto objectForKey:@"swa_alipay_account"] ;
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
                    
                    self.alipayTextField.text = swa_alipay_account;
                    
                    self.nameTextField.text = [dto objectForKey:@"us_realname"];
                    
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }failuer:^(NSError *error){
            //        NSLog(@"error-------->%@",error);
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }else{
        NSDictionary *dic1 = @{
                               @"swa_id":self.swa_id
                               };
        [[RequestManager shareRequestManager] GetSalesmanWithdrawingApplicationDtoDtoResult:dic1 viewController:self successData:^(NSDictionary *result){
            
            if(IsSucess(result)){
                NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                if(![dto isEqual:[NSNull null]] && dto !=nil)
                {
                    NSString *user_login = [dto objectForKey:@"user_login"];
                    NSString *swa_alipay_account = [dto objectForKey:@"swa_alipay_account"];
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
                    
                    self.alipayTextField.text = swa_alipay_account;
                    
                    self.nameTextField.text = [dto objectForKey:@"us_realname"];
                    if (self.gotoWhere == 1) {
                        self.moneyTextField.userInteractionEnabled = NO;
                        self.moneyTextField.text = [NSString stringWithFormat:@"%@", [dto objectForKey:@"swa_sum_str"]];
                    }
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){
            //        NSLog(@"error-------->%@",error);
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            
        }];
    }
}

-(void)pwdsubmit{
    
    show = [[WithdrawPwdShow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    // 确定按钮的点击
    [show.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [show.cancleBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [show.forgetPwdLabel addGestureRecognizer:tap1];
    
    [show showView];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [show.pwdTextField resignFirstResponder];
    
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
    vc.titles = @"重置提现密码";
    vc.isReturnMoneySubmitPage = 1;
    [self.navigationController pushViewController:vc animated:YES];
    [show dismissContactView];
    self.verifyTextField.text = @"";
    show.sureBtn.enabled = YES;
    self.subview.subButton.enabled = YES;
}

-(void)cancelAction{
    [show dismissContactView];
    self.subview.subButton.enabled = YES;
}

-(void)sureAction{
    show.sureBtn.enabled = NO;
    if ([self.swa_id isEqualToString:@""]) {
        NSDictionary *dic = @{
                              @"verifyCode":self.verifyTextField.text,
                              @"swa_name":self.nameTextField.text,
                              @"swa_alipay_account":self.alipayTextField.text,                              @"swa_sum":self.moneyTextField.text,//double 类型
                              @"us_withdraw_pwd":[[RequestManager shareRequestManager] md5:show.pwdTextField.text],
                              };
        [[RequestManager shareRequestManager] ApplyWithdrawByAlipayResultNew:dic viewController:self successData:^(NSDictionary *result){
            NSLog(@"result---123----->%@",result);
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag != 99999){
                if(successFlag == 1){
                    [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                    show.attentionLabel.text = @"为了您的资金安全，请输入提现密码";
                    show.attentionLabel.textColor = FontUIColorBlack;
                    [show dismissContactView];
                }else{
                    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                        msgString =  [result objectForKey:@"msg"];
                        [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
                    }
                }
            }else{
                msgString = @"您提现的密码输入错误，请重新输入";
                [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            show.sureBtn.enabled = YES;
        }];

    }else{
        NSDictionary *dic = @{
                              @"verifyCode":self.verifyTextField.text,
                              @"swa_id":self.swa_id,
                              @"swa_name":self.nameTextField.text,
                              @"swa_alipay_account":self.alipayTextField.text,
                              @"swa_sum":self.moneyTextField.text,//double 类型
                              @"us_withdraw_pwd":[[RequestManager shareRequestManager] md5:show.pwdTextField.text],
                              };
        [[RequestManager shareRequestManager] UpdateApplyWithdrawByAlipayDtoResultNew:dic viewController:self successData:^(NSDictionary *result){
            NSLog(@"result-------->%@",result);
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag != 99999){
                if(successFlag == 1){
                    [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                    show.attentionLabel.text = @"为了您的资金安全，请输入提现密码";
                    show.attentionLabel.textColor = FontUIColorBlack;
                    [show dismissContactView];
                }else{
                    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                        msgString =  [result objectForKey:@"msg"];
                         [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
                    }
                }
            }else{
                msgString = @"您提现的密码输入错误，请重新输入";
                [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
            }
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            show.sureBtn.enabled = YES;
        }];
    }
}

#pragma mark 提交
-(void)submitBtnPressed:(UIButton *)sender
{
    self.subview.subButton.enabled = NO;
    
    if (self.alipayTextField.text.length==0||
        self.moneyTextField.text.length==0||
        self.verifyTextField.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if ([self.swa_id isEqualToString:@""]) {
        NSDictionary *dic = @{
                              @"verifyCode":self.verifyTextField.text,
                              @"swa_name":self.nameTextField.text,
                              @"swa_alipay_account":self.alipayTextField.text,
                              @"swa_sum":self.moneyTextField.text//double 类型
                              };
        
        [[RequestManager shareRequestManager] ApplyWithdrawByAlipayResultNew:dic viewController:self successData:^(NSDictionary *result){
            NSLog(@"result-------->%@",result);
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag == 10000){
                [self pwdsubmit];
                [self.verifyTextField resignFirstResponder];
                [show.pwdTextField becomeFirstResponder];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            self.subview.subButton.enabled = YES;
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.subview.subButton.enabled = YES;
        }];
    }else{
        NSDictionary *dic1 = @{
                               @"verifyCode":self.verifyTextField.text,
                               @"swa_id":self.swa_id,
                               @"swa_name":self.nameTextField.text,
                               @"swa_alipay_account":self.alipayTextField.text,
                               @"swa_sum":self.moneyTextField.text//double 类型
                               };
        [[RequestManager shareRequestManager] UpdateApplyWithdrawByAlipayDtoResultNew:dic1 viewController:self successData:^(NSDictionary *result){
            NSLog(@"result-------->%@",result);
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag == 10000){
                [self pwdsubmit];
                [self.verifyTextField resignFirstResponder];
                [show.pwdTextField becomeFirstResponder];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            self.subview.subButton.enabled = YES;
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.subview.subButton.enabled = YES;
        }];
    }
}

-(void)returnFailure{
    show.sureBtn.enabled = YES;
    show.attentionLabel.text = msgString;
    show.attentionLabel.textColor = RedUIColorC1;
}

-(void)returnListPage{
    SubmitSuccessedViewController *vc = [[SubmitSuccessedViewController alloc] init];
    vc.titles = @"申请提现";
    vc.fromWhere = self.fromWhere;
    vc.isFromSettingpwdpage = self.isFromSettingpwdpage;
    [self.navigationController pushViewController:vc animated:YES];
    show.sureBtn.enabled = YES;
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

-(void)onClick:(UITapGestureRecognizer *)sender{
    
    
    VerifyView *show = [[VerifyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.infoString = [NSString stringWithFormat:@"为了保证您的资金安全，您的支付宝账户注册姓名必须与实名认证姓名一致！ "];

    [show showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kWithdrawViewAlipayPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kWithdrawViewAlipayPage];
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

- (NSTimer *)timer {
    if (_timer == nil) {
        self.timer = [[NSTimer alloc]init];
    }
    return _timer;
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
//        self.nameTextField.delegate = self;
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

-(UIImageView *)nameImageView{
    if (_nameImageView == nil) {
        self.nameImageView = [UIImageView new];
        self.nameImageView.image = [UIImage imageNamed:@"icon-invitation-no"];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        self.nameImageView.userInteractionEnabled = YES;
        [self.nameImageView addGestureRecognizer:tap3];
    }
    return _nameImageView;
}

-(UILabel *)alipayLabel{
    if (_alipayLabel == nil) {
        self.alipayLabel = [CommentMethod initLabelWithText:@"支付宝账号" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.alipayLabel.textColor = FontUIColorGray;
    }
    return _alipayLabel;
}

-(UITextField *)alipayTextField{
    if (_alipayTextField == nil) {        
        self.alipayTextField = [UITextField new];
        self.alipayTextField.placeholder = @"请输入支付宝账号";
//        self.alipayTextField.delegate = self;
        self.alipayTextField.textAlignment = NSTextAlignmentRight;
        self.alipayTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.alipayTextField.clearButtonMode = UITextFieldViewModeNever;
        //        [self.nameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.alipayTextField.backgroundColor = [UIColor clearColor];
        self.alipayTextField.textColor = FontUIColorGray;
//        self.alipayTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _alipayTextField;
}

-(UILabel *)moneyLabel{
    if (_moneyLabel == nil) {
        self.moneyLabel = [CommentMethod initLabelWithText:@"提取金额" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.moneyLabel.textColor = FontUIColorGray;
    }
    return _moneyLabel;
}

-(UITextField *)moneyTextField{
    if (_moneyTextField == nil) {
        self.moneyTextField = [UITextField new];
        self.moneyTextField.placeholder = @"请输入提取金额";
        //        self.nameTextField.delegate = self;
        self.moneyTextField.textAlignment = NSTextAlignmentRight;
        self.moneyTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.moneyTextField.clearButtonMode = UITextFieldViewModeNever;
        //        [self.nameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.moneyTextField.backgroundColor = [UIColor clearColor];
        self.moneyTextField.textColor = FontUIColorGray;
        self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
    }
    return _moneyTextField;
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
        [self.subview.subButton setTitle:@"确认申请" forState:UIControlStateNormal];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}

@end
