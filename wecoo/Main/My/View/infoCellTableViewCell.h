//
//  infoCellTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/4/24.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoCellTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *platformView;
@property (nonatomic,strong)UILabel *platformLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *platformTitleLabel;
@property (nonatomic,strong)UILabel *platformTimeLabel;
@property (nonatomic,strong)UILabel *checkLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)NSMutableDictionary *mydata;

- (CGFloat)setCellHeight:(NSString *)strInfo ;
@end
