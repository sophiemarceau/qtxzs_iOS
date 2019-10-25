//
//  alreadychecklistTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/5/27.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol alreadybuttonclickDelegate <NSObject>
-(void)alreadybuttononclick:(NSInteger)number WithID:(NSString *)iDstring WithReportString:(NSString *)reportstr;
@end
@interface alreadychecklistTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *desLabel;
@property(nonatomic,strong)UILabel *followrecordLabel;
@property(nonatomic,strong)UIImageView *followImageView;
@property(nonatomic,strong)UIView *followView;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UIImageView *PhoneImageView;
@property(nonatomic,strong)UIView *PhoneView;
@property(nonatomic,strong)UIImageView *lineImageView;
@property(nonatomic,strong)UIImageView *verticallineImageView;
@property(nonatomic,strong)UIView *bgView;
- (CGFloat)setCellHeight:(NSString *)strInfo;

@property (nonatomic,strong)NSMutableDictionary *celldata;

@property (weak, nonatomic) id<alreadybuttonclickDelegate> delegate;
@end
