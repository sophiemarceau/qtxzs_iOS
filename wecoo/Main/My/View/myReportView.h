//
//  myReportView.h
//  wecoo
//
//  Created by 屈小波 on 2016/10/25.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myReportView : UIView
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIImageView *reportImageView;
@property(nonatomic,strong)UILabel *reportLabel;
@property(nonatomic,strong)UILabel *allLabel;
@property(nonatomic,strong)UIImageView *arrowImageview;
@property(nonatomic,strong)UIImageView *linImageView;


@property(nonatomic,strong)UILabel *checkLabel;
@property(nonatomic,strong)UILabel *checkConent;

@property(nonatomic,strong)UILabel *followupLabel;
@property(nonatomic,strong)UILabel *followupConent;

@property(nonatomic,strong)UILabel *investigateLabel;
@property(nonatomic,strong)UILabel *investigateConent;

@property(nonatomic,strong)UILabel *signedLabel;
@property(nonatomic,strong)UILabel *signedConent;

@property(nonatomic,strong)UILabel *returnedLabel;
@property(nonatomic,strong)UILabel *returnedConent;

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典


@property(nonatomic,strong)UIView *reporteView;
@end
