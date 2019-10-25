//
//  infoCellTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/4/24.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "infoCellTableViewCell.h"

@implementation infoCellTableViewCell

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
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (CGFloat)setCellHeight:(NSString *)strInfo {
    
//    self.messageTitle.text = [self.mydata objectForKey:@"msg_title"];
    CGFloat height = 0;
 
    
    self.platformTitleLabel.frame = CGRectMake(15, 10*AUTO_SIZE_SCALE_X, kScreenWidth/2-15, 45/2*AUTO_SIZE_SCALE_X);
    self.platformTitleLabel.text = [self.mydata objectForKey:@"projectName"];
    self.platformTimeLabel.frame = CGRectMake(15, self.platformTitleLabel.frame.origin.y+self.platformTitleLabel.frame.size.height+3*AUTO_SIZE_SCALE_X, kScreenWidth-30, 33/2*AUTO_SIZE_SCALE_X);
    self.platformTimeLabel.text = [self.mydata objectForKey:@"crl_createdtime"];
   
    self.checkLabel.text = [self.mydata objectForKey:@"reportStatusName"];
    self.checkLabel.frame = CGRectMake(kScreenWidth-15-80*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
    self.arrowImageView.frame = CGRectMake(kScreenWidth-15, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
    self.contentLabel.frame =CGRectMake(15, self.platformTimeLabel.frame.origin.y+self.platformTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30,0);
    self.contentLabel.text = [self.mydata objectForKey:@"crl_note"];
    [self.contentLabel sizeToFit];
    self.platformView.frame = CGRectMake(0, 0, kScreenWidth, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10*AUTO_SIZE_SCALE_X);
    height = self.platformView.frame.size.height+10*AUTO_SIZE_SCALE_X;
    
    return height;
}

-(void)_initView{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.self.platformView];
    [self.platformView addSubview:self.platformTitleLabel];
    [self.platformView addSubview:self.platformTimeLabel];
    [self.platformView addSubview:self.checkLabel];
    [self.platformView addSubview:self.arrowImageView];
    [self.platformView addSubview:self.contentLabel];
    [self.contentView addSubview:self.platformView];
}

- (UIView *)platformView {
    if (_platformView == nil) {
        self.platformView = [UIView new];
        self.platformView.backgroundColor = [UIColor whiteColor];
        
    }
    return _platformView;
}

- (UILabel *)platformTitleLabel {
    if (_platformTitleLabel == nil) {
        self.platformTitleLabel = [CommentMethod initLabelWithText:@"渠到天下" textAlignment:NSTextAlignmentLeft font:16*AUTO_SIZE_SCALE_X];
        self.platformTitleLabel.textColor = FontUIColorBlack;
    }
    return _platformTitleLabel;
}

- (UILabel *)platformTimeLabel {
    if (_platformTimeLabel == nil) {
        self.platformTimeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.platformTimeLabel.textColor = FontUIColorGray;
    }
    return _platformTimeLabel;
}

- (UILabel *)checkLabel {
    if (_checkLabel == nil) {
        self.checkLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.checkLabel.textColor = FontUIColorGray;
    }
    return _checkLabel;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        self.arrowImageView = [[UIImageView alloc] init];
        [self.arrowImageView setSize:CGSizeMake( 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
    }
    return _arrowImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.contentLabel.textColor = FontUIColorGray;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}

@end
