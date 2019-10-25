//
//  RecomCustomerSuccViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/2.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "RecomCustomerSuccViewController.h"

@interface RecomCustomerSuccViewController ()
@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submitsuccessLabel;
@property (nonatomic,strong)UILabel *submitTitleLabel;
@property (nonatomic,strong)UILabel *sumLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation RecomCustomerSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.rightImageView];
    [self.view addSubview:self.submitsuccessLabel];
    [self.view addSubview:self.submitTitleLabel];
    [self.view addSubview:self.sumLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.submitButton];
    
    
    self.rightImageView.frame = CGRectMake(kScreenWidth/2-66/2*AUTO_SIZE_SCALE_X, kNavHeight+54*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X);
    self.submitsuccessLabel.frame = CGRectMake(kScreenWidth/2-100/2*AUTO_SIZE_SCALE_X, self.rightImageView.frame.origin.y+self.rightImageView.frame.size.height+20*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    
    self.submitTitleLabel.frame = CGRectMake((kScreenWidth-130*AUTO_SIZE_SCALE_X)/2, self.submitsuccessLabel.frame.origin.y+self.submitsuccessLabel.frame.size.height+50*AUTO_SIZE_SCALE_X, kScreenWidth-280*AUTO_SIZE_SCALE_X, 130);
    self.sumLabel.frame = CGRectMake((kScreenWidth-130*AUTO_SIZE_SCALE_X)/2, self.submitTitleLabel.frame.origin.y+self.submitTitleLabel.frame.size.height+50*AUTO_SIZE_SCALE_X, kScreenWidth-280*AUTO_SIZE_SCALE_X, 130);
    
    self.contentLabel.frame = CGRectMake(15, self.sumLabel.frame.origin.y+self.sumLabel.frame.size.height+50*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    self.submitButton.frame = CGRectMake(15, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
}

-(void)backAction{
//    if (self.isReturnMoneySubmitPage == 1) {
//        NSArray * ctrlArray = self.navigationController.viewControllers;
//        [self.navigationController popToViewController:ctrlArray[ctrlArray.count-3] animated:YES];
//        return;
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSubmintRecomCustSuccPage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSubmintRecomCustSuccPage];
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        self.rightImageView = [UIImageView new];
        
        self.rightImageView.image =[UIImage imageNamed:@"icon-ok-red"];
    }
    return _rightImageView;
}

- (UILabel *)submitsuccessLabel {
    if (_submitsuccessLabel == nil) {
        self.submitsuccessLabel = [CommentMethod initLabelWithText:@"推荐成功" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.submitsuccessLabel.textColor = RedUIColorC1;
    }
    return _submitsuccessLabel;
}

- (UILabel *)submitTitleLabel {
    if (_submitTitleLabel == nil) {
        self.submitTitleLabel = [CommentMethod initLabelWithText:@"预计获得赏金" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.submitTitleLabel.textColor = FontUIColorBlack;
        
    }
    return _submitTitleLabel;
}


- (UILabel *)sumLabel {
    if (_sumLabel == nil) {
        self.sumLabel = [CommentMethod initLabelWithText:@"4567.00元" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.sumLabel.textColor = FontUIColorBlack;
        
    }
    return _sumLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [CommentMethod initLabelWithText:@"客户签约后您将获得相应的赏金；相关进展可在”已推荐客户“中查看；客户被推荐后，将会被锁定，不可以再次推荐给其他项目，跟进的项目退回或签约后，自动解锁" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.contentLabel.textColor = FontUIColorBlack;
        
    }
    return _contentLabel;
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
