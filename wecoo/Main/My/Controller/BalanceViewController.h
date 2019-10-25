//
//  BalanceViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"

@interface BalanceViewController : BaseViewController
@property (nonatomic,strong)UIImageView *balanceImageView;
@property (nonatomic,strong)UILabel *balanceLabel;
@property (nonatomic,strong)UILabel *balanceNumLabel;
@property (nonatomic,strong)UIButton *applyButton;
@property (nonatomic,strong)UIImageView *applyrulesImageView;
@property (nonatomic,strong)UILabel *applyrulesLabel;
@property (nonatomic,strong)UIView *acountBgView;
@property (nonatomic,strong)UILabel *acountLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *subbalanceLabel;

@property (nonatomic,strong)NSMutableArray *mydata;



@end
