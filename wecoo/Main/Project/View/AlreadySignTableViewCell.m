//
//  AlreadySignTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/7/14.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "AlreadySignTableViewCell.h"

@implementation AlreadySignTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.subtitleLabel];
    [self.bgView addSubview:self.lineImageView];
}

-(void)insertData{
    self.titleLabel.text = [NSString stringWithFormat:@"%@   %@",[self.celldata objectForKey:@"report_customer_name"],[self.celldata objectForKey:@"report_customer_tel"]];
    self.subtitleLabel.text =[NSString stringWithFormat:@"代理地区: %@",[self.celldata objectForKey:@"report_customer_area_agent_name"]];
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(int)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(mutablestr.length-1,1)];
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X]  range:NSMakeRange(mutablestr.length-1,1)];
    label.attributedText = mutablestr;
    [label sizeToFit];
    [label setFrame:CGRectMake(15, 10*AUTO_SIZE_SCALE_X+self.subtitleLabel.frame.size.height+self.subtitleLabel.frame.origin.y, label.frame.size.width, label.frame.size.height)];
    
    
    return label;
}


- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorBlack;
        self.titleLabel.frame = CGRectMake(15, 14*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.textColor = FontUIColorGray;
        self.subtitleLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+2*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.frame = CGRectMake(0 ,0,kScreenWidth, 70*AUTO_SIZE_SCALE_X);
    }
    return _bgView;
}

- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.frame = CGRectMake(15 ,self.bgView.frame.size.height-1,kScreenWidth-15, 0.5);
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


@end
