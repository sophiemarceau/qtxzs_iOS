//
//  enterpriseapplyControllerViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/31.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "enterpriseapplyControllerViewController.h"
#import "publicTableViewCell.h"
#import "enterprise1View.h"
#import "MOFSPickerManager.h"
#import "MyProjectViewController.h"
#import "FileUploadHelper.h"
#import "TOCropViewController.h"
#import "UIImageView+WebCache.h"
@interface enterpriseapplyControllerViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>{
    NSMutableArray *tradeArrray;
    NSString* tradeindex;
    NSString* districtindex;
    NSURL *refURL;
    NSString*_company_license,*_company_card;
    int imagetag;
    BOOL eyeshow;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong)UIButton *subButton;
@property (nonatomic,strong)UITableView *Tableview;
@property (nonatomic,strong)enterprise1View *HeaderView;
@property (nonatomic,strong)UIView *rightButton;
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style

@end

@implementation enterpriseapplyControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _company_license =@"";
    _company_card =@"";
    self.titles =@"企业账号申请";
    [self.view addSubview:self.Tableview];
    self.HeaderView.phoneContent.text = self.us_tel;
    [self initNavBarView];
    [self.view addSubview:self.subButton];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NameTaped:)];
    [self.HeaderView.nameView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LoginTaped:)];
    [self.HeaderView.loginNameView addGestureRecognizer:tap3];
        
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordTaped:)];
    [self.HeaderView.passwordView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [self.HeaderView.tradeView addGestureRecognizer:tap5];
    
    UITapGestureRecognizer * tap555 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    [self.HeaderView.districtView addGestureRecognizer:tap555];
    
    UITapGestureRecognizer * tap55 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EnNameTaped:)];
    [self.HeaderView.companyView addGestureRecognizer:tap55];
    
    UITapGestureRecognizer * tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EnContactTaped:)];
    [self.HeaderView.ENContactView addGestureRecognizer:tap6];
    
    UITapGestureRecognizer * tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ContactPhoneTaped:)];
    [self.HeaderView.contactPhoneView addGestureRecognizer:tap7];
    
    UITapGestureRecognizer * tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picureUpload:)];
    self.HeaderView.businesslicenceImageView.tag = 0;
    [self.HeaderView.businesslicenceImageView addGestureRecognizer:tap8];
    
    UITapGestureRecognizer * tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picureUpload:)];
    self.HeaderView.postcardImageView.tag = 1;
    [self.HeaderView.postcardImageView addGestureRecognizer:tap9];
    
    UITapGestureRecognizer * tap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EyeTaped:)];
    
    [self.HeaderView.eyeView addGestureRecognizer:tap10];
    
    [self initTrade];
    eyeshow = NO;
//    [self.HeaderView.postcardImageView setImageWithURL:[NSURL URLWithString:@"http://profile-pic.qtxzs.com/e/20170607/49cbf029-c0f0-4d7e-b210-82072205dc00.jpg"] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
}

-(void)NameTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
    [self.HeaderView.nameContent becomeFirstResponder];
}

-(void)LoginTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.loginNameContent becomeFirstResponder];
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
}

-(void)passwordTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.passwordContent becomeFirstResponder];
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
}

-(void)EnNameTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.companyNameContent becomeFirstResponder];
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
}
-(void)EnContactTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.ENContactContent becomeFirstResponder];
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];

}

-(void)ContactPhoneTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.contactPhoneContent becomeFirstResponder];
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];

    NSMutableArray *tradeList = [NSMutableArray new];
    for (NSDictionary *temp in tradeArrray) {
        [tradeList addObject:[temp objectForKey:@"name"]];
    }
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradeList tag:10 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        self.HeaderView.tradeContent.text = string;
        for (NSDictionary *temp in tradeArrray) {
            if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                tradeindex = [temp objectForKey:@"code"] ;
                break;
            }
        }
        
    } cancelBlock:^{
        
    }];
}

-(void)disTaped:(UITapGestureRecognizer *)sender
{
    [self.HeaderView.nameContent resignFirstResponder];
    [self.HeaderView.loginNameContent resignFirstResponder];
    [self.HeaderView.passwordContent resignFirstResponder];
    [self.HeaderView.companyNameContent resignFirstResponder];
    [self.HeaderView.ENContactContent resignFirstResponder];
    [self.HeaderView.contactPhoneContent resignFirstResponder];
    [self.HeaderView.remarkView resignFirstResponder];
    
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
        self.HeaderView.districtContent.text = address;
        
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex =temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];
}

-(void)EyeTaped:(UITapGestureRecognizer *)sender
{
    
    eyeshow = !eyeshow;
    if (eyeshow) { // 按下去了就是明文
        [self.HeaderView.eyeImageView setImage:[UIImage imageNamed:@"btn_enterprise_review_display_password"]];
        NSString *tempPwdStr = self.HeaderView.passwordContent.text;
        self.HeaderView.passwordContent.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.HeaderView.passwordContent.secureTextEntry = NO;
        self.HeaderView.passwordContent.text = tempPwdStr;
    } else { // 暗文
        [self.HeaderView.eyeImageView setImage:[UIImage imageNamed:@"btn_enterprise_review_hidden_password"]];
        NSString *tempPwdStr = self.HeaderView.passwordContent.text;
        self.HeaderView.passwordContent.text = @"";
        self.HeaderView.passwordContent.secureTextEntry = YES;
        self.HeaderView.passwordContent.text = tempPwdStr;
    }
}


-(void)rightClick{
    [MobClick event:kApplyEnterpriseServicePhoneEvent];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009001135"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
     
                             completionHandler:^(BOOL success) {
                                 
                                 //                       NSLog(@"Open  %d",success);
                                 
                             }];
}


#pragma 判断输入是否是手机号码
-(Boolean)valiMobile:(NSString *)mobile{
    
    if (mobile.length < 11)
    {
        return NO;
    }else{
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
            
        }else{
            return NO;
        }
    }
    
}

-(void)dButtonClick{
    

    [MobClick event:kFromEnterpriseApplySubmitEvent];
    self.subButton.enabled = NO ;
    if (self.HeaderView.nameContent.text.length==0||
        self.HeaderView.loginNameContent.text.length==0||
        self.HeaderView.passwordContent.text.length==0 ||
        self.HeaderView.companyNameContent.text.length==0||
        self.HeaderView.districtContent.text.length==0||
        self.HeaderView.tradeContent.text.length==0||
        self.HeaderView.ENContactContent.text.length==0||
        self.HeaderView.remarkView.text.length==0||
        self.HeaderView.contactPhoneContent.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }

    if (_company_card.length == 0 ) {
        if (_company_license.length ==0) {
            [[RequestManager shareRequestManager] tipAlert:@"个人名片与营业执照至少选其一，请您检查并上传" viewController:self];
            self.subButton.enabled = YES ;
            return;
        }
    }
    
    if (self.HeaderView.nameContent.text.length > 15) {
        [[RequestManager shareRequestManager] tipAlert:@"您的姓名，不能超过15个汉字 请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    
    if ( [self judgePassWordLegal:self.HeaderView.loginNameContent.text] == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"您的用户名必须为4-16位字母和数字,以字母开头 请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    
    if (self.HeaderView.passwordContent.text.length > 20 || self.HeaderView.passwordContent.text.length < 6) {
        [[RequestManager shareRequestManager] tipAlert:@"您的密码，必须为6-20位 请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    
    if (self.HeaderView.companyNameContent.text.length > 15) {
        [[RequestManager shareRequestManager] tipAlert:@"企业名称，不能超过15个汉字 请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    
    if (self.HeaderView.contactPhoneContent.text.length != 11) {
        [[RequestManager shareRequestManager] tipAlert:@"您的联系人手机号应为11位，请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    if (![self valiMobile:self.HeaderView.contactPhoneContent.text]) {
        [[RequestManager shareRequestManager] tipAlert:@"您的联系人手机号不正确，请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    
    if (self.HeaderView.companyNameContent.text.length > 20) {
        [[RequestManager shareRequestManager] tipAlert:@"企业简介，应20个汉字以内 请您检查并输入" viewController:self];
        self.subButton.enabled = YES ;
        return;
    }
    NSLog(@"dic----->%@",self.HeaderView.loginNameContent.text);
    NSLog(@"dic----->%@",self.HeaderView.nameContent.text);
    NSLog(@"dic----->%@",self.HeaderView.passwordContent.text);
    NSLog(@"dic----->%@",self.HeaderView.companyNameContent.text);
    NSLog(@"dic----->%@",tradeindex);
    NSLog(@"dic----->%@",districtindex);
    NSLog(@"dic----->%@",self.HeaderView.ENContactContent.text);
    NSLog(@"dic----->%@",self.HeaderView.companyNameContent.text);
    NSLog(@"dic----->%@",self.HeaderView.remarkView.text);
    NSLog(@"dic----->%@",_company_license);
    NSLog(@"dic----->%@",_company_card);
    NSDictionary *dic = @{
                          @"staff_login":self.HeaderView.loginNameContent.text,
                          @"staff_name":self.HeaderView.nameContent.text,
                          @"staff_password":[[RequestManager shareRequestManager] md5:self.HeaderView.passwordContent.text],
                          @"company_name":self.HeaderView.companyNameContent.text,
                          @"company_area":districtindex,
                          @"company_industry":tradeindex,
                          @"company_contact":self.HeaderView.ENContactContent.text,
                          @"company_tel":self.HeaderView.contactPhoneContent.text,
                          @"company_desc":self.HeaderView.remarkView.text,
                          @"_company_license":_company_license,
                          @"_company_card":_company_card,
                          };
    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] CreateCompanyAccountAndInformationResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"正在提交中" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subButton.enabled = YES;
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subButton.enabled = YES;
    }];

}

-(void)returnListPage{
    
    MyProjectViewController *vc = [[MyProjectViewController alloc] init];
    vc.isFromtEnterprisePage = 1;
    [self.navigationController pushViewController:vc animated:YES];
    self.subButton.enabled = YES;

}


-(void)initTrade{
    tradeArrray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetLookupIndustryMapResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (array !=nil) {
                NSMutableArray *indusArray = [NSMutableArray arrayWithObject:
                                              @{
                                                @"code":@"",
                                                @"name":@"综合行业",
                                               
                                                }
                                              ];
                [tradeArrray addObjectsFromArray:indusArray];

                [tradeArrray addObjectsFromArray:array];
            }
            
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        //        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 4){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{4,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

-(void)picureUpload:(UITapGestureRecognizer *)sender{
    imagetag = [[sender view] tag];
    

    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self useCamera];
        }];
        
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self usePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:addPhoneAction];
        [actionSheet addAction:photoAction];
        [actionSheet addAction:cancelAction];
        [self presentViewController:actionSheet animated:true completion:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相薄选择",@"拍照", nil];
        [actionSheet showInView:self.view];
#pragma clang diagnostic pop
        
    }
}
-(void)useCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setDelegate:self];
        [imgPicker setAllowsEditing:NO];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
        imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
        [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
        //            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    else
    {
        [self showAlertView:nil message:@"该设备没有照相机"];
    }
    
}
-(void)usePhoto{
    //照片来源为相册
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    self.croppingStyle = TOCropViewCroppingStyleDefault;
    //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
    imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
    [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
    
    //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    [self presentViewController:imgPicker animated:YES completion:nil];
}
- (void)showAlertView:(NSString *)title message:(NSString *)msg
{
    CHECK_DATA_IS_NSNULL(title, NSString);
    CHECK_STRING_IS_NULL(title);
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:msg
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * publicCell = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = C2UIColorGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
    
    cropController.delegate = self;
    
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The
    
    // -- Uncomment the following lines of code to test out the aspect ratio features --
    //cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare; //Set the initial aspect ratio as a square
    //cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    //cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    
    // -- Uncomment this line of code to place the toolbar at the top of the view controller --
    // cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    
    self.image = image;
    
    //If profile picture, push onto the same navigation stack
    if (self.croppingStyle == TOCropViewCroppingStyleCircular) {
        [picker pushViewController:cropController animated:YES];
    }
    else { //otherwise dismiss, and then present from the main controller
        [picker dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:cropController animated:YES completion:nil];
        }];
    }
    
    refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        img =image;
        
        
        
        img = [img fixOrientation];
        NSString *fileName = [imageRep filename];
        
        if (fileName == nil)
        {
            // 要上传保存在服务器中的名称
            // 使用时间来作为文件名 2014-04-30 14:20:57.png
            // 让不同的用户信息,保存在不同目录中
            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //            // 设置日期格式
            //            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            //            NSString *Name = [formatter stringFromDate:[NSDate date]];
            //
            //            fileName = [NSString stringWithFormat:@"%@%@", Name,@".jpg"];
            fileName = @"tempcapt.jpg";
        }
        //        NSLog(@"fileName--------%@",fileName);
        NSString *localFile = [FileUploadHelper PreUploadImagePath:img AndFileName:fileName];
        if([localFile isEqualToString:@""])
        {
            [self showHint:@"图片获取失败"];
            return;
        }
        //        NSLog(@"localFile--------%@",localFile);
        //        NSString *pathext = [NSString stringWithFormat:@".%@",[localFile pathExtension]];
        //        pathext = [pathext lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSData *imageData = [NSData dataWithContentsOfFile:localFile];
        
        NDLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{
                              
                              };
        
        
        [[RequestManager shareRequestManager] UploadCompFileUploadImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            NSLog(@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]);
            if (imagetag ==1) {
//                [self.HeaderView.postcardImageView setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
                [self.HeaderView.postcardImageView setContentMode:UIViewContentModeScaleAspectFit];
                [self.HeaderView.postcardImageView setImage:image];
                self.HeaderView.plusImageView2.hidden = YES;
                self.HeaderView.imageLabel2.hidden = YES;
                _company_card = [[result objectForKey:@"data"] objectForKey:@"url"];
            }else{
//                [self.HeaderView.businesslicenceImageView setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
                [self.HeaderView.businesslicenceImageView setContentMode:UIViewContentModeScaleAspectFit];
                [self.HeaderView.businesslicenceImageView setImage:image];
                self.HeaderView.plusImageView1.hidden = YES;
                self.HeaderView.imageLabel1.hidden = YES;
                _company_license = [[result objectForKey:@"data"] objectForKey:@"url"];
            }
//            [self.photoArrayM addObject:[[result objectForKey:@"data"] objectForKey:@"url"]];
            //选取完图片之后关闭视图
            //            NSLog(@"phtotArrayM----%@",self.photoArrayM);
            [self viewWillAppear:YES];
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
            
            //        failView.hidden = NO;
        }];
        
        
        //发送更新头像的通知
        
        
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UITableView *)Tableview{
    if (_Tableview == nil) {
        self.Tableview = [[UITableView alloc] init];
        self.Tableview.delegate = self;
        self.Tableview.dataSource = self;
        self.Tableview.bounces = NO;
        //    myTableView.rowHeight = 300;
        self.Tableview.showsVerticalScrollIndicator = NO;
        self.Tableview.backgroundColor = BGColorGray;
        [self.Tableview setFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-ktabFootHeight)];
        [self.Tableview setTableHeaderView:self.HeaderView];
    }
    return _Tableview;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kEnterprisePage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kEnterprisePage];
}

-(void)initNavBarView{
    [self.navView addSubview:self.rightButton];
    
}

- (UIView *)rightButton {
    if (_rightButton == nil) {
        self.rightButton = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-35, 20, 35, 44)];
        self.rightButton.userInteractionEnabled = YES;
        self.rightButton.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * buttonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)];
        [self.rightButton addGestureRecognizer:buttonTap];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,12, 20, 20)];
        imv.image = [UIImage imageNamed:@"btn_enterprise_review_customer_service"];
        [self.rightButton addSubview:imv];
        [self.navView addSubview:self.rightButton];
    }
    return _rightButton;
}

-(UIButton *)subButton{
    if (_subButton ==nil) {
        self.subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.subButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.subButton setTintColor:[UIColor whiteColor]];
        [self.subButton setBackgroundColor:RedUIColorC1];
        self.subButton.userInteractionEnabled = YES;
        [self.subButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        self.subButton.layer.cornerRadius = 22*AUTO_SIZE_SCALE_X;
        self.subButton.enabled = YES;
        self.subButton.frame = CGRectMake(0, kScreenHeight-ktabFootHeight, kScreenWidth, ktabFootHeight);
    }
    return _subButton;
}

- (UIView *)HeaderView {
    if (_HeaderView == nil) {
        self.HeaderView = [enterprise1View new];
        self.HeaderView.frame = CGRectMake(0, 0, kScreenWidth, (15+55*4+10+55*5+10+97.5+10+267.5+10+291+15)*AUTO_SIZE_SCALE_X
                                           );
    }
    return _HeaderView;
}



@end
