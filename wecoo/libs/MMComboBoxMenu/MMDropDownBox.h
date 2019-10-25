//
//  MMDropDownBox.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMDropDownBoxDelegate;
@interface MMDropDownBox : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isOnclick;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, weak) id<MMDropDownBoxDelegate> delegate;
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title;
- (void)updateTitleState:(BOOL)isSelected;
- (void)updateTitleContent:(NSString *)title;



- (void)updateIsSetting:(NSInteger )red8ndex;

- (void)updateArrowDirectionWithNowIndex:(NSInteger)nowindex WithRedIndex:(NSMutableArray *)redIndex;


- (void)updateIsSettingRed8ndex:(NSMutableArray *)red8ndex WithNowIndex:(NSInteger)nowindex;
- (void)onClickArrowDirectionWithNowIndex:(NSInteger)nowindex WithRedIndex:(NSInteger)redIndex;
- (void)respond:(UITapGestureRecognizer *)gesture ;
@end

@protocol MMDropDownBoxDelegate <NSObject>
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index;
@end
