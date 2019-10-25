//
//  enterprise1View.m
//  wecoo
//
//  Created by 屈小波 on 2017/6/2.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "enterprise1View.h"

@implementation enterprise1View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGColorGray;
        
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    UIImageView * linImage1 = [UIImageView new];
    UIImageView * linImage2 = [UIImageView new];
    UIImageView * linImage3 = [UIImageView new];
    UIImageView * linImage4 = [UIImageView new];
    UIImageView * linImage5 = [UIImageView new];
    UIImageView * linImage6 = [UIImageView new];
    UIImageView * linImage7 = [UIImageView new];
    
    linImage1.backgroundColor = lineImageColor;
    linImage2.backgroundColor = lineImageColor;
    linImage3.backgroundColor = lineImageColor;
    linImage4.backgroundColor = lineImageColor;
    linImage5.backgroundColor = lineImageColor;
    linImage6.backgroundColor = lineImageColor;
    linImage7.backgroundColor = lineImageColor;
    
    
    
    
   
    
    
    [self addSubview:self.phoneView];
    [self.phoneView addSubview:self.phoneLabel];
    [self.phoneView addSubview:self.phoneContent];
    [self.phoneView addSubview:linImage1];
    
    [self addSubview:self.nameView];
    [self.nameView addSubview:self.nameLabel];
    [self.nameView addSubview:self.nameContent];
    [self.nameView addSubview:linImage2];
    
    [self addSubview:self.loginNameView];
    [self.loginNameView addSubview:self.loginNameLabel];
    [self.loginNameView addSubview:self.loginNameContent];
    [self.loginNameView addSubview:linImage3];

    [self addSubview:self.passwordView];
    [self.passwordView addSubview:self.passwordLabel];
    [self.passwordView addSubview:self.passwordContent];
    [self.passwordView addSubview:self.eyeImageView];
    [self.passwordView addSubview:self.eyeView];
    [self addSubview:self.companyView];
    [self.companyView addSubview:self.companyNameLabel];
    [self.companyView addSubview:self.companyNameContent];
    [self.companyView addSubview:linImage4];

    [self addSubview:self.districtView];
    [self.districtView addSubview:self.districtLabel];
    [self.districtView addSubview:self.districtContent];
    [self.districtView addSubview:linImage5];

    [self addSubview:self.tradeView];
    [self.tradeView addSubview:self.tradeLabel];
    [self.tradeView addSubview:self.tradeContent];
    [self.tradeView addSubview:linImage6];

    [self addSubview:self.ENContactView];
    [self.ENContactView addSubview:self.ENContactLabel];
    [self.ENContactView addSubview:self.ENContactContent];
    [self.ENContactView addSubview:linImage7];

    [self addSubview:self.contactPhoneView];
    [self.contactPhoneView addSubview:self.contactPhoneLabel];
    [self.contactPhoneView addSubview:self.contactPhoneContent];

    [self addSubview:self.remarkView];

    [self addSubview:self.picView1];
    [self.picView1 addSubview:self.picLabel];
    [self.picView1 addSubview:self.businesslicenceImageView];

    [self addSubview:self.picView2];
    [self.picView2 addSubview:self.postcardLabel];
    [self.picView2 addSubview:self.subpostcardLabel];
    [self.picView2 addSubview:self.postcardImageView];
    
    #pragma mark - 添加约束
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.phoneContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];

    [linImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.phoneView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.nameView.mas_top);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];

    [self.nameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.nameView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];

    [linImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.nameView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.loginNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];

    [self.loginNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.loginNameView.mas_top);
        make.size.mas_equalTo(CGSizeMake(87.5*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];

    [self.loginNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.loginNameView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [linImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.loginNameView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.passwordView.mas_top);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.passwordView.mas_top).offset((55-17)/2*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(17*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
    }];
    
    [self.eyeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.passwordView.mas_top);
        make.size.mas_equalTo(CGSizeMake(42*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.passwordContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.eyeImageView.mas_left).offset(-10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.passwordView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.passwordView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.companyView.mas_top);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.companyNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.companyView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];

    [linImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.companyView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.districtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.districtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.districtView.mas_top);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];

    [self.districtContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.districtView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];
  
    [linImage5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.districtView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.tradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.tradeView.mas_top);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.tradeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.tradeView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];

    [linImage6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.tradeView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.ENContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage6.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ENContactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.ENContactView.mas_top);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ENContactContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.ENContactView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [linImage7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.ENContactView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];

    [self.contactPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(linImage7.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.contactPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.contactPhoneView.mas_top);
        make.size.mas_equalTo(CGSizeMake(96*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.contactPhoneContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.contactPhoneView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X));
    }];

    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.contactPhoneView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 97.5*AUTO_SIZE_SCALE_X));
    }];

    [self.picView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.remarkView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 267.5*AUTO_SIZE_SCALE_X));
    }];

    [self.picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView1.mas_left).offset(15);
        make.top.equalTo(self.picView1.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 52.5*AUTO_SIZE_SCALE_X));
    }];

    [self.businesslicenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView1.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.picView1.mas_top).offset(52.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30,200*AUTO_SIZE_SCALE_X));
    }];
    
    [self.plusImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.businesslicenceImageView.mas_left).offset(137.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.businesslicenceImageView.mas_top).offset(45*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(70*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X));
    }];

    [self.picView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.picView1.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 291*AUTO_SIZE_SCALE_X));
    }];

    [self.postcardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.picView2.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 42.5*AUTO_SIZE_SCALE_X));
    }];

    [self.subpostcardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.picView2.mas_top).offset(42.6*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 18.5*AUTO_SIZE_SCALE_X));
    }];

    [self.postcardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.subpostcardLabel.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 200*AUTO_SIZE_SCALE_X));
    }];

    [self.plusImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postcardImageView.mas_left).offset(137.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.postcardImageView.mas_top).offset(45*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(70*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X));
    }];
}

#pragma mark - view 添加虚线边框
-(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)fieldChanged:(id)sender
{
    UITextField * textField=(UITextField*)sender;
    
    NSString * temp = textField.text;
    
    
    
//    NSString * temp = self.passwordContent.text;
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


#pragma mark - 懒加载

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"当前手机号" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.phoneLabel.backgroundColor = [UIColor whiteColor];
        self.phoneLabel.textColor = FontUIColorBlack;
    }
    return _phoneLabel;
}

-(UITextField *)phoneContent{
    if (_phoneContent == nil) {
        self.phoneContent = [UITextField new];
        self.phoneContent.placeholder =@"请输入手机号";
        self.phoneContent.userInteractionEnabled = NO;
        self.phoneContent.textAlignment = NSTextAlignmentRight;
        self.phoneContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.phoneContent.backgroundColor = [UIColor whiteColor];
        self.phoneContent.textColor = FontUIColorBlack;
    }
    return _phoneContent;
}

- (UIView *)phoneView {
    if (_phoneView == nil) {
        self.phoneView = [UIView new];
        self.phoneView.backgroundColor = [UIColor whiteColor];
        self.phoneView.userInteractionEnabled = YES;
    }
    return _phoneView;
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"您的姓名" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.nameLabel.textColor = FontUIColorBlack;
    }
    return _nameLabel;
}

-(UITextField *)nameContent{
    if (_nameContent == nil) {
        self.nameContent = [UITextField new];
        self.nameContent.placeholder =@"请输入您的真实姓名";
        //        self.phoneContent.userInteractionEnabled = NO;
        self.nameContent.textAlignment = NSTextAlignmentRight;
        self.nameContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.nameContent.backgroundColor = [UIColor clearColor];
        self.nameContent.textColor = FontUIColorBlack;
    }
    return _nameContent;
}

- (UIView *)nameView {
    if (_nameView == nil) {
        self.nameView = [UIView new];
        self.nameView.backgroundColor = [UIColor whiteColor];
        self.nameView.userInteractionEnabled = YES;
    }
    return _nameView;
}

- (UILabel *)loginNameLabel{
    if (_loginNameLabel == nil) {
        self.loginNameLabel = [CommentMethod initLabelWithText:@"登录用户名" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.loginNameLabel.textColor = FontUIColorBlack;
    }
    return _loginNameLabel;
}

-(UITextField *)loginNameContent{
    if (_loginNameContent == nil) {
        self.loginNameContent = [UITextField new];
        self.loginNameContent.placeholder =@"用于登录PC管理平台";
        //        self.phoneContent.userInteractionEnabled = NO;
        self.loginNameContent.textAlignment = NSTextAlignmentRight;
        self.loginNameContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.loginNameContent.backgroundColor = [UIColor clearColor];
        self.loginNameContent.textColor = FontUIColorBlack;
    }
    return _loginNameContent;
}

- (UIView *)loginNameView {
    if (_loginNameView == nil) {
        self.loginNameView = [UIView new];
        self.loginNameView.backgroundColor = [UIColor whiteColor];
        self.loginNameView.userInteractionEnabled = YES;
    }
    return _loginNameView;
}

- (UILabel *)passwordLabel{
    if (_passwordLabel == nil) {
        self.passwordLabel = [CommentMethod initLabelWithText:@"登录密码" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.passwordLabel.textColor = FontUIColorBlack;
    }
    return _passwordLabel;
}

-(UITextField *)passwordContent{
    if (_passwordContent == nil) {
        self.passwordContent = [UITextField new];
        self.passwordContent.placeholder =@"用于登录PC管理平台";
        self.passwordContent.secureTextEntry = YES;
        //        self.phoneContent.userInteractionEnabled = NO;
        self.passwordContent.textAlignment = NSTextAlignmentRight;
        self.passwordContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.passwordContent.backgroundColor = [UIColor clearColor];
        self.passwordContent.textColor = FontUIColorBlack;
        
    }
    return _passwordContent;
}

- (UIView *)passwordView {
    if (_passwordView == nil) {
        self.passwordView = [UIView new];
        self.passwordView.backgroundColor = [UIColor whiteColor];
        self.passwordView.userInteractionEnabled = YES;
    }
    return _passwordView;
}

- (UILabel *)companyNameLabel{
    if (_companyNameLabel == nil) {
        self.companyNameLabel = [CommentMethod initLabelWithText:@"企业名称" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.companyNameLabel.textColor = FontUIColorBlack;
    }
    return _companyNameLabel;
}

-(UITextField *)companyNameContent{
    if (_companyNameContent == nil) {
        self.companyNameContent = [UITextField new];
        self.companyNameContent.placeholder =@"请填写企业名称";
        //        self.phoneContent.userInteractionEnabled = NO;
        self.companyNameContent.textAlignment = NSTextAlignmentRight;
        self.companyNameContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.companyNameContent.backgroundColor = [UIColor clearColor];
        self.companyNameContent.textColor = FontUIColorBlack;
    }
    return _companyNameContent;
}

- (UIView *)companyView {
    if (_companyView == nil) {
        self.companyView = [UIView new];
        self.companyView.backgroundColor = [UIColor whiteColor];
        self.companyView.userInteractionEnabled = YES;
    }
    return _companyView;
}

- (UILabel *)districtLabel {
    if (_districtLabel == nil) {
        self.districtLabel = [CommentMethod initLabelWithText:@"企业地区" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.districtLabel.textColor = FontUIColorBlack;
    }
    return _districtLabel;
}

-(UITextField *)districtContent{
    if (_districtContent == nil) {
        self.districtContent = [UITextField new];
        self.districtContent.userInteractionEnabled = NO;
        self.districtContent.textAlignment = NSTextAlignmentRight;
        self.districtContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.districtContent.backgroundColor = [UIColor clearColor];
        self.districtContent.textColor = FontUIColorBlack;
        self.districtContent.placeholder =@"请选择企业所在地";
    }
    return _districtContent;
}

- (UIView *)districtView {
    if (_districtView == nil) {
        self.districtView = [UIView new];
        self.districtView.backgroundColor = [UIColor whiteColor];
        self.districtView.userInteractionEnabled = YES;
    }
    return _districtView;
}

- (UILabel *)tradeLabel {
    if (_tradeLabel == nil) {
        self.tradeLabel = [CommentMethod initLabelWithText:@"所属行业" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.tradeLabel.textColor = FontUIColorBlack;
    }
    return _tradeLabel;
}

-(UITextField *)tradeContent{
    if (_tradeContent == nil) {
        self.tradeContent = [UITextField new];
        self.tradeContent.placeholder =@"请选择企业所属行业";
        self.tradeContent.userInteractionEnabled = NO;
        self.tradeContent.textAlignment = NSTextAlignmentRight;
        self.tradeContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.tradeContent.backgroundColor = [UIColor clearColor];
        self.tradeContent.textColor = FontUIColorBlack;
    }
    return _tradeContent;
}

- (UIView *)tradeView {
    if (_tradeView == nil) {
        self.tradeView = [UIView new];
        self.tradeView.backgroundColor = [UIColor whiteColor];
        self.tradeView.userInteractionEnabled = YES;
    }
    return _tradeView;
}

- (UILabel *)ENContactLabel {
    if (_ENContactLabel == nil) {
        self.ENContactLabel = [CommentMethod initLabelWithText:@"企业联系人" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.ENContactLabel.textColor = FontUIColorBlack;
    }
    return _ENContactLabel;
}

-(UITextField *)ENContactContent{
    if (_ENContactContent == nil) {
        self.ENContactContent = [UITextField new];
        self.ENContactContent.placeholder =@"仅用于必要时的沟通";
        self.ENContactContent.userInteractionEnabled = YES;
        self.ENContactContent.textAlignment = NSTextAlignmentRight;
        self.ENContactContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.ENContactContent.backgroundColor = [UIColor clearColor];
        self.ENContactContent.textColor = FontUIColorBlack;
    }
    return _ENContactContent;
}

- (UIView *)ENContactView {
    if (_ENContactView == nil) {
        self.ENContactView = [UIView new];
        self.ENContactView.backgroundColor = [UIColor whiteColor];
        self.ENContactView.userInteractionEnabled = YES;
    }
    return _ENContactView;
}

- (UILabel *)contactPhoneLabel {
    if (_contactPhoneLabel == nil) {
        self.contactPhoneLabel = [CommentMethod initLabelWithText:@"联系人手机号" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.contactPhoneLabel.textColor = FontUIColorBlack;
    }
    return _contactPhoneLabel;
}

-(UITextField *)contactPhoneContent{
    if (_contactPhoneContent == nil) {
        self.contactPhoneContent = [UITextField new];
        self.contactPhoneContent.placeholder =@"请输入手机号";
        self.contactPhoneContent.keyboardType = UIKeyboardTypeNumberPad;
        self.contactPhoneContent.userInteractionEnabled = YES;
        self.contactPhoneContent.textAlignment = NSTextAlignmentRight;
        self.contactPhoneContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.contactPhoneContent.backgroundColor = [UIColor clearColor];
        self.contactPhoneContent.textColor = FontUIColorBlack;
        [self.contactPhoneContent addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _contactPhoneContent;
}

- (UIView *)contactPhoneView {
    if (_contactPhoneView == nil) {
        self.contactPhoneView = [UIView new];
        self.contactPhoneView.backgroundColor = [UIColor whiteColor];
        self.contactPhoneView.userInteractionEnabled = YES;
    }
    return _contactPhoneView;
}

-(PlaceholderTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _remarkView.backgroundColor = [UIColor whiteColor];
        _remarkView.delegate = self;
        _remarkView.font = [UIFont systemFontOfSize:14.f];
        _remarkView.textColor = FontUIColorBlack;
        
        _remarkView.textAlignment = NSTextAlignmentLeft;
        _remarkView.editable = YES;
        //        _remarkView.layer.cornerRadius = 4.0f;
        _remarkView.layer.borderColor = kTextBorderColor.CGColor;
        //        _remarkView.layer.borderWidth = 0.5;
        _remarkView.placeholderColor = UIColorFromRGB(0xc4c3c9);
        _remarkView.placeholder = @"请填写企业简介，20字以内";
    }
    return _remarkView;
}

- (UILabel *)picLabel {
    if (_picLabel == nil) {
        self.picLabel = [CommentMethod initLabelWithText:@"请上传营业执照" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.picLabel.textColor = FontUIColorBlack;
    }
    return _picLabel;
}

- (UILabel *)postcardLabel {
    if (_postcardLabel == nil) {
        self.postcardLabel = [CommentMethod initLabelWithText:@"请上传个人名片" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        
        self.postcardLabel.textColor = FontUIColorBlack;
    }
    return _postcardLabel;
}

- (UILabel *)subpostcardLabel {
    if (_subpostcardLabel == nil) {
        self.subpostcardLabel = [CommentMethod initLabelWithText:@"与营业执照至少选其一" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        
        self.subpostcardLabel.textColor = FontUIColorGray;
    }
    return _subpostcardLabel;
}

-(UIImageView *)businesslicenceImageView{
    if (_businesslicenceImageView == nil) {
        self.businesslicenceImageView = [UIImageView new];
//        self.businesslicenceImageView.frame = CGRectMake(15 , 18*AUTO_SIZE_SCALE_X,75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
        self.businesslicenceImageView.size = CGSizeMake(kScreenWidth-30,200*AUTO_SIZE_SCALE_X);
        self.businesslicenceImageView.image = [self imageWithSize:self.businesslicenceImageView.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
        self.businesslicenceImageView.userInteractionEnabled = YES;
        [self.businesslicenceImageView addSubview:self.plusImageView1];
        [self.businesslicenceImageView addSubview:self.imageLabel1];
        
    }
    return _businesslicenceImageView;
}

-(UIImageView *)plusImageView1{
    if (_plusImageView1 == nil) {
        self.plusImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(137.5*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X)];
        self.plusImageView1.image = [UIImage imageNamed:@"icon_upload_photos"];
    }
    return _plusImageView1;
}

-(UILabel *)imageLabel1{
    if (_imageLabel1 == nil) {
        self.imageLabel1 = [CommentMethod initLabelWithText:@"上传营业执照" textAlignment:NSTextAlignmentCenter font:13*AUTO_SIZE_SCALE_X];
        self.imageLabel1.textColor = FontUIColorGray;
        self.imageLabel1.frame = CGRectMake(0,155*AUTO_SIZE_SCALE_X,self.businesslicenceImageView.size.width, 25*AUTO_SIZE_SCALE_X);
    }
    return _imageLabel1;
}

-(UIImageView *)postcardImageView{
    if (_postcardImageView == nil) {
        self.postcardImageView = [UIImageView new];
        //        self.businesslicenceImageView.frame = CGRectMake(15 , 18*AUTO_SIZE_SCALE_X,75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
        self.postcardImageView.size = CGSizeMake(kScreenWidth-30,200*AUTO_SIZE_SCALE_X);
        self.postcardImageView.image = [self imageWithSize:self.businesslicenceImageView.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
        self.postcardImageView.userInteractionEnabled = YES;
        [self.postcardImageView addSubview:self.plusImageView2];
        [self.postcardImageView addSubview:self.imageLabel2];
        
    }
    return _postcardImageView;
}

-(UIImageView *)plusImageView2{
    if (_plusImageView2 == nil) {
        self.plusImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(137.5*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X)];
        self.plusImageView2.image = [UIImage imageNamed:@"icon_upload_photos"];
    }
    return _plusImageView2;
}

-(UILabel *)imageLabel2{
    if (_imageLabel2 == nil) {
        self.imageLabel2 = [CommentMethod initLabelWithText:@"上传个人名片" textAlignment:NSTextAlignmentCenter font:13*AUTO_SIZE_SCALE_X];
        self.imageLabel2.textColor = FontUIColorGray;
        self.imageLabel2.frame = CGRectMake(0,155*AUTO_SIZE_SCALE_X,self.postcardImageView.size.width, 25*AUTO_SIZE_SCALE_X);
    }
    return _imageLabel2;
}

- (UIView *)picView1 {
    if (_picView1 == nil) {
        self.picView1 = [UIView new];
        self.picView1.backgroundColor = [UIColor whiteColor];
        self.picView1.userInteractionEnabled = YES;
    }
    return _picView1;
}

- (UIView *)picView2 {
    if (_picView2 == nil) {
        self.picView2 = [UIView new];
        self.picView2.backgroundColor = [UIColor whiteColor];
        self.picView2.userInteractionEnabled = YES;
    }
    return _picView2;
}

-(UIImageView *)eyeImageView{
    if (_eyeImageView == nil) {
        self.eyeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        self.eyeImageView.image =[UIImage imageNamed:@"btn_enterprise_review_hidden_password"];
        
    }
    return _eyeImageView;
}

- (UIView *)eyeView {
    if (_eyeView == nil) {
        self.eyeView = [UIView new];
        self.eyeView.backgroundColor = [UIColor clearColor];
        self.eyeView.userInteractionEnabled = YES;
    }
    return _eyeView;
}


@end
