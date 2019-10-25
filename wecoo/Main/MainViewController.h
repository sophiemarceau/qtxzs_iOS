//
//  MainViewController.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright (c) 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController
@property (nonatomic,strong) UIImageView *tabbarView;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSMutableArray *imvArray;
@property (nonatomic, retain) NSMutableArray *labelArray;
- (void)selectorAction:(UIButton *)butt;
@end
