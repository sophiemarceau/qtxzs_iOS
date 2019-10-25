//
//  ProgressTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@class ProgressModel;
@interface ProgressTableViewCell : UITableViewCell
//@property (strong, nonatomic)  UILabel *DateLabel; //日期
@property (strong, nonatomic)  WPHotspotLabel *descriptionLabel;  //描述
@property (strong, nonatomic)  UIImageView *infoView; //白色底的那个View
@property (strong, nonatomic)  UIImageView *timeImageView;  //时间轴
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  UIImageView *lineImageView1;
@property (strong, nonatomic)  UIImageView *lineImageView2;
@property (strong,nonatomic)ProgressModel *model;
@property (strong,nonatomic)NSDictionary *dictionary;
/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;

-(void)isHighLighted:(BOOL)isHigh;


-(void)lineimageviewSetIndexPath:(NSIndexPath *)indexPath withCount:(int)count;
@end
