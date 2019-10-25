//
//  QRCodeViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/1/12.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "QRCodeViewController.h"
#import "SGQRCodeTool.h"
#import "ShareQRCodeView.h"
#import "WXApi.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface QRCodeViewController ()<SelectSharedTypeDelegate>{
    UIImageView *imageView;
    UILabel *shareLabel;
    UIView *screenSplitView;
    UIImage *saveImage;
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    screenSplitView = [UIView new];
    screenSplitView.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight);
    [self.view addSubview:screenSplitView];
    [super viewDidLoad];

    
    
    [self initNavBarView];
    [screenSplitView addSubview:self.firstImageView];
    self.firstImageView.frame = CGRectMake(0, 0, kScreenWidth, 130*AUTO_SIZE_SCALE_X);
    
    [screenSplitView addSubview:self.userPhotoImageView];
    self.userPhotoImageView.frame = CGRectMake(kScreenWidth/2-30*AUTO_SIZE_SCALE_X, self.firstImageView.frame.size.height+25*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
    [screenSplitView addSubview:self.nameLabel];
    
    self.nameLabel.frame = CGRectMake(0, self.userPhotoImageView.frame.origin.y+self.userPhotoImageView.frame.size.height+25*AUTO_SIZE_SCALE_X, kScreenWidth, 20*AUTO_SIZE_SCALE_X);
    
    // 生成二维码(中间带有图标)
    [self setupGenerate_Icon_QRCode];
    [screenSplitView addSubview:self.desLabel];
    self.desLabel.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+25*AUTO_SIZE_SCALE_X, kScreenWidth, 20*AUTO_SIZE_SCALE_X);
    
    
    [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:self.userPhoto] placeholderImage:[UIImage imageNamed:@"img-defult-account"]];
    self.nameLabel.text = [NSString stringWithFormat:@"推荐人：%@",self.nameString];
    
    
}

- (void)snapshotScreenInView:(UIView *)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}

-(void)shareClick:(UIButton *)sender{
    
    //    ShareQRCodeView *show = [[ShareQRCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //    show.shareButtonNumber = 2;
    //    [show showView];
    SharedView *show = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.dicarray = @[
                      
                      @{@"icon-image":@"icon-shareWeixin",@"value":@"微信好友",@"shareflag":@"1"},
                      @{@"icon-image":@"icon-sharePyq",@"value":@"朋友圈",@"shareflag":@"2"},
                      @{@"icon-image":@"icon-shareQQ",@"value":@"QQ好友",@"shareflag":@"3"},
                      @{@"icon-image":@"icon-shareQzone@3x",@"value":@"QQ空间",@"shareflag":@"4"},
                      ] ;
    show.delegate = self;
    [show showView];
}

-(void)SelectSharedTypeDelegateReturnPage:(NSDictionary *)returnTypeDic{
    [self snapshotScreenInView:screenSplitView];
    NSString *shared = returnTypeDic[@"shareflag"];
    if ([shared isEqualToString:@"1"]||[shared isEqualToString:@"2"]) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"您的设备没有安装微信"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if ([shared isEqualToString:@"1"]) {
        [MobClick event:kShareWechatFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    
    if ([shared isEqualToString:@"2"]) {
        [MobClick event:kShareWechatCircleOfFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        
    }
    if ([shared isEqualToString:@"0"]) {
       
    }
    if ([shared isEqualToString:@"3"]) {
        [self isQQInstall];
        [MobClick event:kShareQQFriendEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if ([shared isEqualToString:@"4"]) {
        [self isQQInstall];
        [MobClick event:kShareQQSpaceEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
   
}

-(void)isQQInstall{
    if (![QQApiInterface isQQInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的设备没有安装QQ"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}


//-(void)shareWechat: (NSNotification *)notification{
//    [self snapshotScreenInView:screenSplitView];
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"您的设备没有安装微信"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *shared = userInfo[@"shareflag"];
//    if ([shared isEqualToString:@"0"]) {
//        [MobClick event:kShareQRCODEToFriend];
//         [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
//    }
//    
//    if ([shared isEqualToString:@"1"]) {
//       
//        [MobClick event:kShareQRCODEToMoments];
//         [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
//    }
//   
//}


//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
//    shareObject.thumbImage = saveImage
    
    [shareObject setShareImage:saveImage];
    
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
    
    
    
    
    
    
    
    
    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
//    //    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
//    
//    NSString *titles = @"您的好友送您20元红包";
//    NSString *desc = @"听说，80%的渠道人都在这里赚到爆，快和好友一起共闯“渠天下”吧";
//    
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"火爆项目"]];
//    
//    //设置网页地址
//    NSString *joingstr = [NSString stringWithFormat:@"joinUs.html?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
//    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,joingstr];
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        //        [self alertWithError:error];
//    }];
}


-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom).offset(-7);
        make.right.equalTo(self.navView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    shareLabel = [CommentMethod initLabelWithText:@"分享" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
    shareLabel.textColor = [UIColor whiteColor];
    [self.directButton addSubview:shareLabel];
    shareLabel.frame = CGRectMake(0, 0, 35, 30);
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    // 1、借助UIImageView显示二维码
    imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 155*AUTO_SIZE_SCALE_X;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+25*AUTO_SIZE_SCALE_X;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [screenSplitView addSubview:imageView];
    CGFloat scale = 0.2;
    //设置网页地址
    NSString *joingstr = [NSString stringWithFormat:@"joinUs.html?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    NSString *webpageUrl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,joingstr];
    // 2、将最终合得的图片显示在UIImageView上
    imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:webpageUrl logoImageName:@"icon60" logoScaleToSuperView:scale];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIImageView *)firstImageView {
    if (_firstImageView == nil) {
        self.firstImageView = [UIImageView new];
        self.firstImageView.backgroundColor = [UIColor clearColor];
        NSString *path = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"img/invitationtop.jpg"];
        NSLog(@"path-----%@",path);
        [self.firstImageView setImageWithURL:[NSURL URLWithString:path]];
        
    }
    return _firstImageView;
}

- (UIImageView *)userPhotoImageView {
    if (_userPhotoImageView == nil) {
        self.userPhotoImageView = [UIImageView new];
        self.userPhotoImageView.image =[UIImage imageNamed:@"img-defult-account"];
        self.userPhotoImageView.layer.cornerRadius = 30.0*AUTO_SIZE_SCALE_X;
        self.userPhotoImageView.layer.borderWidth = 1.0;
        self.userPhotoImageView.layer.masksToBounds = YES;
        self.userPhotoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
    }
    return _userPhotoImageView;
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.nameLabel.textColor = FontUIColorGray;
    }
    return _nameLabel;
}


- (UILabel *)desLabel {
    if (_desLabel == nil) {
        self.desLabel = [CommentMethod initLabelWithText:@"扫描识别二维码，领取20元现金！" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.desLabel.textColor = FontUIColorGray;
    }
    return _desLabel;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"" forState:UIControlStateNormal];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(60-21, 6, 18, 18)];
        imv.image = [UIImage imageNamed:@"icon-invitation-share"];
        [self.directButton addSubview:imv];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}
@end
