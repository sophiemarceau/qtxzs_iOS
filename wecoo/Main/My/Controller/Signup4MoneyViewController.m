//
//  Signup4MoneyViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/25.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "Signup4MoneyViewController.h"
#import "PlaceholderTextView.h"
#import "SubmitView.h"
#import "SignSucceedViewController.h"
#import "MOFSPickerManager.h"

@interface Signup4MoneyViewController ()<UITextViewDelegate>{
    NSString *crl_note;
     NSString* districtindex;
}
@property(nonatomic,strong)UIImageView *moneyImageView;
@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)SubmitView *subview;
@property(nonatomic,strong)UILabel *districtLabel;
@property(nonatomic,strong)UITextField *districtContent;
@property(nonatomic,strong)UIView *districtView;
@end

@implementation Signup4MoneyViewController

- (void)viewDidLoad {
    districtindex =@"";
    [super viewDidLoad];
    self.titles  =@"签约打款";
    self.view.backgroundColor = BGColorGray;
    [self.view addSubview:self.bgview];
    [self.bgview addSubview:self.moneyImageView];
    [self.bgview addSubview:self.titleLabel];
    [self.bgview addSubview:self.moneyLabel];
    [self.view addSubview:self.remarkView];
    [self.view addSubview:self.subview];
    self.bgview.frame = CGRectMake(0, kNavHeight, kScreenWidth, 190*AUTO_SIZE_SCALE_X);
    self.moneyImageView.frame = CGRectMake((kScreenWidth-50*AUTO_SIZE_SCALE_X)/2, 25*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.titleLabel.frame = CGRectMake(0, self.moneyImageView.frame.origin.y+self.moneyImageView.frame.size.height+25*AUTO_SIZE_SCALE_X, kScreenWidth, 22.5*AUTO_SIZE_SCALE_X);
    self.moneyLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, kScreenWidth, 37.5*AUTO_SIZE_SCALE_X);
    [self.view addSubview:self.districtView];
    [self.districtView addSubview:self.districtLabel];
    [self.districtView addSubview:self.districtContent];
    self.districtView.frame = CGRectMake(0, 200*AUTO_SIZE_SCALE_X+kNavHeight, kScreenWidth, 55*AUTO_SIZE_SCALE_X);
    self.districtLabel.frame = CGRectMake(15, 0, 64*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X);
    self.districtContent.frame = CGRectMake(kScreenWidth/2-15, 0, kScreenWidth/2-15, 55*AUTO_SIZE_SCALE_X);
    self.remarkView.frame = CGRectMake(0,kNavHeight+ 265*AUTO_SIZE_SCALE_X, kScreenWidth,150*AUTO_SIZE_SCALE_X-1);
        self.subview.frame = CGRectMake(0, self.remarkView.frame.origin.y+self.remarkView.frame.size.height+20*AUTO_SIZE_SCALE_X, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    UITapGestureRecognizer * tap555 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    [self.districtView addGestureRecognizer:tap555];
    [self loadData];
}

-(void)disTaped:(UITapGestureRecognizer *)sender
{

    [self.remarkView resignFirstResponder];
    
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
        NSString *address;
        NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
        //        NSLog(@"addresstemparray----%@",addresstemparray);
        if (addresstemparray.count>0) {
            if (addresstemparray.count == 3) {
                if ([addresstemparray[addresstemparray.count-1] isEqualToString: addresstemparray[addresstemparray.count-2]]) {
                    address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[addresstemparray.count-2]];
                }else{
                    address = [NSString stringWithFormat:@"%@ %@ %@",addresstemparray[0],addresstemparray[1],addresstemparray[2]];
                }
            }else if(addresstemparray.count == 2){
                if ([addresstemparray[0] isEqualToString: addresstemparray[1]]) {
                    address = [NSString stringWithFormat:@"%@",addresstemparray[0]];
                }else{
                    address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[1]];
                }
                
            }
        }        //        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
        self.districtContent.text = address;
        
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex =temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];
}

-(void)loadData{
    
    NSDictionary *dic1 = @{
                           @"project_id":self.project_id,
                           };
    
    [[RequestManager shareRequestManager] GetProjectDtoResult:dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            
            NSDictionary *dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){

                
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%d", [[dto objectForKey:@"project_commission_first"] intValue]];
                

            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

#pragma mark 登录
-(void)submitBtnPressed:(UIButton *)sender{
    self.subview.subButton.enabled = NO;
    [MobClick event:kSign4MoneyPageSubmitButtonEvent];
    if (self.districtContent.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"签约地区，请您检查并选择" viewController:self];
        self.subview.subButton.enabled = YES ;
        return;
    }
    
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
                          @"areaCode":districtindex,
                          
                          };
    
    [[RequestManager shareRequestManager] ApplySignedUpAuditing4AppResult:dic viewController:self successData:^(NSDictionary *result){
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
    SignSucceedViewController *vc = [[SignSucceedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.subview.subButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        _remarkView.placeholder = @"备注不超过200字";
        
    }
    return _remarkView;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        self.moneyLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:27*AUTO_SIZE_SCALE_X];
        self.moneyLabel.textColor = RedUIColorC1;
    }
    return _moneyLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [CommentMethod initLabelWithText:@"签约佣金" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorBlack;
    }
    return _titleLabel;
}


- (UIImageView *)moneyImageView {
    if (_moneyImageView == nil) {
        self.moneyImageView = [UIImageView new];
        self.moneyImageView.image =[UIImage imageNamed:@"icon_enterprise_balance"];
        
    }
    return _moneyImageView;
}

- (UIView *)bgview {
    if (_bgview == nil) {
        self.bgview = [UIView new];
        self.bgview.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgview;
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


- (UILabel *)districtLabel {
    if (_districtLabel == nil) {
        self.districtLabel = [CommentMethod initLabelWithText:@"企业地区" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.districtLabel.textColor = FontUIColorBlack;
    }
    return _districtLabel;
}

-(UITextField *)districtContent{
    if (_districtContent == nil) {
        self.districtContent = [UITextField new];
        self.districtContent.userInteractionEnabled = NO;
        self.districtContent.textAlignment = NSTextAlignmentRight;
        self.districtContent.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.districtContent.backgroundColor = [UIColor clearColor];
        self.districtContent.textColor = FontUIColorBlack;
        self.districtContent.placeholder =@"请选择签约地区";
    }
    return _districtContent;
}

- (UIView *)districtView {
    if (_districtView == nil) {
        self.districtView = [UIView new];
        self.districtView.backgroundColor = [UIColor whiteColor];
        self.districtView.userInteractionEnabled = YES;
    }
    return _districtView;
}

@end
