//
//  ShowRegisterSucceedView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/7.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ShowRegisterSucceedView.h"

@implementation ShowRegisterSucceedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 0.8;
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.image = [UIImage imageNamed:@"cover-loginOk"];
    cancelImageview.frame = CGRectMake((kScreenWidth-870/3*AUTO_SIZE_SCALE_X)/2 ,270/2*AUTO_SIZE_SCALE_X,870/3*AUTO_SIZE_SCALE_X, 1020/3*AUTO_SIZE_SCALE_X);
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
    [self addSubview:cancelImageview];
    
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    [self dismissContactView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHowTogeiMoneyPage object:nil];

    
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




@end
