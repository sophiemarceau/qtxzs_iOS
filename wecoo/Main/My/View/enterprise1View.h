//
//  enterprise1View.h
//  wecoo
//
//  Created by 屈小波 on 2017/6/2.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface enterprise1View : UIView
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UITextField *phoneContent;
@property(nonatomic,strong)UIView *phoneView;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITextField *nameContent;
@property(nonatomic,strong)UIView *nameView;

@property(nonatomic,strong)UILabel *loginNameLabel;
@property(nonatomic,strong)UITextField *loginNameContent;
@property(nonatomic,strong)UIView *loginNameView;

@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)UITextField *passwordContent;
@property(nonatomic,strong)UIView *passwordView;

@property(nonatomic,strong)UILabel *companyNameLabel;
@property(nonatomic,strong)UITextField *companyNameContent;
@property(nonatomic,strong)UIView *companyView;

@property(nonatomic,strong)UILabel *tradeLabel;
@property(nonatomic,strong)UITextField *tradeContent;
@property(nonatomic,strong)UIView *tradeView;

@property(nonatomic,strong)UILabel *districtLabel;
@property(nonatomic,strong)UITextField *districtContent;
@property(nonatomic,strong)UIView *districtView;

@property(nonatomic,strong)UILabel *ENContactLabel;
@property(nonatomic,strong)UITextField *ENContactContent;
@property(nonatomic,strong)UIView *ENContactView;

@property(nonatomic,strong)UILabel *contactPhoneLabel;
@property(nonatomic,strong)UITextField *contactPhoneContent;
@property(nonatomic,strong)UIView *contactPhoneView;

@property(nonatomic,strong)PlaceholderTextView *remarkView;

@property(nonatomic,strong)UIView *picView1;
@property(nonatomic,strong)UILabel *picLabel;
@property(nonatomic,strong)UIImageView *businesslicenceImageView;
@property(nonatomic,strong)UIImageView *plusImageView1;
@property(nonatomic,strong)UILabel *imageLabel1;

@property(nonatomic,strong)UIView *picView2;
@property(nonatomic,strong)UILabel *postcardLabel;
@property(nonatomic,strong)UILabel *subpostcardLabel;
@property(nonatomic,strong)UIImageView *postcardImageView;
@property(nonatomic,strong)UIImageView *plusImageView2;
@property(nonatomic,strong)UILabel *imageLabel2;

@property(nonatomic,strong)UIImageView *eyeImageView;
@property(nonatomic,strong)UIView *eyeView;
@property(strong,nonatomic)NSDictionary *data;//接收数据的字典
@end
