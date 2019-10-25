//
//  MyConnectTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/21.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyConnectTableViewCell : UITableViewCell{
    UIImageView *levelFlagImageview;
    UILabel *titleLabel;
    UILabel *statusLabel;
    UILabel *subLabel;
}
@property (strong,nonatomic)NSDictionary *dictionary;
@property (strong,nonatomic)UIImageView *lineImageView;


@property (strong,nonatomic)NSString *celltype;
@end
