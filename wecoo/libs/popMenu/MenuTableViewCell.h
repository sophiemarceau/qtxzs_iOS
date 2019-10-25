//
//  MenuTableViewCell.h
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic,strong) MenuModel * menuModel;
@property (nonatomic,strong) UILabel * menuLabel;
@property (nonatomic,strong) UIImageView * menuLabelIcon;
@property (nonatomic,strong) UIButton * menuButton;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,assign)int indexpathrow;
@end
