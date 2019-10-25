//
//  checklistTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/5/27.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol buttonclickDelegate <NSObject>
-(void)buttononclick:(NSInteger)number WithID:(NSString *)iDstring WithReportString:(NSString *)reportstr WithProjectIDString:(NSString *)projectIDString;
@end
@interface checklistTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *desLabel;
@property(nonatomic,strong)UIImageView *lineImageView;

@property(nonatomic,strong)UIView *buttonView;
@property(nonatomic,strong)UILabel *followrecordLabel;
@property(nonatomic,strong)UIImageView *followImageView;
@property(nonatomic,strong)UIView *followView;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UIImageView *PhoneImageView;
@property(nonatomic,strong)UIView *PhoneView;
@property(nonatomic,strong)UIButton *quitButton;
@property(nonatomic,strong)UIButton *confirmPassButton;
@property(nonatomic,strong)UIView *bgView;






@property(nonatomic,strong)UILabel *followrecordLabel1;
@property(nonatomic,strong)UIImageView *followImageView1;
@property(nonatomic,strong)UIView *followView1;
@property(nonatomic,strong)UILabel *phoneLabel1;
@property(nonatomic,strong)UIImageView *PhoneImageView1;
@property(nonatomic,strong)UIView *PhoneView1;
@property(nonatomic,strong)UIImageView *lineImageView1;
@property(nonatomic,strong)UIImageView *verticallineImageView1;




@property (weak, nonatomic) id<buttonclickDelegate> delegate;
- (CGFloat)setCellHeight:(NSString *)strInfo withFlag:(int)listType;

@property (nonatomic,strong)NSMutableDictionary *celldata;
@end
