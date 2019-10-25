//
//  LoginViewController.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@class WPHotspotLabel;
@interface LoginViewController : BaseViewController
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *appNameLabel;
@property (nonatomic,strong)UITextField *phoneTextField;
@property (nonatomic,strong)UIImageView *lineImageView1;
@property (nonatomic,strong)UITextField *messagePasswordTextField;
@property (nonatomic,strong)UIImageView *lineImageView2;
@property (nonatomic,strong)UITextField *inviteCodeTextField;
@property (nonatomic,strong)UIImageView *lineImageView3;
@property (nonatomic,strong)UIButton *registerButton;
@property (nonatomic,strong)UIButton *codeButton;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)WPHotspotLabel *attentionLabel;
@property (strong, nonatomic) UILabel *timeLabel;//60秒后重发
@end
