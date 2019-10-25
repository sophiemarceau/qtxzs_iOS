//
//  ShowReviewView.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/11.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitView.h"

@interface ShowReviewView : UIView
@property (nonatomic, strong) UILabel  *ruleLabel;
@property (nonatomic, strong) UIImageView  *line1ImageView;
@property (nonatomic, strong) UILabel  *CommissionNoteLabel;
@property (nonatomic, strong) NSString *noteString;
@property (nonatomic, strong) UIImageView  *infoImageView;
@property (nonatomic, strong) SubmitView  *subview;


-(void)showView;

@end
