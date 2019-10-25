//
//  ClientReview.h
//  wecoo
//
//  Created by 屈小波 on 2016/12/14.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientReview : UIView<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *clientNameLabel;
@property(nonatomic,strong)UITextField *clientNameContent;
@property(nonatomic,strong)UIView *clientView;
@property (nonatomic,strong)UILabel *AgeLabel;
@property(nonatomic,strong)UILabel *AgeContent;

@property (nonatomic,strong)UILabel *SexLabel;
@property (nonatomic,strong)UILabel *SexConetent;

@property (nonatomic,strong)UILabel *PhoneLabel;
@property(nonatomic,strong)UITextField *PhoneContent;
@property(nonatomic,strong)UIView *PhoneView;
@property (strong, nonatomic) NSDictionary *data;//接收数据的字典

@end
