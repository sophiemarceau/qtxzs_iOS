//
//  SubmitView.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/24.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "SubmitView.h"

@implementation SubmitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initView{
    [self addSubview:self.subButton];
    [self.subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 44*AUTO_SIZE_SCALE_X));
    }];
}

-(UIButton *)subButton{
    if (_subButton ==nil) {
        self.subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.subButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.subButton setTintColor:[UIColor whiteColor]];
        [self.subButton setBackgroundColor:RedUIColorC1];
//        [self.subButton addTarget:self action:@selector(seviceDetailyuyueBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.subButton.layer.cornerRadius = 15;
        self.subButton.enabled = NO;
        
    }
    return _subButton;
}

@end
