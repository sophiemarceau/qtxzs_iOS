//
//  MyConnectHeaderView.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/20.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "connectView.h"

@interface MyConnectHeaderView : UIView


@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UIImageView *levelImageView;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *LevelLabel;

@property(nonatomic,strong)UIImageView *horizonImageView;
@property(nonatomic,strong)UIImageView *verticalImageView;
@property(nonatomic,strong)connectView *moneyView;
@property(nonatomic,strong)connectView *inviteView;
@property(nonatomic,strong)connectView *reportView;
@property(nonatomic,strong)connectView *signView;



@property(nonatomic,strong)NSDictionary *dataDic;
@end
