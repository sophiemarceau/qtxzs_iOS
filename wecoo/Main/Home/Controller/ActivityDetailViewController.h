//
//  ActivityDetailViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/1.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityDetailViewController : BaseViewController
@property(nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UIView *detailView;
@property (nonatomic,strong)UILabel *detailTitleLabel;
@property (nonatomic,strong)UIImageView *redImageView;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIButton *shareButton;

@property(nonatomic)int activity_id;
@end
