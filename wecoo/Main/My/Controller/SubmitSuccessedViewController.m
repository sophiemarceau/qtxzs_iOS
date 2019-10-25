//
//  SubmitSuccessedViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/11/6.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "SubmitSuccessedViewController.h"

@interface SubmitSuccessedViewController ()
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submitLabel;
@property (nonatomic,strong)UILabel *submit1Label;
@property (nonatomic,strong)UIButton *submitButton;

@end

@implementation SubmitSuccessedViewController

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
    self.submit1Label.text = @"我们将在1-3个工作日内完成打款\n具体参见各银行入账时间";
    [self.submit1Label sizeToFit];
    self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, self.submit1Label.frame.size.height);
    self.submitButton.frame = CGRectMake(15, self.submit1Label.frame.origin.y+self.submit1Label.frame.size.height+35*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
}
-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
    
}

-(void)backAction{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    /*
     *0 个人身份认证已经成功，从我的赏金申请提现 提现提交成功返回我的赏金页面---
     此条件里面不涉及没有设置提现密码的情况
     如果之前已经成功设置了提现密码则-3
     之如果之前尚未设置提现密码则-4
     
     *1 个人身份认证信息提交成功后 去提现 提现提交返回我的赏金页面------必然也已经设置了提现密码，从设置密码页面进入提现页面提交成功的
     *2 个人身份认证信息审核失败 再次提交个人身份认证后 提现提交成功后 返回提现进度列表--------此条件里面不涉及没有设置提现密码的情况
     *3 个人身份认证信息审核通过 提现信息审核不通过 去修改提现信息提交成功后 返回提现进度列表----此条件里面不涉及没有设置提现密码的情况
     */
    if (self.fromWhere == 0) {
        if (self.isFromSettingpwdpage == 1) {
            [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
        }
        if (ctrlArray.count == 5) {//如果 提交失败 从我的赏金正常走流程去提交身份认证审核再提现成功后
            [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
        }
        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
    }
    if (self.fromWhere == 1) {
        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
    }
    if (self.fromWhere == 2) {
        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadwithDrawRecord object:nil];
        
    }
    if (self.fromWhere == 3) {
       
         [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadwithDrawRecord object:nil];
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadBalance object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSubmitMoneySuccessPage];//("PageOne"为页面名称，可自定义)
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
        self.submitLabel = [CommentMethod initLabelWithText:@"提交成功" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
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
