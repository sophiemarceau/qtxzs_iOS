//
//  ConnectViewAttentionViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "PlaceholderTextView.h"

@interface ConnectViewAttentionViewController : BaseViewController
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)PlaceholderTextView *complainLabel;
@property (nonatomic,strong)UILabel *attentionLabel;
@property (nonatomic,strong)UIButton *submitButton;
@end
