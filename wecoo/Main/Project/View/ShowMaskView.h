//
//  ShowMaskView.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMaskView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel  *ruleLabel;
@property (nonatomic, strong) UIImageView  *line1ImageView;
@property (nonatomic, strong) UITableView  *signTableView;
@property (nonatomic, strong) NSMutableArray  *signArray;
-(void)showView;
@end
