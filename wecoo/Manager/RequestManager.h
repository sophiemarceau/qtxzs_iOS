//
//  RequestManager.h
//
//
//
//
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef void(^SuccessData)(NSDictionary *result);
typedef void(^ErrorData)( NSError *error);

@interface RequestManager : NSObject

+(RequestManager *)shareRequestManager;

@property (nonatomic,strong) NSArray *friendArray; //好友数组

@property (nonatomic,copy)NSString *token; //token
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,assign) BOOL hasNetWork;
@property (nonatomic,assign) BOOL setRootVC;
@property (nonatomic,assign) BOOL canuUMPush;
@property (nonatomic,copy) NSString *cityname;
@property (nonatomic,assign)NSInteger heartbeat;  //轮询定位提交时间 (分钟)
@property (nonatomic,assign)NSInteger userPageCount;  //用户搜索的默认分页数量
@property (nonatomic,assign)NSInteger firendPageCount;//好友列表的默认分页数量
@property (nonatomic,assign)NSInteger eventPageCount; //活动搜索的默认分页数量
@property (nonatomic,assign)NSInteger topicPageCount; //活动评论搜索的默认分页数量
@property (nonatomic,copy) NSString *appUsl;//应用的链接地址
@property (nonatomic,copy) NSString *beforeAppVersion_;
@property (nonatomic,copy) NSString *nowVersions_;

@property (nonatomic,strong) UIViewController *CurrMainController;
@property (nonatomic,strong) UITabBarController *CurrTabBarController;

@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *longti;

@property (nonatomic,assign)int messgeCount;//未读消息

-(NSString *)md5:(NSString *)str;

//取消请求
- (void)cancelAllRequest;
-(NSString *)opendUDID;
#pragma jsonString JSON格式的字符串 @return 返回字典
-(NSArray *)dictionaryWithJsonString:(NSString *)jsonString;
#pragma mark - 4.3.11	App退出时，清除机器码
- (void)QuitResult:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors;

#pragma mark - 获取验证码
- (void)GetVerifyCodeResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;
#pragma mark - 登录
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 4.1.1	获取行业数据字典
- (void)GetLookupIndustryMapResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark - 4.1.2	获取银行数据字典
- (void)GetlookupBankAllMapResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark - 4.2.1	获取客户列表
- (void)GetsearchCustomerResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;


#pragma mark - 4.2.2	添加客户
- (void)GetaddCustomerResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 4.2.3	修改客户
- (void)UpdateCustomerResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 4.2.4	通过ID获取一条客户记录
- (void)getCustomerResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 4.2.5	删除客户
- (void)DeleteClientResult:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark - 4.2.6	我的报备-数量统计
- (void)GetMyCustomerReportCountResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;

#pragma mark - 4.2.7	我的报备-核实中
- (void)SearchMyCustomerReportDtosVerifyingResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors;

#pragma mark - 4.2.8	我的报备-跟进中
- (void)SearchMyCustomerReportDtosFollowingResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors;

#pragma mark - 4.2.9	我的报备-考察中
- (void)SearchMyCustomerReportDtosInspectingResult:(NSDictionary *)dataDic
                                    viewController:(UIViewController *)controller
                                       successData:(SuccessData)success
                                           failuer:(ErrorData)errors;

#pragma mark - 4.2.10	我的报备-已签约
- (void)SearchMyCustomerReportDtosSignedUpResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark - 4.2.11	我的报备-已退回
- (void)SearchMyCustomerReportDtosBackResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;

#pragma mark - 4.2.12	查看报备进度
- (void)SearchReportProgressResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark - 4.2.13	添加报备
- (void)AddCustomerReportResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark - 4.2.14	通过ID获取报备记录详情
- (void)GetCustomerReportDtoResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark -4.3.2	统计我的相关数（客户数关注数活动数）
- (void)GetSalesmanUserRelatedCountResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark -4.3.3	个人资料修改
- (void)UpdateUserSalesmanInfoResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors;

#pragma mark -4.3.4	获取业务员用户信息详情
- (void)GetUserDetailResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark -4.3.5	获取用户报备质量分
- (void)GetReportEffectiveRateResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark 4.3.6	上传头像
- (void)SubmitImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark -4.4.1	账户变动明细
- (void)SearchSalemanAccountLogDtosResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark -4.4.2	获取上一次提现记录（获取上一次提现银行卡信息）
- (void)GetLastWithdrawalRecordResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors;

#pragma mark -4.4.3	申请提现
- (void)ApplyWithdrawResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;

#pragma mark -4.5.1	获取未读系统消息的数量
- (void)GetSysMsgUnReadCountResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark -4.5.2	获取系统消息列表
- (void)SearchSysMsgDtosResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark -4.5.3	消息置为已读
- (void)UpdateSysMsgToReadResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark 4.5.4	上传图片文件（如投诉建议功能上传图片）
- (void)ComplaintUploadImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark 4.4.20	企业上传图片
- (void)UploadCompFileUploadImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark -4.5.5	创建投诉/意见反馈
- (void)SubmitFeedbackResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;

#pragma mark -4.5.5	关注项目/悬赏
- (void)AddProjectCollectionRecordResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark -4.5.6	获取关注项目列表/我的关注
- (void)SearchProjectCollectionRecordDtosResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors;

- (void)AddProjectBrowsingRecordesult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;

#pragma mark -4.5.7	取消项目关注/收藏
- (void)CancelProjectCollectionRecordResult:(NSDictionary *)dataDic
                                 viewController:(UIViewController *)controller
                                    successData:(SuccessData)success
                                        failuer:(ErrorData)errors;

- (void)ProjecDetailCancelCollectionRecordResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark -4.5.8	查看项目是否已关注 未添加
- (void)IsProjectCollectedResult:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors;

#pragma mark -4.5.9	获取banner列表(app端)
- (void)SearchAdDtoListResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;

#pragma mark -4.6.1	获取单个项目详情
- (void)GetProjectDtoResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark -4.6.2	获取项目的成交名单
- (void)SearchReportListSignedUpDtoListResult:(NSDictionary *)dataDic
                               viewController:(UIViewController *)controller
                                  successData:(SuccessData)success
                                      failuer:(ErrorData)errors;

#pragma mark -4.6.2	APP获取项目列表
- (void)SearchProjectsResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark -4.6.3	APP获取首页推荐项目列表
- (void)SearchPromotingProjectsResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark -4.7.1	获取单个活动详情
- (void)GetActivityDtoResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;

#pragma mark -4.7.2	APP（前端）获取活动列表
- (void)SearchActivityDtos4ShowResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark -4.8.1	APP（前端）提交外包招商加盟信息
- (void)SubmitJoiningInfoResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;

#pragma mark -4.9.1	APP（前端）提交招商厂商引荐信息
- (void)SubmitManufacturerRecommendInfoResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;
#pragma mark - 4.5.13	检查产品版本更新
- (void)getVersionInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark - 4.5.14	获取打开APP时的加载图片（及对应跳转的Url）
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -首页是否显示新手引导
- (void)NewGuideResult:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -4.4.3 获取提现申请的最低余额限制
- (void)getWithdrawingLimitResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark -4.5.15	查询用户报备质量分变更记录
- (void)SearchSalesmanReporteffectiverateListResult:(NSDictionary *)dataDic
                                     viewController:(UIViewController *)controller
                                        successData:(SuccessData)success
                                            failuer:(ErrorData)errors;

#pragma mark -4.2.15	获取报备客户记录的锁定时间（天数）
- (void)GetReportLockTimeResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark -4.3.8	获取业务员实名认证信息
- (void)GetUserSalesmanIDInfoDtoResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;

#pragma mark 4.3.9	业务员提交实名认证信息
- (void)SalesmanSubmitIDInfoResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark 4.3.7	获取业务员账户余额
- (void)getClientBalanceResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark 4.4.6	当前业务员是否可申请提现
- (void)isWithdrawEnableResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark 4.2.16	用户当天是否允许报备
- (void)isReportAllowedResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

- (void)GetMyInviteInformationResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark - 4.5.16	获取用户头像邀请码邀请人数和总奖金
- (void)GetInvitationSalesmanRewardBalanceResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark -4.5.17	查询被邀请人详情
- (void)GetBeInviterSalesmanDetailsDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;

#pragma mark -4.4.7	获取用户最后一次提现记录
- (void)GetLastWithdrawalRecordByTypeResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.8	根据UserId发送验证码
- (void)SendValidateCodeSmsByUserIdResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.9	支付宝申请提现接口
- (void)ApplyWithdrawByAlipayResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.10	银行卡申请提现接口
- (void)ApplyWithdrawByCardDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;

#pragma mark -4.4.11	查询用户的申请记录
- (void)SearchSalesmanWithdrawingApplicationDtosResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.12	查询提现进度
- (void)GetSalesmanWithdrawingApplicationLogListResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.13	修改申请提现接口-支付宝
- (void)UpdateApplyWithdrawByAlipayDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;
#pragma mark -4.4.14	修改申请提现接口-银行卡
- (void)UpdateApplyWithdrawByCardDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;

#pragma mark -4.4.15	根据提现Id 返回一条提现记录
- (void)GetSalesmanWithdrawingApplicationDtoDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors;

#pragma mark -4.5.19	查询我的人脉列表
- (void)SearchConnectionDtosResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;
#pragma mark - 4.5.20	获取用户头像邀请码邀请人数和总奖金
- (void)GetMyConnectionCountAndContributionSumResult:(NSDictionary *)dataDic
                                      viewController:(UIViewController *)controller
                                         successData:(SuccessData)success
                                             failuer:(ErrorData)errors;

#pragma mark -4.5.18	查询我的人脉详情
- (void)GetConnectionDetailResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark -4.4.17	查询我的人脉收益-统计总金额
- (void)GetMyContributionSumByLevelAndKindResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark -4.4.16	查询我的人脉收益
- (void)SearchConnectionContributionDtosResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark -4.4.18	查询我的人脉详情下的动态
- (void)SearchConnectionDynamicDtosResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors;

#pragma mark -4.3.1	根据用户Id查询用户手机号
- (void)GetUserTelResult:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark -4.3.13	获取用户是否设置过提现密码
- (void)IsWithdrawPwdNullResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark -4.3.14	设置提现密码
- (void)SetUpWithdrawPwdResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;
#pragma mark -4.3.15	提现密码是否输入正确
- (void)IsWithdrawPwdRightResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;
#pragma mark -4.3.16	修改提现密码
- (void)ModifyWithdrawPwdResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;
#pragma mark -4.3.17	重置密码
- (void)ResetWithdrawPwdResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;
#pragma mark -4.4.10NEW	银行卡申请提现接口
- (void)ApplyWithdrawByCardDtoResultNew:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;
#pragma mark -4.4.14New	修改申请提现接口-银行卡
- (void)UpdateApplyWithdrawByCardDtoResultNew:(NSDictionary *)dataDic
                               viewController:(UIViewController *)controller
                                  successData:(SuccessData)success
                                      failuer:(ErrorData)errors;

#pragma mark -4.4.9New	支付宝申请提现接口
- (void)ApplyWithdrawByAlipayResultNew:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;
#pragma mark -4.4.13New	修改申请提现接口-支付宝
- (void)UpdateApplyWithdrawByAlipayDtoResultNew:(NSDictionary *)dataDic
                                 viewController:(UIViewController *)controller
                                    successData:(SuccessData)success
                                        failuer:(ErrorData)errors;
#pragma mark -获取跟进信息列表
- (void)getFollowupInfoDtosResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark - 4.2.18	我推荐的客户-核实中
- (void)SearchParentCustomerReportDtosVerifyingResult:(NSDictionary *)dataDic
                                       viewController:(UIViewController *)controller
                                          successData:(SuccessData)success
                                              failuer:(ErrorData)errors;
#pragma mark - 4.2.19	我推荐的客户-跟进中
- (void)SearchParentCustomerReportDtosFollowingResult:(NSDictionary *)dataDic
                                       viewController:(UIViewController *)controller
                                          successData:(SuccessData)success
                                              failuer:(ErrorData)errors;
#pragma mark - 4.2.20	我推荐的客户-已签约
- (void)SearchParentCustomerReportDtosSignedUpResult:(NSDictionary *)dataDic
                                      viewController:(UIViewController *)controller
                                         successData:(SuccessData)success
                                             failuer:(ErrorData)errors;

#pragma mark - 4.2.21	我推荐的客户-已退回
- (void)SearchParentCustomerReportDtosBackResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark - 4.2.22	查看平台反馈列表
- (void)SearchPlatformFeedbackCrlDtoListResult:(NSDictionary *)dataDic
                                viewController:(UIViewController *)controller
                                   successData:(SuccessData)success
                                       failuer:(ErrorData)errors;

#pragma mark - 4.6.5	获取项目列表
- (void)SearchSimpleAppProjectDtosResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors;

#pragma mark - 4.2.23	获取所有审核中报备数
- (void)GetWaitingAuditingNumResult:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors;

#pragma mark - 4.2.28	审核列表
- (void)SearchCustomerReportDtosByProManager4AppResult:(NSDictionary *)dataDic
                                        viewController:(UIViewController *)controller
                                           successData:(SuccessData)success
                                               failuer:(ErrorData)errors;
#pragma mark - 4.6.6	根据用户 id 获取项目列表
- (void)SearchMyProjectDtosResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;
#pragma mark - 4.4.19	企业账号申请
- (void)CreateCompanyAccountAndInformationResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors;

#pragma mark -4.2.24	根据报备 id 加密串获取客户的手机号
- (void)GetCustomerTelByReportIdStrResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors;
#pragma mark - 4.2.30	查询报备沟通记录
- (void)searchCustomerReportLogsResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;
#pragma mark - 4.2.25	通过审核
- (void)PassAuditing4AppResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;
#pragma mark - 4.2.26	签约打款
- (void)ApplySignedUpAuditing4AppResult:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;
#pragma mark - 4.2.27报备退回
- (void)SendBackCustomerReport4App:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark - 4.2.29	添加报备沟通记录
- (void)AddCustomerReportLogSingle4App:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;

#pragma mark -APP获取提现规则文案
- (void)GetWithdrawRulesResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;
#pragma mark -分页获取已签约报备列表
- (void)SearchAlreadyReportListDtosResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors;

#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller;
- (void)tipAlert:(NSString *)results;
- (void)resultFail:(NSDictionary *)result;
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller;

@end
