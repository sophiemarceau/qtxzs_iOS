//
//  favoriteTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/1.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "favoriteTableViewCell.h"

@implementation favoriteTableViewCell

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
    [self.bgView addSubview:self.pricelabel];
    [self.bgView addSubview:self.numberlabel];
    [self.bgView addSubview:self.lineImageView];
    [self.bgView addSubview:self.alreadyImageView];
    
//    self.pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9*AUTO_SIZE_SCALE_X,0,0)];
//    [self returnlable:pricelabel WithString:@"673" Withindex:2 WithDocument:@"最高" WithDoc1:@"元"];
//    [transView addSubview:pricelabel];
//    
//    self.numberlabel = [[UILabel alloc] init];
//    [self returnlable::self.numberlabel WithString:@"5" Withindex:2 WithDocument:@"已成" WithDoc1:@"单"];
//    [numberlabel setFrame:CGRectMake(10*AUTO_SIZE_SCALE_X+pricelabel.frame.origin.x+pricelabel.frame.size.width, 9*AUTO_SIZE_SCALE_X+titlelabel.frame.size.height+titlelabel.frame.origin.y, numberlabel.width, numberlabel.height)];
//    [transView addSubview:numberlabel];
    
}

-(void)insertData{
    self.titleLabel.text = [self.celldata objectForKey:@"project_name"];
    self.subtitleLabel.text = [self.celldata objectForKey:@"project_slogan"];
    [self returnlable:self.pricelabel WithString:[NSString stringWithFormat:@"%d",[[self.celldata objectForKey:@"project_commission_second"] intValue]] Withindex:4 WithDocument:@"最高佣金" WithDoc1:@"元"];
    [self returnlable:self.numberlabel WithString:[NSString stringWithFormat:@"%d",[[self.celldata objectForKey:@"projectSignedCount"] intValue]] Withindex:2 WithDocument:@"成交" WithDoc1:@"单"];
    [self.numberlabel setFrame:CGRectMake(15+self.pricelabel.frame.origin.x+self.pricelabel.frame.size.width, 10*AUTO_SIZE_SCALE_X+self.subtitleLabel.frame.size.height+self.subtitleLabel.frame.origin.y, self.numberlabel.width, self.numberlabel.height)];
   ;
    if ( [[self.celldata objectForKey:@"project_status"] intValue]==1) {
        self.alreadyImageView.hidden = YES;
    }else{
        self.alreadyImageView.hidden = NO;
    }
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
        self.titleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorBlack;
        self.titleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.textColor = FontUIColorGray;
        self.subtitleLabel.frame = CGRectMake(15, self.titleLabel.origin.y+self.titleLabel.frame.size.height+7.5*AUTO_SIZE_SCALE_X, kScreenWidth-30, 12*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

- (UILabel *)pricelabel {
    if (_pricelabel == nil) {
        self.pricelabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.pricelabel.textColor = FontUIColorGray;

    }
    return _pricelabel;
}



- (UILabel *)numberlabel {
    if (_numberlabel == nil) {
        self.numberlabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.numberlabel.textColor = FontUIColorGray;
      
    }
    return _numberlabel;
}


- (UIView *)bgView {
    if (_bgView == nil) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.frame = CGRectMake(0 ,0,kScreenWidth, 107*AUTO_SIZE_SCALE_X);
    }
    return _bgView;
}


- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.frame = CGRectMake(15 ,self.bgView.frame.size.height-1,kScreenWidth-15, 0.5);
    }
    return _lineImageView;
}



- (UIImageView *)alreadyImageView {
    if (_alreadyImageView == nil) {
        self.alreadyImageView = [UIImageView new];
        self.alreadyImageView.image = [UIImage imageNamed:@"cover-projectOverdue"];
        self.alreadyImageView.frame = CGRectMake(kScreenWidth-15-77*AUTO_SIZE_SCALE_X ,23/2*AUTO_SIZE_SCALE_X,77*AUTO_SIZE_SCALE_X, 77*AUTO_SIZE_SCALE_X);
    }
    return _alreadyImageView;
}
@end
