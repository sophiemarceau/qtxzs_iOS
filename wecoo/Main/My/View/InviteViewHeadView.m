//
//  InviteViewHeadView.m
//  wecoo
//
//  Created by 屈小波 on 2017/1/11.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "InviteViewHeadView.h"

@implementation InviteViewHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
//-(void)setFlag:(NSString *)flag{
//    if ([flag isEqualToString:@"1"]) {
//        self.ruleLabel.hidden =  YES;
//        
//        ////        lineheight = titleLabel.frame.origin.y+titleLabel.frame.size.height;

//       
//
//        
//    }else{
//        self.ruleLabel.hidden = NO;
//    }
//  
//}


- (void)setData:(NSDictionary *)data {
    
    [self addSubview:self.redView];
    [self.redView addSubview:self.headerImageView];
    [self.redView addSubview:self.NameLabel];
    [self.redView addSubview:self.InviteCodeLabel];
    [self.redView addSubview:self.CopyButton];
    [self addSubview:self.verticalLineImageView];
    [self addSubview:self.inviteiconImageView];
    [self addSubview:self.moneyiconImageView];
    [self addSubview:self.inviteLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.invitePersonCountLabel];
    [self addSubview:self.inviteActivityTotallMoneyLabel];
    [self addSubview:self.horizontalLineImageView];
//    
    #pragma mark - 添加约束
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 170*AUTO_SIZE_SCALE_X-64));
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.redView.mas_bottom).offset(-20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];

    [self.InviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.redView.mas_bottom).offset(-30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X));
    }];
    
    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.InviteCodeLabel.mas_top).offset(-8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(150*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X));
    }];
    
    [self.CopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.InviteCodeLabel.mas_right);
        make.bottom.equalTo(self.redView.mas_bottom).offset(-29*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(105/2*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X));
    }];

    [self.verticalLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2);
        make.top.equalTo(self.redView.mas_bottom).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(0.5, 43*AUTO_SIZE_SCALE_X));
    }];

    [self.inviteiconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(62*AUTO_SIZE_SCALE_X+1);
        make.top.equalTo(self.redView.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X));
    }];
    
    [self.moneyiconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2+53*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.redView.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X));
    }];

    [self.inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.inviteiconImageView.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 12*AUTO_SIZE_SCALE_X));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2);
        make.top.equalTo(self.inviteiconImageView.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 12*AUTO_SIZE_SCALE_X));
    }];

    [self.invitePersonCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inviteiconImageView.mas_right).offset(8*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.inviteLabel.mas_top).offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(95*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.inviteActivityTotallMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyiconImageView.mas_right).offset(8*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.moneyLabel.mas_top).offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(95*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];

    [self.horizontalLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.inviteLabel.mas_bottom).offset(14*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];

    
   }

#pragma mark - 懒加载
-(UIView *)redView{
    if (_redView == nil) {
        self.redView = [UIView new];
        self.redView.backgroundColor = RedUIColorC1;
    }
    return _redView;
}

- (UIImageView *)headerImageView {
    if (_headerImageView == nil) {
        self.headerImageView = [UIImageView new];
        self.headerImageView.image =[UIImage imageNamed:@"img-defult-account"];
        self.headerImageView.layer.cornerRadius = 30.0*AUTO_SIZE_SCALE_X;
        self.headerImageView.layer.borderWidth=1.0;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return _headerImageView;
}

- (UILabel *)NameLabel {
    if (_NameLabel == nil) {
        self.NameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.NameLabel.textColor = [UIColor whiteColor];
    }
    return _NameLabel;
}

- (UILabel *)InviteCodeLabel {
    if (_InviteCodeLabel == nil) {
        self.InviteCodeLabel = [CommentMethod initLabelWithText:@"邀请码" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.InviteCodeLabel.textColor = [UIColor whiteColor];
    }
    return _InviteCodeLabel;
}

- (UIImageView *)inviteiconImageView {
    if (_inviteiconImageView == nil) {
        self.inviteiconImageView = [UIImageView new];
        self.inviteiconImageView.image = [UIImage imageNamed:@"icon-invitation-num"];
    }
    return _inviteiconImageView;
}

- (UIImageView *)moneyiconImageView {
    if (_moneyiconImageView == nil) {
        self.moneyiconImageView = [UIImageView new];
        self.moneyiconImageView.image = [UIImage imageNamed:@"icon-invitation-reward"];
    }
    return _moneyiconImageView;
}

- (UILabel *)inviteLabel {
    if (_inviteLabel == nil) {
        self.inviteLabel = [CommentMethod initLabelWithText:@"邀请人数" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.inviteLabel.textColor = FontUIColorGray;
    }
    return _inviteLabel;
}


- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        self.moneyLabel = [CommentMethod initLabelWithText:@"邀请赏金" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.moneyLabel.textColor = FontUIColorGray;
    }
    return _moneyLabel;
}

- (UILabel *)invitePersonCountLabel {
    if (_invitePersonCountLabel == nil) {
        self.invitePersonCountLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.invitePersonCountLabel.textColor = RedUIColorC1;
    }
    return _invitePersonCountLabel;
}

- (UILabel *)inviteActivityTotallMoneyLabel {
    if (_inviteActivityTotallMoneyLabel == nil) {
        self.inviteActivityTotallMoneyLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.inviteActivityTotallMoneyLabel.textColor = RedUIColorC1;
    }
    return _inviteActivityTotallMoneyLabel;
}

- (UIImageView *)verticalLineImageView {
    if (_verticalLineImageView == nil) {
        self.verticalLineImageView = [UIImageView new];
        self.verticalLineImageView.backgroundColor = lineImageColor;
    }
    return _verticalLineImageView;
}

- (UIImageView *)horizontalLineImageView {
    if (_horizontalLineImageView == nil) {
        self.horizontalLineImageView = [UIImageView new];
        self.horizontalLineImageView.backgroundColor = lineImageColor;
    }
    return _horizontalLineImageView;
}

-(UIButton *)CopyButton{
    if (_CopyButton ==nil) {
        self.CopyButton= [UIButton buttonWithType:UIButtonTypeCustom];
        self.CopyButton.showsTouchWhenHighlighted = YES;
        [self.CopyButton setBackgroundImage:[UIImage imageNamed:@"btn-reportProgress"] forState:UIControlStateNormal];
        [self.CopyButton setTitle:@"复制" forState:UIControlStateNormal];
        [self.CopyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.CopyButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        
    }
    return _CopyButton;
   
}
@end
