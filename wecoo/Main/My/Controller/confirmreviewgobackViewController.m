//
//  confirmreviewgobackViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/6/5.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "confirmreviewgobackViewController.h"
#import "RadioButton.h"
#import "PlaceholderTextView.h"
#import "ReviewPassViewController.h"

@interface confirmreviewgobackViewController (){
    NSString *crl_note;
}
@property (nonatomic, strong) RadioButton* radioButton;
@property (nonatomic, strong) UIView* radioBGView;

@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation confirmreviewgobackViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"审核退回";
    [self.view addSubview:self.radioBGView];
    [self.view addSubview:self.submitButton];
    self.submitButton.frame = CGRectMake(15, self.radioBGView.frame.origin.y+self.radioBGView.frame.size.height+20*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:2];
    CGRect btnRect = CGRectMake(15*AUTO_SIZE_SCALE_X , 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 35*AUTO_SIZE_SCALE_X);
    for (NSString* optionTitle in @[@"很遗憾，该用户在后续跟进中，对我品牌已无加盟意向或双方需求不匹配。", @"多时段，多通电话尝试，仍未能联系上该客户。"]) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.y += (35+25)*AUTO_SIZE_SCALE_X;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        [btn setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        
        [btn setImage:[UIImage imageNamed:@"icon_choice_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_choice_selected"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10*AUTO_SIZE_SCALE_X, 0, 0);
        [self.radioBGView addSubview:btn];
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    crl_note = @"很遗憾，该用户在后续跟进中，对我品牌已无加盟意向或双方需求不匹配。";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dButtonClick{
    self.submitButton.enabled = NO;
    [MobClick event:kConfirmGOBackPageSubmitButtonEvent];

    
    if (crl_note.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请您选择后再提交" viewController:self];
        self.submitButton.enabled = YES ;
        return;
    }
    NSDictionary *dic = @{
                          @"report_id":self.report_id,
                          @"crl_note":crl_note
                          };
    
    [[RequestManager shareRequestManager] SendBackCustomerReport4App:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"正在提交中" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.submitButton.enabled = YES;
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.submitButton.enabled = YES;
    }];

    
}

-(void)returnListPage{
    
    ReviewPassViewController *vc = [[ReviewPassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.submitButton.enabled = YES;
    
}
-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        NSLog(@"Selected color: %@", sender.titleLabel.text);
        crl_note = sender.titleLabel.text;
    }
}

-(UIView *)radioBGView{
    if (_radioBGView == nil) {
        self.radioBGView = [UIView new];
        self.radioBGView.backgroundColor = [UIColor whiteColor];
        self.radioBGView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 165*AUTO_SIZE_SCALE_X);
    }
    return _radioBGView;
}





-(UIButton *)submitButton{
    if (_submitButton == nil ) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"确认退回" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.submitButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
