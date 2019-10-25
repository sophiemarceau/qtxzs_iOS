//
//  MyconnectionViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/20.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyconnectionViewController.h"
#import "noWifiView.h"
#import "InviteViewHeadView.h"
#import "publicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SubmitView.h"
#import "noContent.h"
#import "BaseTableView.h"
#import "WebViewController.h"
#import "QRCodeViewController.h"
#import "ProgressHUD.h"
#import "ShareQRCodeView.h"
#import "WXApi.h"
#import "ConnectLisstViewController.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MyConnectDetailViewController.h"
#import "IncomeListViewController.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ConnectViewAttentionViewController.h"

@interface MyconnectionViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate,SelectSharedTypeDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent *nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;
    NSDictionary *dto;
    int badge;
    double balance;
    NSDictionary  *authdto;
    UIWebView *webView;
    UIView *nocontentView;
    UIView *tableviewHeader;
    NSString *userPhoto;
    NSString *nameString;
    NSString *cooystring;
    NSString *reward_balance;
}

@property (nonatomic,strong)InviteViewHeadView *myheadView;
@property (nonatomic,strong)NSMutableArray *mydata;
@property (nonatomic,strong)SubmitView *subview;
@property (nonatomic,strong)UILabel *ruleLabel;
@property (nonatomic,strong)UILabel *noContentLabel;
@property (nonatomic,strong)UIImageView *noContentImageView;
@property (nonatomic,strong)UIButton *directButton;
@property (nonatomic,strong)UIButton *incomeButton;
@property (nonatomic,strong)UIButton *connectionButton;
@end

@implementation MyconnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableviewHeader= [UIView new];
//    [self initNavBarView];
    [self.view addSubview:self.subview];
    self.subview.frame = CGRectMake(0, kScreenHeight-84*AUTO_SIZE_SCALE_X, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    [self initdata];
    [self initTableView];
    [self loadListData];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

-(void)initTableView{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-84*AUTO_SIZE_SCALE_X)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView = tableviewHeader;
    myTableView.rowHeight = 136/2*AUTO_SIZE_SCALE_X+1;
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadListData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetMyConnectionCountAndContributionSumResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                NSDictionary *userdto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                
                userPhoto = [userdto objectForKey:@"us_photo"];
                
                [self.myheadView.headerImageView setImageWithURL:[NSURL URLWithString:[userdto objectForKey:@"us_photo"]] placeholderImage:[UIImage imageNamed:@"img-defult-account"]];
                nameString = [userdto objectForKey:@"us_nickname"];;
                
                self.myheadView.NameLabel.text= [userdto objectForKey:@"us_nickname"];
                NSString *invitationNum = [NSString stringWithFormat:@"邀请码:%d",[[userdto objectForKey:@"user_id"] intValue]];
                self.myheadView.InviteCodeLabel.text = invitationNum;
                self.myheadView.invitePersonCountLabel.text = [NSString stringWithFormat:@"%d人",[[userdto objectForKey:@"invitationNum"] intValue]];
                cooystring = [NSString stringWithFormat:@"%d",[[userdto objectForKey:@"user_id"] intValue]];
                reward_balance =[userdto objectForKey:@"reward_balance"];
                self.myheadView.inviteActivityTotallMoneyLabel.text = [NSString stringWithFormat:@"%@元",[userdto objectForKey:@"reward_balance"]];
                [self.myheadView.CopyButton addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            failView.hidden = YES;
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];
}

-(void)loadListData{
    [myTableView.head endRefreshing];
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"_sil_level":@"",
                          @"_contribution_type":@"",
                          @"_contribution_sum":@"",
                          @"_invitation_count":@"",
                          @"_report_count":@"",
                          @"_signedup_count":@"",
                          @"_sortType":@"",
                          @"_sil_createdtime":@""
                          };
    
    [[RequestManager shareRequestManager] SearchConnectionDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array !=nil)
                {
                    [data addObjectsFromArray:array];
                    
                }else{
                    
                }
                if (data.count>0) {
                    myTableView.hidden = NO;
                    tableviewHeader.hidden = NO;
                    self.myheadView.horizontalLineImageView.hidden = NO;
                    self.myheadView.frame = CGRectMake(0, 0, kScreenWidth, 562/2*AUTO_SIZE_SCALE_X-64);
                    
                    
                    [self.myheadView addSubview:self.ruleLabel];
                    //-25*AUTO_SIZE_SCALE_X
                    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.myheadView.mas_right).offset(-15);
                        make.bottom.equalTo(self.myheadView .mas_bottom);
                        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X));
                    }];
                    tableviewHeader.frame = CGRectMake(0, 0, kScreenWidth, self.myheadView.frame.size.height);
                    [self loadData];
                }else{
                    myTableView.height = YES;
                    tableviewHeader.hidden = YES;
                    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                    [self.view addSubview:webView];
                    webView.frame=CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-84*AUTO_SIZE_SCALE_X);
                    webView.scrollView.bounces=NO;
                    webView.scrollView.showsHorizontalScrollIndicator = NO;
                    webView.scrollView.scrollEnabled = YES;
                    webView.opaque = NO; //去掉下面黑线
                    webView.backgroundColor =[UIColor clearColor];
                    webView.delegate = self;
                    NSString *path = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"partnernull.html"];
                    
                    NSURL *url = [NSURL URLWithString:path];
                    [webView loadRequest:[NSURLRequest requestWithURL:url]];
                }
                
                [tableviewHeader addSubview:self.myheadView];
                myTableView.tableHeaderView = tableviewHeader;
                [myTableView reloadData];
                failView.hidden = YES;
                if (data.count == total_count ) {
                    [myTableView.foot finishRefreshing];
                }
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        failView.hidden = NO;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
        [self loadListData];
        return;
    }
    else{
        current_page ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchConnectionDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        failView.hidden = YES;
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [data removeAllObjects];
            }
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];
            }else{
            }
            [myTableView reloadData];
            [refreshView endRefreshing];
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [myTableView.head endRefreshing];
            }
            if (data.count == total_count) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            [refreshView endRefreshing];
        }
    } failuer:^(NSError *error) {
        [refreshView endRefreshing];
        failView.hidden = NO;
    }];
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (data.count > 0) {
        cell.backgroundColor = [UIColor whiteColor];
        UIView *CellBgView = [UIView new];
        CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 136/2*AUTO_SIZE_SCALE_X);
        CellBgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:CellBgView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height, kScreenWidth, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [CellBgView addSubview:lineImageView];
        
        UIImageView *levelFlagImageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        int levelflag = [[data[indexPath.row] objectForKey:@"level"] intValue];
        if (levelflag == 1) {
            levelFlagImageview.image = [UIImage imageNamed:@"icon-list-1"];
        }
        if (levelflag == 2) {
            levelFlagImageview.image = [UIImage imageNamed:@"icon-list-2"];
        }
        if (levelflag == 3) {
            levelFlagImageview.image = [UIImage imageNamed:@"icon-list-3"];
        }
        
        
        [CellBgView addSubview:levelFlagImageview];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelFlagImageview.frame.size.width+levelFlagImageview.frame.origin.x+8*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 300*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = FontUIColorBlack;
        titleLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        titleLabel.text = [NSString stringWithFormat:@"%@  %@",[data[indexPath.row] objectForKey:@"user_nickname"],[data[indexPath.row] objectForKey:@"user_tel"]];
        [CellBgView addSubview:titleLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-70*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.textColor = RedUIColorC1;
        statusLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        statusLabel.text = [NSString stringWithFormat:@"%@元", [data[indexPath.row] objectForKey:@"self_contribution_sum"]];
        
        [CellBgView addSubview:statusLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 280*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
        subLabel.textAlignment = NSTextAlignmentLeft;
        subLabel.textColor = FontUIColorGray;
        NSString *subString = [NSString stringWithFormat:@"通过审核的推荐客户数为%d条", [[data[indexPath.row] objectForKey:@"self_report_count"] intValue]];
        subLabel.text = [NSString stringWithFormat:@"%@",subString];
        subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        
        
        [CellBgView addSubview:subLabel];
        
        if(indexPath.row == data.count -1 ||data.count == 1){
            lineImageView.hidden = YES;
        }else{
            lineImageView.hidden = NO;
        }

    }
    return cell;
    
}

//-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
//    
//    label.numberOfLines = 1;
//    
//    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
//    
//    label.textAlignment =NSTextAlignmentLeft;
//    
//    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
//    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
//    
//    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
//    label.attributedText = mutablestr;
//    
//    [label sizeToFit];
//    return label;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyConnectDetailViewController * vc = [[MyConnectDetailViewController alloc] init];
    vc.titles =@"用户详情";
    
    vc.sil_id = [NSString stringWithFormat:@"%d",[[data[indexPath.row] objectForKey:@"sil_id"] intValue]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)tempwebView
{
//    NSInteger height = [[tempwebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    
    
//    nocontentView.frame = CGRectMake(0, nocontentView.frame.origin.y, kScreenWidth, webView.frame.origin.y+webView.frame.size.height);
    
    
//    tableviewHeader.frame = CGRectMake(0, 0, kScreenWidth, self.myheadView.frame.size.height+nocontentView.frame.size.height);
//    myTableView.tableHeaderView = tableviewHeader;
    
}

//-(void)shareWechat: (NSNotification *)notification{
//    
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *shared = userInfo[@"shareflag"];
//    if ([shared isEqualToString:@"0"]||[shared isEqualToString:@"1"]) {
//        if (![WXApi isWXAppInstalled]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"您的设备没有安装微信"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//    }
//    if ([shared isEqualToString:@"0"]) {
//        [MobClick event:kShareQRCODEToFriend];
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
//    }
//    
//    if ([shared isEqualToString:@"1"]) {
//        [MobClick event:kShareQRCODEToMoments];
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
//    }
//    if ([shared isEqualToString:@"2"]) {
//        
//        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
//        vc.titles = @"邀请二维码";
//        vc.userPhoto = userPhoto;
//        vc.nameString =nameString;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    
    NSString *titles = @"【您的好友邀请您领取20元现金】";
    NSString *desc = @"听说，80%的渠道人都在这里赚到爆，快和好友一起共闯“渠到天下”吧";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:[UIImage imageNamed:@"渠天下icon"]];
    
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
#pragma mark share board
-(void)submitBtnPressed:(UIButton *)sender
{
    
    [MobClick event:kMyConnectAddConnectButtonEvent];
    SharedView *show = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.dicarray = @[
                      @{@"icon-image":@"icon-myScan-code",@"value":@"当面扫码",@"shareflag":@"0"},
                      @{@"icon-image":@"icon-shareWeixin",@"value":@"微信好友",@"shareflag":@"1"},
                      @{@"icon-image":@"icon-sharePyq",@"value":@"朋友圈",@"shareflag":@"2"},
                      @{@"icon-image":@"icon-shareQQ",@"value":@"QQ好友",@"shareflag":@"3"},
                      @{@"icon-image":@"icon-shareQzone@3x",@"value":@"QQ空间",@"shareflag":@"4"},
                      ] ;
    show.delegate = self;
    [show showView];
    
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
        [MobClick event:kConnectShareWechatFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    
    if ([shared isEqualToString:@"2"]) {
        [MobClick event:kConnectShareWechatCircleOfFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if ([shared isEqualToString:@"0"]) {
        [MobClick event:kConnectShareQRCODEToFriend];

        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
        vc.titles = @"邀请二维码";
        vc.userPhoto = userPhoto;
        vc.nameString =nameString;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([shared isEqualToString:@"3"]) {
        [self isQQInstall];
        [MobClick event:kConnectShareQQFriendEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if ([shared isEqualToString:@"4"]) {
        [self isQQInstall];
        [MobClick event:kConnectShareQQSpaceEvent];
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

#pragma mark 查看进度
-(void)onClickAction:(UIButton *)sender{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    [pab setString:cooystring];
    
    if (pab == nil) {
        [ProgressHUD showError:@"复制失败"];
        
    }else
    {
        [[RequestManager shareRequestManager] tipAlert:@"您已经成功复制邀请码" viewController:self];
    }
}

-(void)ruleTaped:(UITapGestureRecognizer *)sender{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.webViewurl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,@"guizepartner.html"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)incomeButtonOnclick:(UIButton *)sender {
    self.incomeButton.enabled = NO;
    
    IncomeListViewController * vc = [[IncomeListViewController alloc] init];
    vc.titles =@"人脉收益";
    
    if ([reward_balance intValue] == 0) {
        vc.ZeroFlag = YES;
    }else{
        vc.ZeroFlag = NO;

    }
    [self.navigationController pushViewController:vc animated:YES];
    self.incomeButton.enabled = YES;
    
}

- (void)connectionButtonOnclick:(UIButton *)sender {
    self.connectionButton.enabled = NO;
    ConnectLisstViewController  *vc = [[ConnectLisstViewController alloc] init];
    vc.titles =@"人脉列表";
    [self.navigationController pushViewController:vc animated:YES];
    
    self.connectionButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UIButton *)incomeButton{
    if (_incomeButton == nil ) {
        self.incomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.incomeButton.backgroundColor = [UIColor clearColor];
        [self.incomeButton addTarget:self action:@selector(incomeButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeButton;
}

-(UIButton *)connectionButton{
    if (_connectionButton == nil ) {
        self.connectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.connectionButton.backgroundColor = [UIColor clearColor];
        [self.connectionButton addTarget:self action:@selector(connectionButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectionButton;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"发提醒" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _directButton;
}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

-(void)dButtonClick{
    
    self.directButton.enabled = NO;
    ConnectViewAttentionViewController *vc = [[ConnectViewAttentionViewController alloc]init];
    vc.titles = @"发提醒";
    [self.navigationController pushViewController:vc animated:YES];
    self.directButton.enabled = YES;
}

-(InviteViewHeadView *)myheadView{
    if (_myheadView == nil) {
        self.myheadView = [InviteViewHeadView new];
        NSDictionary *tempdata = [[NSDictionary alloc] init];
        self.myheadView.data = tempdata;
        self.myheadView.backgroundColor = [UIColor whiteColor];
        self.myheadView.inviteLabel.text = @"全部人脉";
        [self.myheadView addSubview:self.incomeButton];
        self.incomeButton.frame = CGRectMake(kScreenWidth/2, 170*AUTO_SIZE_SCALE_X-64, kScreenWidth/2, 172/2*AUTO_SIZE_SCALE_X);
        [self.myheadView addSubview:self.connectionButton];
        self.myheadView.moneyLabel.text = @"人脉收益";
        self.connectionButton.frame = CGRectMake(0, 170*AUTO_SIZE_SCALE_X-64, kScreenWidth/2, 172/2*AUTO_SIZE_SCALE_X);
        
    }
    return _myheadView;
}

-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor whiteColor];
        [self.subview.subButton setTitle:@"增加人脉" forState:UIControlStateNormal];
        [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subview;
}

- (UILabel *)ruleLabel {
    if (_ruleLabel == nil) {
        self.ruleLabel = [CommentMethod initLabelWithText:@"查看合伙人规则>>" textAlignment:NSTextAlignmentRight font:13*AUTO_SIZE_SCALE_X];
        self.ruleLabel.textColor = FontUIColorGray;
        self.ruleLabel.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleTaped:)];
        [self.ruleLabel addGestureRecognizer:tap1];
    }
    return _ruleLabel;
}

- (UILabel *)noContentLabel {
    if (_noContentLabel == nil) {
        self.noContentLabel = [CommentMethod initLabelWithText:@"您还没有成功邀请过用户，赶紧来邀请吧！" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.noContentLabel.numberOfLines = 2;
        self.noContentLabel.textColor = FontUIColorGray;
    }
    return _noContentLabel;
}

- (UIImageView *)noContentImageView {
    if (_noContentImageView == nil) {
        self.noContentImageView = [UIImageView new];
        self.noContentImageView.image = [UIImage imageNamed:@"icon-invitation-no"];
    }
    return _noContentImageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:MyConnectionPage];//("PageOne"为页面名称，可自定义)
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:MyConnectionPage];
}
@end
