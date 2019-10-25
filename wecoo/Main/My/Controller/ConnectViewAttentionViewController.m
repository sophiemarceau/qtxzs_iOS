//
//  ConnectViewAttentionViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ConnectViewAttentionViewController.h"
#import "PlaceholderTextView.h"
#import "SelectClientViewController.h"
#import "SendMessageSucceedViewController.h"

@interface ConnectViewAttentionViewController ()<UITextViewDelegate,SelectClientGroupDelegate>

@end

@implementation ConnectViewAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColorGray;
    [self.view addSubview:self.bgview];
    [self.bgview setFrame:CGRectMake(0, kNavHeight, kScreenWidth, 107/2*AUTO_SIZE_SCALE_X)];
    [self.bgview addSubview:self.titleLabel];
    [self.bgview addSubview:self.arrowImageView];
    [self.arrowImageView  setFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, (107/2-16)/2*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    [self.view addSubview:self.complainLabel];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.attentionLabel];
    self.attentionLabel.frame = CGRectMake(15,self.submitButton.frame.origin.y+self.submitButton.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30,15*AUTO_SIZE_SCALE_X);

}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    self.bgview.userInteractionEnabled = NO;
    SelectClientViewController *vc = [[SelectClientViewController alloc]init];
    vc.delegate = self;
    vc.titles = @"选择用户";
    [self.navigationController pushViewController:vc animated:YES];
    self.bgview.userInteractionEnabled = YES;
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

-(void)SelectClientGroupDelegateReturnPage:(NSDictionary *)returnTypeDic{
    NSLog(@"SelectClientGroupDelegateReturnPage");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        self.titleLabel = [CommentMethod initLabelWithText:@"请选择提醒的用户" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorGray;
        self.titleLabel.frame = CGRectMake(15,0, kScreenWidth/2,107/2*AUTO_SIZE_SCALE_X);
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
        _complainLabel.placeholder = @"请您输入您要提醒的内容（用户无法回复）";
        _complainLabel.frame = CGRectMake(0, self.bgview.frame.origin.y+self.bgview.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 120*AUTO_SIZE_SCALE_X);
       
    }
    return _complainLabel;
}

-(UIView *)bgview{
    if (_bgview == nil) {
        self.bgview = [UIView new];
        self.bgview.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        self.bgview.userInteractionEnabled = YES;
        [self.bgview addGestureRecognizer:Viewtap];

    }
    return _bgview;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
    }
    return _arrowImageView;
}

- (UILabel *)attentionLabel {
    if (_attentionLabel == nil) {
        self.attentionLabel = [CommentMethod initLabelWithText:@"只能向您的一级人脉发提醒" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.attentionLabel.textColor = FontUIColorGray;
        self.attentionLabel.backgroundColor = [UIColor clearColor];
    }
    return _attentionLabel;
}
@end
