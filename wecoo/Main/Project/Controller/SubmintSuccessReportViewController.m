//
//  SubmintSuccessReportViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "SubmintSuccessReportViewController.h"
#import "noWifiView.h"


@interface SubmintSuccessReportViewController (){
    int deadlineDay;
    noWifiView * failView;
}

@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *submitLabel;

@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation SubmintSuccessReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

    [self.view addSubview: self.rightImageView];
    [self.view addSubview:self.submitLabel];
    [self.view addSubview: self.submit1Label];
    [self.view addSubview: self.submitButton];
    
    self.rightImageView.frame = CGRectMake(kScreenWidth/2-66/2*AUTO_SIZE_SCALE_X, kNavHeight+54*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X);
    self.submitLabel.frame = CGRectMake(kScreenWidth/2-100/2*AUTO_SIZE_SCALE_X, self.rightImageView.frame.origin.y+self.rightImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    
    [self loadData];
 
}
-(void)saveBtnPressed:(UIButton *)sender{
    [self backAction];
}
-(void)backAction{
    if(self.fromclientFlag == 1){
                NSArray * ctrlArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:ctrlArray[1] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadClientList object:nil];

    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reloadButtonClick:(UIButton *)sender{
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic1 = @{};
    [[RequestManager shareRequestManager] GetReportLockTimeResult :dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            deadlineDay = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            self.submit1Label.text =[NSString stringWithFormat:@"该客户审核确认后，您将获得相应的赏金\n相关进展可在“已推荐客户”中查看\n%d天内，您的客户将被锁定，不可再次报备给其他项目，达到期限或被退回后，自动解锁协助成交，更有额外千元赏金",deadlineDay];
            self.submit1Label.frame = CGRectMake(15, self.submitLabel.frame.origin.y+self.submitLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0);
            [self.submit1Label sizeToFit];self.submitButton.frame = CGRectMake(15, self.submit1Label.frame.origin.y+self.submit1Label.frame.size.height+35*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        failView.hidden = YES;
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        //        nocontent.hidden = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kReportSuccessPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kReportSuccessPage];
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
        self.submit1Label = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.submit1Label.textColor = FontUIColorBlack;
        self.submit1Label.numberOfLines = 0;
       
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
