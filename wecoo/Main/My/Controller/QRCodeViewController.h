//
//  QRCodeViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/1/12.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
@interface QRCodeViewController : BaseViewController
@property (nonatomic,strong)NSString *userPhoto;
@property (nonatomic,strong)NSString *nameString;
@property (nonatomic,strong)UIImageView *firstImageView;
@property (nonatomic,strong)UIImageView *userPhotoImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *desLabel;
@property (nonatomic,strong)UIButton *directButton;
@end
