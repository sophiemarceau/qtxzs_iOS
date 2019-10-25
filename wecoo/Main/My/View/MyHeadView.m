//
//  MyHeadView.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/24.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyHeadView.h"


@implementation MyHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
   
    [self addSubview:self.redView];
    [self addSubview:self.messageImageView];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.clientMangeLabel];
    [self addSubview:self.manageView];
    [self addSubview:self.headerImageView];
    [self addSubview:self.NameLabel];
    [self addSubview:self.PhoneLabel];
    [self addSubview:self.balanceContent];
    [self addSubview:self.arrowverticalImageView];
    [self addSubview:self.efficiencyContent];
    [self addSubview:self.balanceLabel];
    [self addSubview:self.efficiencyLabel];
    [self addSubview:self.balanceView];
    [self addSubview:self.efficiencyView];
    [self addSubview:self.grayView];
//#pragma mark - 添加约束
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 130*AUTO_SIZE_SCALE_X));
    }];
    
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(30*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.messageImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];

    [self.clientMangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView).offset(-10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.messageImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    
    [self.manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clientMangeLabel).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.messageImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X+7*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];

    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.mas_top).offset(49*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];

    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self).offset(57*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];

    [self.PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.NameLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];

    [self.balanceContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.redView.mas_bottom).offset(21*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 22*AUTO_SIZE_SCALE_X));
    }];

    [self.arrowverticalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2);
        make.top.equalTo(self.redView.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(0.5, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.balanceContent.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 20*AUTO_SIZE_SCALE_X));
    }];
    
    [self.efficiencyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.redView.mas_bottom).offset(21*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 22*AUTO_SIZE_SCALE_X));
    }];

    [self.efficiencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.efficiencyContent.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 20*AUTO_SIZE_SCALE_X));
    }];
    
    [self.balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.redView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 84*AUTO_SIZE_SCALE_X));
    }];
    [self.efficiencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.redView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 84*AUTO_SIZE_SCALE_X));
    }];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.efficiencyView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10*AUTO_SIZE_SCALE_X));
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

-(UIView *)grayView{
    if (_grayView == nil) {
        self.grayView = [UIView new];
        self.grayView.backgroundColor = BGColorGray;
    }
    return _grayView;
}

- (UIImageView *)messageImageView {
    if (_messageImageView == nil) {
        self.messageImageView = [UIImageView new];
        self.messageImageView.userInteractionEnabled = YES;
        self.messageImageView.image =[UIImage imageNamed:@"icon-my-msg"];
    }
    return _messageImageView;
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


- (UILabel *)PhoneLabel {
    if (_PhoneLabel == nil) {
        self.PhoneLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.PhoneLabel.textColor = [UIColor whiteColor];
    }
    return _PhoneLabel;
}

- (UILabel *)clientMangeLabel {
    if (_clientMangeLabel == nil) {
        self.clientMangeLabel = [CommentMethod initLabelWithText:@"账号管理" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.clientMangeLabel.textColor = [UIColor whiteColor];
    }
    return _clientMangeLabel;
}



-(UIView *)manageView{
    if (_manageView == nil) {
        self.manageView = [UIView new];
        
        self.manageView.backgroundColor =  [UIColor clearColor];
        
    }
    return _manageView;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image =[UIImage imageNamed:@"icon-my-arrowRightwhite"];
    }
    return _arrowImageView;
}


- (UIImageView *)arrowverticalImageView {
    if (_arrowverticalImageView == nil) {
        self.arrowverticalImageView = [UIImageView new];
//        self.arrowverticalImageView.image =[UIImage imageNamed:@"icon-my-arrowRightwhite"];
        self.arrowverticalImageView.backgroundColor = FontUIColorGray;
    }
    return _arrowverticalImageView;
}

- (UILabel *)balanceContent {
    if (_balanceContent == nil) {
        self.balanceContent = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.balanceContent.textColor = RedUIColorC1;
    }
    return _balanceContent;
}

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        self.balanceLabel = [CommentMethod initLabelWithText:@"我的赏金" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.balanceLabel.textColor = FontUIColorGray;
    }
    return _balanceLabel;
}

- (UILabel *)efficiencyContent {
    if (_efficiencyContent == nil) {
        self.efficiencyContent = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.efficiencyContent.textColor = RedUIColorC1;
    }
    return _efficiencyContent;
}

- (UILabel *)efficiencyLabel {
    if (_efficiencyLabel == nil) {
        self.efficiencyLabel = [CommentMethod initLabelWithText:@"推荐质量分" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.efficiencyLabel.textColor = FontUIColorGray;
    }
    return _efficiencyLabel;
}

-(UIView *)balanceView{
    if (_balanceView == nil) {
        self.balanceView = [UIView new];
        
        self.balanceView.backgroundColor = [UIColor clearColor];
        
    }
    return _balanceView;
}

-(UIView *)efficiencyView{
    if (_efficiencyView == nil) {
        self.efficiencyView = [UIView new];
        
        self.efficiencyView.backgroundColor = [UIColor clearColor];
        
    }
    return _efficiencyView;
}
@end
