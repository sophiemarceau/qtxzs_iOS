//
//  VerifyView.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/4.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VerifyView : UIView
{
    
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel  *ruleLabel;
@property (nonatomic, strong) UILabel  *desLabel;
@property (nonatomic, strong) UIImageView  *line1ImageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *subButton;




@property (strong, nonatomic) NSString *infoString;
-(void)showView;

@end
