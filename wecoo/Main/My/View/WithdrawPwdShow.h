//
//  WithdrawPwdShow.h
//  wecoo
//
//  Created by 屈小波 on 2017/3/31.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawPwdShow : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView  *bgclickview;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UILabel *forgetPwdLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *sureBtn;
-(void)showView;
-(void)dismissContactView;

@end
