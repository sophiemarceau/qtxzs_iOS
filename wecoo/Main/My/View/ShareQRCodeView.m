//
//  ShareQRCodeView.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2017/1/13.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ShareQRCodeView.h"

@implementation ShareQRCodeView{
    int flag;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}
-(void)setShareButtonNumber:(int)shareButtonNumber{
    
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    if (shareButtonNumber ==2) {
        norArray = [NSArray arrayWithObjects:@"icon-invitation-weixin", @"icon-invitation-pyq",   nil];
        selectArray = [NSArray arrayWithObjects:@"icon-invitation-weixin", @"icon-invitation-pyq",  nil];
        labeltextArray = [NSArray arrayWithObjects:@"微信好友", @"朋友圈",  nil];
    }
    
    if (shareButtonNumber ==3) {
        norArray = [NSArray arrayWithObjects:@"icon-invitation-weixin", @"icon-invitation-pyq", @"icon-invitation-er",  nil];
        selectArray = [NSArray arrayWithObjects:@"icon-invitation-weixin", @"icon-invitation-pyq", @"icon-invitation-er", nil];
        labeltextArray = [NSArray arrayWithObjects:@"微信好友", @"朋友圈", @"面对面扫码", nil];
    }
    
    flag = labeltextArray.count;
    float with = kScreenWidth/labeltextArray.count;
    
    for (int i = 0;  i < labeltextArray.count ; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 30*AUTO_SIZE_SCALE_X, with, 70*AUTO_SIZE_SCALE_X)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-50*AUTO_SIZE_SCALE_X)/2, 0, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-14*AUTO_SIZE_SCALE_X, with, 14*AUTO_SIZE_SCALE_X)];
        label.textColor = FontUIColorBlack;
        label.text = [labeltextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        imv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        [view addSubview:label];
        [view addSubview:imv];
        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:Viewtap];
        view.tag = i;
        
        [self.bgclickview  addSubview:view];
    }

}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
//    if (flag==2) {
//        switch (sender.view.tag) {
//            case 0:
//            {
//                [self dismissContactView];
//                if (self.shareFromFlag ==1) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickFun object:nil userInfo:@{@"shareflag":@"0"}];
//                }else{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickQRCODE object:nil userInfo:@{@"shareflag":@"0"}];
//                }
//                
//                break;
//            }
//                
//            case 1:{
//                [self dismissContactView];
//                if (self.shareFromFlag ==1) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickFun object:nil userInfo:@{@"shareflag":@"1"}];
//                }else{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickQRCODE object:nil userInfo:@{@"shareflag":@"1"}];
//                }
//                
//                
//                break;
//            }
//                
//            default:
//                break;
//        }
//    }
//    
//    if (flag==3) {
//        switch (sender.view.tag) {
//            case 0:
//            {
//                [self dismissContactView];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickInvite object:nil userInfo:@{@"shareflag":@"0"}];
//                break;
//            }
//                
//            case 1:{
//                [self dismissContactView];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickInvite object:nil userInfo:@{@"shareflag":@"1"}];
//                
//                break;
//            }
//                
//            case 2:{
//                [self dismissContactView];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kShareOnclickInvite object:nil userInfo:@{@"shareflag":@"2"}];
//                break;
//            }
//                
//            default:
//                break;
//        }
//    }
    [self dismissContactView];
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
    

    
    
    
    
    
    
    
    self.lineImageView = [UIImageView new];
    self.lineImageView.frame = CGRectMake(0, self.bgclickview.frame.size.height-43*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5);
    self.lineImageView.backgroundColor = lineImageColor;
    
    
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,self.bgclickview.frame.size.height-43*AUTO_SIZE_SCALE_X,kScreenWidth, 43*AUTO_SIZE_SCALE_X)];
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelLabel.text = @"取消分享";
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

    
    
    [self.bgclickview addSubview:self.lineImageView];
    [self.bgclickview addSubview:self.cancelLabel];
    [self.bgclickview addSubview:cancelImageview];
    

}


#pragma mark - 手势点击事件,移除View
- (void)dismissView:(UITapGestureRecognizer *)tapGesture{
    
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

-(UIImageView *)wechatImageView{
    if (_wechatImageView == nil) {
        _wechatImageView = [UIImageView new];
        _wechatImageView.image = [UIImage imageNamed:@"icon-invitation-weixin"];
        self.wechatImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
        self.wechatImageView.frame = CGRectMake(73*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        self.wechatImageView.layer.masksToBounds = YES;
        
    }
    return _wechatImageView;
}

-(UIImageView *)wechatFriendImageView{
    if (_wechatFriendImageView == nil) {
        _wechatFriendImageView = [UIImageView new];
        _wechatFriendImageView.image = [UIImage imageNamed:@"icon-invitation-pyq"];
        self.wechatFriendImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
        self.wechatFriendImageView.frame = CGRectMake(kScreenWidth-(73*AUTO_SIZE_SCALE_X)-50*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        self.wechatFriendImageView.layer.masksToBounds = YES;
        
    }
    return _wechatFriendImageView;
}

@end
