//
//  VerifyView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/4.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "VerifyView.h"

@implementation VerifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

-(void)setInfoString:(NSString *)infoString{
    self.desLabel.text = [NSString stringWithFormat:@"%@",infoString];
    self.desLabel.numberOfLines = 0;
    self.desLabel.frame = CGRectMake(24, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+30*AUTO_SIZE_SCALE_X, self.bgView.frame.size.width-48, 0);
    
    [self.desLabel sizeToFit];
    self.desLabel.textColor = FontUIColorBlack;
    self.desLabel.frame = CGRectMake(24, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+30*AUTO_SIZE_SCALE_X, self.bgView.frame.size.width-48, self.desLabel.frame.size.height);
    [self.bgView addSubview:self.desLabel];
    [self.bgView addSubview:self.subButton];
    self.subButton.frame = CGRectMake(35, self.desLabel.frame.origin.y+self.desLabel.frame.size.height+20*AUTO_SIZE_SCALE_X, self.bgView.frame.size.width-70, 36*AUTO_SIZE_SCALE_X);

}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 0.8;
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];

    self.bgView = [UIView new];
    self.bgView.frame = CGRectMake(40, 200*AUTO_SIZE_SCALE_X, kScreenWidth-80, 390/2*AUTO_SIZE_SCALE_X);
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10*AUTO_SIZE_SCALE_X;
    [self addSubview:self.bgView];
    
    self.ruleLabel =  [CommentMethod initLabelWithText:@"提示" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
    self.ruleLabel.textColor = FontUIColorBlack;
    self.ruleLabel.frame =  CGRectMake(15,0, self.bgView.frame.size.width-30, 40*AUTO_SIZE_SCALE_X);
    [self.bgView addSubview:self.ruleLabel];
    self.line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.ruleLabel.frame.size.height-1, self.ruleLabel.frame.size.width, 0.5)];
    self.line1ImageView.backgroundColor = lineImageColor;

    [self.bgView addSubview:self.line1ImageView];
    self.desLabel= [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    
    bgView.userInteractionEnabled = YES;
    
    [bgView addGestureRecognizer:tapGesture];
    
    

    
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];
}

-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

// 这里加载在了window上
-(void)showView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

-(UIButton *)subButton{
    if (_subButton ==nil) {
        self.subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.subButton setTitle:@"知道了" forState:UIControlStateNormal];
        [self.subButton setTintColor:[UIColor whiteColor]];
        [self.subButton setBackgroundColor:RedUIColorC1];
        self.subButton.userInteractionEnabled = YES;
        [self.subButton addTarget:self action:@selector(dismissContactView:) forControlEvents:UIControlEventTouchUpInside];
        self.subButton.layer.cornerRadius = 18*AUTO_SIZE_SCALE_X;
        self.subButton.enabled = YES;
        
    }
    return _subButton;
}

@end
