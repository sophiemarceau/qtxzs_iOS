//
//  SharedcellTableViewCell.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedcellTableViewCell : UITableViewCell{
    UIImageView *levelFlagImageview;
    UILabel *titleLabel;
}
@property (strong,nonatomic)NSDictionary *dictionary;
@property (nonatomic,assign)int shareCountFlag;
@end
