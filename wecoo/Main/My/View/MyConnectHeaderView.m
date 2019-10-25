//
//  MyConnectHeaderView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/20.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyConnectHeaderView.h"

@implementation MyConnectHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.NameLabel];
        
        [self addSubview:self.levelImageView];
        [self.levelImageView addSubview:self.LevelLabel];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.moneyView];
        [self addSubview:self.reportView];
        [self addSubview:self.inviteView];
        [self addSubview:self.signView];
        [self addSubview:self.horizonImageView];
        [self addSubview:self.verticalImageView];
        
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    self.phoneLabel.text = [dataDic objectForKey:@"user_tel"];
    self.NameLabel.text = [dataDic objectForKey:@"user_nickname"];
    
    self.NameLabel.frame = CGRectMake(15, 15, 0, 10*AUTO_SIZE_SCALE_X);
    [self.NameLabel sizeToFit];
    self.levelImageView.frame = CGRectMake(self.NameLabel.frame.origin.x+self.NameLabel.frame.size.width+15*AUTO_SIZE_SCALE_X, 25/2*AUTO_SIZE_SCALE_X, 124/2*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X);
    self.LevelLabel.frame = CGRectMake(0, 0, 124/2*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X);
    self.phoneLabel.frame = CGRectMake(15, self.NameLabel.frame.origin.y+self.NameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 10*AUTO_SIZE_SCALE_X);
    self.moneyView.frame = CGRectMake(0, self.phoneLabel.frame.origin.y+self.phoneLabel.frame.size.height+16*AUTO_SIZE_SCALE_X, kScreenWidth/2, 335/4*AUTO_SIZE_SCALE_X);
    self.inviteView.frame = CGRectMake(kScreenWidth/2, self.phoneLabel.frame.origin.y+self.phoneLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, kScreenWidth/2, 335/4*AUTO_SIZE_SCALE_X);
    
    self.reportView.frame = CGRectMake(0, self.moneyView.frame.origin.y+self.moneyView.frame.size.height, kScreenWidth/2, 335/4*AUTO_SIZE_SCALE_X);
    self.signView.frame = CGRectMake(kScreenWidth/2, self.moneyView.frame.origin.y+self.moneyView.frame.size.height, kScreenWidth/2, 335/4*AUTO_SIZE_SCALE_X);
    self.horizonImageView.frame = CGRectMake(0, self.moneyView.frame.origin.y+self.moneyView.frame.size.height-1, kScreenWidth, 0.5);
    self.verticalImageView.frame = CGRectMake(kScreenWidth/2, self.phoneLabel.frame.origin.y+self.phoneLabel.frame.size.height+15*AUTO_SIZE_SCALE_X-1, 0.5, self.moneyView.frame.size.height+self.reportView.frame.size.height);
    
    [self returnlable:self.moneyView.firstlabel WithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sil_self_contribution_sum"]]  Withindex:[@"本人赏金:" length] WithDocument:@"本人赏金:" WithDoc1:@""];
    [self returnlable:self.moneyView.secondlabel WithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sil_total_contribution_sum"]]  Withindex:[@"累计赏金:" length] WithDocument:@"累计赏金:" WithDoc1:@""];
    [self returnlable:self.inviteView.firstlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_self_invitation_count"] intValue]] Withindex:[@"本人邀请:" length] WithDocument:@"本人邀请:" WithDoc1:@""];
    [self returnlable:self.inviteView.secondlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_total_invitation_count"] intValue]] Withindex:[@"累计邀请:" length] WithDocument:@"累计邀请:" WithDoc1:@""];
    [self returnlable:self.reportView.firstlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_self_report_count"] intValue]] Withindex:[@"本人推荐:" length] WithDocument:@"本人推荐:" WithDoc1:@""];
    [self returnlable:self.reportView.secondlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_total_report_count"] intValue]] Withindex:[@"累计推荐:" length] WithDocument:@"累计推荐:" WithDoc1:@""];
    [self returnlable:self.signView.firstlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_self_signedup_count"] intValue]] Withindex:[@"本人签约:" length] WithDocument:@"本人签约:" WithDoc1:@""];
    [self returnlable:self.signView.secondlabel WithString:[NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"sil_total_signedup_count"] intValue]] Withindex:[@"本人签约:" length] WithDocument:@"累计签约:" WithDoc1:@""];
    
    int levelflag = [[dataDic objectForKey:@"level"] intValue];
    if (levelflag == 1) {
        self.levelImageView.backgroundColor = RedUIColorC1;
        self.LevelLabel.text = @"一级人脉";
    }
    if (levelflag == 2) {
        self.levelImageView.backgroundColor = UIColorFromRGB(0xffbb50);
        self.LevelLabel.text = @"二级人脉";
    }
    if (levelflag == 3) {
        self.levelImageView.backgroundColor = UIColorFromRGB(0x5cb6ea);
        self.LevelLabel.text = @"三级人脉";
    }
}


- (UIImageView *)levelImageView {
    if (_levelImageView == nil) {
        self.levelImageView = [UIImageView new];
        self.levelImageView.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        //        self.iconImageView.layer.borderWidth=1.0;
        //        self.iconImageView.layer.masksToBounds = YES;
        //        self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return _levelImageView;
}

- (UILabel *)NameLabel {
    if (_NameLabel == nil) {
        self.NameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.NameLabel.numberOfLines = 1;
        self.NameLabel.textColor = FontUIColorBlack;
        
    }
    return _NameLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.phoneLabel.textColor = FontUIColorBlack;
    }
    return _phoneLabel;
}

- (connectView *) moneyView{
    if (_moneyView == nil) {
        self.moneyView = [connectView new];
        self.moneyView.backgroundColor = [UIColor whiteColor];
        self.moneyView.iconImageView.image = [UIImage imageNamed:@"self-Reward"];
        
    }
    return _moneyView;
}

- (connectView *) inviteView{
    if (_inviteView == nil) {
        self.inviteView = [connectView new];
        self.inviteView.backgroundColor = [UIColor whiteColor];
        self.inviteView.iconImageView.image = [UIImage imageNamed:@"self-Invitation"];
        
    }
    return _inviteView;
}
- (connectView *) reportView{
    if (_reportView == nil) {
        self.reportView = [connectView new];
        self.reportView.backgroundColor = [UIColor whiteColor];
        self.reportView.iconImageView.image = [UIImage imageNamed:@"self-Report"];
        
    }
    return _reportView;
}
- (connectView *) signView{
    if (_signView == nil) {
        self.signView = [connectView new];
        self.signView.backgroundColor = [UIColor whiteColor];
        self.signView.iconImageView.image = [UIImage imageNamed:@"self-Sign"];
        
    }
    return _signView;
}

- (UIImageView *)horizonImageView {
    if (_horizonImageView == nil) {
        self.horizonImageView = [UIImageView new];
        self.horizonImageView.backgroundColor = lineImageColor;
        
    }
    return _horizonImageView;
}
- (UIImageView *)verticalImageView {
    if (_verticalImageView == nil) {
        self.verticalImageView = [UIImageView new];
        self.verticalImageView.backgroundColor = lineImageColor;
        
    }
    return _verticalImageView;
}

- (UILabel *)LevelLabel {
    if (_LevelLabel == nil) {
        self.LevelLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.LevelLabel.numberOfLines = 1;
        self.LevelLabel.textColor = [UIColor whiteColor];
        
    }
    return _LevelLabel;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 1;
    
    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}

@end
