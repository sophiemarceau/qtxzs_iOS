//
//  confirmreviewpassViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/6/5.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "confirmreviewpassViewController.h"
#import "RadioButton.h"
#import "PlaceholderTextView.h"
#import "ReviewPassViewController.h"
@interface confirmreviewpassViewController (){
    NSString *crl_note;
}
@property (nonatomic, strong) RadioButton* radioButton;
@property (nonatomic, strong) UIView* radioBGView;
@property(nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)UIButton *submitButton;

@end

@implementation confirmreviewpassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"审核通过";
    crl_note = @"";
    [self.view addSubview:self.radioBGView];
//    [self.view addSubview:self.remarkView];
//    self.remarkView.frame = CGRectMake(0, self.radioBGView.frame.size.height+self.radioBGView.frame.origin.y
//                                       +10*AUTO_SIZE_SCALE_X, kScreenWidth, 186*AUTO_SIZE_SCALE_X);
    [self.view addSubview:self.submitButton];
    self.submitButton.frame = CGRectMake(15, self.radioBGView.frame.origin.y+self.radioBGView.frame.size.height+20*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
    
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:5];
    CGRect btnRect = CGRectMake(15*AUTO_SIZE_SCALE_X , 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 22.5*AUTO_SIZE_SCALE_X);
    for (NSString* optionTitle in @[@"客户对该行业有投资意向，需持续跟进", @"客户对本项目很感兴趣，尽快邀约考察", @"客户对本项目投资意向强烈，尽快签约"]) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.y += (22.5+25)*AUTO_SIZE_SCALE_X;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        
        [btn setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [btn setImage:[UIImage imageNamed:@"icon_choice_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_choice_selected"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.radioBGView addSubview:btn];
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    crl_note = @"客户对该行业有投资意向，需持续跟进";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dButtonClick{
    self.submitButton.enabled = NO;
    [MobClick event:kConfirmPassPageSubmitButtonEvent];

    if (crl_note.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请您选择后再提交" viewController:self];
        self.submitButton.enabled = YES ;
        return;
    }
    NSDictionary *dic = @{
                          @"report_id":self.report_id,
                          @"crl_note":crl_note
    };
    
    [[RequestManager shareRequestManager] PassAuditing4AppResult:dic viewController:self successData:^(NSDictionary *result){
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
        crl_note = sender.titleLabel.text ;
    }
}

-(UIView *)radioBGView{
    if (_radioBGView == nil) {
        self.radioBGView = [UIView new];
        self.radioBGView.backgroundColor = [UIColor whiteColor];
        self.radioBGView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 144+25
                                            *AUTO_SIZE_SCALE_X);
    }
    return _radioBGView;
}


-(PlaceholderTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _remarkView.backgroundColor = [UIColor whiteColor];
        _remarkView.delegate = self;
        _remarkView.font = [UIFont systemFontOfSize:14.f];
        _remarkView.textColor = FontUIColorBlack;
        
        _remarkView.textAlignment = NSTextAlignmentLeft;
        _remarkView.editable = YES;
        //        _remarkView.layer.cornerRadius = 4.0f;
        _remarkView.layer.borderColor = kTextBorderColor.CGColor;
        //        _remarkView.layer.borderWidth = 0.5;
        _remarkView.placeholderColor = UIColorFromRGB(0xc4c3c9);
        _remarkView.placeholder = @"其他，不超过200字";
    }
    return _remarkView;
}


-(UIButton *)submitButton{
    if (_submitButton == nil ) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.submitButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
