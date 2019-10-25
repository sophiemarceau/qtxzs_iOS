//
//  AdvertiseViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/19.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "AdvertiseViewController.h"
#import "UIImageView+WebCache.h"

@interface AdvertiseViewController  ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    UIView *ADView;
    int CountdownNum;
    UILabel *CountdownLabel;
}

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation AdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView removeFromSuperview];
//    NSLog(@"pic------>%@",self.advertiseImageString);
//    NSLog(@"pic-------URL---------%@",self.advertiseUrlString);
    
    ADView = [[UIView alloc] init];
    ADView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:ADView];
    
    self.view.backgroundColor = C2UIColorGray;
    
     if (self.advertiseImageString!=[NSNull class] && self.advertiseImageString.length !=0 &&![self.advertiseImageString isEqualToString:@""]) {
         UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
         [imageV setImageWithURL:[NSURL URLWithString:self.advertiseImageString] placeholderImage:[UIImage imageNamed:@"Default-800-Portrait-736h"]];
         [ADView addSubview:imageV];
         if (self.advertiseUrlString!=[NSNull class] && self.advertiseUrlString.length !=0 &&![self.advertiseUrlString isEqualToString:@""]) {
             imageV.userInteractionEnabled = YES;
         }else{
             imageV.userInteractionEnabled = NO;
         }
         
         UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(gotoViewController:)];
         [imageV addGestureRecognizer:tap];
         
         UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80*AUTO_SIZE_SCALE_X, kScreenWidth, 80*AUTO_SIZE_SCALE_X)];
         buttomView.backgroundColor = [UIColor whiteColor];
         [ADView  addSubview:buttomView];
         
         UIImageView * adImv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (80*AUTO_SIZE_SCALE_X-45)/2, 45*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
         
         adImv.image = [UIImage imageNamed:@"logo-login"];
         [buttomView addSubview:adImv];
         
         UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(adImv.frame.size.width+adImv.frame.origin.x+15, (80*AUTO_SIZE_SCALE_X-45*AUTO_SIZE_SCALE_X)/2, 180*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
         loginLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
         loginLabel.backgroundColor = [UIColor clearColor];
         loginLabel.textColor = FontUIColorGray;
         loginLabel.textAlignment = NSTextAlignmentLeft;
         loginLabel.text = @"渠到天下";
         [buttomView addSubview:loginLabel];
         
         UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
         skipButton.frame = CGRectMake(kScreenWidth-54-14, (80*AUTO_SIZE_SCALE_X-30)/2, 54, 30);
         //                        skipButton.layer.cornerRadius = 15.0;
         [skipButton setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateNormal];
         [skipButton setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateHighlighted];
         [skipButton setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateSelected];
         [skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
         [buttomView addSubview:skipButton];
         
         UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-29-14, 26, 29, 29)];
         secView.layer.cornerRadius = 14.5;
         secView.backgroundColor = [UIColor blackColor];
         secView.alpha = 0.5;
         [ADView addSubview:secView];
         
         CountdownNum = 3;
         
         CountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 29, 11)];
         CountdownLabel.text = [NSString stringWithFormat:@"%d秒",CountdownNum];
         CountdownLabel.font = [UIFont systemFontOfSize:11];
         CountdownLabel.textColor = [UIColor whiteColor];
         CountdownLabel.textAlignment = NSTextAlignmentCenter;
         [secView addSubview:CountdownLabel];
         
         [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
         [self performSelector:@selector(dismissADView) withObject:nil afterDelay:4.0];

         
    }
}

-(void)gotoViewController:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kPushAdvertisePage object:nil];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    CountdownNum = CountdownNum -1;
    CountdownLabel.text = [NSString stringWithFormat:@"%d秒",CountdownNum];
    if (CountdownNum == 0) {
        [theTimer invalidate];
    }
}

//跳过广告
-(void)skipButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)dismissADView
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
