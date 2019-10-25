//
//  MyController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyController.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"
#import "MyReportListViewController.h"
#import "MyClientViewController.h"
#import "BalanceViewController.h"
#import "efficiencyViewController.h"
#import "ComplainViewController.h"
#import "messageControlllerViewController.h"
#import "SettingViewController.h"
#import "AboutusViewController.h"
#import "FunViewController.h"
#import "MyFavrioteViewController.h"   
#import "ActivityListViewController.h"
#import "WithdrawViewController.h"  
#import "ClientInformationViewController.h"
#import "SubmitSuccessedViewController.h"
#import "UIImageView+WebCache.h"
#import "ReviewPersonalInfoViewController.h"
#import "JSBadgeView.h"
#import "MyInviteViewController.h"
#import "MyconnectionViewController.h"
#import "MyConnectDetailViewController.h"
#import "IncomeListViewController.h"
#import "ConnectLisstViewController.h"
#import "loginenterpriseViewController.h"
#import "MyProjectViewController.h"
#import "Signup4MoneyViewController.h"
#import "ProgressRecordViewController.h"
#import "enterpriseapplyControllerViewController.h"
#import "SignSucceedViewController.h"
#import "confirmreviewpassViewController.h"

@interface MyController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UITableView * myTableView;
    noWifiView * failView;
    NSDictionary *dto;
    int badge;
    double balance;
    NSString *us_partner_kind;
    int isCompanyAccount,reportWaitingAuditingNum;
}
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@property (nonatomic,strong)JSBadgeView *badgeView;
@end

@implementation MyController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUserIconUpdate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserInfo) name:kUserIconUpdate object:nil];

    self.myheadView.frame = CGRectMake(0, 0, kScreenWidth, 224*AUTO_SIZE_SCALE_X);
    self.myReportView.frame = CGRectMake(0, self.myheadView.frame.size.height+self.myheadView.frame.origin.y, kScreenWidth, 125*AUTO_SIZE_SCALE_X);
    
    for (int i = 0;  i < 4 ; i++) {
        //设置自定义按钮
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*kScreenWidth/4, 45*AUTO_SIZE_SCALE_X, kScreenWidth/4, (125-45)*AUTO_SIZE_SCALE_X)];

        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:Viewtap];
        view.tag = i;
        [self.myReportView addSubview:view];
    }

    [self.MyTableHeadView addSubview:self.myheadView];
    [self.MyTableHeadView addSubview:self.myReportView];
    self.MyTableHeadView.frame = CGRectMake(0, 0, kScreenWidth, 224*AUTO_SIZE_SCALE_X+125*AUTO_SIZE_SCALE_X);
    [self initTableView];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBalance:)];
    [self.myheadView.balanceView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickmyReport:)];
    [self.myReportView.reporteView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickEfficiency:)];
    [self.myheadView.efficiencyView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickmessagelist:)];
    self.myheadView.userInteractionEnabled = YES;
    [self.myheadView.messageImageView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickmanage:)];
    [self.myheadView.manageView addGestureRecognizer:tap4];
    [self.view addSubview:self.navView];
    self.navView.alpha  = 0;
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.myheadView.messageImageView alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeBackgroundColor = RedUIColorC1;
    self.badgeView.badgeOverlayColor = RedUIColorC1;//没有反光面
    self.badgeView.badgeStrokeColor = [UIColor whiteColor];//外圈的颜色，默认是白色
}


-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    MyReportListViewController * vc = [[MyReportListViewController alloc] init];
    NSLog(@"%d",(int)sender.view.tag+1);
    vc.menuTag = (int)sender.view.tag+1;
    vc.titles =@"已推荐客户";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickmanage:(UITapGestureRecognizer *)sender{
    [MobClick event:kAccountManageOnclickbuttonEvent];
    ClientInformationViewController  * vc = [[ClientInformationViewController alloc] init];
    vc.titles =@"账号管理";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickmessagelist:(UITapGestureRecognizer *)sender{
    self.myheadView.messageImageView.userInteractionEnabled = NO;
    [self pushview];
}

- (void)changeUserInfo{
    //获取当前用户信息
    [self getClientData];
}

-(void)onClickBalance:(UITapGestureRecognizer *)sender{
    [MobClick event:kMyAwardOnclickbuttonEvent];
    BalanceViewController  * vc = [[BalanceViewController alloc] init];
    vc.titles =@"我的赏金";
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)onClickEfficiency:(UITapGestureRecognizer *)sender{
    [MobClick event:kMyReportScoresEvent];
    efficiencyViewController  * vc = [[efficiencyViewController alloc] init];
    vc.titles =@"推荐质量分";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickmyReport:(UITapGestureRecognizer *)sender
{
    [MobClick event:kMyReportEvent];
    MyReportListViewController * vc = [[MyReportListViewController alloc] init];
    vc.menuTag = 1;
//    vc.menuTag = (int)sender.view.tag+1;
    vc.titles =@"已推荐客户";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initData{
    self.mydata =[NSMutableArray arrayWithCapacity:0];
    [self getClientData];
    [self getmessageCount];
    [self getReportRelateCount];
    
}


-(void)getClientData{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetUserDetailResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            if (result != nil) {
                NSDictionary *userdto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                 [self.myheadView.headerImageView setImageWithURL:[NSURL URLWithString:[userdto objectForKey:@"us_photo"]] placeholderImage:[UIImage imageNamed:@"img-defult-account"]];
                self.myheadView.NameLabel.text= [userdto objectForKey:@"us_nickname"];
                self.titles =  self.myheadView.NameLabel.text;
                self.myheadView.PhoneLabel.text = [userdto objectForKey:@"us_tel"];
                self.myheadView.balanceContent.text = [NSString stringWithFormat:@"￥%@",[userdto objectForKey:@"us_balance_str"]];
                
                balance = [[userdto objectForKey:@"us_balance"] doubleValue];
                us_partner_kind = [NSString stringWithFormat:@"%d",[[userdto objectForKey:@"us_partner_kind_code"] intValue]];
                self.myheadView.efficiencyContent.text = [NSString stringWithFormat:@"%d分",[[userdto objectForKey:@"us_report_effective_rate"] intValue]];
                
                
                
                isCompanyAccount = [[userdto objectForKey:@"isCompanyAccount"] intValue];
                
                
                [self getRelateCount];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}

-(void)getmessageCount{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetSysMsgUnReadCountResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            badge = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];

            if (badge==0) {
                self.badgeView.badgeText = nil;
            }else{
                self.badgeView.badgeText = [NSString stringWithFormat:@"%d", badge];
            }
             [self.badgeView setNeedsLayout];
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
//        [[RequestManager shareRequestManager] tipAlert:[NSString stringWithFormat:@"%d",badge] viewController:self];
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)getReportRelateCount{
    [self.mydata removeAllObjects];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetMyCustomerReportCountResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSDictionary *reportDto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![reportDto isEqual:[NSNull null]]){
                self.myReportView.checkConent.text = [NSString stringWithFormat:@"%d",[[reportDto objectForKey:@"auditCount"] intValue]];
                self.myReportView.followupConent.text =  [NSString stringWithFormat:@"%d",[[reportDto objectForKey:@"followUpCount"] intValue]];
                self.myReportView.investigateConent.text =  [NSString stringWithFormat:@"%d",[[reportDto objectForKey:@"inspectingCount"] intValue]];
                self.myReportView.signedConent.text =  [NSString stringWithFormat:@"%d",[[reportDto objectForKey:@"signedUpCount"] intValue]];
                self.myReportView.returnedConent.text = [NSString stringWithFormat:@"%d",[[reportDto objectForKey:@"backCustomerReporCount"] intValue]];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)getRelateCount{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetSalesmanUserRelatedCountResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSDictionary  *resultdto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![resultdto isEqual:[NSNull null]]){
                
                [self.mydata addObject:@{@"imagename":@"icon-myCustomer",
                                        @"imageLabel":@"我的客户",
                                        @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"customerNum"] intValue]]
                                         }];
                [self.mydata addObject:@{ @"imagename":@"icon-myFavorites",
                                          @"imageLabel":@"我的关注",
                                          @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"projectCollectionRecordNum"] intValue]]
                                          }];
                if ([us_partner_kind isEqualToString:@"0"]) {//如果是0 显示 我的邀请
                    [self.mydata addObject:@{ @"imagename":@"icon-myinvitation",
                                              @"imageLabel":@"我的邀请",
                                              @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"invitationNum"] intValue]]
                                              }];
                }
                if ([us_partner_kind isEqualToString:@"1"]) {//如果是1 显示我的人脉
                    [self.mydata addObject:@{ @"imagename":@"icon-myConnection",
                                              @"imageLabel":@"我的人脉",
                                              @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"connectionCount"] intValue]]
                                              }];
                 }
                
                if (isCompanyAccount == 0) {    //isCompanyAccount:是否为企业账号:0、企业账号;1、非企业账号
                    [self.mydata addObject:@{ @"imagename":@"icon_my_project",
                                              @"imageLabel":@"我的项目",
                                              @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"reportWaitingAuditingNum"] intValue]]
                                              }];
                }else{
                    [self.mydata addObject:@{ @"imagename":@"icon_my_settled",
                                              @"imageLabel":@"企业入驻",
                                              @"count":@"0"
                                              }];
                }
                
                [self.mydata addObject: @{ @"imagename":@"icon-myBunos",
                                             @"imageLabel":@"奖励活动",
                                             @"count":[NSString stringWithFormat:@"%d",[[resultdto objectForKey:@"activityNum"] intValue]]
                                             }];

                [self.mydata addObject:  @{
                                           @"imagename":@"icon-myComplaint",
                                           @"imageLabel":@"投诉建议",
                                           @"count":@"0",
                                           
                                           }];
                
                [self.mydata addObject: @{
                                          @"imagename":@"icon-myWanzhuan",
                                          @"imageLabel":@"玩转渠到天下",
                                          @"count":@"0",
                                          
                                          }];

                [self.mydata addObject: @{
                                          @"imagename":@"icon-myAbout",
                                          @"imageLabel":@"关于渠到天下",
                                          @"count":@"0",
                                          
                                          }];
                [self.mydata addObject: @{
                                          @"imagename":@"icon-mySet",
                                          @"imageLabel":@"设置",
                                          @"count":@"0",
                                          
                                          }];

                [myTableView reloadData];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView =self.MyTableHeadView;
    [self.view addSubview:myTableView];
//    //加载数据失败时显示
//    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
//    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    failView.hidden = YES;
//    [self.view addSubview:failView];
}

#pragma mark tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ((int)indexPath.row==3) {
        return 70*AUTO_SIZE_SCALE_X;
    }
    return 50*AUTO_SIZE_SCALE_X;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mydata.count;
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
    if (self.mydata.count > 0) {
        cell.backgroundColor = BGColorGray;
        UIView *CellBgView = [UIView new];
        CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
        CellBgView.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 15.5*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
        iconImageView.image = [UIImage imageNamed:[self.mydata[indexPath.row] objectForKey:@"imagename"]];
        [CellBgView addSubview:iconImageView];
        [cell addSubview:CellBgView];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height, kScreenWidth, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [CellBgView addSubview:lineImageView];
        
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+12*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 120*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X)];
        iconLabel.textAlignment = NSTextAlignmentLeft;
        iconLabel.textColor = UIColorFromRGB(0x333333);
        iconLabel.font=[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        iconLabel.text =[self.mydata[indexPath.row] objectForKey:@"imageLabel"];
        [CellBgView addSubview:iconLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, 18*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        [CellBgView addSubview:arrowImageView];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70*AUTO_SIZE_SCALE_X-15-7*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.textColor = FontUIColorGray;
        numberLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        numberLabel.text = [self.mydata[indexPath.row] objectForKey:@"count"];
        if([[self.mydata[indexPath.row] objectForKey:@"imageLabel"] isEqualToString:@"我的项目"]){
//            if ([[self.mydata[indexPath.row] objectForKey:@"count"] intValue] != 0) {
                numberLabel.text = [NSString stringWithFormat:@"%d条未审核",[[self.mydata[indexPath.row] objectForKey:@"count"] intValue]];
//            }
            
        }
        numberLabel.hidden = YES;
        [CellBgView addSubview:numberLabel];
        
        if ((int)indexPath.row== 2 || (int)indexPath.row==8 ||(int)indexPath.row==3) {
            lineImageView.hidden = YES;
        }
        if (isCompanyAccount == 0) {
            if ((int)indexPath.row==0 || (int)indexPath.row==1 ||(int)indexPath.row==2 ||(int)indexPath.row==3 ||(int)indexPath.row==4) {
                numberLabel.hidden = NO;
            }
        }else{
            if ((int)indexPath.row==0 || (int)indexPath.row==1 ||(int)indexPath.row==2 ||(int)indexPath.row==4) {
                numberLabel.hidden = NO;
            }
        }
        
        if ((int)indexPath.row==3) {
            CellBgView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
            return cell;
        }
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0) {
         [MobClick event:kMyClientEvent];
            MyClientViewController * vc = [[MyClientViewController alloc] init];
            vc.titles =@"我的客户";
            [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row ==1) {
        [MobClick event:kMyCollectEvent];
//
        MyFavrioteViewController *vc = [[MyFavrioteViewController alloc] init];
        vc.titles = @"我的关注";
        [self.navigationController pushViewController:vc animated:YES];
        
//        SignSucceedViewController *vc = [[SignSucceedViewController alloc] init];
        
//        ProgressRecordViewController *vc = [[ProgressRecordViewController alloc] init];
//        SignSucceedViewController *vc = [[SignSucceedViewController alloc] init];
//        confirmreviewpassViewController *vc = [[confirmreviewpassViewController alloc] init];
//        enterpriseapplyControllerViewController *vc = [[enterpriseapplyControllerViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        [self pushMyInviteView];
    }
    
    if (indexPath.row == 3) {
        if (isCompanyAccount == 0) {    //isCompanyAccount:是否为企业账号:0、企业账号;1、非企业账号
            [MobClick event:kMyProjectEvent];
            MyProjectViewController *vc = [[MyProjectViewController alloc] init];
            vc.isFromtEnterprisePage = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MobClick event:kMyEnterpriseIncomeEvent];
            enterpriseapplyControllerViewController *vc = [[enterpriseapplyControllerViewController alloc] init];
            vc.us_tel = self.myheadView.PhoneLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.row == 4) {
        [MobClick event:kMyActivityEvent];
        ActivityListViewController  *vc = [[ActivityListViewController alloc] init];
        vc.titles = @"奖励活动";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 5) {
        [MobClick event:kMyComplainEvent];
        ComplainViewController* vc = [[ComplainViewController alloc] init];
        vc.titles =@"投诉建议";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 6 ) {
        [MobClick event:kMyFunEvent];
        FunViewController *vc = [[FunViewController alloc] init];
        vc.titles =@"玩转渠到天下";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 7 ) {
        [MobClick event:kABOUTUSEvent];
        AboutusViewController* vc = [[AboutusViewController alloc] init];
        vc.titles =@"关于渠到天下";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 8 ) {
        [MobClick event:kSettingEvent];
        SettingViewController * vc = [[SettingViewController alloc] init];
        vc.titles =@"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(MyHeadView *)myheadView{
    if (_myheadView == nil) {
        self.myheadView = [MyHeadView new];
        NSDictionary *data = [[NSDictionary alloc] init];
        self.myheadView.data = data;
        self.myheadView.backgroundColor = [UIColor whiteColor];
    }
    return _myheadView;
}

-(myReportView *)myReportView{
    if (_myReportView == nil) {
        self.myReportView = [myReportView new];
        NSDictionary *data = [[NSDictionary alloc] init];
        self.myReportView.data = data;
        self.myReportView.backgroundColor = BGColorGray;

    }
    return _myReportView;
}


-(UIView *)MyTableHeadView{
    if (_MyTableHeadView == nil) {
        self.MyTableHeadView = [UIView new];
        self.MyTableHeadView.backgroundColor = BGColorGray;
        
    }
    return _MyTableHeadView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=0) {
        //            imv.center = CGPointMake(kScreenWidth/2, (240*AUTO_SIZE_SCALE_X+scrollView.contentOffset.y)/2);
        self.navView.alpha = scrollView.contentOffset.y/(100.0*AUTO_SIZE_SCALE_X);
        
    }
    //        CGFloat xx = 0.0; //0-1
    //        xx = (-scrollView.contentOffset.y)/(65.0);
    //        myTableView.frame = CGRectMake(0, 20*(xx), kScreenWidth, kScreenHeight-20*(xx));
    
    if (scrollView.contentOffset.y <= 0)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}

-(void)pushview{
    
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] UpdateSysMsgToReadResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            
            self.badgeView.badgeText = nil;
            [self.badgeView setNeedsLayout];
            
            badge = 0;
            [self gotoMessageListViewController];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        self.myheadView.messageImageView.userInteractionEnabled = YES;
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.myheadView.messageImageView.userInteractionEnabled = NO;
    }];
}

-(void)pushMyInviteView{
    if ([us_partner_kind isEqualToString:@"0"]) {//如果是0 显示 我的邀请
        
        [MobClick event:kMyInviteEvent];
        MyInviteViewController  *vc = [[MyInviteViewController alloc] init];
        vc.titles = @"我的邀请";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([us_partner_kind isEqualToString:@"1"]) {//如果是1 显示我的人脉
        [MobClick event:kMyConnectEvent];
        MyconnectionViewController *vc = [[MyconnectionViewController alloc] init];
        vc.titles =@"我的人脉";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)gotoMessageListViewController{
    
    [MobClick event:kMessageOnclickButtonEvent];
    messageControlllerViewController  * vc = [[messageControlllerViewController alloc] init];
    vc.titles =@"消息中心";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kPageFour];//("PageOne"为页面名称，可自定义)
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kPageFour];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}
/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
/*
 开启ios右滑返回
 */
- (void)startSideBack {
    self.isCanUseSideBack=YES;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanUseSideBack;
}

@end
