//
//  timeTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/27.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *lbDate; //日期
@property (strong, nonatomic)  UILabel *lbdescription;  //描述
@property (strong, nonatomic)  UIImageView *infoView; //白色底的那个View
@property (strong, nonatomic)  UIImageView *timeImageView;  //时间轴
@property (strong, nonatomic)  UIImageView *lineImageView;

- (CGFloat)setCellHeight:(NSString *)strInfo isHighLighted:(BOOL)isHigh isRedColor:(BOOL)isRed isZero:(BOOL)isZero isLastData:(BOOL)isLastData;


@end
