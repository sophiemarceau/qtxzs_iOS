//
//  Comment.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/5/26.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#ifndef Wecoo_Comment_h
#define Wecoo_Comment_h

#define IS_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define kTabHeight  45
#define ktabFootHeight  49
#define kNavHeight  64
#define kHeightFor6s     668
#define kWidthFor6s     375
#define navBtnHeight 44
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define tyCurrentWindow [[UIApplication sharedApplication].windows firstObject]

#define AUTO_SIZE_SCALE_X (kScreenHeight != kHeightFor6s ? (kScreenWidth/kWidthFor6s) : 1.0)
#define AUTO_SIZE_SCALE_Y (kScreenHeight != kHeightFor6s ? ((kScreenHeight-kNavHeight)/(kHeightFor6s-kNavHeight)) : 1.0)


#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define BGColorGray      UIColorFromRGB(0xf4f4f4)
#define RedUIColorC1     UIColorFromRGB(0xe83e41)
#define C6UIColorGray    UIColorFromRGB(0x747474)
#define C2UIColorGray    UIColorFromRGB(0xededed)
#define FontUIColorGray  UIColorFromRGB(0x666666)
#define FontUIColorBlack UIColorFromRGB(0x333333)
#define kTextBorderColor RGBCOLOR(227,224,216)
#define lineImageColor   UIColorFromRGB(0xdddddd)

//#define BaseURLString                      @"app-api-test.qtxzs.com"

#define BaseURLHTMLString                  @"http://m.qtxzs.com/app/"
#define BaseURLStringHTTPS                 @"https://app-api.qtxzs.com"
#define BaseURLString                      @"http://app-api.qtxzs.com"
#define kUmengAppkey                       @"581196f77f2c746ae1002f27"
#define kWechatAppKey                      @"wxb72874c1e7f529a7" //wechat appkey
#define kWechatAppSecret                   @"23480ae17eccb26e65cfd3c4a61b2740" //wechat appsecret
#define kWechatAppSecretURL                @"http://mobile.umeng.com/social"//wechat url

#define APPNAME @"渠到天下"
#define AgreeString                  @"客户本人知晓并同意提交该信息"
#define SENDPASSWORD  @"huatuozx"
//#define POST_key @"594f803b380a41396ed63dca39503542"//测试
#define POST_key @"1234567890" //正式
#define APPScheme @"huatuojiadaoiOS"

#define BUNDLE_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define k_UIFont(font)  [UIFont systemFontOfSize:font]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define IsSucess(result) [[result objectForKey:@"flag"] boolValue]
#define IsSucessCode(result)  [[result objectForKey:@"code"] isEqualToString:@"0000"]?TRUE:FALSE
#define noIsKindOfNusll(result,key)   ![[(result) objectForKey:(key)] isKindOfClass:[NSNull class]]
//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt
//判断Server返回数据是否为NSNull 类型 txt为参数 type为类型,like NSString,NSArray,NSDictionary
#define CHECK_DATA_IS_NSNULL(param,type) param = [param isKindOfClass:[NSNull class]] ? [type new] : param
#define kDateFormatTime @"yyyy-MM-dd hh:mm:ss"
#define kDateFormatDay @"yyyy-MM-dd"

//引入头文件
#import "UIViewExt.h"
#import "ZCControl.h"
#import "Toast+UIView.h"
#import "RequestManager.h"
#import "TTGlobalUICommon.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "UIView+ViewController.h"
#import "UIImage+category.h"
#import "UIImage+fixOrientation.h"
#import "UILabel+StringFrame.h"
#import "UMMobClick/MobClick.h"
//设置是否调试模式
#define NDDEBUG 1

#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif

#define LAST_RUN_VERSION_KEY                @"first_run_version_of_application"
#define IS_UPDATE_VERSION                   @"IS_updateversion"
#define NOTIFICATION_NAME_USER_LOGOUT       @"userLogout" //退出登录
#define NOTIFICATION_SECONDCONTROLLER       @"pushSelectSecondView" 
#define NOTIFICATION_FOURTHROLLER           @"pushSelectFourthView"
#define NOTIFICATION_FirstCONTROLLER        @"pushSelectFirstView"
#define NOTIFICATION_NAME_USER_UNLOGIN      @"unlogin" //未登录登录
#define kUserIconUpdate                     @"IconUpdate123" //用户头像
#define kProjectDetailToPost                @"delegatepdtop"
#define kCheckVersionInloginPage            @"checkVersionUnLogin" //login 检查更新
#define kCheckVersionInMainPage             @"checkVersion" //main 检查更新
#define kPushAdvertisePage                  @"advertiseWebView" //main 检查更新
#define kHowTogeiMoneyPage                  @"howtogetmonyPage" 

#define KJpushappKey                        @"6f07854879d91d444afd354f"
#define KJpushchannel                       @"App Store"
#define kCheckPersonalInfomation            @"checkPersonalInfomationPicture"
#define kfinishLoadingView                  @"finishLoadingView"
#define kReloadBalance                      @"reloadBalance" //用户头像
#define kinviteReloadHeight                 @"inviteReloadHeight" //用户头像
#define kModifyWithdraw                     @"modifywithdrawInfo"
#define kReloadClientList                   @"ReloadClientList"
#define kRefreshProgressList                @"RefreshProgressList"
#define kReloadwithDrawRecord               @"ReloadwithDrawRecord"
#define kPostMenuSorted                     @"PostMenuSorted"
#define khiddenKeyboard                     @"hiddenKeyboard" //隐藏键盘
#define kRefreshCheckList                   @"RefreshCheckList"
#define kgotoDetailProjectPage              @"gotoDetailProjectPage" //通知 切入项目详情页面
// iOS系统版本
#define SYSTEM_VERSION    [[[UIDevice currentDevice] systemVersion] doubleValue]
// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT                        20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT            20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT                44
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT                              44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT                              44
// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT                (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
// 根据APP_STATUSBAR_HEIGHT判断是否存在热点栏
#define IS_HOTSPOT_CONNECTED                (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
// 无热点栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT    (SYS_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在APP_STATUSBAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT                    (APP_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)


#define kTAB_HomeEvent                        @"HomeEvent"
#define kTAB_ProjectEvent                     @"ProjectEvent"
#define kTAB_FindEvent                        @"FindEvent"
#define kTAB_MYEvent                          @"MYEvent"
#define kConnectListSortedEvent               @"ConnectListSortedEvent"
#define kHomePageActivityEvent                @"HomePageActivityEvent"//首页-奖励活动点击
#define kBannerEvent                          @"BannerEvent"//首页-banner点击
#define kHomePageShareFrientEvent             @"HomePageShareFrientEvent"//首页-我的邀请点击
#define kHomePageMyCollectEvent               @"HomePageMyCollectEvent"//首页-我的关注点击
#define kHomePageMyReportEvent                @"HomePageMyReportEvent"//首页-我的报备点击
#define kHomePageSelectMyProjectEvent         @"HomePageSelectMyProjectEvent"//首页-选我的项目点击
#define kHomePageSelectReportClientEvent      @"HomePageSelectReportClientEvent"//首页-选我的报备点击
#define kHomePageSelectRewardEvent            @"HomePageSelectRewardEvent"//首页-领赏金点击
#define kHomePageListEvent                    @"HomePageListEvent"//首页-推广项目列表点击
#define kDirectReportEvent                    @"DirectReportEvent"//悬赏-按行业报备按钮点击
#define kDirectReportSubmitEvent              @"DirectReportSubmitEvent"//按行业报备-提交报备按钮点击
#define kProjectListEvent                     @"ProjectListEvent"//悬赏-项目列表点击
#define kAlreadyEvent                         @"AlreadyEvent"//项目详情-成交数点击
#define kCommission_noteEvent                 @"Commission_noteEvent"//项目详情-签约佣金点击
#define kProjectDetailCommericalTabButtonclick @"ProjectDetailCommericalTabButtonclick"//项目详情-招商详情tab点击
#define kProjectDetailSlikBagTabButtonclick @"ProjectDetailSlikBagTabButtonclick"//项目详情-锦囊tab点击
#define kProjectDetailCollectButtonclick @"ProjectDetailCollectButtonclick"//项目详情-关注按钮点击
#define kHiddenViewEvent                      @"HiddenViewEvent"//项目详情-关闭广播按钮点击
#define kProjectDetailonClickEvent            @"ProjectDetailonClickEvent"//项目详情-报备客户按钮点击
#define kProjectDetailSelectClientonClickEvent @"ProjectDetailSelectClientonClickEvent"//按行业报备客户-选择客户按钮点击
#define kSelectClientEvent                    @"SelectClientEvent"//项目详情-报备客户-选择客户按钮点击
#define kSelectClientListEvent                @"SelectClientListEvent"//选择客户-客户列表点击
#define kFromDetailProjectReportSubmitEvent   @"FromDetailProjectReportSubmitEvent"//项目详情-报备客户-提交报备按钮点击
#define kProjectDetailSlikBagListclick @"ProjectDetailSlikBagListclick"//项目详情-锦囊list点击
#define kFunshareonclickButton @"FunshareonclickButton"//玩转渠天下-分享按钮点击
#define kShareProjectDetailEvent              @"ShareProjectDetailEvent"//项目详情-分享按钮点击
#define kShareSlikBagEvent                    @"ShareSlikBagEvent"//锦囊详情-分享按钮点击
#define kShareWechatFriend                    @"ShareWechatFriend"//分享按钮-微信好友
#define kShareWechatCircleOfFriend            @"ShareWechatCircleOfFriend"//分享按钮-朋友圈
#define kShareQQSpaceEvent                    @"kShareQQSpaceEvent"//分享按钮-qq空间
#define kShareQQFriendEvent                   @"kShareQQFriendEvent"//分享按钮-qq好友
#define kShareCancelEvent                          @"ShareCancelButton"//分享按钮-取消分享按钮点击
#define kMessageOnclickButtonEvent                 @"MessageOnclickButton"//我的-消息点击
#define kAccountManageOnclickbuttonEvent           @"AccountManageOnclickbutton"//我的-账号管理点击
#define kMyAwardOnclickbuttonEvent            @"MyAwardOnclickbutton"//我的-我的赏金点击
#define kMyReportScoresEvent            @"MyReportScoresEvent"//我的-报备质量分点击
#define kMyReportEvent            @"MyReportScoresEvent"//我的-我的报备点击
#define kMyClientEvent            @"MyClientEvent"//我的-我的客户点击
#define kMyCollectEvent               @"MyCollectEvent"//我的-我的关注点击
#define kMyInviteEvent               @"MyInviteEvent"//我的-我邀请点击
#define kMyActivityEvent               @"MyActivityEvent"//我的-奖励活动点击
#define kMyComplainEvent               @"MyComplainEvent"//我的-投诉建议点击
#define kMyConnectEvent               @"MyConnectEvent"//我的-人脉点击
#define kMyFunEvent               @"MyFunEvent"//我的-玩转渠天下点击
#define kABOUTUSEvent               @"ABOUTUSEvent"//我的-关于渠天下点击
#define kSettingEvent               @"SettingEvent"//我的-设置点击
#define kMyConnectCallEvent               @"MyConnectCallEvent"//人脉详情-拨打电话按钮点击
#define kMyConnectBossEvent               @"MyConnectBossEvent"//人脉详情-查看上级人脉按钮点击
#define kMyComplainSubmitEvent  @"MyComplainSubmitEvent"//投诉建议-提交按钮点击
#define kAboutCallEvent  @"AboutCallEvent"//关于渠天下-拨打电话点击
#define kClearCacheEvent  @"ClearCacheEvent"//设置-清除缓存点击
#define kQuitOnClickEvent  @"QuitOnClickEvent"//设置-退出登录按钮
#define kAppleyMoneyOnClickEvent  @"AppleyMoneyOnClickEvent"//我的赏金-申请提现按钮点击
#define kAppleyMoneyRuleOnClickEvent  @"AppleyMoneyRuleOnClickEvent"//我的赏金-提现规则点击
#define kApplyMoneyRecordOnClickEvent  @"ApplyMoneyRecordOnClickEvent"//我的赏金-申请记录点击
#define kApplyMoneyRecordProgressOnClickEvent  @"ApplyMoneyRecordProgressOnClickEvent"//申请记录-提现进度点击
#define kRecordProgressOnClickEvent  @"ApplyMoneyRecordProgressOnClickEvent"//提现进度-修改申请信息点击
#define kMyAccountSaveSubmitOnClickEvent  @"MyAccountSaveSubmitOnClickEvent"//账号管理-保存按钮点击
#define kMyMessageCheck  @"MessageCheck"//消息-点击查看消息点击
#define kActivityDetail  @"ActivityDetailCheck"//奖励活动-活动详情点击
#define kActivityHistroy @"ActivityHistroy"//奖励活动-历史活动tab点击
#define kActivityHistroyDetail @"ActivityHistroyDetail"//历史活动-历史活动详情点击
#define kMyCollectListSelectOnclick @"MyCollectListSelectOnclick"//我的关注-项目列表点击点击
#define kMyClientAddbuttonOnclick @"MyClientAddbuttonOnclick"//我的客户-添加客户按钮点击
#define kMyClientAddClientSubmitOnclick @"MyClientAddClientSubmitOnclick"//添加客户-提交按钮点击
#define kMyClientAddClientSaveOnclick @"MyClientAddClientSaveOnclick"//添加客户-保存按钮点击
#define kMyReportList @"MyReportList"//我的报备-报备列表点击
#define kMyReportProgress @"MyReportProgress"//我的报备-查看进度点击
#define kInviteCodeEvent @"InviteCodeEvent"//我的邀请-复制邀请码按钮点击
#define kInviteChectRuleEvent @"InviteChectRuleEvent"//我的邀请-查看邀请规则按钮点击
#define kInviteFriendButtonEvent @"kInviteFriendButtonEvent"//我的邀请-邀请好友按钮
#define kMyConnectAddConnectButtonEvent @"MyConnectAddConnectButtonEvent"//我的人脉-增加人脉按钮

#define kModifyPwdSubmitEvent   @"ModifypwdSubmitEvent"//修改密码按钮提交
#define kPlatFormProgress @"PlatFormProgressOnclick"//跟进进度
#define kFollowUpProgress @"FollowUpProgressOnclick"//平台反馈 进度
#define kSearchEvent                    @"SearchReportEvent"//悬赏-按行业报备按钮点击
#define kConfirmPassPageSubmitButtonEvent @"ConfirmPassPageSubmitButtonEvent"//
#define kSign4MoneyPageSubmitButtonEvent @"Sign4MoneyPageSubmitButtonEvent"//
#define kConfirmGOBackPageSubmitButtonEvent @"ConfirmGOBackPageSubmitButtonEvent"//
#define kMyProjectEvent               @"MyProjectEvent"//我的-我的项目·
#define kMyEnterpriseIncomeEvent               @"MyEnterpriseIncomeEvent"//我的 企业入驻·
#define kMyProjectPCEvent                    @"MyProjectPCEvent"//我的项目 PC Onclick
#define kMyEnterpriseProjectListEveryEvent @"MyEnterpriseProjectListEveryEvent"//我的企业项目列表 逐项点击
#define kEnterpriseApplyMicrophoneOnclickEvent @"EnterpriseApplyMicrophoneOnclickEvent"//我的企业申请🎧点击

#define kFromEnterpriseApplySubmitEvent   @"FromEnterpriseApplySubmitEvent"//企业账号申请 提交按钮点击
#define kChectListBackonClickEvent            @"ChectListBackonClickEvent"//审核列表退回按钮点击
#define kChectListPhoneonClickEvent            @"ChectListPhoneonClickEvent"//审核列表电话按钮点击
#define kChectListConfirmSignonClickEvent            @"ChectListConfirmSignonClickEvent"//审核列表确认签约按钮点击
#define kChectListConfirmPassClickEvent            @"ChectListConfirmPassClickEvent"//审核列表确认通过按钮点击
#define kFromProgressListQuitButtonEvent @"FromProgressListQuitButtonEvent"//跟进记录列表退回按钮点击
#define kFromProgressListConfirmButtonEvent @"FromProgressListConfirmButtonEvent"//跟进记录列表确认通过按钮点击
#define kFromProgressListAddRecordButtonEvent @"FromProgressListAddRecordButtonEvent"//跟进记录列表添加记录按钮点击
#define kFromProgressListPhoneButtonEvent @"FromProgressListPhoneButtonEvent"//跟进记录列表添加记录按钮点击
#define kApplyEnterpriseServicePhoneEvent                    @"ApplyEnterpriseServicePhoneEvent"//企业入职申请 客服电话拨打 Onclick
//（邀请渠道包括邀请好友和增加人脉）
/*
 //邀请好友按钮-当面扫码
 //邀请好友按钮-微信好友
 //邀请好友按钮-朋友圈
 //邀请好友按钮-qq空间
 //邀请好友按钮-qq好友
 //邀请好友按钮-取消
 */
#define kInviteShareQRCODEToFriend                  @"InviteShareQRCODEtoFriend"
#define kInviteShareWechatFriend                    @"InvitShareWechatFriend"
#define kInvitShareWechatCircleOfFriend             @"InvitShareWechatCircleOfFriend"
#define kInvitShareQQSpaceEvent                     @"InvitShareQQSpaceEvent"
#define kInvitShareQQFriendEvent                    @"InvitShareQQFriendEvent"
#define kInvitShareCancelEvent                      @"InvitShareCancelButton"
#define kConnectShareQRCODEToFriend                 @"konnectShareQRCODEtoFriend"
#define kConnectShareWechatFriend                   @"connectShareWechatFriend"
#define kConnectShareWechatCircleOfFriend           @"connectShareWechatCircleOfFriend"
#define kConnectShareQQSpaceEvent                   @"connectShareQQSpaceEvent"
#define kConnectShareQQFriendEvent                  @"connectShareQQFriendEvent"
#define kConnectShareCancelEvent                    @"connectShareCancelButton"

#define kLoginPage               @"LoginPage"
#define kLawPage                 @"WebViewPage"
#define kAdvertisePage           @"AdvertisePage"
#define kAdvertiseWebPage        @"AdvertiseWebPage"
#define kPageOne                 @"HomePage"
#define kPageTwo                 @"ProjectListPage"
#define kPageThree               @"FindPage"
#define kPageFour                @"MyPage"
#define kActivityPage            @"ActivityListPage"
#define kActivityDetailPage      @"ActivityDetailPage"
#define kMyCollectListPage       @"MyCollectListPage"
#define kMyReportListPage        @"MyReportListPage"
#define kMyyApplyRecordListPage  @"MyApplyRecordListPage"
#define kMyReportDetailPage      @"MyReportDetailPage"
#define kProjecrDetailPage       @"ProjectDetailPage"
#define kDirectReportPage        @"DirectReportPage"
#define kFromProjectDetailPage   @"TraditionReportPage"
#define kReportSuccessPage       @"ReportSuccessPage"
#define kjoiningInfoPage         @"joiningInfoPage"
#define krecommendInfoPage       @"recommendInfoPage"
#define kMessageLisPage          @"MessageLisPage"
#define kMessageTimelinePage     @"MessageTimelinePage"
#define kWithdrawProgressPage    @"WithdrawProgressPage "
#define kAccountPage             @"AccountPage"
#define kEfficiencyPage          @"EfficiencyPage"
#define kEfficiencyListPage      @"EfficiencyListPage"
#define kAccountManagePage       @"AccountManagePage"
#define kMyClinetListPage        @"MyClientListPage"
#define kMyClinetDetailPage      @"MyClientDetailPage"
#define kAddClientDetailPage     @"AddClientDetailPage"
#define kComplaintPage           @"ComplaintPage"
#define kFunQuPage               @"FunQuPage"
#define kAboutUsPage             @"AboutUsPage"
#define kSettingPage             @"SettingPage"
#define kUnlockClientListPage    @"UnlockClientListPage"
#define kWithdrawViewPage        @"WithdrawViewPage"
#define kWithdrawViewAlipayPage  @"WithdrawViewAlipayPage"
#define kReviewPage              @"ReviewPage"
#define kSubmitMoneySuccessPage  @"SubmitMoneySuccessPage"
#define kGuideViewPage           @"GuideViewPage"
#define kBannerPage              @"BannerWebPage"
#define kLawPage                 @"WebViewPage"
#define kMyconnectListPage       @"connectListPage"
#define kSelectSendClient        @"selectSendClientPage"
#define kMyInvitePage            @"MyInvitePage"
#define kMyInviteDetailPage      @"MyInviteDetailPage"
#define MyConnectionPage         @"MyConnectionPage"
#define kMyInvitePage            @"MyInvitePage"
#define kMyIncomeListPage        @"incomeListPage"
#define kMyCheckListPage        @"MyCheckListPage"
#define kProgressRecordPage     @"ProgressRecordPage"

#define kAccountSecurityPage      @"AccountSecurityPage"
#define kFollowupTimelinePage     @"FollowupTimelinePage"
#define kPlatformTimelinePage     @"PlatformTimelinePage"


#define kSubmintRecomCustSuccPage  @"SubmintRecomCustSuccPage"

#define kEnterprisePage        @"EnterprisePage"
#define kSignSuccessPagesPage  @"SignSuccessPage"
#define kAlreadySignListPage       @"AlreadySignListPage"
#endif
