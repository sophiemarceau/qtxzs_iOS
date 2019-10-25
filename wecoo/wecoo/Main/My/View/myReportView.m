//
//  myReportView.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/25.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "myReportView.h"

@implementation myReportView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.reportImageView];
    [self addSubview:self.reportLabel];
    [self addSubview:self.arrowImageview];
    [self addSubview:self.allLabel];
    [self addSubview:self.linImageView];
    [self addSubview:self.checkLabel];
    [self addSubview:self.checkConent];
    [self addSubview:self.followupLabel];
    [self addSubview:self.followupConent];
    [self addSubview:self.investigateLabel];
    [self addSubview:self.investigateConent];
    [self addSubview:self.signedLabel];
    [self addSubview:self.signedConent];
    [self addSubview:self.returnedLabel];
    [self addSubview:self.returnedConent];

    [self addSubview:self.reporteView];

  #pragma mark - 添加约束
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 115*AUTO_SIZE_SCALE_X));
    }];
    
    [self.reportImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.backgroundView.mas_top).offset(14*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(19*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X));
    }];
    
    [self.reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reportImageView.mas_right).offset(15);
        make.top.equalTo(self.backgroundView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(70*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];

    [self.reporteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.backgroundView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45*AUTO_SIZE_SCALE_X));
    }];

    
    [self.arrowImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.backgroundView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageview.mas_left).offset(-15);
        make.top.equalTo(self.backgroundView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];
    
    [self.linImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.backgroundView.mas_top).offset(45*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.checkConent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.linImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.checkConent.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 13*AUTO_SIZE_SCALE_X));
    }];
    
    [self.followupConent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkConent.mas_right);
        make.top.equalTo(self.linImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.followupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkLabel.mas_right);
        make.top.equalTo(self.checkConent.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 13*AUTO_SIZE_SCALE_X));
    }];
    
    [self.investigateConent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followupConent.mas_right);
        make.top.equalTo(self.linImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.investigateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followupLabel.mas_right);
        make.top.equalTo(self.investigateConent.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 13*AUTO_SIZE_SCALE_X));
    }];
    [self.signedConent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.investigateConent.mas_right);
        make.top.equalTo(self.linImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.signedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.investigateLabel.mas_right);
        make.top.equalTo(self.signedConent.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 13*AUTO_SIZE_SCALE_X));
    }];
    [self.returnedConent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signedConent.mas_right);
        make.top.equalTo(self.linImageView.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 10*AUTO_SIZE_SCALE_X));
    }];
    [self.returnedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signedLabel.mas_right);
        make.top.equalTo(self.returnedConent.mas_bottom).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/5, 13*AUTO_SIZE_SCALE_X));
    }];
    
}


















#pragma mark - 懒加载
-(UIView *)backgroundView{
    if (_backgroundView == nil) {
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    return _backgroundView;
}

- (UIImageView *)reportImageView {
    if (_reportImageView == nil) {
        self.reportImageView = [UIImageView new];
        self.reportImageView.image =[UIImage imageNamed:@"icon-myReport"];
    }
    return _reportImageView;
}



- (UILabel *)reportLabel {
    if (_reportLabel == nil) {
        self.reportLabel = [CommentMethod initLabelWithText:@"我的报备" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.reportLabel.textColor = FontUIColorGray;
    }
    return _reportLabel;
}


- (UILabel *)allLabel {
    if (_allLabel == nil) {
        self.allLabel = [CommentMethod initLabelWithText:@"全部" textAlignment:NSTextAlignmentRight font:15*AUTO_SIZE_SCALE_X];
        self.allLabel.textColor = FontUIColorGray;
    }
    return _allLabel;
}


- (UIImageView *)arrowImageview {
    if (_arrowImageview == nil) {
        self.arrowImageview = [UIImageView new];
        self.arrowImageview.image  =[UIImage imageNamed:@"icon-my-arrowRightgray"];
    }
    return _arrowImageview;
}



- (UIImageView *)linImageView {
    if (_linImageView == nil) {
        self.linImageView = [UIImageView new];
        self.linImageView.image  =[UIImage imageNamed:@"item_line"];
    }
    return _linImageView;
}


- (UILabel *)checkLabel {
    if (_checkLabel == nil) {
        self.checkLabel = [CommentMethod initLabelWithText:@"核实中" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.checkLabel.textColor = FontUIColorGray;
    }
    return _checkLabel;
}

- (UILabel *)checkConent {
    if (_checkConent == nil) {
        self.checkConent = [CommentMethod initLabelWithText:@"1" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.checkConent.textColor = FontUIColorGray;
    }
    return _checkConent;
}


- (UILabel *)followupLabel {
    if (_followupLabel == nil) {
        self.followupLabel = [CommentMethod initLabelWithText:@"跟进中" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.followupLabel.textColor = FontUIColorGray;
    }
    return _followupLabel;
}

- (UILabel *)followupConent {
    if (_followupConent == nil) {
        self.followupConent = [CommentMethod initLabelWithText:@"1" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.followupConent.textColor = FontUIColorGray;
    }
    return _followupConent;
}

- (UILabel *)investigateLabel {
    if (_investigateLabel == nil) {
        self.investigateLabel = [CommentMethod initLabelWithText:@"考察中" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.investigateLabel.textColor = FontUIColorGray;
    }
    return _investigateLabel;
}

- (UILabel *)investigateConent {
    if (_investigateConent == nil) {
        self.investigateConent = [CommentMethod initLabelWithText:@"1" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.investigateConent.textColor = FontUIColorGray;
    }
    return _investigateConent;
}



- (UILabel *)signedLabel {
    if (_signedLabel == nil) {
        self.signedLabel = [CommentMethod initLabelWithText:@"已签约" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.signedLabel.textColor = FontUIColorGray;
    }
    return _signedLabel;
}

- (UILabel *)signedConent {
    if (_signedConent == nil) {
        self.signedConent = [CommentMethod initLabelWithText:@"1" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.signedConent.textColor = FontUIColorGray;
    }
    return _signedConent;
}

- (UILabel *)returnedLabel {
    if (_returnedLabel == nil) {
        self.returnedLabel = [CommentMethod initLabelWithText:@"已退回" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.returnedLabel.textColor = FontUIColorGray;
    }
    return _returnedLabel;
}

- (UILabel *)returnedConent {
    if (_returnedConent == nil) {
        self.returnedConent = [CommentMethod initLabelWithText:@"1" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.returnedConent.textColor = FontUIColorGray;
    }
    return _returnedConent;
}


-(UIView *)reporteView{
    if (_reporteView == nil) {
        self.reporteView = [UIView new];
        self.reporteView.backgroundColor = [UIColor clearColor];
        
    }
    return _reporteView;
}
@end
