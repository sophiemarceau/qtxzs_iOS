//
//  ShowShareView.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/21.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowShareView : UIView
@property (nonatomic, strong) UIView  *bgclickview;
@property (nonatomic, strong) UIImageView  *wechatImageView;
@property (nonatomic, strong) UILabel  *wechatLabel;
@property (nonatomic, strong) UIImageView  *lineImageView;
@property (nonatomic,strong) UIView *cancelView;
@property (nonatomic,strong) UILabel *cancelLabel;


@property (nonatomic,strong) NSString *sharefrom;
-(void)showView;
@end
