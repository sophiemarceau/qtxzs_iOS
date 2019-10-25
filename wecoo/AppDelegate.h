//
//  AppDelegate.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

static BOOL isProduction = NO;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;
-(void)onMain;
@end

