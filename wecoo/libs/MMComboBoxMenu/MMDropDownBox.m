//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMHeader.h"
@interface MMDropDownBox (){
    }

@property (nonatomic, strong) CAGradientLayer *line;
@end

@implementation MMDropDownBox
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.isSelected = NO;
        self.userInteractionEnabled = YES;
        self.isOnclick = NO;
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        
        //add subView
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-arrow-down"]];
        self.arrow.frame = CGRectMake(self.width - ArrowSide - ArrowToRight,(self.height - Arrowheight)/2  , ArrowSide , Arrowheight);
        [self addSubview:self.arrow];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:DropDownBoxFontSize];
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = FontUIColorGray;
        self.titleLabel.frame = CGRectMake(DropDownBoxTitleHorizontalToLeft, 0 ,self.arrow.left - DropDownBoxTitleHorizontalToArrow - DropDownBoxTitleHorizontalToLeft  , self.height);
        [self addSubview:self.titleLabel];
        
        UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
        UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
        NSArray *colors = @[(id)[UIColor colorWithHexString:@"e8e8e8"].CGColor,(id)[UIColor colorWithHexString:@"e8e8e8"].CGColor, (id)[UIColor colorWithHexString:@"e8e8e8"].CGColor];
//  @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
        NSArray *locations = @[@1.0, @1.0, @1.0];
//  @[@0.2, @0.5, @0.8];
        self.line = [CAGradientLayer layer];
        self.line.colors = colors;
        self.line.locations = locations;
        self.line.startPoint = CGPointMake(0, 0);
        self.line.endPoint = CGPointMake(0, 1);
        self.line.frame = CGRectMake(self.arrow.right + ArrowToRight - 1.0/scale , 0, 1.0/scale, self.height);
        [self.layer addSublayer:self.line];
    }
    return self;

}

- (void)updateTitleState:(BOOL)isSelected {
    if (isSelected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
        self.arrow.image = [UIImage imageNamed:@"icon-arrow-up-red"];
    } else{
//        self.titleLabel.textColor = FontUIColorGray;
//        self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
    }
}

- (void)updateTitleContent:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture {
//    self.isOnclick = !self.isOnclick;
//    if (self.isOnclick) {
//        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
//        self.arrow.image = [UIImage imageNamed:@"icon-arrow-up-red"];
//    
//    }else{
//        self.titleLabel.textColor = FontUIColorGray;
//        self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
//    }
//    else{
//        self.titleLabel.textColor = FontUIColorGray;
//        self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];

//    }
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}

- (void)updateIsSetting:(NSInteger )red8ndex{
    
    if(self.tag == (NSInteger)red8ndex){
        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
        self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
    }else{
        if (self.isOnclick) {
            self.isOnclick = !self.isOnclick;
            self.titleLabel.textColor = FontUIColorGray;
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
        }
    }
    
}

- (void)updateIsSettingRed8ndex:(NSMutableArray * )red8ndex WithNowIndex:(NSInteger)nowindex{
    NSNumber *tagNum = [NSNumber numberWithInteger:self.tag];
    if(self.tag == (NSInteger)nowindex){
        if([red8ndex containsObject:tagNum]){
            self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
        }else{
            
            self.titleLabel.textColor = FontUIColorGray;
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
        }
        self.isOnclick = !self.isOnclick;
    }else{
        if ([red8ndex containsObject:tagNum]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
        }else{
            
        }
    }

}



-(void)updateArrowDirectionWithNowIndex:(NSInteger)nowindex WithRedIndex:(NSMutableArray *)redIndex{
    NSNumber *tagNum = [NSNumber numberWithInteger:self.tag];
    if(self.tag == (NSInteger)nowindex){
        if(redIndex.count == 0){
            self.titleLabel.textColor = FontUIColorGray;
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
            self.isOnclick = !self.isOnclick;

            return;
        }
        if ([redIndex containsObject:tagNum]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
            self.isOnclick = !self.isOnclick;

        }else{
            self.titleLabel.textColor = FontUIColorGray;
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
            self.isOnclick = !self.isOnclick;
        }
    }else{
        if ([redIndex containsObject:tagNum]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
            self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
        }
    }
    
}




-(void)onClickArrowDirectionWithNowIndex:(NSInteger)nowindex WithRedIndex:(NSInteger)redIndex{
//    if(self.tag == (NSInteger)nowindex){
//        if(self.isOnclick){
////                        self.isOnclick = !self.isOnclick;
//        }
//    }else{
//        if(self.isOnclick){
//            if (self.tag == redIndex) {
//                self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
//                self.arrow.image = [UIImage imageNamed:@"icon-arrow-down-active"];
//            }else{
//                self.titleLabel.textColor = FontUIColorGray;
//                self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
//            }
////            self.isOnclick = !self.isOnclick;
//        }
//        
//    }
    
}


- (void)respond:(UITapGestureRecognizer *)gesture {
    self.isOnclick = !self.isOnclick;
    if (self.isOnclick) {
        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
        self.arrow.image = [UIImage imageNamed:@"icon-arrow-up-red"];
        
    }else{
        self.titleLabel.textColor = FontUIColorGray;
        self.arrow.image = [UIImage imageNamed:@"icon-arrow-down"];
    }

}
@end
