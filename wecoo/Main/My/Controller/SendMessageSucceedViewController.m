//
//  SendMessageSucceedViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SendMessageSucceedViewController.h"

@interface SendMessageSucceedViewController (){
    NSString *selectNum;
}
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submit1Label;
@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation SendMessageSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.rightImageView];
    [self.view addSubview: self.submit1Label];
    [self.view addSubview: self.submitButton];
    
    self.rightImageView.frame = CGRectMake(kScreenWidth/2-66/2*AUTO_SIZE_SCALE_X, kNavHeight+54*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X);
    self.submit1Label.numberOfLines = 0;
    self.submit1Label.text = @"发送成功";
    [self.submit1Label sizeToFit];
    self.submit1Label.frame = CGRectMake(15, self.rightImageView.frame.origin.y+self.rightImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, self.submit1Label.frame.size.height);
    self.submitButton.frame = CGRectMake(15, self.submit1Label.frame.origin.y+self.submit1Label.frame.size.height+35*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
    
}

-(void)backAction{
    NSArray * ctrlArray = self.navigationController.viewControllers;
//    /*
//     *0 我的赏金申请提现 提现成功返回我的赏金页面
//     *1 个人身份认证信息提交后 去提现 提现成功返回我的赏金页面
//     *2 个人身份认证信息审核失败 再次提交个人身份认证后 提现成功后 返回提现进度列表
//     *3 个人身份认证信息审核通过 提现信息审核不通过 去修改提现信息提交成功后 返回提现进度列表
//     */
//    if (self.fromWhere == 0) {
//        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
//    }
//    if (self.fromWhere == 1) {
//        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
//    }
//    if (self.fromWhere == 2) {
//        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-4] animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadwithDrawRecord object:nil];
//        
//    }
//    if (self.fromWhere == 3) {
//        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadwithDrawRecord object:nil];
//        
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadBalance object:nil];
     [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
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
