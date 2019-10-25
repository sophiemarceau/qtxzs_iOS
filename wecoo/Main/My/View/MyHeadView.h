//
//  MyHeadView.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/24.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyHeadView : UIView
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIImageView *messageImageView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *PhoneLabel;
@property(nonatomic,strong)UILabel *clientMangeLabel;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UILabel *balanceContent;
@property(nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,strong)UILabel *efficiencyContent;
@property(nonatomic,strong)UILabel *efficiencyLabel;
@property(nonatomic,strong)UIImageView *arrowverticalImageView;
@property(nonatomic,strong)UIView *balanceView;
@property(nonatomic,strong)UIView *efficiencyView;
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIView *manageView;
@property(nonatomic,strong)NSDictionary *data;//接收数据的字典
@end
