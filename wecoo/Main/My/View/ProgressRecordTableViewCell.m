//
//  ProgressRecordTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/26.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ProgressRecordTableViewCell.h"

@implementation ProgressRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView{
    [self.contentView addSubview:self.infoView];
    
    
    [self.infoView addSubview:self.lbdescription];
    [self.infoView addSubview:self.lbDate];
    [self.infoView addSubview:self.progressdesLabel];
    
    [self addSubview:self.timeImageView];
    }

- (CGFloat)setCellHeight:(NSString *)strInfo isHighLighted:(BOOL)isHigh isRedColor:(BOOL)isRed isZero:(BOOL)isZero isLastData:(BOOL)isLastData{
    
    CGFloat descheight =self.lbdescription.frame.size.height;
    [self.lbdescription setNumberOfLines:0];  //0行，则表示根据文本长度，自动增加行数
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    self.lbdescription.text =strInfo;
    [self.lbdescription sizeToFit];
    CGSize size  = CGSizeMake(self.lbdescription.frame.size.width, self.lbdescription.frame.size.height);
    
    descheight = descheight > size.height ? descheight : size.height;
    self.lbdescription.size = CGSizeMake(self.lbdescription.frame.size.width, descheight);
    
    
    self.lbDate.frame = CGRectMake(self.lbDate.frame.origin.x, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, self.lbDate.frame.size.width, self.lbDate.frame.size.height);
    self.progressdesLabel.frame = CGRectMake(self.progressdesLabel.frame.origin.x, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, self.progressdesLabel.frame.size.width, self.progressdesLabel.frame.size.height);
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                     self.infoView.frame.origin.y,
                                     self.infoView.frame.size.width,
                                     self.lbDate.frame.origin.y + self.lbDate.frame.size.height+15*AUTO_SIZE_SCALE_X);
    if (isRed) {
        self.lbdescription.textColor =RedUIColorC1;
    }else{
        self.lbdescription.textColor =FontUIColorGray;
    }
    if(isHigh){
        self.timeImageView.image = [UIImage imageNamed:@"icon-timeAxis-red"];
        self.timeImageView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X ,32*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    }else{
        self.timeImageView.image  =[UIImage imageNamed:@"icon-timeAxis"];
        
        self.timeImageView.frame = CGRectMake(13*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X);
    }
    
    return self.infoView.frame.origin.y + self.infoView.frame.size.height ;
}

-(UIImageView *)infoView{
    if (_infoView == nil) {
        self.infoView = [UIImageView new];
        self.infoView.frame = CGRectMake(32*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, kScreenWidth-47*AUTO_SIZE_SCALE_X, 63*AUTO_SIZE_SCALE_X);
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"icon-timeAxisTxt"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(50*AUTO_SIZE_SCALE_X, 15, 5, 5)];
        self.infoView.image = backImage;
    }
    return _infoView;
}




- (UILabel *)lbDate {
    if (_lbDate == nil) {
        self.lbDate = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:11*AUTO_SIZE_SCALE_X];
        
        self.lbDate.textColor = FontUIColorGray;
        self.lbDate.frame = CGRectMake(25*AUTO_SIZE_SCALE_X+(kScreenWidth-(32+15+40)*AUTO_SIZE_SCALE_X)/2, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, (kScreenWidth-(32+15+40)*AUTO_SIZE_SCALE_X)/2, 10*AUTO_SIZE_SCALE_X);
    }
    return _lbDate;
}

- (UILabel *)lbdescription {
    if (_lbdescription == nil) {
        self.lbdescription = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.lbdescription.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, kScreenWidth-(30+15+20+23)*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
        self.lbdescription.textColor = RedUIColorC1;
    }
    return _lbdescription;
}

- (UILabel *)progressdesLabel {
    if (_progressdesLabel == nil) {
        self.progressdesLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.progressdesLabel.textColor = FontUIColorGray;
        self.progressdesLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, (kScreenWidth-(32+15+40)*AUTO_SIZE_SCALE_X)/2+20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
        
    }
    return _progressdesLabel;
}


- (UIImageView *)timeImageView {
    if (_timeImageView == nil) {
        self.timeImageView = [UIImageView new];
        
        
    }
    return _timeImageView;
}

- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineImageView;
}
@end
