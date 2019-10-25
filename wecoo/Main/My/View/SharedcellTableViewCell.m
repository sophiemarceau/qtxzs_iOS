//
//  SharedcellTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SharedcellTableViewCell.h"

@implementation SharedcellTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"sharedcell";
    SharedcellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[SharedcellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self _initView];
    }
    return self;
}

-(void)_initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    levelFlagImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:levelFlagImageview];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = FontUIColorBlack;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:10*AUTO_SIZE_SCALE_X];
   [self.contentView addSubview:titleLabel];
}

-(void)setDictionary:(NSDictionary *)dictionary{
    levelFlagImageview.image = [UIImage imageNamed:[dictionary objectForKey:@"icon-image"]];
    titleLabel.text = [dictionary objectForKey:@"value"];
}

-(void)setShareCountFlag:(int)shareCountFlag{
    if (shareCountFlag == 5) {
        levelFlagImageview.frame = CGRectMake(27*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X);
        titleLabel.frame = CGRectMake(27*AUTO_SIZE_SCALE_X, levelFlagImageview.frame.size.height+levelFlagImageview.frame.origin.y+20*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    }else{
        levelFlagImageview.frame = CGRectMake((kScreenWidth/4-53*AUTO_SIZE_SCALE_X)/2, 35*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X);
        titleLabel.frame = CGRectMake((kScreenWidth/4-53*AUTO_SIZE_SCALE_X)/2, levelFlagImageview.frame.size.height+levelFlagImageview.frame.origin.y+20*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    }
}

@end
