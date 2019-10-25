//
//  ClientTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientTableViewCell :  UITableViewCell{
    UIImageView *levelFlagImageview;
    UILabel *titleLabel;
    UIImageView *statusLabel;
    UILabel *subLabel;
}
@property (strong,nonatomic)NSDictionary *dictionary;
@property (strong,nonatomic)UIImageView *lineImageView;


@end
