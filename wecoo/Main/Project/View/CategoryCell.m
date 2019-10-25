//
//  CategoryCell.m
//  BaiduCloudStorage
//
//  Created by 曾诗亮 on 2017/1/12.
//  Copyright © 2017年 zsl. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

//懒加载创建数据
-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-22*AUTO_SIZE_SCALE_X)/2, 16.5*AUTO_SIZE_SCALE_X,22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X)];
        
    }
    return _iconImageView;
}



-(UIImageView *)hotImageView{
    if (_hotImageView == nil) {
        self.hotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-33*AUTO_SIZE_SCALE_X, 0,33*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
        self.hotImageView.image =[UIImage imageNamed:@"icon_classification_hot"];
    }
    return _hotImageView;
}

- (UILabel *)namelabel {
    if (_namelabel == nil) {
        self.namelabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:13*AUTO_SIZE_SCALE_X];
        self.namelabel.textColor = UIColorFromRGB(0x333333);
        self.namelabel.frame = CGRectMake(0,48.5*AUTO_SIZE_SCALE_X ,self.frame.size.width, 18.5*AUTO_SIZE_SCALE_X);
//        self.namelabel.backgroundColor =[UIColor redColor];
    }
    return _namelabel;
}

//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.hotImageView];
        [self.contentView addSubview:self.namelabel];
    }
    return self;
}


@end
