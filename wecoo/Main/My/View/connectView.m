//
//  connectView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/20.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "connectView.h"

@implementation connectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.firstlabel];
        [self addSubview:self.secondlabel];
        #pragma mark - 添加约束
        [self.firstlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(17/2*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.mas_top).offset(25*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(258/2*AUTO_SIZE_SCALE_X, 25/2*AUTO_SIZE_SCALE_X));
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(18*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(36*AUTO_SIZE_SCALE_X, 42*AUTO_SIZE_SCALE_X));
        }];
        
        [self.secondlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(17/2*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.firstlabel.mas_bottom).offset(9*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(258/2*AUTO_SIZE_SCALE_X, 25/2*AUTO_SIZE_SCALE_X));
        }];
    }
    return self;
}



- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        self.iconImageView = [UIImageView new];
        self.iconImageView.image =[UIImage imageNamed:@"self-Invitation"];
//        self.iconImageView.layer.cornerRadius = 30.0*AUTO_SIZE_SCALE_X;
//        self.iconImageView.layer.borderWidth=1.0;
//        self.iconImageView.layer.masksToBounds = YES;
//        self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return _iconImageView;
}

- (UILabel *)firstlabel {
    if (_firstlabel == nil) {
        self.firstlabel = [CommentMethod initLabelWithText:@"本人赏金：687.00" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.firstlabel.textColor = FontUIColorBlack;
    }
    return _firstlabel;
}

- (UILabel *)secondlabel {
    if (_secondlabel == nil) {
        self.secondlabel = [CommentMethod initLabelWithText:@"累计赏金：56700" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.secondlabel.textColor = FontUIColorBlack;
        
    }
    return _secondlabel;
}




@end
