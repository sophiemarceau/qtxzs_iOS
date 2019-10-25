//
//  CommissionNoteView.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommissionNoteView : UIView
@property (nonatomic, strong) UILabel  *ruleLabel;
@property (nonatomic, strong) UIImageView  *line1ImageView;
@property (nonatomic, strong) UILabel  *CommissionNoteLabel;
@property (nonatomic,strong)NSString *noteString;
-(void)showView;
@end
