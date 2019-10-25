//
//  ShowAnimationView.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAnimationView : UIView{
    UILabel *titlle1;
}
@property (nonatomic, strong) UILabel  *ruleLabel;
@property (nonatomic, strong) UIImageView  *line1ImageView;
@property (nonatomic, strong) UIImageView  *line2ImageView;
@property (nonatomic, strong) NSString  *dayString;
-(void)showView; 
@end
