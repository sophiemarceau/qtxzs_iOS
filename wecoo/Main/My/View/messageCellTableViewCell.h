//
//  messageCellTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/31.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageCellTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *messageDate; //日期
@property (strong, nonatomic)  UIView *messageView; //日期
@property (strong, nonatomic)  UILabel *messageTitle;  //描述
@property (strong, nonatomic)  UILabel *messageDescLabel; //白色底的那个View
@property (strong, nonatomic)  UIImageView *lineImageView;  //时间轴
@property (strong, nonatomic)  UIView *bgView;
@property (strong, nonatomic)  UILabel  *clickLabel;
@property (strong, nonatomic)  UIImageView *arrowImageView;
@property (strong, nonatomic)  UIButton *clickView;

@property (nonatomic,strong)NSMutableDictionary *mydata;

- (CGFloat)setCellHeight:(NSString *)strInfo ;
@end
