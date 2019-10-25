//
//  noneListView.m
//  wecoo
//
//  Created by 屈小波 on 2016/12/5.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "noneListView.h"

@implementation noneListView

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
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2-49*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(100*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(98*AUTO_SIZE_SCALE_X, 59*AUTO_SIZE_SCALE_X));
    }];
    
    [self.noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        
        make.top.equalTo(self.noImageView.mas_bottom).offset(18);
        
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 14*AUTO_SIZE_SCALE_X));
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
