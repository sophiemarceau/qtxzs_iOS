//
//  SignSucceedViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/6/5.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SignSucceedViewController.h"
#import "CheckListViewController.h"

@interface SignSucceedViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submitLabel;
@property (nonatomic,strong)UILabel *submit1Label;
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation SignSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"签约打款";
    [self.view addSubview: self.rightImageView];
    [self.view addSubview:self.submitLabel];
//    [self.view addSubview: self.submit1Label];
    [self.view addSubview: self.submitButton];
    
    self.rightImageView.frame = CGRectMake(kScreenWidth/2-44/2*AUTO_SIZE_SCALE_X, kNavHeight+54*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    self.submitLabel.frame = CGRectMake(kScreenWidth/2-100/2*AUTO_SIZE_SCALE_X, self.rightImageView.frame.origin.y+self.rightImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
//    self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
//    self.submit1Label.numberOfLines = 0;
//    self.submit1Label.text = @"签约成功";
//    [self.submit1Label sizeToFit];
//    self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, self.submit1Label.frame.size.height);
    self.submitButton.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
}
-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
}
-(void)backAction{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    for (UIViewController *temp in ctrlArray) {
        if ([temp isMemberOfClass: [CheckListViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCheckList object:nil];
            break;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSignSuccessPagesPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSignSuccessPagesPage];
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
        self.submitLabel = [CommentMethod initLabelWithText:@"签约成功" textAlignment:NSTextAlignmentCenter font:18*AUTO_SIZE_SCALE_X];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}
/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
/*
 开启ios右滑返回
 */
- (void)startSideBack {
    self.isCanUseSideBack=YES;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanUseSideBack;
}



@end



