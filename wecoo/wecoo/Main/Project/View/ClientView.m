//
//  ClientView.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/23.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ClientView.h"

@implementation ClientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    
    UIImageView * linImage1 = [UIImageView new];
    UIImageView * linImage2 = [UIImageView new];
    UIImageView * linImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    linImage1.image = [UIImage imageNamed:@"item_line"];
    linImage2.image = [UIImage imageNamed:@"item_line"];
    linImage3.image = [UIImage imageNamed:@"item_line"];
    [self addSubview:linImage1];
    [self addSubview:linImage2];
    [self addSubview:linImage3];
    
    [self addSubview:self.clientNameLabel];
    [self addSubview:self.AgeLabel];
    [self addSubview:self.SexLabel];
    [self addSubview:self.PhoneLabel];
    
    [self addSubview:self.clientNameContent];
    [self addSubview:self.AgeContent];
    [self addSubview:self.SexConetent];
    [self addSubview:self.PhoneContent];
    
#pragma mark - 添加约束(订单详情部分)
    [self.clientNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [linImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.clientNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];

    
    [self.AgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.clientNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X));
    }];
    [linImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.AgeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.SexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.AgeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X));
    }];
    [linImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.SexLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.SexLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.clientNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.AgeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.clientNameContent.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.SexConetent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.AgeContent.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.PhoneContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.SexConetent.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
}



#pragma mark - 懒加载
- (UILabel *)clientNameLabel {
    if (_clientNameLabel == nil) {
        self.clientNameLabel = [CommentMethod initLabelWithText:@"客户姓名" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.clientNameLabel.textColor = FontUIColorGray;
    }
    return _clientNameLabel;
}

- (UILabel *)AgeLabel {
    if (_AgeLabel == nil) {
        self.AgeLabel = [CommentMethod initLabelWithText:@"年龄" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.AgeLabel.textColor = FontUIColorGray;
    }
    return _AgeLabel;
}


- (UILabel *)SexLabel {
    if (_SexLabel == nil) {
        self.SexLabel = [CommentMethod initLabelWithText:@"性别" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
          self.SexLabel.textColor = FontUIColorGray;
    }
    return _SexLabel;
}

- (UILabel *)PhoneLabel {
    if (_PhoneLabel == nil) {
        self.PhoneLabel = [CommentMethod initLabelWithText:@"手机" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
         self.PhoneLabel.textColor = FontUIColorGray;
    }
    return _PhoneLabel;
}

- (UILabel *)clientNameContent {
    if (_clientNameContent == nil) {
        self.clientNameContent = [CommentMethod initLabelWithText:@"屈小波" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.clientNameContent.textColor = FontUIColorGray;
    }
    return _clientNameContent;
}

- (UILabel *)AgeContent {
    if (_AgeContent == nil) {
        self.AgeContent = [CommentMethod initLabelWithText:@"24" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.AgeContent.textColor = FontUIColorGray;
    }
    return _AgeContent;
}

- (UILabel *)SexConetent {
    if (_SexConetent == nil) {
        self.SexConetent = [CommentMethod initLabelWithText:@"男" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.SexConetent.textColor = FontUIColorGray;
    }
    return _SexConetent;
}

- (UILabel *)PhoneContent {
    if (_PhoneContent == nil) {
        self.PhoneContent = [CommentMethod initLabelWithText:@"13681588610" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        //文字变色
        //        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        //        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        //        self.orderStateLabel.attributedText = str;
        self.PhoneContent.textColor = FontUIColorGray;
    }
    return _PhoneContent;
}
@end
