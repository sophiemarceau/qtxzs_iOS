//
//  ShowAnimationView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ShowAnimationView.h"

@implementation ShowAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
        [self loadTop5Data];
    }
    return self;
}

-(void)setDayString:(NSString *)dayString{
    
    
    //    self.line2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,  titlle1.frame.origin.y+titlle1.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0.5)];
//    self.line2ImageView.backgroundColor = UIColorFromRGB(0xAAAAAA);
//    //    titlle4.frame = CGRectMake(15, self.line2ImageView.frame.origin.y+self.line2ImageView.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
//    [self addSubview:self.line2ImageView];
}

-(void)loadTop5Data{
    
    NSDictionary *dic = @{
                         
                          };
    [[RequestManager shareRequestManager] GetWithdrawRulesResult:dic viewController:nil successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            
            titlle1.text = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
            titlle1.numberOfLines = 0;
            titlle1.frame = CGRectMake(15, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+25*AUTO_SIZE_SCALE_X, kScreenWidth-15, 0);
            
            [titlle1 sizeToFit];
            titlle1.textColor = [UIColor whiteColor];
            [self addSubview:titlle1];
            titlle1.frame = CGRectMake(15, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+25*AUTO_SIZE_SCALE_X, kScreenWidth-15, titlle1.frame.size.height);

        }else{
            
        }
    }failuer:^(NSError *error){
        
    }];
}


- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 0.8;
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.image = [UIImage imageNamed:@"icon-close"];
    cancelImageview.frame = CGRectMake((kScreenWidth-50*AUTO_SIZE_SCALE_X)/2 ,kScreenHeight-95*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
    [self addSubview:cancelImageview];
    /*创建显示View*/
//    _contentView = [[UIView alloc] init];
//    _contentView.frame = CGRectMake(0, 0, self.frame.size.width - 40, 180);
//    _contentView.backgroundColor=[UIColor whiteColor];
//    _contentView.layer.cornerRadius = 4;
//    _contentView.layer.masksToBounds = YES;
//    [self addSubview:_contentView];
    /*可以继续在其中添加一些View 虾米的*/
    
    self.ruleLabel =  [CommentMethod initLabelWithText:@"提现规则" textAlignment:NSTextAlignmentCenter font:20*AUTO_SIZE_SCALE_X];
    self.ruleLabel.textColor = [UIColor whiteColor];
    self.ruleLabel.frame =  CGRectMake(15, 90*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    [self addSubview:self.ruleLabel];
    self.line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.ruleLabel.frame.origin.y+self.ruleLabel.frame.size.height+ 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0.5)];
    self.line1ImageView.backgroundColor = UIColorFromRGB(0xAAAAAA);
    
    
   
    [self addSubview:self.line1ImageView];
    titlle1 = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
   
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




@end
