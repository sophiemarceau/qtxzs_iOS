//
//  LoginViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "LoginViewController.h"
#import "JPUSHService.h"
#import "WebViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    int i;
    NSString *new_downloadUrl;
}
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation LoginViewController

- (void)viewDidLoad {
    //将status bar 文本颜色设置为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCheckVersionInloginPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:kCheckVersionInloginPage object:nil];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * firstRun = [userDefaults objectForKey:@"firstRun"];
    //存在需要查看版本更新
    if (firstRun) {
        //提示升级客户端
        [self checkVersion];
    }
    //不存在,为第一次启动,不需要 版本更新
    else{
        firstRun = @"alreadyRun";
        [userDefaults setObject:firstRun forKey:@"firstRun"];
    }

    [super viewDidLoad];
    i = 60;

    [self.navView removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.appNameLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.lineImageView1];
    [self.view addSubview:self.messagePasswordTextField];
    [self.view addSubview:self.lineImageView2];
    [self.view addSubview:self.inviteCodeTextField];
    [self.view addSubview:self.lineImageView3];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.attentionLabel];
    
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/2-25*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.view.mas_top).offset(85*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
//    }];
    
    self.iconImageView.frame =
//    UIRect((kScreenWidth-50)/2, 85, 50, 50);
    CGRectMake((kScreenWidth-50)/2, UI(85), UI(50),UI(50));
//    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(kScreenWidth/2-40*AUTO_SIZE_SCALE_X);
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
//    }];
    self.appNameLabel.frame =
//    UIRect((kScreenWidth-80)/2, 145, 80, 17);
    CGRectMake((kScreenWidth-80)/2, UI(145), UI(80),UI(17));
//    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.appNameLabel.mas_bottom).offset(30*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 28*AUTO_SIZE_SCALE_X));
//    }];
    self.phoneTextField.frame = UIRect(15, 162+30, 384, 28);
   
//    [self.lineImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.phoneTextField.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 0.5));
//    }];
    self.lineImageView1.frame = CGRectMake(15, UI(220+12), UI(384), 0.5);
//    UIRect(15, 220+12, 384, 0.5);
    
//    [self.messagePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.lineImageView1.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X));
//    }];
    self.messagePasswordTextField.frame = UIRect(15, 233+15, 200, 28);
    
//    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.top.equalTo(self.lineImageView1.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X, 36*AUTO_SIZE_SCALE_X));
//    }];
    self.codeButton.frame = CGRectMake(kScreenWidth-UI(125), UI(233+12), UI(110), UI(36));

    
//    [self.lineImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.messagePasswordTextField.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 0.5));
//    }];
//    NSLog(@"-----kscreenwidth---%f",kScreenWidth);
//    NSLog(@"-----kscreenheithth---%f",kScreenHeight);
//    #define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//    #define SCREEN_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen ] bounds].size.height : [[UIScreen mainScreen ] bounds].size.width)
//    NSLog(@"-----SCREEN_WIDTH---%f",SCREEN_WIDTH);
    self.lineImageView2.frame =
//    UIRect(15, 276+12,384, 0.5);
    CGRectMake(15, UI(276+12), UI(384), 0.5);
//    [self.inviteCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.lineImageView2.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 28*AUTO_SIZE_SCALE_X));
//    }];
    self.inviteCodeTextField.frame = UIRect(15, 289+15, 384, 28);
    
//    [self.lineImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.inviteCodeTextField.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 0.5));
//    }];
    self.lineImageView3.frame =  CGRectMake(15, UI(332+12), UI(384), 0.5);
//    UIRect(15, 332+12, 384, 0.5);
    
//    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.top.equalTo(self.lineImageView3.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 44*AUTO_SIZE_SCALE_X));
//    }];
    self.registerButton.frame = UIRect(15, 345+15, 384, 44);
    
//    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-25*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 44*AUTO_SIZE_SCALE_X));
//    }];
    self.attentionLabel.frame = UIRect(15, kScreenHeight-69, 384, 44);
    
}


#pragma mark 版本更新
-(void)checkVersion{
    
    NSDictionary * dic = @{
                           @"source":@"2",
                           @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           };
    
    [[RequestManager shareRequestManager] getVersionInfo:dic viewController:self successData:^(NSDictionary *result) {
        if(IsSucess(result)){
            new_downloadUrl = @"";
            new_downloadUrl = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]];
            NSString *versionFlag = [[result objectForKey:@"data"] objectForKey:@"result"];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * VersionAletshow = [userDefaults objectForKey:@"VersionAletshow"];
             //0 已是最新 1 可更新 2必更新
            if([versionFlag isEqualToString:@"1"] ){
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本有新的更新，是否现在去更新" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alertView.tag = 101;
                if (VersionAletshow) {
                    //已提示
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *lastRunVersion = [defaults objectForKey:IS_UPDATE_VERSION];
                    NSLog(@"lastRunVersion--->%@",lastRunVersion);
                    if ([lastRunVersion isEqualToString:@"1"]) {

                        [defaults setObject:@"0" forKey:IS_UPDATE_VERSION];
                        
                        [defaults synchronize];
                         NSString *version = [defaults objectForKey:IS_UPDATE_VERSION];
                         NSLog(@"lastRunVersion--->%@",version);
                        [alertView show];
                    }
                }
                else{
                    //可更新
                    [alertView show];
                    VersionAletshow = @"1";
                    [userDefaults setObject:VersionAletshow forKey:@"VersionAletshow"];
                    [userDefaults synchronize];
                }
            }else if([versionFlag isEqualToString:@"2"]){
                //必须更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本已不可用，请更新后使用" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles: nil];
                alertView.tag = 102;
                [alertView show];
            }else{
                return ;
            }
        }
    } failuer:^(NSError *error) {
        // 检查版本更新
        
    }];
}

#pragma mark Alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //可以使用，更新
    if (alertView.tag == 101) {
        if (buttonIndex == 0){
            
        }
        else if (buttonIndex == 1){
            //            NSString *str = [NSString stringWithFormat:
            //                             @"http://fir.im/75xc" ];
            //
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:new_downloadUrl]];
        }
    }
    //不可使用，必须更新
    else if(alertView.tag == 102){
        //        NSString *str = [NSString stringWithFormat:
        //                         @"http://fir.im/75xc" ];
        //
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        NSLog(@"sender---tag---------%@",new_downloadUrl);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:new_downloadUrl]];
    }
}


#pragma mark 登录
-(void)loginBtnPressed:(UIButton *)sender
{
    
    if(sender.tag ==1001){
        if (self.phoneTextField.text.length == 11) {
            
            NSDictionary * dic = @{
                                   @"tel":self.phoneTextField.text,
                                   };
            
            [[RequestManager shareRequestManager] GetVerifyCodeResult:dic viewController:self successData:^(NSDictionary *result){
                if(IsSucess(result)){
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                    [self.codeButton removeFromSuperview];
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
                    [self.timer fire];
                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }failuer:^(NSError *error){
                [self showHint:[error networkErrorInfo]];

//                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            }];
        }else{
            [[RequestManager shareRequestManager] tipAlert:@"手机号输入错误，请重新输入" viewController:self];
        }
    }else{
        [self.phoneTextField resignFirstResponder];
        [self.messagePasswordTextField resignFirstResponder];
        [self.inviteCodeTextField resignFirstResponder];

        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([self.phoneTextField.text isEqualToString:@""]) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写手机号" viewController:self];
            return;
        }
        if (self.phoneTextField.text.length<11) {
            [[RequestManager shareRequestManager] tipAlert:@"电话号码尾数不够11位，请重新输入" viewController:self];
            return;
        }
        if ([self.messagePasswordTextField.text isEqualToString:@""]) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写验证码" viewController:self];
            return;
        }
        
        if (self.messagePasswordTextField.text.length < 4) {
            [[RequestManager shareRequestManager] tipAlert:@"验证码位数不够4位，请重新输入" viewController:self];
            return;
        }
        
        if (self.inviteCodeTextField.text.length >10) {
            [[RequestManager shareRequestManager] tipAlert:@"邀请码位数不得超过10位" viewController:self];
            return;
        }
        
        
        NSDictionary * dic = @{
                               @"user_login":self.phoneTextField.text,
                               @"verification_code":self.messagePasswordTextField.text,
                               @"_invitation_code":self.inviteCodeTextField.text,
                               @"source":@"2",//2 代表 iOS
                               };
        [[RequestManager shareRequestManager] LoginUserRequest:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
               
                NSDictionary *returndata =  [result objectForKey:@"data"];
                NSString * qtx_auth = [returndata objectForKey:@"qtx_auth"];
                 NSString * user_id = [returndata objectForKey:@"user_id"];
                [userDefaults removeObjectForKey:@"qtx_auth"];
                [userDefaults setValue:qtx_auth forKey:@"qtx_auth"];
                [userDefaults removeObjectForKey:@"user_id"];
                [userDefaults setValue:user_id forKey:@"user_id"];
                [userDefaults synchronize];
                
//                __autoreleasing NSMutableSet *tags = [NSMutableSet set];
//                [self setTags:&tags addTag:qtx_auth];
                
                [JPUSHService setTags:nil alias:[[RequestManager shareRequestManager] opendUDID] fetchCompletionHandle:
                ^(int iResCode, NSSet *iTags,NSString *iAlias){
                    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,[self logSet:iTags], iAlias];
                    NSLog(@"TagsAlias回调:%@", callbackString);
                }];
                //将status bar 文本颜色设置为白色
                [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
            }else{
//                [[RequestManager shareRequestManager] resultFail:result WithController:self];
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){

            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
}

- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
  
    [*tags addObject:tag];
}


- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
  
//    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void)runClock
{
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d秒后重发",i];
    [self.view addSubview:self.timeLabel];
    
     //获取验证码按钮
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.top.equalTo(self.lineImageView1.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X, 36*AUTO_SIZE_SCALE_X));    }];
    
    self.timeLabel.frame = CGRectMake(kScreenWidth-UI(125), UI(233+12),UI(110), UI(36));
    i--;
    if (i<0) {
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self.view addSubview:self.codeButton];
        //约束
//        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.view.mas_right).offset(-15);
//            make.top.equalTo(self.lineImageView1.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
//            make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X, 36*AUTO_SIZE_SCALE_X));
//        }];
        
        self.codeButton.frame = UIRect(kScreenWidth-125, self.lineImageView1.frame.origin.y+self.lineImageView1.frame.size.height+12, 110, 36);
        self.codeButton.frame = CGRectMake(kScreenWidth-UI(125), UI(233+12), UI(110), UI(36));
        i=60;
        
    }
    
}

#pragma mark - 按钮点击事件
-(void)fieldChanged:(id)sender
{
  UITextField  *textField =  (UITextField*)sender;
    if (textField.tag==1001) {
        NSString * temp = textField.text;
        if (textField.markedTextRange ==nil){
            while(1){
                if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                    break;
                }else{
                    temp = [temp substringToIndex:temp.length-1];
                }
            }
            textField.text=temp;
        }
    }
    if (self.phoneTextField.text.length == 11 && self.messagePasswordTextField.text.length == 4) {
        self.registerButton.enabled = YES;
    }else{
        self.registerButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        self.iconImageView = [UIImageView new];
        self.iconImageView.image =[UIImage imageNamed:@"logo-login"];
    }
    return _iconImageView;
}

- (UILabel *)appNameLabel {
    if (_appNameLabel == nil) {
        self.appNameLabel = [CommentMethod initLabelWithText:@"渠到天下" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.appNameLabel.textColor = FontUIColorBlack;
    }
    return _appNameLabel;
}

-(UITextField *)phoneTextField{
    if (_phoneTextField == nil) {
        self.phoneTextField = [UITextField new];
        self.phoneTextField.placeholder = @"请填写手机号";
        self.phoneTextField.delegate = self;
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.phoneTextField.tag =1001;
        [self.phoneTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写手机号" attributes:
           @{NSForegroundColorAttributeName:lineImageColor,
                        NSFontAttributeName:self.phoneTextField.font
                }];
        self.phoneTextField.attributedPlaceholder = attrString;
        self.phoneTextField.textColor = UIColor.blackColor;
    }
    return _phoneTextField;
}

- (UIImageView *)lineImageView1 {
    if (_lineImageView1 == nil) {
        self.lineImageView1 = [UIImageView new];
//        self.lineImageView1.image =[UIImage imageNamed:@"item_line"];
        self.lineImageView1.backgroundColor =lineImageColor;

    }
    return _lineImageView1;
}

-(UITextField *)messagePasswordTextField{
    if (_messagePasswordTextField == nil) {
        self.messagePasswordTextField = [UITextField new];
        self.messagePasswordTextField.placeholder = @"请填写验证码";
        self.messagePasswordTextField.delegate = self;
        self.messagePasswordTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
         self.messagePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.messagePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.messagePasswordTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请填写验证码" attributes:
           @{NSForegroundColorAttributeName:lineImageColor,
                        NSFontAttributeName:self.messagePasswordTextField.font
                }];
        self.messagePasswordTextField.attributedPlaceholder = attrString;
        self.messagePasswordTextField.textColor = UIColor.blackColor;
        
    }
    return _messagePasswordTextField;
}

-(UIView *)lineImageView2{
    if ( _lineImageView2== nil) {
        self.lineImageView2 = [UIImageView new];
//        self.lineImageView2.image =[UIImage imageNamed:@"item_line"];
        self.lineImageView2.backgroundColor =lineImageColor;
    }
    return _lineImageView2;
}

-(UIView *)lineImageView3{
    if ( _lineImageView3== nil) {
        self.lineImageView3 = [UIImageView new];
//        self.lineImageView3.image =[UIImage imageNamed:@"item_line"];
        self.lineImageView3.backgroundColor =lineImageColor;
//        self.lineImageView3.backgroundColor = BGColorGray;
        
    }
    return _lineImageView3;
}

-(UIView *)inviteCodeTextField{
    if (_inviteCodeTextField == nil) {
        self.inviteCodeTextField = [UITextField new];
        self.inviteCodeTextField.placeholder = @"（选填）邀请码，如无邀请码请直接登录";
        self.inviteCodeTextField.delegate = self;
        self.inviteCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.inviteCodeTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.inviteCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.inviteCodeTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"（选填）邀请码，如无邀请码请直接登录" attributes:
           @{NSForegroundColorAttributeName:lineImageColor,
                        NSFontAttributeName:self.inviteCodeTextField.font
                }];
        self.inviteCodeTextField.attributedPlaceholder = attrString;
        self.inviteCodeTextField.textColor = UIColor.blackColor;
    }
    return _inviteCodeTextField;
}

-(UIButton *)registerButton{
    if (_registerButton == nil ) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.registerButton.userInteractionEnabled = YES;
        self.registerButton.enabled = NO;
        [self.registerButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.registerButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registerButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        self.registerButton.tag =1002;
        [self.registerButton addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
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

- (WPHotspotLabel *)attentionLabel {
    if (_attentionLabel == nil) {
        self.attentionLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectZero];
        self.attentionLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary* style3 = @{@"body" :
                                     @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0*AUTO_SIZE_SCALE_X],
                                       FontUIColorGray],
                                 @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                     NSLog(@"Help action");
                                     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                                     WebViewController *vc = [[WebViewController alloc] init];
                                     vc.webViewurl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"disclaimer.html"];
                                      [self.navigationController pushViewController:vc animated:YES];
                                 }],
                                 @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                     NSLog(@"Settings action");
                                 }],
                                 @"u": @[FontUIColorGray,
                                         @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}
                                         ],
                                 };
        self.attentionLabel.attributedText = [@"点击“登录”表示您已同意《<help><u>法律声明和隐私策略</u></help>》" attributedStringWithStyleBook:style3];
    }
    return _attentionLabel;
}

//- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
//    // alias analyse
//    if (![*alias length]) {
//        // ignore alias
//        *alias = nil;
//    }
//    // tags analyse
//    if (![*tags count]) {
//        *tags = nil;
//    } else {
//        __block int emptyStringCount = 0;
//        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
//            if ([tag isEqualToString:@""]) {
//                emptyStringCount++;
//            } else {
//                emptyStringCount = 0;
//                *stop = YES;
//            }
//        }];
//        if (emptyStringCount == [*tags count]) {
//            *tags = nil;
//        }
//    }
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kLoginPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kLoginPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}
/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
/*
 开启ios右滑返回
 */
- (void)startSideBack {
    self.isCanUseSideBack=YES;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanUseSideBack;
}

@end
