//
//  ReviewPersonalInfoViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ReviewPersonalInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "FileUploadHelper.h"
#import "SubmitView.h"
#import "ShowReviewView.h"
#import "ClientReview.h"
#import "WithdrawViewController.h"
#import "TOCropViewController.h"
#import "AlipayWithdrawViewController.h"
#import "SettingPwdViewController.h"

@interface ReviewPersonalInfoViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,TOCropViewControllerDelegate>{
    NSDictionary *DataDic;
    NSString *_us_photo;
    UIButton *submitButton;
    NSURL *refURL;
}
@property (nonatomic,strong)UILabel *attentionLabel;
@property (nonatomic,strong)ClientReview *clientView;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UIView *headBGView;
@property (nonatomic,strong)UILabel *headBGLabel;
@property (nonatomic,strong)SubmitView *subview;
@property (nonatomic,strong)UITableView *Tableview;
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)UILabel *desc1Label;
@property (nonatomic,assign)TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation ReviewPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCheckPersonalInfomation object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoMethod) name:kCheckPersonalInfomation object:nil];
    self.view.backgroundColor = BGColorGray;
    
    [self.view addSubview:self.Tableview];
    [self.HeaderView addSubview:self.attentionLabel];
    [self.HeaderView addSubview:self.clientView];
  
    [self.HeaderView addSubview:self.headBGView];
    [self.HeaderView addSubview:self.subview];
    [self.headBGView addSubview:self.headImageView];
    [self.headImageView addSubview:self.headBGLabel];
    [self.HeaderView addSubview:self.desc1Label];
    
    
    self.attentionLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 50*AUTO_SIZE_SCALE_X);
    self.clientView.frame = CGRectMake(0, self.attentionLabel.frame.origin.y+self.attentionLabel.frame.size.height,kScreenWidth, self.clientView.frame.size.height);
    self.headBGView.frame = CGRectMake(0, self.clientView.frame.size.height+self.clientView.origin.y+10*AUTO_SIZE_SCALE_X, kScreenWidth, 578/2*AUTO_SIZE_SCALE_X);
    self.headImageView.frame = CGRectMake(15, 15, kScreenWidth-30, self.headBGView.frame.size.height-30);
    self.headBGLabel.frame = CGRectMake(0, self.headImageView.frame.size.height - 50*AUTO_SIZE_SCALE_X, self.headImageView.frame.size.width, 25*AUTO_SIZE_SCALE_X);
    self.subview.frame = CGRectMake(0, self.headBGView.frame.origin.y+self.headBGView.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);
   
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.subview.frame.origin.y+self.subview.frame.size.height+35*AUTO_SIZE_SCALE_X, 125*AUTO_SIZE_SCALE_X, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [self.HeaderView  addSubview:lineImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineImageView.frame.origin.x+lineImageView.frame.size.width, self.subview.frame.origin.y+self.subview.frame.size.height+20*AUTO_SIZE_SCALE_X, 190/2*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X)];
    titleLabel.text = @"说  明";
    titleLabel.textColor = FontUIColorGray;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    [self.HeaderView addSubview:titleLabel];
    UIImageView *lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, self.subview.frame.origin.y+self.subview.frame.size.height+35*AUTO_SIZE_SCALE_X, 125*AUTO_SIZE_SCALE_X, 0.5)];
    lineImageView1.backgroundColor = lineImageColor;
    [self.HeaderView  addSubview:lineImageView1];
    
    
    self.desc1Label.frame = CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+25*AUTO_SIZE_SCALE_X,kScreenWidth-30, 0);
    [self.desc1Label sizeToFit];
    self.desc1Label.frame = CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+25*AUTO_SIZE_SCALE_X,kScreenWidth-30, self.desc1Label.frame.size.height);
    [self.HeaderView setFrame:CGRectMake(0, 0, kScreenWidth, self.desc1Label.frame.origin.y+self.desc1Label.frame.size.height+60*AUTO_SIZE_SCALE_X)];
    
    [self.Tableview setTableHeaderView:self.HeaderView];

}

#pragma mark - event response
- (void)onUserImageClick:(UITapGestureRecognizer *)sender
{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    ShowReviewView *show = [[ShowReviewView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.noteString = @"请您按照下面示意图片 拍摄或上传认证图片";
    [show showView];
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
        
        UIImagePickerController *standardPicker = [[UIImagePickerController alloc] init];
        standardPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        standardPicker.allowsEditing = NO;
        standardPicker.delegate = self;
        
        self.croppingStyle = TOCropViewCroppingStyleDefault;

        //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
        standardPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
        [standardPicker.navigationBar setBarTintColor:RedUIColorC1];
        
        //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        [self presentViewController:standardPicker animated:YES completion:nil];
        
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
        
        NSData *imageData = [NSData dataWithContentsOfFile:localFile];
        
        NDLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};
        [[RequestManager shareRequestManager] SubmitImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            [self.headImageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.headImageView setImage:image];
            self.headBGLabel.hidden = YES;
            _us_photo = [[result objectForKey:@"data"] objectForKey:@"url"];
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
            self.headBGLabel.hidden = NO;
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

#pragma mark 提交
-(void)submitBtnPressed:(UIButton *)sender
{
    self.subview.subButton.enabled = NO;
    if (self.clientView.clientNameContent.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"姓名不能为空，请您输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    if (self.clientView.PhoneContent.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"身份证号码不能为空，请您输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    int flag = [self Chk18PaperId:self.clientView.PhoneContent.text];
    if (flag==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您输入的身份证号码有误，请您重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if (self.clientView.PhoneContent.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"身份证号码不能为空，请您输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if (_us_photo.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请您上传身份证照片后，再提交" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
   
    NSDictionary *dic = @{
                          @"us_realname":self.clientView.clientNameContent.text,
                          @"us_id_number":self.clientView.PhoneContent.text,
                          @"us_id_photo":_us_photo,
                          };
    [[RequestManager shareRequestManager] SalesmanSubmitIDInfoResult:dic viewController:self successData:^(NSDictionary *result){
        NSLog(@"error----result---->%@",result);
        if(IsSucess(result)){
            
            if (result !=nil) {
                [[RequestManager shareRequestManager] tipAlert:@"提交成功，我们会尽快审核您的认证信息" viewController:self];
                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subview.subButton.enabled = YES;
        }
//        sender.enabled = YES;
    }failuer:^(NSError *error){
        //        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subview.subButton.enabled = YES;
    }];
}

-(void)returnListPage{
    NSArray * ctrlArray = self.navigationController.viewControllers;
//    NSLog(@"gotoWhere------>%ld",self.gotoWhere);
    if (self.IsWithDrawPwdFlag == 0){
        SettingPwdViewController *vc = [[SettingPwdViewController alloc] init];
        vc.titles = @"设置提现密码";
        vc.fromWhere = 1;
        vc.gotoWhere = self.gotoWhere;
        [self.navigationController setViewControllers:@[ctrlArray[0],ctrlArray[1],vc] animated:YES];
        return ;
    }
    
    
    if (self.gotoWhere == 0) {
        AlipayWithdrawViewController *vc = [[AlipayWithdrawViewController alloc] init];
        vc.titles = @"支付宝提现";
        vc.swa_id = @"";
    
        if (self.fromWhere == 1) {
            vc.fromWhere = 1;
        }
        if (self.fromWhere == 2) {
            vc.swa_id = [NSString stringWithFormat:@"%d",self.swa_id];
            vc.fromWhere = 2;
            vc.gotoWhere =1;// gotowhere  修改提现 的时候 传1
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WithdrawViewController *vc = [[WithdrawViewController alloc] init];
        vc.titles = @"个人银行卡提现";
        vc.swa_id = @"";
        
        
        if (self.fromWhere == 1) {
            vc.fromWhere = 1;
        }
        if (self.fromWhere == 2) {
            vc.swa_id = [NSString stringWithFormat:@"%d",self.swa_id];
            vc.fromWhere = 2;
            vc.gotoWhere =1;// gotowhere  修改提现 的时候 传1
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    self.subview.subButton.enabled = YES;
}

-(void)setAuthDictionary:(NSDictionary *)authDictionary{
    
    int wetherFlag = [[authDictionary objectForKey:@"us_id_status_code"] intValue];
    if (wetherFlag == 3 ||wetherFlag == 1) {
        self.clientView.clientNameContent.text = [authDictionary objectForKey:@"us_realname"];
        self.clientView.PhoneContent.text = [authDictionary objectForKey:@"us_id_number"];
        _us_photo = [authDictionary objectForKey:@"us_id_photo"];
        [self.headImageView setImageWithURL:[NSURL URLWithString:[authDictionary objectForKey:@"us_id_photo"]]];
        if(![_us_photo isEqualToString:@""]){
            self.headBGLabel.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

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
   
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kReviewPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kReviewPage];
}

-(BOOL)Chk18PaperId:(NSString *)IDCardNumber
{
    if ([IDCardNumber length] < 15 ||[IDCardNumber length] > 18) {
        return NO;
    }
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCardNumber length] != 18){
        return NO;
    }

    NSString *regex = [NSString stringWithFormat:@"%@", @"^(\\d{15})|^(\\d{17}([0-9]|X|x))$"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:IDCardNumber]){
        return NO;
    }else{
        return YES;
    }
}


- (ClientReview *)clientView {
    if (_clientView == nil) {
        self.clientView = [ClientReview new];
        self.clientView.data = DataDic;
        self.clientView.clientNameLabel.text = @"姓名";
        self.clientView.PhoneLabel.text = @"身份证号";
        self.clientView.clientNameContent.placeholder = @"请输入姓名";
        self.clientView.PhoneContent.placeholder = @"请输入身份证号";
        self.clientView.frame = CGRectMake(0, kNavHeight, kScreenWidth,217/2*AUTO_SIZE_SCALE_X);
        self.clientView.backgroundColor = [UIColor whiteColor];
        self.clientView.PhoneContent.keyboardType = UIKeyboardTypeDefault;

    }
    return _clientView;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.image =[UIImage imageNamed:@"icon-uploadsfz"];
        self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.headImageView.clipsToBounds = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
        [self.headImageView addGestureRecognizer:singleTap];
        
    }
    return _headImageView;
}
         
-(UIView *)headBGView{
    if (_headBGView==nil) {
        self.headBGView = [UIView new];
        self.headBGView.backgroundColor = [UIColor whiteColor];
        self.headBGView.userInteractionEnabled = YES;
    }
    return _headBGView;
}

-(UILabel *)headBGLabel{
    if (_headBGLabel==nil) {
        self.headBGLabel = [UILabel new];
        self.headBGLabel.backgroundColor = [UIColor clearColor];
        self.headBGLabel.textColor = UIColorFromRGB(0xadadad);
        self.headBGLabel.text =@"上传图片";
        self.headBGLabel.font = [UIFont systemFontOfSize:25*AUTO_SIZE_SCALE_X];
        self.headBGLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headBGLabel;

}

-(UILabel *)attentionLabel{
    if (_attentionLabel==nil) {
        self.attentionLabel = [UILabel new];
        self.attentionLabel.numberOfLines = 1;
        self.attentionLabel.backgroundColor = [UIColor clearColor];
        self.attentionLabel.textColor = FontUIColorGray;
        self.attentionLabel.text =@"为了保证您的账户安全，请您提交实名认证资料。";
        self.attentionLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.attentionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _attentionLabel;
    
}


-(UILabel *)desc1Label{
    if (_desc1Label==nil) {
        self.desc1Label = [UILabel new];
        self.desc1Label.backgroundColor = [UIColor clearColor];
        self.desc1Label.textColor = UIColorFromRGB(0xadadad);
        self.desc1Label.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.desc1Label.textAlignment = NSTextAlignmentLeft;
        self.desc1Label.numberOfLines =0;
        self.desc1Label.text = @"1.请填写姓名、身份证号码（确保填写的信息与证件一致），并上传本人手持身份证的正面合影;\n\n2.请确保五官、证件内容清晰可见。我们将在3个工作日内完成审核。";
    }
    return _desc1Label;
    
}


-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.userInteractionEnabled = YES;
        self.subview.backgroundColor = [UIColor clearColor];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}


-(UITableView *)Tableview{
    if (_Tableview == nil) {
        self.Tableview = [[UITableView alloc] init];
        self.Tableview.delegate = self;
        self.Tableview.dataSource = self;
        self.Tableview.bounces = NO;
        //    myTableView.rowHeight = 300;
        self.Tableview.showsVerticalScrollIndicator = NO;
        self.Tableview.backgroundColor = C2UIColorGray;
        self.Tableview.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight);
    }
    return _Tableview;
}

- (UIView *)HeaderView {
    if (_HeaderView == nil) {
        self.HeaderView = [UIView new];
        self.HeaderView.backgroundColor = C2UIColorGray;
    }
    return _HeaderView;
}


@end
