//
//  MyConnectTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/21.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyConnectTableViewCell.h"

@implementation MyConnectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"DetailTableViewCell";
    MyConnectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[MyConnectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
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
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelFlagImageview.frame.size.width+levelFlagImageview.frame.origin.x+8*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 300*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = FontUIColorBlack;
    titleLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];

    [CellBgView addSubview:titleLabel];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-150*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 150*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = RedUIColorC1;
    statusLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];

    [CellBgView addSubview:statusLabel];
    
    
    subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 280*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.textColor = FontUIColorGray;
    subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    [CellBgView addSubview:subLabel];
//    subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
//    [NSString stringWithFormat:@"%@ %@",[data[indexPath.row] objectForKey:@"beInviterSalesman_date"],[data[indexPath.row] objectForKey:@"beInviterSalesman_describe"]];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height-1, kScreenWidth, 0.5)];
    self.lineImageView.backgroundColor = lineImageColor;
    [CellBgView addSubview:self.lineImageView];

}

-(void)setDictionary:(NSDictionary *)dictionary{
    int levelflag = [[dictionary objectForKey:@"level"] intValue];
    if (levelflag == 1) {
        levelFlagImageview.image = [UIImage imageNamed:@"icon-list-1"];
    }
    if (levelflag == 2) {
         levelFlagImageview.image = [UIImage imageNamed:@"icon-list-2"];
    }
    if (levelflag == 3) {
        levelFlagImageview.image = [UIImage imageNamed:@"icon-list-3"];
    }
    if([self.celltype isEqualToString:@"income"]){
        titleLabel.text = [NSString stringWithFormat:@"%@  %@",[dictionary objectForKey:@"user_nickname"],[dictionary objectForKey:@"user_tel"]];
        subLabel.text =  [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"describe"]];
        statusLabel.text = [NSString stringWithFormat:@"+%@",[dictionary objectForKey:@"contribution_sum"]];
        return;
    }
    titleLabel.text = [NSString stringWithFormat:@"%@  %@",[dictionary objectForKey:@"user_nickname"],[dictionary objectForKey:@"user_tel"]];
    subLabel.text =  [NSString stringWithFormat:@"通过审核的推荐数为%d条",[[dictionary objectForKey:@"self_report_count"] intValue]];
    statusLabel.text = [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"self_contribution_sum"]];
}


-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}
@end
