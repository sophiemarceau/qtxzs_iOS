//
//  ClientTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ClientTableViewCell.h"

@implementation ClientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}


-(void)_initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *CellBgView = [UIView new];
    CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 138/2*AUTO_SIZE_SCALE_X);
    CellBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:CellBgView];
    
    
    levelFlagImageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    
    [CellBgView addSubview:levelFlagImageview];
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelFlagImageview.frame.size.width+levelFlagImageview.frame.origin.x+15*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 300*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = FontUIColorBlack;
    titleLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    
    [CellBgView addSubview:titleLabel];
    
    statusLabel = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-24*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X)];
    statusLabel.image = [UIImage imageNamed:@"icon-phone"];
    
    [CellBgView addSubview:statusLabel];
    
    
    subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 280*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.textColor = FontUIColorGray;
    subLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    [CellBgView addSubview:subLabel];
    //    subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    //    [NSString stringWithFormat:@"%@ %@",[data[indexPath.row] objectForKey:@"beInviterSalesman_date"],[data[indexPath.row] objectForKey:@"beInviterSalesman_describe"]];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height-1, kScreenWidth, 0.5)];
    self.lineImageView.backgroundColor = lineImageColor;
    [CellBgView addSubview:self.lineImageView];
    
}

-(void)setDictionary:(NSDictionary *)dictionary{
    levelFlagImageview.image = [UIImage imageNamed:@"icon-list-1"];
    levelFlagImageview.image = [UIImage imageNamed:@"icon-list-2"];
    levelFlagImageview.image = [UIImage imageNamed:@"icon-list-3"];
    titleLabel.text = @"张三 13681588610";
    subLabel.text = @"2016-12-12 活动：大家一起来赚钱";
    
    
    //        titleLabel.text = [NSString stringWithFormat:@"%@  %@",[dictionary[indexPath.row] objectForKey:@"us_nickname"],[dictionary[indexPath.row] objectForKey:@"us_tel"]];
    //        statusLabel.text =[dictionary objectForKey:@"beInviterSalesman_status"];
    //    NSString *subString =
    //    subLabel.text = [NSString stringWithFormat:@"%@",subString];
}


-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

@end
