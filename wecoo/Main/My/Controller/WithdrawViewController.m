//
//  WithdrawViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "WithdrawViewController.h"
#import "STPickerSingle.h"
#import "STPickerArea.h"
#import "SubmitSuccessedViewController.h"
#import "MOFSPickerManager.h"
#import "VerifyView.h"
#import "WithdrawPwdShow.h"
#import "ForgetPwdViewController.h"

@interface WithdrawViewController ()<UITextFieldDelegate>{
    NSMutableArray *bankarray;
    NSString *bankindex;
    UIButton *submintButton;
    int i;
    UIImageView *linImageView6;
    NSString *districtindex;
    WithdrawPwdShow *show;
    NSString *msgString;

}
@property (nonatomic, assign) NSInteger count;
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    bankindex =@"";
    [self loadBankData];
    [super viewDidLoad];
    
    
    UIImageView *linImageView1 = [UIImageView new];
    linImageView1.backgroundColor = lineImageColor;
    UIImageView *linImageView2 = [UIImageView new];
    linImageView2.backgroundColor = lineImageColor;
    UIImageView *linImageView5 = [UIImageView new];
    linImageView5.backgroundColor = lineImageColor;
    UIImageView *linImageView3 = [UIImageView new];
    linImageView3.backgroundColor = lineImageColor;
    UIImageView *linImageView4 = [UIImageView new];
    linImageView4.backgroundColor = lineImageColor;
    linImageView6 = [UIImageView new];
    linImageView6.backgroundColor = lineImageColor;
    
    UIImageView *linImageView7 = [UIImageView new];
    linImageView7.backgroundColor = lineImageColor;
    UIImageView *linImageView8 = [UIImageView new];
    linImageView8.backgroundColor = lineImageColor;
    
    [self.view addSubview:self.bgview];
    [self.bgview addSubview:self.nameLabel];
    [self.bgview addSubview:self.nameTextField];
    [self.bgview addSubview:self.nameImageView];
    [self.bgview addSubview:self.nameView];
    
    
    [self.bgview addSubview:linImageView1];
    [self.bgview addSubview:self.bankNamLabel];
    [self.bgview addSubview:self.bankNameTextField];
    [self.bgview addSubview:self.bankNameView];
    [self.bgview addSubview:linImageView2];
    
    [self.bgview addSubview:self.openBankDistrictLabel];
    [self.bgview addSubview:self.openBankDistrictTextField];
    [self.bgview addSubview:self.openBankDistrictView];
    [self.bgview addSubview:linImageView5];
    
    [self.bgview addSubview:self.openBankNameLabel];
    [self.bgview addSubview:self.openBankNameTextField];
    [self.bgview addSubview:self.openBankNameView];
    [self.bgview addSubview:linImageView3];
    
    [self.bgview addSubview:self.bankAccountLabel];
    [self.bgview addSubview:self.bacnkAccountTextField];
    [self.bgview addSubview:self.bankAccountView];
    [self.bgview addSubview:linImageView4];

    [self.bgview addSubview:self.sumLabel];
    [self.bgview addSubview:self.sumTextField];
    [self.bgview addSubview:self.sumView];
    [self.bgview addSubview:linImageView8];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:linImageView6];
    
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:linImageView7];
    
    [self.view addSubview:self.submitButton];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.navView.mas_bottom).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(18*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameImageView.mas_left).offset(-10);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15-18*AUTO_SIZE_SCALE_X,54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-15-18*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    

    [linImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bankNamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    [self.bankNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 54*AUTO_SIZE_SCALE_X));
    }];

    [self.bankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.bankNameTextField.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.openBankDistrictLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.openBankDistrictTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.openBankDistrictView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 54*AUTO_SIZE_SCALE_X));
    }];

    [linImageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.openBankDistrictTextField.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.openBankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.openBankNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 54*AUTO_SIZE_SCALE_X));
    }];

    [self.openBankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView5.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 58*AUTO_SIZE_SCALE_X));
    }];

    [linImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.openBankNameLabel.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bankAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bacnkAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2+30*AUTO_SIZE_SCALE_X-15, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bankAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView3.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 54*AUTO_SIZE_SCALE_X));
    }];

    [linImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.bankAccountLabel.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.sumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(linImageView4.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.sumView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView8.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 54*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.phoneLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(linImageView6.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15,54*AUTO_SIZE_SCALE_X));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView6.mas_bottom).offset(9*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(110*AUTO_SIZE_SCALE_X,36*AUTO_SIZE_SCALE_X));
    }];
    
    [linImageView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.verifyTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(linImageView7.mas_bottom).offset(49/2);;
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 44*AUTO_SIZE_SCALE_X));
    }];
    
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped1:)];
    
    [self.nameView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped2:)];
    [self.bankNameView addGestureRecognizer:tap2];
   
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped3:)];
    [self.openBankNameView addGestureRecognizer:tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped4:)];
    [self.bankAccountView addGestureRecognizer:tap4];
    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped5:)];
    [self.sumView addGestureRecognizer:tap5];
    
    UITapGestureRecognizer * tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped6:)];
    [self.openBankDistrictView addGestureRecognizer:tap6];

    self.nameTextField.userInteractionEnabled = NO;
    self.bgview.userInteractionEnabled = YES;
    self.nameView.userInteractionEnabled = YES;
    
    
    

}

-(void)disTaped1:(UITapGestureRecognizer *)sender{
    [self.nameTextField becomeFirstResponder];
}

-(void)disTaped2:(UITapGestureRecognizer *)sender{
    [self.nameTextField resignFirstResponder];
    [self.bankNameTextField resignFirstResponder];
    [self.openBankNameTextField resignFirstResponder];
    [self.sumTextField resignFirstResponder];
    [self.bacnkAccountTextField resignFirstResponder];
    NSMutableArray *bankList = [NSMutableArray new];
    for (NSDictionary *temp in bankarray) {
        [bankList addObject:[temp objectForKey:@"name"]];
    }
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:bankList tag:13 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        
        self.openBankNameTextField.text = @"";
        self.bacnkAccountTextField.text = @"";
        self.bankNameTextField.text = string;

//        [self fieldChanged];

        for (NSDictionary *temp in bankarray) {
            if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                bankindex = [temp objectForKey:@"code"] ;
                break;
            }
        }
    } cancelBlock:^{
        
    }];
}

-(void)disTaped3:(UITapGestureRecognizer *)sender{
    [self.openBankNameTextField becomeFirstResponder];
}

-(void)disTaped4:(UITapGestureRecognizer *)sender{
    [self.bacnkAccountTextField becomeFirstResponder];
}

-(void)disTaped5:(UITapGestureRecognizer *)sender{
    [self.sumTextField becomeFirstResponder];
}

-(void)disTaped6:(UITapGestureRecognizer *)sender{
    
    [self.nameTextField resignFirstResponder];
    [self.bankNameTextField resignFirstResponder];
    [self.openBankNameTextField resignFirstResponder];
    [self.sumTextField resignFirstResponder];
    [self.bacnkAccountTextField resignFirstResponder];
    
    
    
    
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
        }
        self.openBankDistrictTextField.text = address;
        
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex = temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];
}

-(void)analysis{
    NSString *zipCode;
    
    NSString *middelFlag = [districtindex substringFromIndex:2];
    //    NSLog(@"middelFlag--------%@",middelFlag);
    if([middelFlag isEqualToString:@"0000"]){
        zipCode = [NSString stringWithFormat:@"%@-%@",districtindex,districtindex] ;
    }else{
        NSString *lastflag = [districtindex substringFromIndex:4];
        //        NSLog(@"lastflag--------%@",lastflag);
        if([lastflag isEqualToString:@"00"]){
            NSString *temp1 = [NSString stringWithFormat:@"%@0000",[districtindex substringToIndex:2]];
            zipCode = [NSString stringWithFormat:@"%@-%@",temp1,districtindex] ;
        }else{
            NSString *temp1 = [NSString stringWithFormat:@"%@0000",[districtindex substringToIndex:2]];
            NSString *temp2 = [NSString stringWithFormat:@"%@%@00",[districtindex substringToIndex:2],[districtindex substringWithRange:NSMakeRange(2, 2)]];
            zipCode = [NSString stringWithFormat:@"%@-%@-%@",temp1,temp2,districtindex] ;
            
        }
    }
    
    //    NSLog(@"zipcode--------%@",[NSString stringWithFormat:@"%@",zipCode]);
    [[MOFSPickerManager shareManger] searchAddressByZipcode:zipCode block:^(NSString *addressStr){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *address;
            NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
            //            NSLog(@"addresstemparray----%@",addresstemparray);
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
            }
            // 更UI
            self.openBankDistrictTextField.text = address;
        });
    }];
}

-(void)loadData{
    if ([self.swa_id isEqualToString:@""]) {
        NSDictionary *dic = @{
                              @"swa_type":@"1"//银行卡
                              };
        [[RequestManager shareRequestManager] GetLastWithdrawalRecordByTypeResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                if(![dto isEqual:[NSNull null]] && dto !=nil)
                {
                    self.nameTextField.text= [dto objectForKey:@"us_realname"];
                    int index ;
                    NSString *string = nil;
                    NSString *str = nil;
                    NSString *des = @"当前绑定手机号为";
                    string = [NSString stringWithFormat:@"%@", [dto objectForKey:@"user_login"]];
                    str = [NSString stringWithFormat:@"%@%@",des,string];
                    index = (int)[des length] ;
//                    NSLog(@"%d",index);
//                    NSLog(@"%@",str);
                    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
                    
                    [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
                    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
                    
                    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
                    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
                    self.phoneLabel.attributedText = mutablestr;
                    
                    NSString *swa_bank = [dto objectForKey:@"swa_bank"];
                    if(![swa_bank isEqual:[NSNull null]] && swa_bank !=nil)
                    {
                        for (NSDictionary *temp in bankarray) {
                            if ([[temp objectForKey:@"code"] isEqualToString:[dto objectForKey:@"swa_bank"]]) {
                                self.bankNameTextField.text= [temp objectForKey:@"name"];
                                bankindex = [temp objectForKey:@"code"] ;
                            }
                        }
                    }

                    districtindex = [dto objectForKey:@"swa_card_area"];
                    if(![districtindex isEqualToString:@""]){
                        [self analysis];
                    }
                    self.openBankNameTextField.text = [dto objectForKey:@"swa_bank_fullname"];
                    
                    NSString *swa_card_no = [dto objectForKey:@"swa_card_no"];
                    if(![swa_card_no isEqual:[NSNull null]] && swa_card_no !=nil)
                    {
                         self.bacnkAccountTextField.text = [self normalNumToBankNum:[dto objectForKey:@"swa_card_no"]];
                    }
                   
//                    [self fieldChanged];
                    
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }failuer:^(NSError *error){
            //        NSLog(@"error-------->%@",error);
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            
        }];
    }else{
        NSDictionary *dic1 = @{
                               @"swa_id":self.swa_id
                               };
        [[RequestManager shareRequestManager] GetSalesmanWithdrawingApplicationDtoDtoResult:dic1 viewController:self successData:^(NSDictionary *result){
            
            if(IsSucess(result)){
                NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                if(![dto isEqual:[NSNull null]] && dto !=nil)
                {
                    self.nameTextField.text= [dto objectForKey:@"us_realname"];
                    int index ;
                    NSString *string = nil;
                    NSString *str = nil;
                    NSString *des = @"当前绑定手机号为";
                    string = [NSString stringWithFormat:@"%@", [dto objectForKey:@"user_login"]];
                    str = [NSString stringWithFormat:@"%@%@",des,string];
                    index = (int)[des length] ;
                    NSLog(@"%d",index);
                    NSLog(@"%@",str);
                    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
                    
                    [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
                    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
                    
                    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
                    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
                    
                    self.phoneLabel.attributedText = mutablestr;

                    
                    NSString *swa_bank = [dto objectForKey:@"swa_bank"];
                    if(![swa_bank isEqual:[NSNull null]] && swa_bank !=nil)
                    {
                        for (NSDictionary *temp in bankarray) {
                            if ([[temp objectForKey:@"code"] isEqualToString:[dto objectForKey:@"swa_bank"]]) {
                                self.bankNameTextField.text= [temp objectForKey:@"name"];
                                bankindex = [temp objectForKey:@"code"] ;
                            }
                        }
                    }
                    
                    districtindex = [dto objectForKey:@"swa_card_area"];
                    if(![districtindex isEqualToString:@""]){
                        [self analysis];
                    }
                    self.openBankNameTextField.text = [dto objectForKey:@"swa_bank_fullname"];
                    
                    NSString *swa_card_no = [dto objectForKey:@"swa_card_no"];
                    
                    if(![swa_card_no isEqual:[NSNull null]] && swa_card_no !=nil)
                    {
                        self.bacnkAccountTextField.text = [self normalNumToBankNum:[dto objectForKey:@"swa_card_no"]];
                    }

                    
                    
                    
                    if (self.gotoWhere == 1) {
                        self.sumTextField.userInteractionEnabled = NO;
                        self.sumTextField.text = [NSString stringWithFormat:@"%@", [dto objectForKey:@"swa_sum_str"]];
                    }
//                    [self fieldChanged];
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }failuer:^(NSError *error){
            //        NSLog(@"error-------->%@",error);
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            
        }];
    }
}

-(void)loadBankData{
    NSDictionary *dic = @{};
//    NSLog(@"dic---%@",dic);
    [[RequestManager shareRequestManager] GetlookupBankAllMapResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            bankarray = [[result objectForKey:@"data"] objectForKey:@"result"];
            [self loadData];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

#pragma mark - 按钮点击事件
//-(void)fieldChanged
//{
//    if (self.nameTextField.text.length != 0 && self.bankNameTextField.text.length != 0 && self.openBankNameTextField.text.length != 0 && self.sumTextField.text.length != 0 && self.bacnkAccountTextField.text.length != 0 && self.verifyTextField.text.length != 0) {
//        self.submitButton.enabled = YES;
//    }else{
//        self.submitButton.enabled = NO;
//    }
//}

// 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum:(NSString *)sumString
{
    return [sumString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalNumToBankNum:(NSString *)sumString
{
    NSString *tmpStr = [self bankNumToNormalNum:sumString];
    
    int size = (tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

-(void)pwdsubmit{
    
    show = [[WithdrawPwdShow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    // 确定按钮的点击
    [show.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [show.forgetPwdLabel addGestureRecognizer:tap1];
    [show.cancleBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [show showView];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [show.pwdTextField resignFirstResponder];
    
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
    vc.titles = @"重置提现密码";
    vc.isReturnMoneySubmitPage = 1;
    [self.navigationController pushViewController:vc animated:YES];
    [show dismissContactView];
    show.sureBtn.enabled = YES;
    self.verifyTextField.text = @"";
}

-(void)cancelAction{
    [show dismissContactView];
    self.submitButton.enabled =YES;
}

-(void)sureAction{
    show.sureBtn.enabled = NO;
    NSString *cardNumberString =
    [self bankNumToNormalNum:self.bacnkAccountTextField.text];
    if ([self.swa_id isEqualToString:@""]) {
        NSDictionary *dic = @{
                              @"swa_name":self.nameTextField.text,
                              @"swa_bank":bankindex,
                              @"swa_bank_fullname":self.openBankNameTextField.text,
                              @"swa_card_no":cardNumberString,
                              @"swa_sum":self.sumTextField.text,
                              @"swa_card_area":districtindex,
                              @"verifyCode":self.verifyTextField.text,
                              @"us_withdraw_pwd":[[RequestManager shareRequestManager] md5:show.pwdTextField.text],
                              };
        [[RequestManager shareRequestManager] ApplyWithdrawByCardDtoResultNew:dic viewController:self successData:^(NSDictionary *result){
            NSLog(@"result-------->%@",result);
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag != 99999){
                if(successFlag == 1){
                    [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                    show.attentionLabel.text = @"为了您的资金安全，请输入提现密码";
                    show.attentionLabel.textColor = FontUIColorBlack;
                    [show dismissContactView];
                }else{
                    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                        msgString =  [result objectForKey:@"msg"];
                        [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
                    }
                }
            }else{
                msgString = @"您提现的密码输入错误，请重新输入";
                [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
            }

        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.submitButton.enabled = YES;
            show.sureBtn.enabled = YES;
        }];
    }else{
        NSDictionary *dic = @{
                              @"swa_id":self.swa_id,
                              @"swa_bank":bankindex,
                              @"swa_bank_fullname":self.openBankNameTextField.text,
                              @"swa_card_no":cardNumberString,
                              @"swa_sum":self.sumTextField.text,
                              @"swa_card_area":districtindex,
                              @"verifyCode":self.verifyTextField.text,
                              @"us_withdraw_pwd":[[RequestManager shareRequestManager] md5:show.pwdTextField.text],
                              };
        [[RequestManager shareRequestManager] UpdateApplyWithdrawByCardDtoResultNew:dic viewController:self successData:^(NSDictionary *result){
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag != 99999){
                if(successFlag == 1){
                    [[RequestManager shareRequestManager] tipAlert:@"正在提交" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                    show.attentionLabel.text = @"为了您的资金安全，请输入提现密码";
                    show.attentionLabel.textColor = FontUIColorBlack;
                    [show dismissContactView];
                }else{
                    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
                        msgString =  [result objectForKey:@"msg"];
                        [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
                    }
                }
            }else{
                msgString = @"您提现的密码输入错误，请重新输入";
                [self performSelector:@selector(returnFailure) withObject:self afterDelay:2.0];
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.submitButton.enabled = YES;
            show.sureBtn.enabled = YES;
        }];
    }
}


-(void)submitBtnPressed:(UIButton *)sender{
    self.submitButton.enabled =NO;
    if (self.nameTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"收款人姓名 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    
    if (self.bankNameTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"收款人银行 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    
    if (self.openBankDistrictTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"开户行地区 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }

    if (self.openBankNameTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"开户行名称 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    
    if (self.bacnkAccountTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"银行卡卡号 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    
    if (self.sumTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"提现金额 请您检查并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    
    NSString *myString = self.sumTextField.text;
    
    if ([myString doubleValue]<=0) {
        [[RequestManager shareRequestManager] tipAlert:@"输入金额必须大于零" viewController:self];
        self.submitButton.enabled = YES;
        return;
    }
    
    if (self.verifyTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"验证码 请您获取并输入" viewController:self];
        sender.enabled = YES;
        return;
    }
    NSString *cardNumberString =
    [self bankNumToNormalNum:self.bacnkAccountTextField.text];
    if ([self.swa_id isEqualToString:@""]) {
        NSDictionary *dic = @{
                              @"swa_name":self.nameTextField.text,
                              @"swa_bank":bankindex,
                              @"swa_bank_fullname":self.openBankNameTextField.text,
                              @"swa_card_no":cardNumberString,
                              @"swa_sum":self.sumTextField.text,
                              @"swa_card_area":districtindex,
                              @"verifyCode":self.verifyTextField.text
                              };
        [[RequestManager shareRequestManager] ApplyWithdrawByCardDtoResultNew:dic viewController:self successData:^(NSDictionary *result){
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag == 10000){
                [self pwdsubmit];
                [self.verifyTextField resignFirstResponder];
                [show.pwdTextField becomeFirstResponder];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            self.submitButton.enabled = YES;
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.submitButton.enabled =YES;
        }];
    }else{
        NSDictionary *dic1 = @{
                               @"swa_id":self.swa_id,
                               @"swa_bank":bankindex,
                               @"swa_bank_fullname":self.openBankNameTextField.text,
                               @"swa_card_no":cardNumberString,
                               @"swa_sum":self.sumTextField.text,
                               @"swa_card_area":districtindex,
                               @"verifyCode":self.verifyTextField.text,
                               };
        
        [[RequestManager shareRequestManager] UpdateApplyWithdrawByCardDtoResultNew:dic1 viewController:self successData:^(NSDictionary *result){
            int successFlag = [[result objectForKey:@"flag"] intValue];
            if(successFlag == 10000){
                [self pwdsubmit];
                [self.verifyTextField resignFirstResponder];
                [show.pwdTextField becomeFirstResponder];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];                
            }
            self.submitButton.enabled = YES;
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            self.submitButton.enabled = YES;
        }];
    }
}

-(void)returnFailure{
    show.sureBtn.enabled = YES;
    show.attentionLabel.text = @"您提现的密码输入错误，请重新输入";
    show.attentionLabel.textColor = RedUIColorC1;
}

-(void)returnListPage{
    SubmitSuccessedViewController *vc = [[SubmitSuccessedViewController alloc] init];
    vc.titles = @"申请提现";

    vc.fromWhere = self.fromWhere;
    vc.isFromSettingpwdpage = self.isFromSettingpwdpage;
    [self.navigationController pushViewController:vc animated:YES];

    self.submitButton.enabled = YES;
    show.sureBtn.enabled = YES;
}

-(void)loginBtnPressed:(UIButton *)sender
{
    
    
    sender.enabled = NO;
//    if (self.bankNameTextField.text.length == 0) {
//        [[RequestManager shareRequestManager] tipAlert:@"所在银行 请您检查并输入" viewController:self];
//        sender.enabled = YES;
//        return;
//    }
//    if (self.openBankDistrictTextField.text.length == 0) {
//        [[RequestManager shareRequestManager] tipAlert:@"开户行地区 请您检查并输入" viewController:self];
//        sender.enabled = YES;
//        return;
//    }
//    if (self.openBankNameTextField.text.length == 0) {
//        [[RequestManager shareRequestManager] tipAlert:@"开户行名称 请您检查并输入" viewController:self];
//        sender.enabled = YES;
//        return;
//    }
//    if (self.bacnkAccountTextField.text.length == 0) {
//        [[RequestManager shareRequestManager] tipAlert:@"银行卡卡号 请您检查并输入" viewController:self];
//        sender.enabled = YES;
//        return;
//    }
//    if (self.sumTextField.text.length == 0) {
//        [[RequestManager shareRequestManager] tipAlert:@"提现金额 请您检查并输入" viewController:self];
//        sender.enabled = YES;
//        return;
//    }
    
    NSDictionary * dic = @{};
    
    [[RequestManager shareRequestManager] SendValidateCodeSmsByUserIdResult:dic viewController:self successData:^(NSDictionary *result){
        sender.enabled = YES;
        if(IsSucess(result)){
            self.codeButton.enabled = NO;
            self.count = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
        }else{
            //                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        sender.enabled = YES;
        [self showHint:[error networkErrorInfo]];
        
        //                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}


-(void)runClock{
    if (self.count != 1) {
        self.count -= 1;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode-dis"] forState:UIControlStateNormal];
        [self.codeButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        [self.codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
    } else {
        self.codeButton.enabled = YES;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode"] forState:UIControlStateNormal];
        [self.codeButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.count = 60;
        [self.timer invalidate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kWithdrawViewPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kWithdrawViewPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"收款人姓名" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.nameLabel.textColor = FontUIColorGray;
    }
    return _nameLabel;
}

-(UILabel *)bankNamLabel{
    if (_bankNamLabel == nil) {
        self.bankNamLabel = [CommentMethod initLabelWithText:@"收款人银行" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.bankNamLabel.textColor = FontUIColorGray;
    }
    return _bankNamLabel;
}


-(UILabel *)openBankDistrictLabel{
    if (_openBankDistrictLabel == nil) {
        self.openBankDistrictLabel = [CommentMethod initLabelWithText:@"开户行地区" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.openBankDistrictLabel.textColor = FontUIColorGray;
    }
    return _openBankDistrictLabel;
}

-(UILabel *)openBankNameLabel{
    if (_openBankNameLabel == nil) {
        self.openBankNameLabel = [CommentMethod initLabelWithText:@"开户行名称" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.openBankNameLabel.textColor = FontUIColorGray;
    }
    return _openBankNameLabel;
}

-(UILabel *)bankAccountLabel
{
    if (_bankAccountLabel == nil) {
        self.bankAccountLabel = [CommentMethod initLabelWithText:@"银行卡号" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.bankAccountLabel.textColor = FontUIColorGray;
    }
    return _bankAccountLabel;
}
-(UILabel *)sumLabel{
    if (_sumLabel == nil) {
        self.sumLabel = [CommentMethod initLabelWithText:@"提取金额" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.sumLabel.textColor = FontUIColorGray;
    }
    return _sumLabel;
}

-(UITextField *)nameTextField{
    if (_nameTextField == nil) {
        self.nameTextField = [UITextField new];
        self.nameTextField.placeholder = @"请输入收款人姓名";
        self.nameTextField.delegate = self;
        self.nameTextField.textAlignment = NSTextAlignmentRight;
        self.nameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.nameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.nameTextField.backgroundColor = [UIColor clearColor];
        self.nameTextField.textColor = FontUIColorGray;
        self.nameTextField.userInteractionEnabled = NO;
    }
    return _nameTextField;
}

-(UIImageView *)nameImageView{
    if (_nameImageView == nil) {
        self.nameImageView = [UIImageView new];
        self.nameImageView.image = [UIImage imageNamed:@"icon-invitation-no"];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        self.nameImageView.userInteractionEnabled = YES;
        [self.nameImageView addGestureRecognizer:tap3];
    }
    return _nameImageView;
}

-(void)onClick:(UITapGestureRecognizer *)sender{
    VerifyView *show = [[VerifyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.infoString = [NSString stringWithFormat:@"为了保证您的资金安全，您的个人银行卡账户注册姓名必须与实名认证姓名一致！"];
    [show showView];
}

-(UITextField *)bankNameTextField{
    if (_bankNameTextField == nil) {
        self.bankNameTextField = [UITextField new];
        self.bankNameTextField.placeholder = @"请选择收款人银行";
        self.bankNameTextField.userInteractionEnabled = NO;
        self.bankNameTextField.textAlignment = NSTextAlignmentRight;
        self.bankNameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.bankNameTextField.backgroundColor = [UIColor clearColor];
//        [self.bankNameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.bankNameTextField.textColor = FontUIColorGray;
    }
    return _bankNameTextField;
}

-(UIView *)openBankDistrictView{
    if (_openBankDistrictView == nil) {
        self.openBankDistrictView = [UIView new];
        self.openBankDistrictView.backgroundColor = [UIColor clearColor];
    }
    return _openBankDistrictView;
}

-(UIView *)bankNameView{
    if (_bankNameView == nil) {
        self.bankNameView = [UIView new];
        
        self.bankNameView.backgroundColor = [UIColor clearColor];
    }
    return _bankNameView;
}

-(UITextField *)openBankDistrictTextField{
    if (_openBankDistrictTextField == nil) {
        self.openBankDistrictTextField = [UITextField new];
        self.openBankDistrictTextField.placeholder = @"请选择开户行地区";
        self.openBankDistrictTextField.textAlignment = NSTextAlignmentRight;
        self.openBankDistrictTextField.delegate = self;
        self.openBankDistrictTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.openBankDistrictTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self.openBankDistrictTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.openBankDistrictTextField.backgroundColor = [UIColor clearColor];
        self.openBankDistrictTextField.textColor = FontUIColorGray;
    }
    return _openBankDistrictTextField;
}


-(UITextField *)openBankNameTextField{
    if (_openBankNameTextField == nil) {
        self.openBankNameTextField = [UITextField new];
        self.openBankNameTextField.placeholder = @"请输入开户行";
        self.openBankNameTextField.textAlignment = NSTextAlignmentRight;
        self.openBankNameTextField.delegate = self;
        self.openBankNameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.openBankNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self.openBankNameTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.openBankNameTextField.backgroundColor = [UIColor clearColor];
        self.openBankNameTextField.textColor = FontUIColorGray;
    }
    return _openBankNameTextField;
}

-(UITextField *)bacnkAccountTextField{
    if (_bacnkAccountTextField == nil) {
        self.bacnkAccountTextField = [UITextField new];
        self.bacnkAccountTextField.placeholder = @"请输入银行卡号";
        self.bacnkAccountTextField.delegate = self;
        self.bacnkAccountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.bacnkAccountTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.bacnkAccountTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.bacnkAccountTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.bacnkAccountTextField.textAlignment = NSTextAlignmentRight;
        self.bacnkAccountTextField.backgroundColor = [UIColor clearColor];
        self.bacnkAccountTextField.textColor = FontUIColorGray;
        self.bacnkAccountTextField.tag = 10012;
    }
    return _bacnkAccountTextField;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 10012) {
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        NSLog(@"newString--------%d",newString.length);
        if (newString.length >= 25) {
            return NO;
        }
        
        [textField setText:newString];
        
        return NO;
    }else if(textField == self.sumTextField)  {
 //       UITextField 限制用户输入小数点后位数的方法
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
            return NO;
        }
        //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4){
            return NO;
        }
    }
    return  YES;
}

-(UITextField *)sumTextField{
    if (_sumTextField == nil) {
        self.sumTextField = [UITextField new];
        self.sumTextField.placeholder = @"请输入提取金额";
        self.sumTextField.delegate = self;
        self.sumTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.sumTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.sumTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.sumTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.sumTextField.textColor = FontUIColorGray;
        self.sumTextField.textAlignment = NSTextAlignmentRight;
        self.sumTextField.backgroundColor = [UIColor clearColor];
        
    }
    return _sumTextField;
}


-(UIButton *)submitButton{
    if (_submitButton == nil ) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"btn-gray"] forState:UIControlStateDisabled];
         [self.submitButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"确认申请" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.submitButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _submitButton;
}


//颜色转换 背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIView *)bgview{
    if (_bgview == nil) {
        self.bgview = [UIView new];
        self.bgview.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight);
        self.bgview.backgroundColor = [UIColor whiteColor];
    }
    return _bgview;
}

-(UIView *)nameView{
    if (_nameView == nil) {
        self.nameView = [UIView new];
        self.nameView.backgroundColor = [UIColor clearColor];
    }
    return _nameView;
}

-(UIView *)openBankNameView{
    if (_openBankNameView == nil) {
        self.openBankNameView = [UIView new];
        self.openBankNameView.backgroundColor = [UIColor clearColor];
    }
    return _openBankNameView;
}

-(UIView *)bankAccountView{
    if (_bankAccountView == nil) {
        self.bankAccountView = [UIView new];
        self.bankAccountView.backgroundColor = [UIColor clearColor];
    }
    return _bankAccountView;
}

-(UIView *)sumView{
    if (_sumView == nil) {
        self.sumView = [UIView new];
        self.sumView.backgroundColor = [UIColor clearColor];
    }
    return _sumView;
}

-(UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"当前绑定手机号为:" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.phoneLabel.textColor = FontUIColorGray;
    }
    return _phoneLabel;
}

-(UITextField *)verifyTextField{
    if (_verifyTextField == nil) {
        self.verifyTextField = [UITextField new];
        self.verifyTextField.placeholder = @"输入验证码";
        self.verifyTextField.delegate = self;
        self.verifyTextField.textAlignment = NSTextAlignmentLeft;
        self.verifyTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.verifyTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.verifyTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.verifyTextField.backgroundColor = [UIColor clearColor];
        self.verifyTextField.textColor = FontUIColorGray;
        self.verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _verifyTextField;
}

-(UIButton *)codeButton{
    if (_codeButton == nil ) {
        self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.codeButton.userInteractionEnabled = YES;
        [self.codeButton setBackgroundImage:[UIImage imageNamed:@"btn-sendcode"] forState:UIControlStateNormal];
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        self.codeButton.tag =1001;
        [self.codeButton addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = FontUIColorBlack;
        self.timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        self.timeLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 18*AUTO_SIZE_SCALE_X;
    }
    return _timeLabel;
}

@end
