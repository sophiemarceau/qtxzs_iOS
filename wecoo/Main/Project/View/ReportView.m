//
//  ReportView.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/23.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ReportView.h"

@implementation ReportView

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
    UIImageView * linImage3 = [UIImageView new];
//    UIImageView * linImage4 = [UIImageView new];
//    UIImageView * linImage5 = [UIImageView new];
    linImage1.backgroundColor = lineImageColor;
    linImage2.backgroundColor = lineImageColor;
    linImage3.backgroundColor = lineImageColor;
//    linImage1.image = [UIImage imageNamed:@"item_line"];
//    linImage2.image = [UIImage imageNamed:@"item_line"];
//    linImage3.image = [UIImage imageNamed:@"item_line"];
//    linImage4.image = [UIImage imageNamed:@"item_line"];
//    linImage5.image = [UIImage imageNamed:@"item_line"];
    [self addSubview:linImage1];
    [self addSubview:linImage2];
    [self addSubview:linImage3];
//    [self addSubview:linImage4];
//    [self addSubview:linImage5];
    
    [self addSubview:self.tradeLabel];
    [self addSubview:self.tradeContent];
    [self addSubview:self.districtLabel];
    [self addSubview:self.districtContent];
    [self addSubview:self.budgetLabel];
    [self addSubview:self.budgetContent];
    [self addSubview:self.planBeginTimeLabel];
    [self addSubview:self.planBeginTimeContent];
//    [self addSubview:self.StoreLabel];
//    [self addSubview:self.StoreSizeLabel];
    
    [self addSubview:self.tradeView];
    [self addSubview:self.budgeView];
    [self addSubview:self.districtView];
    [self addSubview:self.planView];
   
    
#pragma mark - 添加约束
    [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    [self.tradeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.tradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    
    [linImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.tradeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    
    [self.districtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.tradeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.districtContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.tradeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-64*AUTO_SIZE_SCALE_X-30-15, 55*AUTO_SIZE_SCALE_X));
    }];
    [self.districtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.tradeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [linImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.districtLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.budgetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.districtLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.budgetContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.districtLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.budgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.districtLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [linImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.budgetLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.planBeginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.budgetLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];
    [self.planBeginTimeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.budgetLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 50*AUTO_SIZE_SCALE_X));
    }];
    [self.planView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.budgetLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
//    [linImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.planBeginTimeLabel.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
//    }];
    
//    [self.StoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.planBeginTimeLabel.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 58*AUTO_SIZE_SCALE_X));
//    }];
//    
//    [linImage5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.StoreLabel.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
//    }];

//    [self.StoreSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.StoreLabel.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(64*AUTO_SIZE_SCALE_X, 58*AUTO_SIZE_SCALE_X));
//    }];
    
}

#pragma mark - 懒加载
- (UILabel *)tradeLabel {
    if (_tradeLabel == nil) {
        self.tradeLabel = [CommentMethod initLabelWithText:@"意向行业" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
    
        self.tradeLabel.textColor = FontUIColorGray;
    }
    return _tradeLabel;
}

- (UILabel *)districtLabel {
    if (_districtLabel == nil) {
        self.districtLabel = [CommentMethod initLabelWithText:@"代理区域" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.districtLabel.textColor = FontUIColorGray;
    }
    return _districtLabel;
}


- (UILabel *)budgetLabel {
    if (_budgetLabel == nil) {
        self.budgetLabel = [CommentMethod initLabelWithText:@"投资预算" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.budgetLabel.textColor = FontUIColorGray;
    }
    return _budgetLabel;
}

- (UILabel *)planBeginTimeLabel {
    if (_planBeginTimeLabel == nil) {
        self.planBeginTimeLabel = [CommentMethod initLabelWithText:@"计划启动时间" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.planBeginTimeLabel.textColor = FontUIColorGray;
    }
    return _planBeginTimeLabel;
}

- (UILabel *)StoreLabel {
    if (_StoreLabel == nil) {
        self.StoreLabel = [CommentMethod initLabelWithText:@"拥有店铺" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.StoreLabel.textColor = FontUIColorGray;
    }
    return _StoreLabel;
}

- (UILabel *)StoreSizeLabel {
    if (_StoreSizeLabel == nil) {
        self.StoreSizeLabel = [CommentMethod initLabelWithText:@"店铺面积" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.StoreSizeLabel.textColor = FontUIColorGray;
    }
    return _StoreSizeLabel;
}

- (UIView *)tradeView {
    if (_tradeView == nil) {
        self.tradeView = [UIView new];
        self.tradeView.backgroundColor = [UIColor clearColor];
        self.tradeView.userInteractionEnabled = YES;
    }
    return _tradeView;
}

- (UIView *)budgeView {
    if (_budgeView == nil) {
        self.budgeView = [UIView new];
        self.budgeView.backgroundColor = [UIColor clearColor];
        self.budgeView.userInteractionEnabled = YES;
    }
    return _budgeView;
}

- (UIView *)districtView {
    if (_districtView == nil) {
        self.districtView = [UIView new];
        self.districtView.backgroundColor = [UIColor clearColor];
        self.districtView.userInteractionEnabled = YES;
    }
    return _districtView;
}

- (UIView *)planView {
    if (_planView == nil) {
        self.planView = [UIView new];
        self.planView.backgroundColor = [UIColor clearColor];
        self.planView.userInteractionEnabled = YES;
    }
    return _planView;
}

-(UITextField *)tradeContent{
    if (_tradeContent == nil) {
        self.tradeContent = [UITextField new];
        self.tradeContent.placeholder =@"请选择意向行业";
        self.tradeContent.userInteractionEnabled = NO;
        self.tradeContent.textAlignment = NSTextAlignmentRight;
        self.tradeContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.tradeContent.backgroundColor = [UIColor clearColor];
        self.tradeContent.textColor = FontUIColorBlack;
    }
    return _tradeContent;
}

-(UITextField *)districtContent{
    if (_districtContent == nil) {
        self.districtContent = [UITextField new];
        self.districtContent.userInteractionEnabled = NO;
        self.districtContent.textAlignment = NSTextAlignmentRight;
        self.districtContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.districtContent.backgroundColor = [UIColor clearColor];
        self.districtContent.textColor = FontUIColorBlack;
        self.districtContent.placeholder =@"请选择代理区域";
    }
    return _districtContent;
}

-(UITextField *)budgetContent{
    if (_budgetContent == nil) {
        self.budgetContent = [UITextField new];
        self.budgetContent.userInteractionEnabled = NO;
//        self.budgetConten.textColor = FontUIColorBlack;
        self.budgetContent.textColor = FontUIColorBlack;
        self.budgetContent.textAlignment = NSTextAlignmentRight;
        self.budgetContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.budgetContent.backgroundColor = [UIColor clearColor];
        self.budgetContent.placeholder =@"请输入客户预算/万元";

    }
    return _budgetContent;
}

-(UITextField *)planBeginTimeContent{
    if (_planBeginTimeContent == nil) {
        self.planBeginTimeContent = [UITextField new];
        self.planBeginTimeContent.userInteractionEnabled = NO;
        self.planBeginTimeContent.textAlignment = NSTextAlignmentRight;
        self.planBeginTimeContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.planBeginTimeContent.textColor = FontUIColorBlack;
        self.planBeginTimeContent.backgroundColor = [UIColor clearColor];
        self.planBeginTimeContent.placeholder =@"请选择启动时间段";
    }
    return _planBeginTimeContent;
}
@end
