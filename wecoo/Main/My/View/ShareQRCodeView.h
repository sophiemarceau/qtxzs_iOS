//
//  ShareQRCodeView.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2017/1/13.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareQRCodeView : UIView
@property (nonatomic, strong) UIView  *bgclickview;
@property (nonatomic, strong) UIImageView  *wechatImageView;
@property (nonatomic, strong) UILabel  *wechatLabel;

@property (nonatomic, strong) UIImageView  *wechatFriendImageView;
@property (nonatomic, strong) UILabel  *wechatFriendLebel;

@property (nonatomic, strong) UIImageView  *lineImageView;
@property (nonatomic,strong) UIView *cancelView;
@property (nonatomic,strong) UILabel *cancelLabel;


@property (nonatomic,strong) NSString *sharefrom;


@property (nonatomic,assign)int shareButtonNumber;

@property (nonatomic,assign)int shareFromFlag;
-(void)showView;
@end
