//
//  WithdrawPwdShow.m
//  wecoo
//
//  Created by 屈小波 on 2017/3/31.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "WithdrawPwdShow.h"

@implementation WithdrawPwdShow

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
//    //添加手势事件,移除View
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
//    [self addGestureRecognizer:tapGesture];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    UIView *pwdBG= [UIView new];
    pwdBG.frame = CGRectMake(35,
                             180*AUTO_SIZE_SCALE_X,
                             kScreenWidth-70,
                             428/2*AUTO_SIZE_SCALE_X
                             );
    pwdBG.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    [self addSubview:pwdBG];
    
    [pwdBG addSubview:self.subtitleLabel];
    [pwdBG addSubview:self.attentionLabel];
    [pwdBG addSubview:self.pwdTextField];
    [pwdBG addSubview:self.forgetPwdLabel];
    [pwdBG addSubview:self.cancleBtn];
    UIImageView *linImageView1 = [UIImageView new];
    linImageView1.backgroundColor = lineImageColor;
    [self.cancleBtn addSubview:linImageView1];
    linImageView1.frame = CGRectMake(0, 0, self.cancleBtn.frame.size.width, 0.5);
    [pwdBG addSubview:self.sureBtn];
}

#pragma mark - 手势点击事件,移除View
- (void)dismissView:(UITapGestureRecognizer *)tapGesture{
    [self dismissContactView];
}

-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        //        weakSelf.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 按钮点击事件
-(void)fieldChanged:(id)sender
{
    if(self.pwdTextField.text.length > 6){
        self.pwdTextField.text = [self.pwdTextField.text substringToIndex:6];
    }

    if (self.pwdTextField.text.length == 6) {
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.enabled = NO;
    }
}

// 这里加载在了window上
-(void)showView
{
    [UIView animateWithDuration:0.25 animations:^{
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        [window addSubview:self];
        //        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }completion:^(BOOL finished) {
        
    }];
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"提现密码" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.frame = CGRectMake(0, 20*AUTO_SIZE_SCALE_X, kScreenWidth-70, 15*AUTO_SIZE_SCALE_X);
        self.subtitleLabel.textColor = FontUIColorBlack;
    }
    return _subtitleLabel;
}

- (UILabel *)attentionLabel {
    if (_attentionLabel == nil) {
        self.attentionLabel = [CommentMethod initLabelWithText:@"为了您的资金安全，请输入提现密码" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.attentionLabel.frame = CGRectMake(15, self.subtitleLabel.frame.origin.y+self.subtitleLabel.frame.size.height+20*AUTO_SIZE_SCALE_X, kScreenWidth-70-30, 15*AUTO_SIZE_SCALE_X);
        self.attentionLabel.textColor = FontUIColorBlack;

    }
    return _attentionLabel;
}

- (UILabel *)forgetPwdLabel {
    if (_forgetPwdLabel == nil) {        
        self.forgetPwdLabel = [CommentMethod initLabelWithText:@"忘记密码 >" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.forgetPwdLabel.frame = CGRectMake(kScreenWidth-70-(15+70*AUTO_SIZE_SCALE_X), self.pwdTextField.frame.origin.y+self.pwdTextField.frame.size.height+10*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.forgetPwdLabel.textColor = UIColorFromRGB(0x2500f9);
        self.forgetPwdLabel.userInteractionEnabled = YES;
    }
    return _forgetPwdLabel;
}

-(UITextField *)pwdTextField{
    if (_pwdTextField == nil) {
        self.pwdTextField = [UITextField new];
        self.pwdTextField.placeholder = @"请输入支付密码";
        self.pwdTextField.delegate = self;
        self.pwdTextField.textAlignment = NSTextAlignmentCenter;
        self.pwdTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.pwdTextField.clearButtonMode = UITextFieldViewModeNever;
        [self.pwdTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.pwdTextField.backgroundColor = [UIColor clearColor];
        self.pwdTextField.textColor = FontUIColorGray;
        self.pwdTextField.layer.borderColor = FontUIColorGray.CGColor;
        self.pwdTextField.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.pwdTextField.secureTextEntry = YES;
        self.pwdTextField.layer.borderWidth = 0.2;
        self.pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.pwdTextField.frame = CGRectMake(15, self.attentionLabel.frame.origin.y+self.attentionLabel.frame.size.height+20*AUTO_SIZE_SCALE_X, kScreenWidth-70-30, 40*AUTO_SIZE_SCALE_X);
    }
    return _pwdTextField;
}


-(UIButton *)cancleBtn{
    if (_cancleBtn == nil ) {
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.userInteractionEnabled = YES;
        
        [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
       
        self.cancleBtn.frame = CGRectMake(0, self.forgetPwdLabel.frame.origin.y+self.forgetPwdLabel.frame.size.height+20*AUTO_SIZE_SCALE_X, (kScreenWidth-70)/2, 40*AUTO_SIZE_SCALE_X);
    }
    return _cancleBtn;
}

-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(UIButton *)sureBtn{
    if (_sureBtn == nil ) {
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.userInteractionEnabled = YES;
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[self imageWithColor:RedUIColorC1 size:CGSizeMake((kScreenWidth-70)/2, 40*AUTO_SIZE_SCALE_X)] forState:UIControlStateNormal];
         [self.sureBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xDDDDDD) size:CGSizeMake((kScreenWidth-70)/2, 40*AUTO_SIZE_SCALE_X)] forState:UIControlStateDisabled];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:UIColorFromRGB(0x9c9c9c) forState:UIControlStateDisabled];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        self.sureBtn.frame = CGRectMake((kScreenWidth-70)/2+1, self.forgetPwdLabel.frame.origin.y+self.forgetPwdLabel.frame.size.height+20*AUTO_SIZE_SCALE_X-1, (kScreenWidth-70)/2, 40*AUTO_SIZE_SCALE_X);
        self.sureBtn.enabled = NO;
    }
    return _sureBtn;
}
@end
