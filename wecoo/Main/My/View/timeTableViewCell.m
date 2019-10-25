//
//  timeTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/27.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "timeTableViewCell.h"

@implementation timeTableViewCell

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

    [self.contentView addSubview:self.infoView];
    [self.infoView addSubview:self.lbDate];
    [self.infoView addSubview:self.lbdescription];
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
    }else{
        self.timeImageView.image  =[UIImage imageNamed:@"icon-timeAxis"];
    }
   
    return self.infoView.frame.origin.y + self.infoView.frame.size.height ;
}



-(UIImageView *)infoView{
    if (_infoView == nil) {
        self.infoView = [UIImageView new];
        self.infoView.frame = CGRectMake(30*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth-45*AUTO_SIZE_SCALE_X, 63*AUTO_SIZE_SCALE_X);
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"icon-timeAxisTxt"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(50*AUTO_SIZE_SCALE_X, 15, 5, 5)];
         self.infoView.image = backImage;
        
    }
    return _infoView;
}

- (UILabel *)lbdescription {
    if (_lbdescription == nil) {
        self.lbdescription = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.lbdescription.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, kScreenWidth-(30+15+20+23)*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
        self.lbdescription.textColor = RedUIColorC1;
    }
    return _lbdescription;
}

- (UILabel *)lbDate {
    if (_lbDate == nil) {
        self.lbDate = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.lbDate.textColor = FontUIColorGray;
        self.lbDate.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-(30+15+43)*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
    }
    return _lbDate;
}

- (UIImageView *)timeImageView {
    if (_timeImageView == nil) {
        self.timeImageView = [UIImageView new];
        
        self.timeImageView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X ,40*AUTO_SIZE_SCALE_X,15, 15);
        
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
