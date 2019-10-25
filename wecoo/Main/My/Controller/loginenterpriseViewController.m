//
//  loginenterpriseViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/25.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "loginenterpriseViewController.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@interface loginenterpriseViewController ()
@property (nonatomic,strong)UIImageView *computerImageView;
@property (nonatomic,strong)UILabel *name1Label;
@property (nonatomic,strong)UILabel *name2Label;
@property (nonatomic,strong)UILabel *name3Label;
@property (nonatomic,strong)UILabel *desphoneLabel;
@property (nonatomic,strong)WPHotspotLabel *phoneLabel;

@end

@implementation loginenterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles =@"登录企业后台网页版";
    [self.view addSubview:self.computerImageView];
    [self.view addSubview:self.name1Label];
    [self.view addSubview:self.name2Label];
    [self.view addSubview:self.name3Label];
    [self.view addSubview:self.phoneLabel];
    
    
    self.computerImageView.frame = CGRectMake(122.5*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 130*AUTO_SIZE_SCALE_X, 115*AUTO_SIZE_SCALE_X);
    self.name1Label.frame = CGRectMake(0,self.computerImageView.frame.origin.y+self.computerImageView.frame.size.height+45*AUTO_SIZE_SCALE_X, kScreenWidth, 21*AUTO_SIZE_SCALE_X);
    self.name2Label.frame = CGRectMake(0, self.name1Label.frame.origin.y+self.name1Label.frame.size.height+5*AUTO_SIZE_SCALE_X, kScreenWidth, 33.5*AUTO_SIZE_SCALE_X);
    self.name3Label.frame = CGRectMake(0, self.name2Label.frame.size.height+self.name2Label.frame.origin.y+10*AUTO_SIZE_SCALE_X, kScreenWidth, 21*AUTO_SIZE_SCALE_X);
 
    self.phoneLabel.frame = CGRectMake(0, self.name3Label.frame.size.height+self.name3Label.frame.origin.y+134*AUTO_SIZE_SCALE_X, kScreenWidth, 8.5*AUTO_SIZE_SCALE_X);
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallTaped:)];
    [self.phoneLabel addGestureRecognizer:tap1];
    self.phoneLabel.userInteractionEnabled = YES;
}

-(void)CallTaped:(UITapGestureRecognizer *)sender{
    
    self.phoneLabel.userInteractionEnabled = NO;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009001135"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
     
                             completionHandler:^(BOOL success) {
                                 
                                                        NSLog(@"Open  %d",success);
                                  self.phoneLabel.userInteractionEnabled = YES;
                             }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UILabel *)name1Label {
    if (_name1Label == nil) {
        self.name1Label = [CommentMethod initLabelWithText:@"请在网页中输入下方网址" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.name1Label.textColor = FontUIColorGray;
    }
    return _name1Label;
}


- (UIImageView *)computerImageView {
    if (_computerImageView == nil) {
        self.computerImageView = [UIImageView new];
        self.computerImageView.image =[UIImage imageNamed:@"icon_enterprise_login_img"];
//        self.computerImageView.backgroundColor = FontUIColorGray;
    }
    return _computerImageView;
}

- (UILabel *)name2Label {
    if (_name2Label == nil) {
        self.name2Label = [CommentMethod initLabelWithText:@"e.qtxzs.com" textAlignment:NSTextAlignmentCenter font:30*AUTO_SIZE_SCALE_X];
        self.name2Label.textColor = FontUIColorGray;
    }
    return _name2Label;
}

- (UILabel *)name3Label {
    if (_name3Label == nil) {
        self.name3Label = [CommentMethod initLabelWithText:@"登录后享受更多企业端功能" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
        self.name3Label.textColor = FontUIColorGray;
    }
    return _name3Label;
}

- (WPHotspotLabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectZero];
        self.phoneLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary* style3 = @{@"body" :
                                     @[[UIFont fontWithName:@"PingFangSC-Regular" size:13.0*AUTO_SIZE_SCALE_X],
                                       UIColorFromRGB(0x999999)],
                                 @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                     NSLog(@"Help action");
                            
                                 }],
                                 @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                     NSLog(@"Settings action");
                                 }],
                                 @"u": @[[UIFont fontWithName:@"Helvetica" size:13.0*AUTO_SIZE_SCALE_X],
                                         RedUIColorC1],
                                 };
        self.phoneLabel.attributedText = [@"<body>拨打客服电话：</body><u>400-900-1135</u>" attributedStringWithStyleBook:style3];
    }
    return _phoneLabel;
}
@end
