//
//  PhotoCollectionViewCell.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/28.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

//懒加载创建数据
-(UIImageView *)photoV{
    if (_photoV == nil) {
        self.photoV = [[UIImageView alloc]initWithFrame:self.bounds];
        self.photoV.userInteractionEnabled = YES;
        [self.photoV setContentMode:UIViewContentModeScaleAspectFill];
        self.photoV.clipsToBounds = YES;
    }
    return _photoV;
}



-(UIImageView *)cancelImageView{

if (_cancelImageView == nil) {
    self.cancelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.photoV.frame.size.width-(5+18)*AUTO_SIZE_SCALE_X, (5)*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    self.cancelImageView.image =[UIImage imageNamed:@"icon-uploadimg-del"];
    self.cancelImageView.userInteractionEnabled = YES;
//    UIButton *cancel = [[UIButton alloc] init];
//    cancel.backgroundColor = [UIColor clearColor];
//    cancel.frame = CGRectMake(0, 0, 18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X);
}
return _cancelImageView;
}

//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {        
        [self.contentView addSubview:self.photoV];
        [self.photoV addSubview:self.cancelImageView];
        
    }
    return self;
}




@end
