//
//  SubmitSuccessPwdViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/3/31.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SubmitSuccessPwdViewController.h"

@interface SubmitSuccessPwdViewController ()
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submitLabel;

@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation SubmitSuccessPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.rightImageView];
    [self.view addSubview:self.submitLabel];
    [self.view addSubview: self.submit1Label];
    [self.view addSubview: self.submitButton];
    
    self.rightImageView.frame = CGRectMake(kScreenWidth/2-66/2*AUTO_SIZE_SCALE_X, kNavHeight+54*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X);
    self.submitLabel.frame = CGRectMake(kScreenWidth/2-100/2*AUTO_SIZE_SCALE_X, self.rightImageView.frame.origin.y+self.rightImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
    self.submit1Label.numberOfLines = 0;
    
    [self.submit1Label sizeToFit];
    self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, self.submit1Label.frame.size.height);
    self.submitButton.frame = CGRectMake(15, self.submit1Label.frame.origin.y+self.submit1Label.frame.size.height+35*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
    
}

-(void)backAction{
    
    if (self.isReturnMoneySubmitPage == 1) {
        NSArray * ctrlArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSubmitMoneySuccessPage];
    //("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSubmitMoneySuccessPage];
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        self.rightImageView = [UIImageView new];
        self.rightImageView.image =[UIImage imageNamed:@"icon-ok-red"];
    }
    return _rightImageView;
}

- (UILabel *)submitLabel {
    if (_submitLabel == nil) {
        self.submitLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.submitLabel.textColor = RedUIColorC1;
    }
    return _submitLabel;
}

- (UILabel *)submit1Label {
    if (_submit1Label == nil) {
        self.submit1Label = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.submit1Label.textColor = FontUIColorBlack;
        
    }
    return _submit1Label;
}

-(UIButton *)submitButton{
    if (_submitButton == nil ) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.submitButton addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


@end
