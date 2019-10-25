//
//  ActivityDetailViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/1.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShowShareView.h"
#import "noWifiView.h"
#import "WXApi.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface ActivityDetailViewController ()<SelectSharedTypeDelegate>{
    NSDictionary *dto;
    noWifiView *failView;
}

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {

    
    [super viewDidLoad];
    [self loadData];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.dateLabel];
    [self.view addSubview:self.detailView];
    [self.detailView addSubview:self.redImageView];
    [self.detailView addSubview:self.detailTitleLabel];
    [self.detailView addSubview:self.detailLabel];
    self.detailLabel.frame =CGRectMake(15, self.detailTitleLabel.frame.origin.y+self.detailTitleLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, kScreenWidth-30,0);
    [self.detailLabel setNumberOfLines:0];
   
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{
    
    NSDictionary *dic = @{ @"activity_id":[NSString stringWithFormat:@"%d",self.activity_id],};
    
    
    
    [[RequestManager shareRequestManager] GetActivityDtoResult:dic viewController:self successData:^(NSDictionary *result){
        failView.hidden = YES;
        if(IsSucess(result)){
            dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){
                
                self.titleLabel.text = [NSString stringWithFormat:@"%@",[dto objectForKey:@"activity_name"]];
                self.dateLabel.text = [NSString stringWithFormat:@"有效期至 %@",[dto objectForKey:@"activity_enddate"]];
                self.detailLabel.text =[dto objectForKey:@"activity_desc"] ;
                [self.detailLabel sizeToFit];
                self.detailView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.headerView.frame.origin.y+self.headerView.frame.size.height, kScreenWidth, self.detailLabel.frame.origin.y+self.detailLabel.frame.size.height+12*AUTO_SIZE_SCALE_X);
                [self.view addSubview:self.shareButton];
                
               int IsShare = [[dto objectForKey:@"activity_kind_code"] intValue];
               
                self.shareButton.frame = CGRectMake(15, 20*AUTO_SIZE_SCALE_X+self.detailView.frame.origin.y+self.detailView.frame.size.height, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
                if (IsShare ==4) {
                    self.shareButton.hidden = NO;
                }else{
                    self.shareButton.hidden = YES;
                }
//                NSString *name = [dto objectForKey:@"report_customer_name"];
//                self.clientView.clientNameContent.text = name;
//                NSString *phone = [dto objectForKey:@"report_customer_tel"];
//                self.clientView.PhoneContent.text = [NSString stringWithFormat:@"%@",phone];
//                
//                [self initTrade];
//                [self initBudgeData];
//                [self initPlanTimeData];
//                self.remarkView.text = [dto objectForKey:@"report_customer_note"];
//                if (self.remarkView.text.length !=0) {
//                    self.remarkView.placeholder =@"";
//                }
//                self.reportView.districtContent.text = [dto objectForKey:@"report_customer_area_agent"];
//                districtindex = [dto objectForKey:@"report_customer_area_agent"];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
    }];
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
//    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    
    NSString *titles = @"您的好友送您20元红包";
    NSString *desc = @"听说，80%的渠道人都在这里赚到爆，快和好友一起共闯“渠到天下”吧";

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"火爆项目"]];
    
    //设置网页地址
    NSString *joingstr = [NSString stringWithFormat:@"joinUs.html?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,joingstr];
    
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
}




-(void)SelectSharedTypeDelegateReturnPage:(NSDictionary *)returnTypeDic{
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

-(void)shareBtnPressed:(UIButton *)sender{
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kActivityDetailPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kActivityDetailPage];
}

-(UIView *)headerView{
    if (_headerView == nil) {
        self.headerView = [UIView new];
        self.headerView.frame = CGRectMake(0,  kNavHeight, kScreenWidth, 65*AUTO_SIZE_SCALE_X);
        self.headerView.backgroundColor = [UIColor whiteColor];
        
    }
    return _headerView;
}


-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [CommentMethod initLabelWithText:@"邀请好友赚钱啦" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.titleLabel.textColor = FontUIColorBlack;
        self.titleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
        
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (_dateLabel == nil) {
        self.dateLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.dateLabel.textColor = FontUIColorGray;
        self.dateLabel.frame = CGRectMake(15, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+8*AUTO_SIZE_SCALE_X, kScreenWidth-30, 11*AUTO_SIZE_SCALE_X);
    }
    return _dateLabel;
}


-(UIView *)detailView{
    if (_detailView == nil) {
        self.detailView = [UIView new];
        self.detailView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.headerView.frame.origin.y+self.headerView.frame.size.height, kScreenWidth, 0);
        self.detailView.backgroundColor = [UIColor whiteColor];
    }
    return _detailView;
}

-(UILabel *)detailTitleLabel{
    if (_detailTitleLabel == nil) {
        self.detailTitleLabel = [CommentMethod initLabelWithText:@"活动说明" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.detailTitleLabel.textColor = FontUIColorBlack;
        self.detailTitleLabel.frame = CGRectMake(15, 12*AUTO_SIZE_SCALE_X, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
    }
    return _detailTitleLabel;
}

-(UILabel *)detailLabel{
    if (_detailLabel == nil) {
        self.detailLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.detailLabel.textColor = FontUIColorGray;
    }
    return _detailLabel;
}

-(UIImageView *)redImageView{
    if (_redImageView == nil) {
        self.redImageView = [UIImageView new];
        self.redImageView.frame = CGRectMake(0,12*AUTO_SIZE_SCALE_X,4*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X);
        self.redImageView.backgroundColor = RedUIColorC1;

    }
    return _redImageView;
}

-(UIButton *)shareButton{
    if (_shareButton == nil ) {
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.userInteractionEnabled = YES;
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.shareButton setTitle:@"马上分享，邀请好友" forState:UIControlStateNormal];
        [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.shareButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.shareButton addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
