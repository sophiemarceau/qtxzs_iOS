//
//  AlreadySignTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/7/14.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlreadySignTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)NSMutableDictionary *celldata;
-(void)insertData;
@end
