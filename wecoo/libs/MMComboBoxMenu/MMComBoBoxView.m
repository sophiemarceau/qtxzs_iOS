//
//  MMComBoBoxView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMComBoBoxView.h"
#import "MMDropDownBox.h"
#import "MMHeader.h"
#import "MMBasePopupView.h"
#import "MMSelectedPath.h"

@interface MMComBoBoxView () <MMDropDownBoxDelegate,MMPopupViewDelegate>{
    NSInteger redindex;
    NSInteger nowIndex;
    
    NSMutableArray *redArray;
}
//@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *symbolArray;  //当成一个队列来标记那个弹出视图
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) MMBasePopupView *popupView;
@property (nonatomic, assign) NSInteger lastTapIndex;       //默认 -1
@property (nonatomic, assign) BOOL isAnimation;
@end

@implementation MMComBoBoxView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lastTapIndex = -1;
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.symbolArray = [NSMutableArray arrayWithCapacity:1];
        redArray = [NSMutableArray arrayWithCapacity:0];
        redindex =-1;
    }
    return self;
}


- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
      count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    
    CGFloat width = self.width/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            [item findTheTypeOfPopUpView];
            MMDropDownBox *dropBox = [[MMDropDownBox alloc] initWithFrame:CGRectMake(i*width, 0, width, self.height) titleName:item.title];
            dropBox.tag = i;
            dropBox.delegate = self;
            [self addSubview:dropBox];
            [self.dropDownBoxArray addObject:dropBox];
            [self.itemArray addObject:item];
        }
    }
    [self _addLine];
}

- (void)dimissPopView {
    if (self.popupView.superview) {
        [self.popupView dismissWithOutAnimation];
    }
}

#pragma mark - Private Method
- (void)_addLine {
    self.topLine = [CALayer layer];
    self.topLine.frame = CGRectMake(0, 0 , self.width, 1.0/scale);
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"].CGColor;
//    [self.layer addSublayer:self.topLine];
    
    self.bottomLine = [CALayer layer];
    self.bottomLine.frame = CGRectMake(0, self.height - 1.0/scale , self.width, 1.0/scale);
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"].CGColor;
    [self.layer addSublayer:self.bottomLine];
}
#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index {
    nowIndex = index;
    if (self.isAnimation == YES) return;
    
    
    //点击后先判断symbolArray有没有标示
    if (self.symbolArray.count) {
        for (int i = 0; i <self.dropDownBoxArray.count; i++) {
            MMDropDownBox *currentBox  = self.dropDownBoxArray[i];
            if (currentBox.isOnclick) {
                NSNumber *iNum = [NSNumber numberWithInt:i];
                NSLog(@"redarray----->%d",redArray.count);
                if ([redArray containsObject:iNum]) {
                    //红
                    currentBox.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
                    currentBox.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];

                }else{
                    currentBox.titleLabel.textColor = FontUIColorGray;
                    currentBox.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];

                }
                currentBox.isOnclick = !currentBox.isOnclick;
            }
//            if (i == index) {
//                MMDropDownBox *currentBox  = self.dropDownBoxArray[i];
//                [currentBox respond:nil];
//            }else{
//            
//            }
//            
//            
        }
        //移除 菜单
        MMBasePopupView * lastView = self.symbolArray[0];
        [lastView dismiss];
        [self.symbolArray removeAllObjects];
        
        
        
    }else{
        // 载入菜单
        for (int i = 0; i <self.dropDownBoxArray.count; i++) {
            if (i == index) {
                MMDropDownBox *currentBox  = self.dropDownBoxArray[i];
                [currentBox respond:nil];
            }else{
                
            }
   
        }
        self.isAnimation = YES;
        MMItem *item = self.itemArray[index];
        MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
        popupView.delegate = self;
        popupView.tag = index;
        self.popupView = popupView;
        [popupView popupViewFromSourceFrame:self.frame completion:^{
           self.isAnimation = NO;
        }];
        [self.symbolArray addObject:popupView];
    }
}

#pragma mark - MMPopupViewDelegate
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    nowIndex = index;
    MMItem *item = self.itemArray[index];
    if (item.displayType == MMPopupViewDisplayTypeMultilayer || item.displayType == MMPopupViewDisplayTypeNormal) {
        //拼接选择项
        NSMutableString *title = [NSMutableString string];
        for (int i = 0; i <array.count; i++) {
            MMSelectedPath *path = array[i];
            [title appendString:i?[NSString stringWithFormat:@";%@",[item findTitleBySelectedPath:path]]:[item findTitleBySelectedPath:path]];
        }
        MMDropDownBox *box = self.dropDownBoxArray[index];
        [box updateTitleContent:title];
    }; //筛选不做UI赋值操作 直接将item的路径回调回去就好了
    [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
        MMItem *firstItem = item.childrenNodes[path.firstPath];
        MMItem *SecondItem = item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
//        NSLog(@"当title为%@时，所选字段为 %@-----code----%@",firstItem.title,SecondItem.title,SecondItem.code);
        NSNumber *number = [NSNumber numberWithInteger:index];
        if ([firstItem.title isEqualToString:@"所在人脉"]) {
            
            if (![SecondItem.code isEqualToString:@""]) {
                
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        
        if ([firstItem.title isEqualToString:@"贡献类型"]) {
            if (![SecondItem.code isEqualToString:@"1"]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        
        if ([firstItem.title isEqualToString:@"贡献赏金（元）"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        if ([firstItem.title isEqualToString:@"贡献邀请人数"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        if ([firstItem.title isEqualToString:@"贡献通过推荐数"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        if ([firstItem.title isEqualToString:@"贡献签约数"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        if ([firstItem.title isEqualToString:@"注册时间"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }

        }
        if ([firstItem.title isEqualToString:@"赏金类型"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
            
        }
        if ([firstItem.title isEqualToString:@"赏金时间"]) {
            if (![SecondItem.code isEqualToString:@""]) {
                redindex = index;
                if (![redArray containsObject:number]) {
                    [redArray addObject:number];
                }
                
                
            }else{
                if ([redArray containsObject:number]) {
                    [redArray removeObject:number];
                }
                
                
            }
        }
        
           
    }];
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate comBoBoxView:self didSelectedItemsPackagingInArray:array atIndex:index];
    }
    
//    if ([redArray containsObject:[NSNumber numberWithInteger:index]]) {
//        NSLog(@"redindex---------->true");
//    }
//    
//    NSLog(@"redindex---------->%ld",(long)redindex);
}

//- (void)popupViewWillDismiss:(MMBasePopupView *)popupView {
//  [self.symbolArray removeAllObjects];
////   for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
////        [currentBox updateTitleState:NO];
////    }
//
//}


- (void)popupViewWillDismiss:(MMBasePopupView *)popupView WithIndex:(NSString *)index {
    [self.symbolArray removeAllObjects];
    //   for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
    //        [currentBox updateTitleState:NO];
    //    }
    if([index isEqualToString:@""]){
        for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
            [currentBox updateArrowDirectionWithNowIndex:nowIndex WithRedIndex:redArray];
        }
        return;
    }
    
    for (MMDropDownBox *currentBox in self.dropDownBoxArray) {

        [currentBox updateIsSettingRed8ndex:redArray WithNowIndex:nowIndex];

    }
}
@end
