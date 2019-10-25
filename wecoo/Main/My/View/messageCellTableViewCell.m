//
//  messageCellTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/31.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "messageCellTableViewCell.h"
#import "timelineViewController.h"

// 20  45 的点击  41的title高
@implementation messageCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (CGFloat)setCellHeight:(NSString *)strInfo {
    self.messageDate.text = [self.mydata objectForKey:@"msg_createdtime"];
    self.messageTitle.text = [self.mydata objectForKey:@"msg_title"];
    CGFloat height = 0;
     self.messageDescLabel.frame =CGRectMake(12, self.messageTitle.frame.origin.y+self.messageTitle.frame.size.height, self.bgView.frame.size.width-24,0);
    [self.messageDescLabel setNumberOfLines:0];
    self.messageDescLabel.text =[self.mydata objectForKey:@"msg_content"] ;
    [self.messageDescLabel sizeToFit];
    
    //msg_pageflag 0 无跳转 1 跳转至报备进度 2跳转到账户明细
    if ( [[self.mydata objectForKey:@"msg_page_to"] isEqualToString:@"0"]) {
        self.lineImageView.hidden = YES;
        self.clickLabel.hidden =YES;
        self.arrowImageView.hidden = YES;
        self.clickView.frame = CGRectMake(0, 0, 0, 0);
        //if([[self.mydata objectForKey:@"msg_pageflag"] isEqualToString:@"1"])
    }else {
        self.lineImageView.frame = CGRectMake(0, self.messageDescLabel.frame.origin.y+self.messageDescLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, self.bgView.frame.size.width, 0.5f);
        self.clickLabel.hidden =NO;
        self.arrowImageView.hidden = NO;
        self.clickView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, self.clickView.frame.size.width, self.clickLabel.frame.size.height);
    }
    self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.messageDescLabel.frame.size.height+self.messageTitle.frame.size.height+self.clickView.frame.size.height+15*AUTO_SIZE_SCALE_X);
    height = self.messageView.frame.origin.y+self.messageView.frame.size.height+self.bgView.frame.size.height+10*AUTO_SIZE_SCALE_X;
    
   
    
    return height;
}




-(void)_initView{
    self.backgroundColor = [UIColor clearColor];
     [self.contentView addSubview:self.self.messageView];
    
    [self.contentView addSubview:self.bgView];
    

    [self.bgView addSubview:self.messageTitle];
    [self.bgView addSubview:self.messageDescLabel];
    [self.bgView addSubview:self.lineImageView];
    [self.bgView addSubview:self.clickView];
    [self.clickView addSubview:self.clickLabel];
    [self.clickView addSubview:self.arrowImageView];

}

-(UIView *)messageView{
    if (_messageView == nil) {
        self.messageView = [UIView new];
        self.messageView.frame = CGRectMake((kScreenWidth-260/2*AUTO_SIZE_SCALE_X)/2, 20*AUTO_SIZE_SCALE_X, 260/2*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X);
        self.messageView.layer.cornerRadius =11*AUTO_SIZE_SCALE_X;
        self.messageView.layer.masksToBounds = YES;
        self.messageView.layer.borderWidth = 0;
        self.messageView.backgroundColor = UIColorFromRGB(0xd0d0d0);
    }
    return _messageView;
}

- (UILabel *)messageDate {
    if (_messageDate == nil) {
        self.messageDate = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.messageDate.textColor = [UIColor whiteColor];
        self.messageDate.backgroundColor = [UIColor clearColor];
        self.messageDate.frame = CGRectMake(0, 0, 260/2*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X);
        self.messageDate.font  = [UIFont fontWithName:@"Arial" size:12*AUTO_SIZE_SCALE_X];
        [self.messageView addSubview:self.messageDate];
    }
    return _messageDate;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        self.bgView = [UIView new];
        self.bgView.frame = CGRectMake(15, self.messageView.frame.origin.y+self.messageView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
        self.bgView.backgroundColor =[UIColor whiteColor];
        
    }
    return _bgView;
}


- (UILabel *)messageTitle {
    if (_messageTitle == nil) {
        self.messageTitle = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.messageTitle.frame = CGRectMake(12, 0, self.bgView.frame.size.width-24, 41*AUTO_SIZE_SCALE_X);
        self.messageTitle.textColor = FontUIColorBlack;
        self.messageTitle.backgroundColor = [UIColor clearColor];
    }
    return _messageTitle;
}


- (UILabel *)messageDescLabel {
    if (_messageDescLabel == nil) {
        self.messageDescLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        self.messageDescLabel.textColor = FontUIColorGray;
        self.messageDescLabel.backgroundColor = [UIColor clearColor];
    }
    return _messageDescLabel;
}

- (UILabel *)clickLabel {
    if (_clickLabel == nil) {
        self.clickLabel = [CommentMethod initLabelWithText:@"点击查看" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.clickLabel.frame = CGRectMake(12*AUTO_SIZE_SCALE_X, 0, 100, 45*AUTO_SIZE_SCALE_X);
        self.clickLabel.textColor = RedUIColorC1;
        
    }
    return _clickLabel;
}


- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        self.arrowImageView.frame = CGRectMake(self.bgView.frame.size.width-12-16 ,15*AUTO_SIZE_SCALE_X,7, 16);
        
    }
    return _arrowImageView;
}

-(UIButton *)clickView{
    if (_clickView == nil) {
        self.clickView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickView.frame = CGRectMake(0, self.messageDescLabel.frame.origin.y+self.messageDescLabel.frame.origin.y, self.bgView.frame.size.width, 0);
        self.clickView.backgroundColor =[UIColor clearColor];
        
    }
    return _clickView;

}

- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineImageView;
}

@end
