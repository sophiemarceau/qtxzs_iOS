//
//  CommissionNoteView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "CommissionNoteView.h"

@implementation CommissionNoteView

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
    
    
    
    self.ruleLabel =  [CommentMethod initLabelWithText:@"赏金说明" textAlignment:NSTextAlignmentCenter font:20*AUTO_SIZE_SCALE_X];
    self.ruleLabel.textColor = [UIColor whiteColor];
    self.ruleLabel.frame =  CGRectMake(15, 90*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    [self addSubview:self.ruleLabel];
    
    
    self.line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.ruleLabel.frame.origin.y+self.ruleLabel.frame.size.height+ 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0.5)];
    self.line1ImageView.backgroundColor = UIColorFromRGB(0xAAAAAA);
    [self addSubview:self.line1ImageView];
    
    [self addSubview:self.CommissionNoteLabel];
   
//    NSLog(@"%@",self.CommissionNoteLabel);
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.image = [UIImage imageNamed:@"icon-close"];
    cancelImageview.frame = CGRectMake((kScreenWidth-50*AUTO_SIZE_SCALE_X)/2 ,kScreenHeight-95*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
    [self addSubview:cancelImageview];
    
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
    
    self.CommissionNoteLabel.text =self.noteString;
    [self.CommissionNoteLabel sizeToFit];

    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}


-(UILabel *)CommissionNoteLabel{
    if (_CommissionNoteLabel == nil) {
        self.CommissionNoteLabel = [CommentMethod createLabelWithText:@"" TextColor:[UIColor whiteColor] BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
        self.CommissionNoteLabel.frame = CGRectMake(15, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
  
        
    }
    return _CommissionNoteLabel;
}
@end
