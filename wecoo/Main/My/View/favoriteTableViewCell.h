//
//  favoriteTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/1.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface favoriteTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *pricelabel;
@property (nonatomic,strong)UILabel *numberlabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UIImageView *alreadyImageView;


@property (nonatomic,strong)NSMutableDictionary *celldata;
-(void)insertData;
@end
