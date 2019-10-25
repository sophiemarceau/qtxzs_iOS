//
//  ShowReviewView.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/11.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ShowReviewView.h"

@implementation ShowReviewView

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
   
    self.ruleLabel =  [CommentMethod initLabelWithText:@"1.请上传本人手持身份证的正面合影；" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
    self.ruleLabel.textColor = [UIColor whiteColor];
    self.ruleLabel.frame =  CGRectMake(15, 90*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    [self addSubview:self.ruleLabel];
    
    
     self.infoImageView = [[UIImageView alloc] init];
    [self addSubview:self.CommissionNoteLabel];
    [self addSubview:self.infoImageView];
    [self addSubview:self.subview];
   

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
//    infoImageView
    
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];
}

-(void)submitBtnPressed:(UIButton *)sender
{
    [self dismissContactView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckPersonalInfomation object:nil];
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
    self.CommissionNoteLabel.numberOfLines = 1;
    self.CommissionNoteLabel.text =@"2.请确保五官，证件内容清晰可见。";
    self.infoImageView.frame =CGRectMake(15, self.CommissionNoteLabel.frame.origin.y+self.CommissionNoteLabel.frame.size.height+ 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 514/2*AUTO_SIZE_SCALE_X);
    self.infoImageView.image = [UIImage imageNamed:@"sfzDefault"];
    self.infoImageView.layer.cornerRadius = 20.0*AUTO_SIZE_SCALE_X;
    
    self.infoImageView.layer.masksToBounds = YES;
    self.subview.frame = CGRectMake(0, self.infoImageView.frame.origin.y+self.infoImageView.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}


-(UILabel *)CommissionNoteLabel{
    if (_CommissionNoteLabel == nil) {
        self.CommissionNoteLabel = [CommentMethod createLabelWithText:@"" TextColor:[UIColor whiteColor] BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
        self.CommissionNoteLabel.frame = CGRectMake(15, self.ruleLabel.frame.origin.y+self.ruleLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
    }
    return _CommissionNoteLabel;
}


-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.userInteractionEnabled = YES;
        [self.subview.subButton setTitle:@"上传照片" forState:UIControlStateNormal];
        self.subview.backgroundColor = [UIColor clearColor];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}
@end
