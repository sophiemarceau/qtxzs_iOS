//
//  SDLaunchViewController.m
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "SDLaunchViewController.h"
#import "SDLaunchWebViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "DetailProjectViewController.h"

#define SDMainScreenBounds [UIScreen mainScreen].bounds
@interface SDLaunchViewController ()<UIScrollViewDelegate>{
    int CountdownNum;
    UILabel *CountdownLabel;

}

@property(nonatomic,strong)UIViewController *mainVC;

@property(nonatomic,strong)NSTimer *timer;//广告计时器

@property(nonatomic,strong)UILabel *timerLabel;//广告倒计时

@property(nonatomic,strong)UIImageView *adImageView;//广告图片

@property(nonatomic,strong)UITapGestureRecognizer *timerLabelTap;//点击手势

@property(nonatomic,strong)UIImage *rollImage;//滚动图片

@property(nonatomic,strong)UIImageView *rollImageView;//滚动图片View

@property(nonatomic,strong)NSTimer *rollTimer;//滚动视图计时器

@property(nonatomic,assign)LaunchViewControllerType vcType;//控制器类型



@end

@implementation SDLaunchViewController

-(instancetype)initWithMainVC:(UIViewController *)mainVC viewControllerType:(LaunchViewControllerType )viewControllerType{

    if (self = [super init]) {
        
        self.mainVC = mainVC;
        self.adTime = 7;
        self.vcType = viewControllerType;
        self.isSkip = YES;
        self.hideEndButton = NO;
//        self.placeholderImageName = @"引导页.png";
        self.adImageView = [[UIImageView alloc]initWithFrame:SDMainScreenBounds];
        self.frontGifView = [[UIView alloc]initWithFrame:SDMainScreenBounds];
        self.frontRollView = [[UIView alloc]initWithFrame:SDMainScreenBounds];
        if (viewControllerType != ADLaunchViewController) {
            
            [self loadEndButton];
        }
        if (viewControllerType ==GreenhandLaunchViewController) {
            [self loadPageControl];
        }


    }

    return self;
}

// 引用自stackflow
- (NSString *)ty_getLaunchImageName
{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = tyCurrentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}


#pragma mark ---全局方法---

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (_vcType) {
        case ADLaunchViewController:{
        
            [self loadADImageView];
            
            [self loadTimerLabel];
            
            self.timer =[NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(setAppMainViewController) userInfo:nil repeats:YES];
            
        
        
        }
            break;
            
        case GreenhandLaunchViewController:{
            
            [self loadImageScollView];

            
        }
            break;
            
        case GifBackgroundLaunchViewController:{
            
            [self loadGifImage];
            
            
        }
            break;
            
        case RollImageLaunchViewController:{
            
            [self loadRollImageView];
            
            
        }
            break;
            
            
        default:{
        
            NSLog(@"Error:类型错误!");
        
        }
            break;
    }
    

    
}

-(void)skipAppRootMainViewController{

    self.view.window.rootViewController = self.mainVC;

}


#pragma mark ---广告类型控制器相关方法---
-(void)loadADImageView{
        
    self.adImageView.frame =  CGRectMake(0, 0, SDMainScreenBounds.size.width, SDMainScreenBounds.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushADWebVC)];
    [self.adImageView addGestureRecognizer:tap];
    self.adImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.adImageView];


}

-(void)loadTimerLabel{
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(gotoViewController:)];
//    [imageV addGestureRecognizer:tap];
    
    UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80*AUTO_SIZE_SCALE_X, kScreenWidth, 80*AUTO_SIZE_SCALE_X)];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.adImageView  addSubview:buttomView];
    
    UIImageView * adImv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (80*AUTO_SIZE_SCALE_X-45)/2, 45*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    
    adImv.image = [UIImage imageNamed:@"logo-login"];
    [buttomView addSubview:adImv];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(adImv.frame.size.width+adImv.frame.origin.x+15, (80*AUTO_SIZE_SCALE_X-45*AUTO_SIZE_SCALE_X)/2, 180*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    loginLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.textColor = FontUIColorGray;
    loginLabel.textAlignment = NSTextAlignmentLeft;
    loginLabel.text = @"渠到天下";
    [buttomView addSubview:loginLabel];
    
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(kScreenWidth-54-14, (80*AUTO_SIZE_SCALE_X-30)/2, 54, 30);
    //                        skipButton.layer.cornerRadius = 15.0;
    [skipButton setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:skipButton];
    
    UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-29-14, 26, 29, 29)];
    secView.layer.cornerRadius = 14.5;
    secView.backgroundColor = [UIColor blackColor];
    secView.alpha = 0.5;
    [self.adImageView addSubview:secView];

    CountdownNum = 6;
    
    CountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 29, 11)];
    CountdownLabel.text = [NSString stringWithFormat:@"%ds",CountdownNum];
    CountdownLabel.font = [UIFont systemFontOfSize:11];
    CountdownLabel.textColor = [UIColor whiteColor];
    CountdownLabel.textAlignment = NSTextAlignmentCenter;
    [secView addSubview:CountdownLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:4.0];
//    self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(SDMainScreenBounds.size.width-120, 40, 100, 40)];
//
//    self.timerLabel.backgroundColor = [UIColor colorWithRed:125/256.0 green:125/256.0  blue:125/256.0  alpha:0.5];
//    
//    self.timerLabel.textColor = [UIColor whiteColor];
//    
//    self.timerLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.timerLabel.layer.masksToBounds = YES;
//    
//    self.timerLabel.layer.cornerRadius = 5;
//    self.timerLabel.userInteractionEnabled = YES;
//
//    if (self.isSkip) {
//        _timerLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipAD)];
//        
//        [self.timerLabel addGestureRecognizer:_timerLabelTap];
//
//    }


}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    CountdownNum = CountdownNum -1;
    CountdownLabel.text = [NSString stringWithFormat:@"%ds",CountdownNum];
    if (CountdownNum == 0) {
        [theTimer invalidate];
    }
}

//计时器调取方法
-(void)setAppMainViewController{
    
    if (self.isSkip) {
        
        self.timerLabel.text = [NSString stringWithFormat:@"跳过(%ld)",self.adTime];
        
        self.adTime--;
        
        if (self.adTime < 0) {
            
            [self.timer invalidate];
            
            self.view.window.rootViewController = self.mainVC;
            
            
        }
    }else{
    
        self.timerLabel.text = [NSString stringWithFormat:@"剩余%ld秒",self.adTime];
        self.adTime--;
        
        if (self.adTime < 0) {
            
            [self.timer invalidate];
            
            self.view.window.rootViewController = self.mainVC;
            
        }
    
    }
    

    
}

//停止计时器并且跳转到主控制器
-(void)skipAD{

    if (self.timer !=nil) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.rollTimer != nil) {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
    
    self.view.window.rootViewController = self.mainVC;

}

//获取图片并且启动计时器
-(void)setImageURL:(NSString *)imageURL{
    
//    _imageURL = imageURL;
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getfirstFigure:dic viewController:nil successData:^(NSDictionary *result) {
        
        if(IsSucess(result)){
            
            _imageURL =[[result objectForKey:@"data"] objectForKey:@"pic"];
            self.adURL =[[result objectForKey:@"data"] objectForKey:@"pic_url"];
            self.project_id = [[[result objectForKey:@"data"] objectForKey:@"project_id"] intValue];
            if (_imageURL!=[NSNull class] && _imageURL.length !=0 &&![_imageURL isEqualToString:@""]) {
                __weak typeof(self)temp = self;
                [self.adImageView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed: [self ty_getLaunchImageName]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [temp.view addSubview:temp.timerLabel];
                    [temp.view bringSubviewToFront:temp.timerLabel];
                    temp.adImageView.image = image;
                    [temp.timer fire];
                    
                }];
            }
        }else{
            
        }
    }failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:[error networkErrorInfo] viewController:nil];
    }];
}

//跳转到广告页面
-(void)pushADWebVC{
    
    if (![self.adURL isEqualToString:@""]) {
        [self.timer invalidate];
        SDLaunchWebViewController *vc= [[SDLaunchWebViewController alloc]init];
        vc.mainViewController = self.mainVC;
        if (self.titleString != nil) {
            vc.titleString = self.titleString;
            
        }
        NSLog(@"self.adURL-------->%@",self.adURL);
        vc.requestURL = self.adURL;
        
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }else if (self.project_id != 0) {
        [self.timer invalidate];
        self.view.window.rootViewController = self.mainVC;
        [[NSNotificationCenter defaultCenter] postNotificationName:kgotoDetailProjectPage object:nil userInfo:@{@"project_id":[NSString stringWithFormat:@"%d",self.project_id]}];
        return;
    }
}


#pragma mark ---轮播图新手导引控制器相关方法---
-(void)loadImageScollView{

    UIScrollView *imageScollView = [[UIScrollView alloc]initWithFrame:SDMainScreenBounds];
    
    imageScollView.delegate = self;
    
    //加载本地图片
    if (_imageURLArray.count == 0 && _imageNameArray.count != 0) {
        
        imageScollView.contentSize = CGSizeMake(SDMainScreenBounds.size.width*_imageNameArray.count, SDMainScreenBounds.size.height);
        
        imageScollView.pagingEnabled = YES;
        
        imageScollView.showsHorizontalScrollIndicator = NO;
        
        imageScollView.showsVerticalScrollIndicator =NO;
        
        imageScollView.bounces = NO;
        
        //添加图片
        for (int i = 0; i<_imageNameArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SDMainScreenBounds.size.width*i, 0, SDMainScreenBounds.size.width, SDMainScreenBounds.size.height)];
            
            imageView.image = [UIImage imageNamed:_imageNameArray[i]];
            
            [imageScollView addSubview:imageView];
            
            if (i == _imageNameArray.count-1) {
                
                //最后一张图片加上进入按钮
                [imageView addSubview:self.endButton];
                
                imageView.userInteractionEnabled = YES;
                
                
            }
            
        }
  
    }
    
    //加载网络图片
    if (_imageURLArray.count != 0) {
        
        
        imageScollView.contentSize = CGSizeMake(SDMainScreenBounds.size.width*_imageURLArray.count, SDMainScreenBounds.size.height);
        
        imageScollView.pagingEnabled = YES;
        
        imageScollView.showsHorizontalScrollIndicator = NO;
        
        imageScollView.showsVerticalScrollIndicator =NO;
        
        imageScollView.bounces = NO;
        
        //添加图片
        for (int i = 0; i<_imageURLArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SDMainScreenBounds.size.width*i, 0, SDMainScreenBounds.size.width, SDMainScreenBounds.size.height)];
            
            [imageView sd_setImageWithURL:_imageURLArray[i] placeholderImage:nil];
            
            [imageScollView addSubview:imageView];
            
            if (i == _imageNameArray.count-1) {
                
                //最后一张图片加上进入按钮
                [imageView addSubview:self.endButton];
                
                
            }
            
        }

    }
    
    [self.view addSubview:imageScollView];
    
    
    [self.view addSubview:self.pageControl];
    
    _pageControl.numberOfPages = _imageNameArray.count;


}

//跳转按钮的
-(void)loadEndButton{


    _endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _endButton.frame = CGRectMake(SDMainScreenBounds.size.width/2-60, SDMainScreenBounds.size.height-120, 120, 40);
    
    _endButton.tintColor = [UIColor lightGrayColor];
    [_endButton setImage:[UIImage imageNamed:@"进入应用"] forState:UIControlStateNormal];
    
    [_endButton addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
    

}


-(void)loadPageControl{

    
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SDMainScreenBounds.size.height-40, SDMainScreenBounds.size.width, 40)];
        
        _pageControl.currentPage =0;

        //设置当前页指示器的颜色
        _pageControl.currentPageIndicatorTintColor =[UIColor blueColor];
        //设置指示器的颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //获取偏移量
    NSInteger currentPage = scrollView.contentOffset.x/SDMainScreenBounds.size.width;
    //改变PageControl的显示
    _pageControl.currentPage = currentPage;
    
    
}

#pragma mark ---GIF动态图控制器相关方法---

-(void)loadGifImage{

    UIImageView *gifImageView = [[UIImageView alloc]initWithFrame:SDMainScreenBounds];
    
    if (self.gifImageName != nil && self.gifImageURL ==nil) {
        gifImageView.image = [UIImage sd_animatedGIFNamed:self.gifImageName];

    }else{
    
        [gifImageView sd_setImageWithURL:[NSURL URLWithString:self.gifImageURL]];

    }
    
    [self.view addSubview:gifImageView];

    self.frontGifView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9  alpha:0.5];
    
    if (!_hideEndButton) {
        [self.frontGifView addSubview:self.endButton];
        
        _endButton.tintColor = [UIColor blueColor];
    }

    [self.view addSubview:self.frontGifView];
    

}

#pragma mark ---滚动图片控制器相关方法---


-(void)loadRollImageView{
    if (self.rollImageName != nil && self.rollImageURL ==nil) {
        _rollImage = [UIImage imageNamed:self.rollImageName];
        [self addRollImageAndTimer];
    }else{
        [self downLoaderImageWithUrlString:_rollImageURL];
    }
}

-(void)addRollImageAndTimer{

    if (_rollImage !=nil && _rollImage.size.height>_rollImage.size.width) {
        
        NSLog(@"Error:滚动图片的高度比宽度高,不能进行横向滚动!");
        
    }else{
        
        
        _rollImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SDMainScreenBounds.size.height* _rollImage.size.width/_rollImage.size.height, SDMainScreenBounds.size.height)];
        
        _rollImageView.image = _rollImage;
        
        self.rollTimer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rollImageAction) userInfo:nil repeats:YES];
        
        [self.view addSubview:_rollImageView];
        
        
        if (!_hideEndButton) {
            [self.frontRollView addSubview:self.endButton];
            
            _endButton.tintColor = [UIColor blueColor];
        }
        
        [self.view addSubview:self.frontRollView];
        
        [self.rollTimer fire];
    }



}

int rollX = 0;
bool isReverse = NO;//是否反向翻滚
-(void)rollImageAction{
    
    if (rollX-1 >(SDMainScreenBounds.size.width-SDMainScreenBounds.size.height* _rollImage.size.width/_rollImage.size.height) &&!isReverse) {
        
        rollX = rollX-1;
        _rollImageView.frame = CGRectMake(rollX, 0,SDMainScreenBounds.size.height* _rollImage.size.width/_rollImage.size.height, SDMainScreenBounds.size.height);

    }else{
    
        isReverse = YES;
    }

    if (rollX+1 < 0 &&isReverse) {
    
        rollX = rollX +1;
        
        _rollImageView.frame = CGRectMake(rollX, 0,SDMainScreenBounds.size.height* _rollImage.size.width/_rollImage.size.height, SDMainScreenBounds.size.height);

    }else{
        isReverse = NO;
    }

}


-(void)downLoaderImageWithUrlString:(nonnull NSString *)string{
    
    //1.准备URL
    NSURL *url = [NSURL URLWithString:string];
    
    //2.准备session
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)temp = self;
    
    //3.创建下载任务
    NSURLSessionDownloadTask *task  =[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *tmp = [NSData dataWithContentsOfURL:location];
        
        UIImage *img = [UIImage imageWithData:tmp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            temp.rollImage = img;
            
            [temp addRollImageAndTimer];
        });
        
    }];
    
    //4.执行任务
    [task resume];
    
}


-(void)dealloc{
    
    if (self.timer !=nil) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.rollTimer != nil) {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kAdvertisePage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAdvertisePage];
}


@end
