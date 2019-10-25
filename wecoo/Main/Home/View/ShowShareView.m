//
//  ShowShareView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/21.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ShowShareView.h"

@implementation ShowShareView

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
    UIView *topbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-390/2*AUTO_SIZE_SCALE_X)];
    topbgView.alpha = 0.4;
    topbgView.backgroundColor = [UIColor blackColor];
    [self addSubview:topbgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-390/2*AUTO_SIZE_SCALE_X, kScreenWidth, 390/2*AUTO_SIZE_SCALE_X)];
    
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    self.bgclickview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 390/2*AUTO_SIZE_SCALE_X)];
    
    self.bgclickview.backgroundColor = [UIColor whiteColor];
    
    self.wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.wechatImageView.frame.origin.y+self.wechatImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 14*AUTO_SIZE_SCALE_X)];
    self.wechatLabel.textAlignment = NSTextAlignmentCenter;
    self.wechatLabel.text = @"微信好友";
    self.wechatLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    self.wechatLabel.textColor = FontUIColorBlack;
    
    self.lineImageView = [UIImageView new];
    self.lineImageView.frame = CGRectMake(0, self.bgclickview.frame.size.height-43*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5);
    self.lineImageView.backgroundColor = lineImageColor;
    
    
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,self.bgclickview.frame.size.height-43*AUTO_SIZE_SCALE_X,kScreenWidth, 43*AUTO_SIZE_SCALE_X)];
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelLabel.text = @"取消";
    self.cancelLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    self.cancelLabel.textColor = FontUIColorBlack;
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.frame = CGRectMake(0 ,self.bgclickview.frame.size.height-43*AUTO_SIZE_SCALE_X,kScreenWidth, 43*AUTO_SIZE_SCALE_X);
    self.cancelLabel.userInteractionEnabled = YES;
    self.bgclickview.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
     UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    topbgView.userInteractionEnabled = YES;
    [topbgView addGestureRecognizer:tapGesture1];
    [bgView addSubview:self.bgclickview];
    [self.bgclickview addSubview:self.wechatImageView];
    [self.bgclickview addSubview:self.wechatLabel];
    [self.bgclickview addSubview:self.lineImageView];
    [self.bgclickview addSubview:self.cancelLabel];
    [self.bgclickview addSubview:cancelImageview];
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareContactView:)];
    self.wechatImageView.userInteractionEnabled = YES;
    [self.wechatImageView addGestureRecognizer:tapG];

    
}

#pragma mark -
- (void)shareContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];

    
}
#pragma mark - 手势点击事件,移除View
- (void)dismissView:(UITapGestureRecognizer *)tapGesture{
        [self dismissContactView];
}

-(void)dismissContactView
{
    [MobClick event:kShareCancelEvent];

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

-(UIImageView *)wechatImageView{
    if (_wechatImageView == nil) {
        _wechatImageView = [UIImageView new];
        _wechatImageView.image = [UIImage imageNamed:@"icon-shareWeixin"];      
        self.wechatImageView.layer.cornerRadius = 75.0/2*AUTO_SIZE_SCALE_X;
        self.wechatImageView.frame = CGRectMake((kScreenWidth-75*AUTO_SIZE_SCALE_X)/2, 24*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
        self.wechatImageView.layer.masksToBounds = YES;

    }
    return _wechatImageView;
}
@end
