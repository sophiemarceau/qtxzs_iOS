//
//  MMHeader.h
//  MMPhotoView
//
//  Created by wyy on 16/11/10.
//  Copyright © 2016年 yyx. All rights reserved.
//

#ifndef MMHeader_h
#define MMHeader_h
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define scale [UIScreen mainScreen].scale
#define RedUIColorC1     UIColorFromRGB(0xe83e41)
#define FontUIColorGray  UIColorFromRGB(0x666666)
#define FontUIColorBlack UIColorFromRGB(0x333333)
#define lineImageColor   UIColorFromRGB(0xdddddd)
static  NSString *titleSelectedColor = @"e83e41";
//static const CGFloat  ButtonFontSize = 14.0f;
////MMPopupView
//static const CGFloat PopupViewRowHeight = 44.0f;
//static const CGFloat DistanceBeteewnPopupViewAndBottom =80.0f;
//static const CGFloat PopupViewTabBarHeight = 40.0f;
//static const CGFloat LeftCellHorizontalMargin = 20.0f;
//static const CGFloat LeftCellWidth = 100.0f;
//static const CGFloat ShadowAlpha = .5;
////static const CGFloat
//static  NSString *MainCellID = @"MainCellID";
//static  NSString *SubCellID = @"SubCellID";
//static const NSTimeInterval AnimationDuration= .25;
//static const CGFloat ButtonHorizontalMargin = 10.0f;
//
///* fontSize*/
//static const CGFloat MainTitleFontSize = 13.0f;
//static const CGFloat SubTitleFontSize = 12.0f;
///* color */
//static  NSString *SelectedBGColor = @"F2F2F2";
//static  NSString *UnselectedBGColor = @"FFFFFF";
////MMComBoBoxView
//
////MMCombinationFitlerView
//static const CGFloat AlternativeTitleVerticalMargin = 10.0f;
//static const CGFloat AlternativeTitleHeight = 31.0f;
//static const CGFloat zeroHeight = 0.0f;
//static const CGFloat TitleVerticalMargin = 10.0f;
//static const CGFloat TitleHeight  = 20.0f;
//
//static const CGFloat ItemHeight  = 25.0f;
//static const CGFloat ItemWidth  = 80.0f*AUTO_SIZE_SCALE_X;
//static const CGFloat ItemHorizontalMargin = 13.0f;
//static const CGFloat ItemHorizontalDistance = 10.0f;
////MMDropDownBox
//static const CGFloat DropDownBoxFontSize = 12.0f;
//static const CGFloat ArrowSide = 11.0f;
//static const CGFloat Arrowheight = 5.0f;
//static const CGFloat ArrowToRight = 38.0f;
//static const CGFloat DropDownBoxTitleHorizontalToArrow = 10.0f;
//static const CGFloat DropDownBoxTitleHorizontalToLeft  = 38.0;
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define   ButtonFontSize 14.0f*AUTO_SIZE_SCALE_X
//MMPopupView
#define PopupViewRowHeight  44.0f*AUTO_SIZE_SCALE_X
#define DistanceBeteewnPopupViewAndBottom 80.0f*AUTO_SIZE_SCALE_X
#define PopupViewTabBarHeight  40.0f*AUTO_SIZE_SCALE_X
#define LeftCellHorizontalMargin  20.0f*AUTO_SIZE_SCALE_X
#define LeftCellWidth  100.0f*AUTO_SIZE_SCALE_X
#define ShadowAlpha  .5*AUTO_SIZE_SCALE_X
//static const CGFloat
static  NSString *MainCellID = @"MainCellID";
static  NSString *SubCellID = @"SubCellID";
#define AnimationDuration .25*AUTO_SIZE_SCALE_X
#define ButtonHorizontalMargin  10.0f*AUTO_SIZE_SCALE_X

/* fontSize*/
#define MainTitleFontSize  13.0f*AUTO_SIZE_SCALE_X
#define SubTitleFontSize  12.0f*AUTO_SIZE_SCALE_X
/* color */
static  NSString *SelectedBGColor = @"F2F2F2";
static  NSString *UnselectedBGColor = @"FFFFFF";
//MMComBoBoxView

//MMCombinationFitlerView
#define AlternativeTitleVerticalMargin  10.0f*AUTO_SIZE_SCALE_X
#define AlternativeTitleHeight  31.0f*AUTO_SIZE_SCALE_X
#define zeroHeight  0.0f
#define TitleVerticalMargin  10.0f*AUTO_SIZE_SCALE_X
#define TitleHeight   20.0f*AUTO_SIZE_SCALE_X

#define ItemHeight  25.0f*AUTO_SIZE_SCALE_X
#define  ItemWidth   80.0f*AUTO_SIZE_SCALE_X
#define ItemHorizontalMargin  10.0f*AUTO_SIZE_SCALE_X
#define ItemHorizontalDistance  6*AUTO_SIZE_SCALE_X
//MMDropDownBox
#define DropDownBoxFontSize  12.0f*AUTO_SIZE_SCALE_X
#define ArrowSide  11.0f*AUTO_SIZE_SCALE_X
#define Arrowheight  5.0f*AUTO_SIZE_SCALE_X
#define ArrowToRight  38.0f*AUTO_SIZE_SCALE_X
#define DropDownBoxTitleHorizontalToArrow  10.0f*AUTO_SIZE_SCALE_X
#define DropDownBoxTitleHorizontalToLeft   38.0*AUTO_SIZE_SCALE_X

#endif /* MMHeader_h */
