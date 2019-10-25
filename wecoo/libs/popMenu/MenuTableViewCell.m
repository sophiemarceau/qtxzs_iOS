//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell {
    UIButton *btnNormal;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

   
    [self addSubview:self.lineView];
    [self addSubview:self.menuLabel];
    [self addSubview:self.menuLabelIcon];

    self.backgroundColor = [UIColor clearColor];
    
//    
//    self.textLabel.font = [UIFont systemFontOfSize:14];
//    self.textLabel.textColor = [UIColor blackColor];
    
    btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnNormal setFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    
    [btnNormal addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnNormal];

}

-(void)setTag:(NSInteger)tag{
    btnNormal.tag = tag;
//    NSLog(@"btnNormal----------tag------%ld",btnNormal.tag);

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(15, self.bounds.size.height - 1, self.bounds.size.width - 30, 0.5);
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
//    self.imageView.image = [UIImage imageNamed:menuModel.imageName];
//    self.textLabel.text = menuModel.itemName;
    self.menuLabel.text = menuModel.itemName;
    
}

-(UIImageView *)menuLabelIcon{
    if (_menuLabelIcon == nil) {
        self.menuLabelIcon = [UIImageView new];
        self.menuLabelIcon.userInteractionEnabled = YES;
        self.menuLabelIcon.image =[UIImage imageNamed:@"icon-sort-way-gray-1"];
        self.menuLabelIcon.frame = CGRectMake(self.menuLabel.frame.origin.x+self.menuLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 15, 10*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
    }
    return _menuLabelIcon;
}

-(UILabel *)menuLabel{
    if (_menuLabel == nil) {
        self.menuLabel = [UILabel new];
        self.menuLabel.userInteractionEnabled = YES;
        self.menuLabel.frame = CGRectMake(15, 15, 55*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
        self.menuLabel.textColor = [UIColor grayColor];
        self.menuLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        self.menuLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _menuLabel;
}

- (void)touchBtn: (id)sender {
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        self.menuLabelIcon.image = [UIImage imageNamed:@"icon-sort-way-2"] ;
    }else{
        self.menuLabelIcon.image = [UIImage imageNamed:@"icon-sort-way-1"] ;
//        self.menuLabel.textColor = FontUIColorGray;
    }
    self.menuLabel.textColor = RedUIColorC1;
    NSDictionary *dic = @{
                          @"indexpath":[NSString stringWithFormat:@"%d",self.indexpathrow],
                          @"modelentity":self.menuModel,
                          @"IsSelectFlag":[NSString stringWithFormat:@"%d",button.selected+1],
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:kPostMenuSorted object:dic];
}

//-(UIButton *)menuButton{
//    if (_menuButton == nil) {
//        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.menuButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
////        [self.menuButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _menuButton;
//}
//
//-(void)menuButtonPressed:(UIButton *)sender{
//    
//    
////    if (self.itemsClickBlock) {
////        self.itemsClickBlock(model.itemName,indexPath.row +1);
////    }
//}
-(UIView *)lineView{
    if (_lineView == nil) {
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end
