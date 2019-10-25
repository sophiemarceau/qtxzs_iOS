//
//  withdrawprogressTableviewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/3.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
@interface withdrawprogressTableviewCell : UITableViewCell{
    NSDictionary* style3;
   
}
@property (strong, nonatomic)  UILabel *lbDate; //日期
@property (strong, nonatomic)  WPHotspotLabel *lbdescription;  //描述
@property (strong, nonatomic)  UIImageView *infoView; //白色底的那个View
@property (strong, nonatomic)  UIImageView *timeImageView;  //时间轴
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  NSDictionary *everyDic;
- (CGFloat)setCellHeight:(NSDictionary *)strInfo isHighLighted:(BOOL)isHigh isRedColor:(BOOL)isRed isZero:(BOOL)isZero isLastData:(BOOL)isLastData;






/**
 *  返回复用的HUserStatusCell
 *
 *  @param tableView 当前展示的tableView
 */
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView;



/**
 *  传入每一行cell数据，返回行高，提供接口
 *
 *  @param tableView 当前展示的tableView
 *  @param object cell的展示数据内容
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;
@end
