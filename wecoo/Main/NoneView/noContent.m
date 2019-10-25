//
//  noContent.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/11/7.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "noContent.h"

@implementation noContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}
- (void)initView {
    [self addSubview:self.noImageView];
    [self addSubview:self.noContentLabel];
    
    
    //约束
    [self.noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(150*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(98*AUTO_SIZE_SCALE_X, 59*AUTO_SIZE_SCALE_X));
    }];
    
    [self.noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.noImageView.mas_bottom).offset(18);
        make.height.mas_equalTo(14);
    }];
  }

#pragma mark - 懒加载
- (UIImageView *)noImageView {
    if (_noImageView == nil) {
        self.noImageView = [UIImageView new];
        [self.noImageView setImage:[UIImage imageNamed:@"icon-noContent"]];
        self.noImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noImageView;
}
- (UILabel *)noContentLabel {
    if (_noContentLabel == nil) {
        self.noContentLabel = [CommentMethod initLabelWithText:@"这里没有内容哦~" textAlignment:NSTextAlignmentCenter font:11];
        self.noContentLabel.textColor = FontUIColorBlack;
    }
    return _noContentLabel;
}

@end
