//
//  AddCommunicationRecordViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/27.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "AddCommunicationRecordViewController.h"
#import "PlaceholderTextView.h"
#import "SubmitView.h"
#import "ReviewPassViewController.h"

@interface AddCommunicationRecordViewController ()<UITextViewDelegate>{
    NSString *crl_note;
}
@property (nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)SubmitView *subview;
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation AddCommunicationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"添加沟通记录";
    [self.view addSubview:self.remarkView];
    [self.view addSubview:self.subview];
    self.remarkView.frame = CGRectMake(0,kNavHeight+ 10*AUTO_SIZE_SCALE_X, kScreenWidth,186*AUTO_SIZE_SCALE_X);
    self.subview.frame = CGRectMake(0, self.remarkView.frame.origin.y+self.remarkView.frame.size.height+0*AUTO_SIZE_SCALE_X, kScreenWidth,84*AUTO_SIZE_SCALE_X);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 登录
-(void)submitBtnPressed:(UIButton *)sender{
    self.subview.subButton.enabled = NO;
    [MobClick event:kSign4MoneyPageSubmitButtonEvent];
    crl_note = self.remarkView.text;
    if (crl_note.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"备注不得为空，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES ;
        return;
    }
    if (crl_note.length >200) {
        [[RequestManager shareRequestManager] tipAlert:@"备注不超过200字，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES ;
        return;
    }
    
    NSDictionary *dic = @{
                          @"report_id":self.report_id,
                          @"crl_note":crl_note,
                          
                          };
    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] AddCustomerReportLogSingle4App:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"正在提交中" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subview.subButton.enabled = YES;
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subview.subButton.enabled = YES;
    }];
}

-(void)returnListPage{
//    ReviewPassViewController *vc = [[ReviewPassViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    self.subview.subButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProgressList object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(PlaceholderTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _remarkView.backgroundColor = [UIColor whiteColor];
        _remarkView.delegate = self;
        _remarkView.font = [UIFont systemFontOfSize:14.f];
        _remarkView.textColor = [UIColor blackColor];
        _remarkView.textAlignment = NSTextAlignmentLeft;
        _remarkView.editable = YES;
        _remarkView.textColor = FontUIColorBlack;
        //        _remarkView.layer.cornerRadius = 4.0f;
        _remarkView.layer.borderColor = kTextBorderColor.CGColor;
        //        _remarkView.layer.borderWidth = 0.5;
        _remarkView.placeholderColor = UIColorFromRGB(0xc4c3c9);
        _remarkView.placeholder = @"请填写本次沟通内容，不超过200字";
        
    }
    return _remarkView;
}



-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor clearColor];
        [self.subview.subButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}

@end
