//
//  ZeroView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ZeroView.h"

@implementation ZeroView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}
- (void)initView {
    
    [self addSubview:self.noContentLabel];
    
    
    //约束
  
    [self.noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-50);
        make.top.equalTo(self.mas_top).offset(110*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(30);
    }];
    [self.noContentLabel sizeToFit];
}

#pragma mark - 懒加载

- (UILabel *)noContentLabel {
    if (_noContentLabel == nil) {
        self.noContentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:11];
        self.noContentLabel.textColor = FontUIColorBlack;
        self.noContentLabel.numberOfLines = 0;
    }
    return _noContentLabel;
}

@end
