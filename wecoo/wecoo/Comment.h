//
//  Comment.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/5/26.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#ifndef Wecoo_Comment_h
#define Wecoo_Comment_h

#define IS_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromFindRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.6]

#define APPNAME @"华佗驾到门店版"

#define SENDPASSWORD  @"huatuozx"


#define BGColorGray UIColorFromRGB(0xf4f4f4)
#define RedUIColorC1 UIColorFromRGB(0xe83e41)
#define C6UIColorGray UIColorFromRGB(0x747474)
#define C2UIColorGray UIColorFromRGB(0xededed)
#define FontUIColorGray UIColorFromRGB(0x666666)
#define FontUIColorBlack UIColorFromRGB(0x333333)
//#define RedUIColorC3 UIColorFromRGB(0xd83219)
//
//#define OrangeUIColorC4 UIColorFromRGB(0xf39517)
//
//#define BlackUIColorC5 UIColorFromRGB(0x1d1d1d)
//
//#define C5UIColorGray UIColorFromRGB(0xbfc4ca)
//
//
//
//#define C7UIColorGray UIColorFromRGB(0xc8c8c8)
//
//#define C8UIColorGray UIColorFromRGB(0xebebeb)
//#define UIColorBlackString UIColorFromRGB(0x282828)
//
//#define UIColorGrayString UIColorFromRGB(0x808080)
//
//#define UIColorBlueString UIColorFromRGB(0x006BD1)
//#define VIewBackGroundColor UIColorFromRGB(0xebebe5)
//
//#define UIColorBrownString UIColorFromRGB(0xC64300)
//
//#define UIColorfontString UIColorFromRGB(0xCA5D00)
//
//#define UIColorTextfieldString UIColorFromRGB(0xCC6D41)
//
//#define UIColorShihuangseString UIColorFromRGB(0xFCF7EF)
//
//#define UIColorSelected UIColorFromRGB(0x9c4e1f)
//
//#define UIColorNormal UIColorFromRGB(0xab9283)

#define WAITCODETIME 120


#define  BaseURLString  @"http://server.huatuojiadao.com/huatuo_server"//生产环境 .com

//#define  BaseURLString  @"http://server.huatuojiadao.cn/huatuo_server"//测试环境 8.11 .cn




#define UMENG_APPKEY @"56a1a05be0f55ae412001b1d"
#define   kTabHeight  49
#define   kNavHeight  64
#define   kHeightFor6s     668
#define   kWidthFor6s     375


#define   kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define   kScreenWidth   [UIScreen mainScreen].bounds.size.width

//#define   kHeight  ((IS_3_5_INCH_SCREEN)? 568:kScreenHeight)

#define AUTO_SIZE_SCALE_X (kScreenHeight != kHeightFor6s ? (kScreenWidth/kWidthFor6s) : 1.0)

#define   AUTO_SIZE_SCALE_Y (kScreenHeight != kHeightFor6s ? ((kScreenHeight-kNavHeight)/(kHeightFor6s-kNavHeight)) : 1.0)

#define   k_UIFont(font)  [UIFont systemFontOfSize:font]
#define   WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define    IsSucess(result) [[result objectForKey:@"Result"] boolValue]


#define    IsSucessCode(result)  [[result objectForKey:@"code"] isEqualToString:@"0000"]?TRUE:FALSE


#define  noIsKindOfNusll(result,key)   ![[(result) objectForKey:(key)] isKindOfClass:[NSNull class]]
//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt
#define kDateFormatTime @"yyyy-MM-dd hh:mm:ss"
#define kDateFormatDay @"yyyy-MM-dd"

//引入头文件

#import "UIViewExt.h"
#import "ZCControl.h"

#import "Toast+UIView.h"
#import "RequestManager.h"
#import "TTGlobalUICommon.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "UIView+ViewController.h"

#import "UIImage+fixOrientation.h"
#import "UILabel+StringFrame.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//设置是否调试模式
#define NDDEBUG 1

#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif

#define IS_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



#define kPersonalServiceCellHeight 108

//#define POST_key @"594f803b380a41396ed63dca39503542"//测试

#define POST_key @"1234567890" //正式

#define APPScheme @"huatuojiadaoiOS"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define navBtnHeight 44


#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

#define LAST_RUN_VERSION_KEY @"first_run_version_of_application"
#define  NOTIFICATION_NAME_USER_LOGOUT       @"userLogout" //退出登录

#define  NOTIFICATION_NAME_USER_UNLOGIN       @"unlogin" //未登录登录



#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#endif
