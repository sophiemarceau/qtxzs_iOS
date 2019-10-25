//
//  ClientInformationViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/11/6.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ClientInformationViewController.h"
#import "UIImageView+WebCache.h"
#import "FileUploadHelper.h"

@interface ClientInformationViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    NSString *_us_photo;
}
@property (nonatomic,strong) UIView *bgview;
@property (nonatomic,strong) UILabel *headLabel;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *line1ImageView;
@property (nonatomic,strong) UIView *headview;
@property (nonatomic,strong) UILabel *nickLabel;
@property (nonatomic,strong) UITextField *nickTextField;
@property (nonatomic,strong) UIImageView *line2ImageView;
@property (nonatomic,strong) UILabel *companyLabel;
@property (nonatomic,strong) UITextField *compayTextField;
@property (nonatomic,strong) UIImageView *line3ImageView;
@property (nonatomic,strong) UILabel *positionLabel;
@property (nonatomic,strong) UITextField *positionTextField;

@property (nonatomic,strong) UIButton *saveButton;
@end

@implementation ClientInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgview];
    [self.view addSubview:self.saveButton];
    
    [self.bgview addSubview:self.headLabel];
    [self.bgview addSubview:self.headImageView];
    [self.bgview addSubview:self.line1ImageView];
    [self.bgview addSubview:self.headview];
    
    [self.bgview addSubview:self.nickLabel];
    [self.bgview addSubview:self.nickTextField];
    [self.bgview addSubview:self.line2ImageView];
    
    [self.bgview addSubview:self.companyLabel];
    [self.bgview addSubview:self.compayTextField];
    [self.bgview addSubview:self.line3ImageView];
    
    [self.bgview addSubview:self.positionLabel];
    [self.bgview addSubview:self.positionTextField];
    
    
    self.headLabel.frame = CGRectMake(15, 0, 50*AUTO_SIZE_SCALE_X, 132/2*AUTO_SIZE_SCALE_X+1);
    self.headImageView.frame = CGRectMake(kScreenWidth-15-40*AUTO_SIZE_SCALE_X,
                                          (132/2*AUTO_SIZE_SCALE_X+1-40*AUTO_SIZE_SCALE_X)/2,
                                          40*AUTO_SIZE_SCALE_X,
                                          40*AUTO_SIZE_SCALE_X);
    self.line1ImageView.frame = CGRectMake(15, self.headLabel.frame.size.height-1, kScreenWidth-15, 0.5);
    
    self.nickLabel.frame  = CGRectMake(15, self.headLabel.frame.origin.y+self.headLabel.frame.size.height, 50*AUTO_SIZE_SCALE_X, 132/2*AUTO_SIZE_SCALE_X+1);
    self.nickTextField.frame = CGRectMake(kScreenWidth/2, self.headLabel.frame.size.height+self.headLabel.frame.origin.y, kScreenWidth/2-15, 132/2*AUTO_SIZE_SCALE_X+1);
    self.line2ImageView.frame = CGRectMake(15, self.headLabel.frame.origin.y+self.headLabel.frame.size.height+self.nickLabel.frame.size.height-1,  kScreenWidth-15, 0.5);

    self.companyLabel.frame = CGRectMake(15, self.nickTextField.frame.origin.y+self.nickTextField.frame.size.height, 50*AUTO_SIZE_SCALE_X, 132/2*AUTO_SIZE_SCALE_X+1);
    self.compayTextField.frame = CGRectMake(kScreenWidth/2,  self.nickTextField.frame.origin.y+self.nickTextField.frame.size.height, kScreenWidth/2-15, 132/2*AUTO_SIZE_SCALE_X+1);
    self.line3ImageView.frame = CGRectMake(15, self.compayTextField.frame.origin.y+self.compayTextField.frame.size.height-1,  kScreenWidth-15, 0.5);

    self.positionLabel.frame = CGRectMake(15, self.companyLabel.frame.origin.y+self.companyLabel.frame.size.height, 50*AUTO_SIZE_SCALE_X, 132/2*AUTO_SIZE_SCALE_X+1);
    self.positionTextField.frame = CGRectMake(kScreenWidth/2,  self.compayTextField.frame.origin.y+self.compayTextField.frame.size.height,  kScreenWidth/2-15, 132/2*AUTO_SIZE_SCALE_X+1);
    
    self.bgview.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.positionLabel.frame.origin.y+self.positionLabel.frame.size.height);
    
    self.saveButton.frame = CGRectMake(15, self.bgview.frame.size.height+self.bgview.frame.origin.y+20*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
    
    [self initData];
    

}

-(void)initData{

    NSDictionary *dic = @{
                          
                          
                                                    };
    
    
    [[RequestManager shareRequestManager] GetUserDetailResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            if (result != nil) {
                NSDictionary *dto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                [self.headImageView setImageWithURL:[NSURL URLWithString:[dto objectForKey:@"us_photo"]] placeholderImage:[UIImage imageNamed:@"img-defult-account"]];
                 _us_photo = [dto objectForKey:@"us_photo"];
                
                self.nickTextField.text = [dto objectForKey:@"us_nickname"];
                self.compayTextField.text = [dto objectForKey:@"us_company"];
                self.positionTextField.text = [dto objectForKey:@"us_jobtitle"];
                           }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];

}

-(void)saveBtnPressed:(UIButton *)sender{
    self.saveButton.enabled = NO;
    if (self.nickTextField.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"昵称不能为空，请您填写" viewController:self];
        self.saveButton.enabled = YES;
        return;
    }

    NSDictionary *dic = @{
                          
                          @"us_nickname":self.nickTextField.text ,
                          @"_us_photo":_us_photo,
                          @"_us_company":self.compayTextField.text,
                          @"_us_jobtitle":self.positionTextField.text,
                          
                                                   };
    
    
    [[RequestManager shareRequestManager] UpdateUserSalesmanInfoResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            if (result != nil) {
                 //发送更新头像的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserIconUpdate object:nil];
                [[RequestManager shareRequestManager] tipAlert:@"修改成功" viewController:self];
                [self performSelector:@selector(returnListPage:) withObject:self afterDelay:2.0];
                
                [MobClick event:kMyAccountSaveSubmitOnClickEvent];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.saveButton.enabled = YES;
        }
//        sender.enabled = YES;
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.saveButton.enabled = YES;
    }];
}

-(void)returnListPage:(UIButton *)sender{
    self.saveButton.enabled = YES;
    //    [self.delegate addSuccessReturnClientPage];
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheet Delegate
- (void)photoMethod
{
    UIActionSheet * acSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"关闭"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [acSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        //照片来源为相册
        UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imgPicker setDelegate:self];
        [imgPicker setAllowsEditing:YES];
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
        imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
        [imgPicker.navigationBar setBarTintColor:RedUIColorC1];

//        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        [self presentViewController:imgPicker animated:YES completion:nil];

    }
    if(buttonIndex == 1)
    {
        

        //照片来源为相机
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
#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        
        
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
      
     
        [[RequestManager shareRequestManager] SubmitImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
//            NSLog(@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]);
            [self.headImageView setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            self.headImageView.backgroundColor = [UIColor blueColor];
            _us_photo = [[result objectForKey:@"data"] objectForKey:@"url"];
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
            
            //        failView.hidden = NO;
        }];
        
        
        //发送更新头像的通知
        
        
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^(void)
     {
         //         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
         
         
     }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event response
- (void)onUserImageClick:(UITapGestureRecognizer *)sender
{
    [self photoMethod];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kAccountManagePage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAccountManagePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UIView *)bgview{
    if (_bgview == nil) {
        _bgview = [UIView new];
        
        _bgview.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgview;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.image =[UIImage imageNamed:@"img-defult-account"];

        self.headImageView.layer.cornerRadius = 20.0*AUTO_SIZE_SCALE_X;
        self.headImageView.layer.borderWidth=1.0;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
        [self.headImageView addGestureRecognizer:singleTap];

    }
    return _headImageView;
}

- (UILabel *)headLabel {
    if (_headLabel == nil) {
        self.headLabel = [CommentMethod initLabelWithText:@"头像" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.headLabel.textColor = FontUIColorBlack;
    }
    return _headLabel;
}


- (UIImageView *)line1ImageView {
    if (_line1ImageView == nil) {
        self.line1ImageView = [UIImageView new];
        self.line1ImageView.backgroundColor = lineImageColor;
        
    }
    return _line1ImageView;
}


-(UIView *)headview{
    if (_headview == nil) {
        _headview = [UIView new];
        
        _headview.backgroundColor = [UIColor whiteColor];
        
    }
    return _headview;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        self.nickLabel = [CommentMethod initLabelWithText:@"昵称" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.nickLabel.textColor = FontUIColorBlack;
    }
    return _nickLabel;
}

-(UITextField *)nickTextField{
    if (_nickTextField == nil) {
        self.nickTextField = [UITextField new];
        self.nickTextField.placeholder = @"请输入昵称";
        self.nickTextField.delegate = self;
        self.nickTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.nickTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.nickTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.nickTextField.backgroundColor = [UIColor clearColor];
        self.nickTextField.textAlignment = NSTextAlignmentRight;
        
    }
    return _nickTextField;
}


- (UIImageView *)line2ImageView {
    if (_line2ImageView == nil) {
        self.line2ImageView = [UIImageView new];
        
        self.line2ImageView.backgroundColor = lineImageColor;
    }
    return _line2ImageView;
}

- (UILabel *)companyLabel {
    if (_companyLabel == nil) {
        self.companyLabel = [CommentMethod initLabelWithText:@"公司" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.companyLabel.textColor = FontUIColorBlack;
    }
    return _companyLabel;
}

-(UITextField *)compayTextField{
    if (_compayTextField == nil) {
        self.compayTextField = [UITextField new];
        self.compayTextField.placeholder = @"请输入公司";
        self.compayTextField.delegate = self;
        self.compayTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.compayTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.compayTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.compayTextField.backgroundColor = [UIColor clearColor];
        self.compayTextField.textAlignment = NSTextAlignmentRight;
        
    }
    return _compayTextField;
}


- (UIImageView *)line3ImageView {
    if (_line3ImageView == nil) {
        self.line3ImageView = [UIImageView new];
        
        self.line3ImageView.backgroundColor = lineImageColor;
    }
    return _line3ImageView;
}


- (UILabel *)positionLabel {
    if (_positionLabel == nil) {
        self.positionLabel = [CommentMethod initLabelWithText:@"职位" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.positionLabel.textColor = FontUIColorBlack;
    }
    return _positionLabel;
}

-(UITextField *)positionTextField{
    if (_positionTextField == nil) {
        self.positionTextField = [UITextField new];
        self.positionTextField.placeholder = @"请输入职位";
        self.positionTextField.delegate = self;
        self.positionTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.positionTextField.clearButtonMode = UITextFieldViewModeNever;
//        [self.positionTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
        self.positionTextField.backgroundColor = [UIColor clearColor];
        self.positionTextField.textAlignment = NSTextAlignmentRight;

        
    }
    return _positionTextField;
}

-(UIButton *)saveButton{
    if (_saveButton == nil ) {
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.saveButton addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
