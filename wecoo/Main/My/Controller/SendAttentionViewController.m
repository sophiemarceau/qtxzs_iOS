//
//  SendAttentionViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SendAttentionViewController.h"
#import "SendMessageSucceedViewController.h"
@interface SendAttentionViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UIButton *submitButton;
@end

@implementation SendAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.complainLabel];
    [self.view addSubview:self.submitButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)submitBtnPressed:(UIButton *)sender
{
    self.submitButton.enabled = NO;


    if (self.complainLabel.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"您的提交不能为空" viewController:self];
        self.submitButton.enabled = YES;
        return;
    }
//
//    if (self.clientView.clientNameContent.text.length >12) {
//        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过12位请您重新输入" viewController:self];
//        self.saveinfoButton.enabled = YES;
//        return;
//    }
//    
//    if (self.clientView.clientNameContent.text.length <2) {
//        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，至少2位 请您检查并输入" viewController:self];
//        self.saveinfoButton.enabled = YES;
//        return;
//    }
//    
//    NSDictionary *dic = @{
//                          @"report_customer_name":self.clientView.clientNameContent.text,
//                          @"report_customer_tel":self.clientView.PhoneContent.text,
//                          @"_report_customer_industry":tradeindex,
//                          @"report_customer_area_agent":districtindex,
//                          @"report_customer_budget":budgetindex,
//                          @"report_customer_startdate":plantimeindex,
//                          @"_report_customer_note":self.remarkView.text,
//                          @"_project_id":@"",
//                          };
//    [[RequestManager shareRequestManager] AddCustomerReportResult:dic viewController:self successData:^(NSDictionary *result){
//        
//        if(IsSucess(result)){
//            if (result !=nil) {
//                [self.delegate addSuccessReturnClientPage];
//                SubmintSuccessReportViewController *vc = [[SubmintSuccessReportViewController alloc] init];
//                vc.fromclientFlag = 1;
//                vc.titles = @"报备客户";
//                [self.navigationController pushViewController:vc animated:YES];
//                //                [[RequestManager shareRequestManager] tipAlert:@"提交报备成功" viewController:self];
//                //                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
//            }
//        }else{
//            [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            self.saveinfoButton.enabled = YES;
//        }
//        self.saveinfoButton.enabled = YES;
//    }failuer:^(NSError *error){
//        //        NSLog(@"error-------->%@",error);
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        self.saveinfoButton.enabled = YES;
//    }];
    [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];

//    if(IsSucess(result)){
//        [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
//        [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
//        
//    }else{
//        [[RequestManager shareRequestManager] resultFail:result viewController:self];
//        [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
//    }
}

-(void)returnFailure{
    self.submitButton.enabled = YES;
}

-(void)returnListPage{
    SendMessageSucceedViewController *vc = [[SendMessageSucceedViewController alloc] init];
    vc.titles = @"发提醒";
    [self.navigationController pushViewController:vc animated:YES];
    self.submitButton.enabled = YES;
}

-(UIButton *)submitButton{
    if (_submitButton ==nil) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.submitButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.submitButton setTintColor:[UIColor whiteColor]];
        [self.submitButton setBackgroundColor:RedUIColorC1];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.submitButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.submitButton.enabled = YES;
        self.submitButton.frame = CGRectMake(15, self.complainLabel.frame.origin.y+self.complainLabel.frame.size.height+22*AUTO_SIZE_SCALE_X, (kScreenWidth-30), 44*AUTO_SIZE_SCALE_X);

    }
    return _submitButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [CommentMethod initLabelWithText:@"提醒还未报备的好友赶紧来报备获得奖金吧！" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorGray;
        self.titleLabel.frame = CGRectMake(15,kNavHeight, kScreenWidth-30, 62*AUTO_SIZE_SCALE_X);
    }
    return _titleLabel;
}

-(PlaceholderTextView *)complainLabel{
    if (!_complainLabel) {
        _complainLabel = [[PlaceholderTextView alloc] init];
        _complainLabel.backgroundColor = [UIColor whiteColor];
        _complainLabel.delegate = self;
        _complainLabel.font = [UIFont systemFontOfSize:14.f*AUTO_SIZE_SCALE_X];
        _complainLabel.textColor = [UIColor blackColor];
        _complainLabel.textAlignment = NSTextAlignmentLeft;
        _complainLabel.editable = YES;
        _complainLabel.layer.cornerRadius = 4.0f;
        _complainLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _complainLabel.layer.borderWidth = 0.5;
        _complainLabel.placeholderColor = FontUIColorGray;
        _complainLabel.placeholder = @"报备通过立刻获得50元奖金，签约再得数千元，还在等什么？";
        _complainLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, kScreenWidth, 120*AUTO_SIZE_SCALE_X);
    }
    return _complainLabel;
}



@end
