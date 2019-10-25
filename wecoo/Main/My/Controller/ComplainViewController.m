//
//  ComplainViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/28.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ComplainViewController.h"
#import "UIImageView+WebCache.h"
#import "FileUploadHelper.h"
#import "TOCropViewController.h"
@interface ComplainViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>{

    NSURL *refURL;
    
}
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation ComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.complainView];
    [self.view addSubview:self.complainLabel];
    [self.view addSubview:self.subview];
    self.complainView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 108*AUTO_SIZE_SCALE_X);
    self.complainLabel.frame = CGRectMake(15, kNavHeight+15*AUTO_SIZE_SCALE_X, kScreenWidth-30, (108-15)*AUTO_SIZE_SCALE_X);

//    //创建collectionView进行上传图片
    [self.view addSubview:self.collectionBGView];
    self.collectionBGView.frame = CGRectMake(0, self.complainView.frame.origin.y+self.complainView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth,75*AUTO_SIZE_SCALE_X + 36*AUTO_SIZE_SCALE_X);
    [self addCollectionViewPicture];
    self.subview.frame = CGRectMake(0, self.collectionBGView.frame.origin.y+self.collectionBGView.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);

   //上传图片的button
    self.photoBtn = [UIImageView new];
    self.photoBtn.frame = CGRectMake(15 , 18*AUTO_SIZE_SCALE_X,75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
    self.photoBtn.image = [self imageWithSize:self.photoBtn.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
    self.photoBtn.userInteractionEnabled = YES;
    [self.photoBtn addSubview:self.plusImageView];
    [self.photoBtn addSubview:self.defaultLabel];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picureUpload:)];
    [self.photoBtn addGestureRecognizer:tap4];
    [self.collectionBGView addSubview:self.photoBtn];
    
    
}


-(void)cancelImageView:(UITapGestureRecognizer *)sender{
    
//    NSLog(@"cancelImageView-------%ld",(long)sender.view.tag);
//    switch (sender.view.tag) {
//        case 0:
//        {
//            
//            break;
//        }
//            
//        case 1:{
//            ShowShareView *show = [[ShowShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//            show.sharefrom = @"friend";
//            [show showView];
//            break;
//            
//        }
//            
//        case 2:{
//            MyFavrioteViewController *vc = [[MyFavrioteViewController alloc] init];
//            vc.titles = @"我的关注";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//            
//        }
//            
//        case 3:{
//            MyReportListViewController * vc = [[MyReportListViewController alloc] init];
//            vc.titles =@"我的报备";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//            
//        }
//            
//        default:
//            break;
//    }
//    NSLog(@"cancalliex-----%d",cancelidex);
    [self.photoArrayM removeObjectAtIndex:sender.view.tag];
    [self viewWillAppear:YES];
    
    
}
-(void)picureUpload:(UITapGestureRecognizer *)sender{
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



-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(75*AUTO_SIZE_SCALE_X , 75*AUTO_SIZE_SCALE_X);
    flowL.sectionInset = UIEdgeInsetsMake(18*AUTO_SIZE_SCALE_X,15, 18*AUTO_SIZE_SCALE_X, 15);
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 75*AUTO_SIZE_SCALE_X + 36*AUTO_SIZE_SCALE_X) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor clearColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.collectionBGView addSubview:_collectionV];
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
}

#pragma mark textField的字数限制
//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
//    NSInteger wordCount = textView.text.length;
//    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}

#pragma mark dfd
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 300) {
//        NSLog(@"%ld",text.text.length);
        self.complainLabel.editable = YES;
        
    }
    else{
        self.complainLabel.editable = NO;
        
    }
    return nil;
}

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.photoV setImageWithURL:[NSURL URLWithString:self.photoArrayM[indexPath.item]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelImageView:)];
    cell.userInteractionEnabled = YES;
    cell.cancelImageView.tag =indexPath.item;
     cell.cancelImageView.userInteractionEnabled =  YES;
    [cell.cancelImageView addGestureRecognizer:tap4];
    
//    cancelidex =(int)indexPath.item ;
   
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kComplaintPage];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kComplaintPage];//("PageOne"为页面名称，可自定义)
    if (self.photoArrayM.count < 4) {
        //        NSLog(@"count------%ld",self.photoArrayM.count);
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(
                                         15*(self.photoArrayM.count + 1) + 75*AUTO_SIZE_SCALE_X * self.photoArrayM.count,
                                         18*AUTO_SIZE_SCALE_X,
                                         75*AUTO_SIZE_SCALE_X,
                                         75*AUTO_SIZE_SCALE_X
                                         );
        self.photoBtn.hidden = NO;
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
        self.photoBtn.hidden = YES;
        
    }
   
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
        
        
        [[RequestManager shareRequestManager] ComplaintUploadImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            //            NSLog(@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]);
            [self.photoArrayM addObject:[[result objectForKey:@"data"] objectForKey:@"url"]];
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



#pragma mark 提交
-(void)submitBtnPressed:(UIButton *)sender
{
     self.subview.subButton.enabled = NO;
    if (self.complainLabel.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"投诉内容不能为空，请尽量详细的描述您的问题" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    NSMutableString *picStr =[NSMutableString string];
    if (self.photoArrayM.count>1) {
        for (NSString *temp in self.photoArrayM) {
            [picStr appendFormat:@"%@^", temp];
        }
        [picStr deleteCharactersInRange:NSMakeRange(picStr.length-1, 1)];
    }else if(self.photoArrayM.count==1){
        picStr =self.photoArrayM[0];
    }else{
        
    }
    
   
    NSDictionary *dic = @{
                          
                          @"feedback_content":self.complainLabel.text,
                          @"_feedback_pics":picStr,
                         
                          };
    
    
    [[RequestManager shareRequestManager] SubmitFeedbackResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            if (result !=nil) {
                [MobClick event:kMyComplainSubmitEvent];
                
                [[RequestManager shareRequestManager] tipAlert:@"提交成功，我们将在5个工作日内与您联系" viewController:self];
                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.subview.subButton.enabled = YES;
        }
        
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.subview.subButton.enabled = YES;
    }];
}

-(void)returnListPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.subview.subButton.enabled = YES;
}

- (SubmitView *)submit {
    if(_submit == nil){
        self.submit = [[SubmitView alloc]init];
        self.submit.backgroundColor = [UIColor clearColor];
    }
    return _submit;
}

-(UIImageView *)myReportView{
    if (_myReportView == nil) {
        self.myReportView = [UIImageView new];
        
        self.myReportView.image = [UIImage imageNamed:@"icon-myBalanceHelp"];
        
    }
    return _myReportView;
}

- (UIView *)complainView {
    if (_complainView == nil) {
        self.complainView = [UIView new];
        self.complainView.backgroundColor = [UIColor whiteColor];
    }
    return _complainView;
}

-(UIView *)viewBgImage{
    if (_viewBgImage == nil) {
        self.viewBgImage = [UIView new];
        self.viewBgImage.backgroundColor = [UIColor whiteColor];
    }
    return _viewBgImage;
}

-(PlaceholderTextView *)complainLabel{
    if (!_complainLabel) {
        _complainLabel = [[PlaceholderTextView alloc] init];
        _complainLabel.backgroundColor = [UIColor clearColor];
        _complainLabel.delegate = self;
        _complainLabel.font = [UIFont systemFontOfSize:14.f*AUTO_SIZE_SCALE_X];
        _complainLabel.textColor = [UIColor blackColor];
        _complainLabel.textAlignment = NSTextAlignmentLeft;
        _complainLabel.editable = YES;
        _complainLabel.layer.cornerRadius = 4.0f;
        _complainLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _complainLabel.layer.borderWidth = 0.5;
        _complainLabel.placeholderColor = FontUIColorGray;
        _complainLabel.placeholder = @"请输入投诉内容，我们将不断改进，尽量详细描述您遇到的问题";
    }
    return _complainLabel;
}

- (UIView *)collectionBGView {
    if (_collectionBGView == nil) {
       _collectionBGView = [UIView new];
        _collectionBGView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionBGView;
}

//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (_photoArrayM==nil) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
//        [_photoArrayM addObjectsFromArray:@[@"1",@"2",@"3",@"4"]];
    }
    return _photoArrayM;
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




-(UIImageView *)plusImageView{
    if (_plusImageView == nil) {
        self.plusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22*AUTO_SIZE_SCALE_X, 13.5*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X)];
        self.plusImageView.image =[UIImage imageNamed:@"icon-uploadimg"];
    }
    return _plusImageView;
}

-(UILabel *)defaultLabel{
    if (_defaultLabel == nil) {
        self.defaultLabel = [CommentMethod initLabelWithText:@"上传图片" textAlignment:NSTextAlignmentCenter font:13*AUTO_SIZE_SCALE_X];
        self.defaultLabel.textColor = FontUIColorGray;
        self.defaultLabel.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, self.plusImageView.frame.origin.y+self.plusImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
        
    }
    return _defaultLabel;
}



-(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
