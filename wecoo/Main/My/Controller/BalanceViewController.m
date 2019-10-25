//
//  BalanceViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BalanceViewController.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "WithdrawViewController.h"
#import "ShowMaskView.h"
#import "ShowAnimationView.h"
#import "CommissionNoteView.h"
#import "ReviewPersonalInfoViewController.h"
#import "ApplyRecordControllerViewController.h"
#import "AlipayWithdrawViewController.h"
#import "SettingPwdViewController.h"

@interface BalanceViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView *failView;
    NSMutableArray *data;
    int current_page;
    int total_count;
    int deadlineDay;
    NSDictionary *authdto;
    double balance;
    NSString *status_code;
    int IsWithDrawPwdFlag;
}
@property (nonatomic,strong)UIButton *directButton;
@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReloadBalance object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadBalance) name:kReloadBalance object:nil];
    [self initdata];
    [self initNavBarView];
    [self loadData];
    [self initView];
    [self initTableView];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

-(void)initTableView{
    
    myTableView = [[BaseTableView alloc] init];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 136/2*AUTO_SIZE_SCALE_X+1;

    [self.view addSubview:myTableView];
    
               
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.acountBgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 136/2*AUTO_SIZE_SCALE_X*3+116/2*AUTO_SIZE_SCALE_X));
    }];
               
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];   
}

-(void)reloadBalance{
    [self loadData];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{                          
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchSalemanAccountLogDtosResult :dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
         [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];
            }
            
            [myTableView reloadData];
            if (data.count>0) {
                myTableView.hidden = NO;
                self.acountLabel.hidden = NO;
                self.acountBgView.hidden =NO;
            }else{
                myTableView.hidden = YES;
                self.acountLabel.hidden = YES;
                self.acountBgView.hidden =YES;
            }
            failView.hidden = YES;
            if (data.count == total_count || data.count == 0) {
                 [myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
    }];
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic1 = @{};
    [[RequestManager shareRequestManager] getWithdrawingLimitResult :dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            deadlineDay = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            self.subbalanceLabel.text = [NSString stringWithFormat:@"注意：每周三且当前赏金大于%d元方可提现",deadlineDay];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
    }];
    
    
    [self getClientBalance];
    
    [self GetIsWithdrawPwd];

}

#pragma mark  4.3.13	获取用户是否设置过提现密码
-(void)GetIsWithdrawPwd{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] IsWithdrawPwdNullResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            if (result != nil) {
                //true:设置过提现密码 false:没有设置过
                IsWithDrawPwdFlag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                NSLog(@"result-GetIsWithdrawPwd--IsWithDrawPwdFlag-->%d",IsWithDrawPwdFlag);
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];

    }];
}

-(void)getClientBalance{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetUserDetailResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            if (result != nil) {
                NSDictionary *userdto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                balance = [[userdto objectForKey:@"us_balance"] doubleValue];
                self.balanceNumLabel.text = [NSString stringWithFormat:@"￥%@",[userdto objectForKey:@"us_balance_str"]];
                
                balance = [[userdto objectForKey:@"us_balance"] doubleValue];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        //        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}


#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    
    //        failView.activityIndicatorView.hidden = NO;
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
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
    [[RequestManager shareRequestManager] SearchSalemanAccountLogDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        //            [self hideHud];
        
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
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                if (data.count>0) {
                    
                }else{
                    
                }
            }
            failView.hidden = YES;
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    if (data.count > 0) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.textAlignment = NSTextAlignmentLeft;
        numberLabel.textColor = RedUIColorC1;
        if([[data[indexPath.row] objectForKey:@"sal_addsubflag_code"] intValue]==1){
            numberLabel.text = [NSString stringWithFormat:@"+%@",[data[indexPath.row] objectForKey:@"sal_sum_str"] ];
        }else{
            numberLabel.text = [NSString stringWithFormat:@"-%@",[data[indexPath.row] objectForKey:@"sal_sum_str"] ];
        }
        
        numberLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        
        numberLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30, 12*AUTO_SIZE_SCALE_X);
        [cell addSubview:numberLabel];
        
        UILabel *descriLabel = [[UILabel alloc] init];
        descriLabel.textAlignment = NSTextAlignmentLeft;
        descriLabel.textColor = FontUIColorGray;
        descriLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"sal_desc"] ];
        descriLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        
        descriLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X+numberLabel.frame.size.height+numberLabel.frame.origin.y, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
        [cell addSubview:descriLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 136/2*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [cell addSubview:lineImageView];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = FontUIColorGray;
        timeLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"sal_createdtime"] ];
        timeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        
        timeLabel.frame = CGRectMake(kScreenWidth-15-200*AUTO_SIZE_SCALE_X, numberLabel.frame.origin.y,200*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        [cell addSubview:timeLabel];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kAccountPage];//("PageOne"为页面名称，可自定义)
    
    [self GetIsWithdrawPwd];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAccountPage];
}

-(void)initView{
    [self.view addSubview:self.balanceImageView];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.balanceNumLabel];
    [self.view addSubview:self.applyButton];
    [self.view addSubview:self.subbalanceLabel];
    [self.view addSubview:self.applyrulesImageView];
    [self.view addSubview:self.applyrulesLabel];
    [self.view addSubview:self.acountBgView];
    [self.view addSubview:self.acountLabel];
    [self.acountLabel addSubview:self.lineImageView];
    
    #pragma mark - 添加约束
    [self.balanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((kScreenWidth/2-53/2*AUTO_SIZE_SCALE_X));
        make.top.equalTo(self.navView.mas_bottom).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(53*AUTO_SIZE_SCALE_X, 55*AUTO_SIZE_SCALE_X));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((kScreenWidth/2-80/2*AUTO_SIZE_SCALE_X));
        make.top.equalTo(self.balanceImageView.mas_bottom).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
    
    [self.balanceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 23*AUTO_SIZE_SCALE_X));
    }];
    
    [self.subbalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.balanceNumLabel.mas_bottom).offset(12.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 12*AUTO_SIZE_SCALE_X));
    }];

    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.subbalanceLabel.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 44*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.applyrulesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(146*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.applyButton.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(16*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    
    [self.applyrulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.applyrulesImageView.mas_right).offset(6*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.applyButton.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*(AUTO_SIZE_SCALE_X), 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.acountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.applyrulesLabel.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 77/2*AUTO_SIZE_SCALE_X));
    }];
    [self.acountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.applyrulesLabel.mas_bottom).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30,  77/2*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.acountBgView.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,  0.5));
    }];

}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

-(void)onClick:(UITapGestureRecognizer *)sender{
    [MobClick event:kAppleyMoneyRuleOnClickEvent];
    ShowAnimationView *show = [[ShowAnimationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.dayString = [NSString stringWithFormat:@"%d",deadlineDay];
    [show showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIImageView *)balanceImageView{
    if (_balanceImageView == nil) {
        self.balanceImageView = [UIImageView new];
        self.balanceImageView.image = [UIImage imageNamed:@"icon-myBalance"];
    }
    return _balanceImageView;
}

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        self.balanceLabel = [CommentMethod initLabelWithText:@"可提现赏金" textAlignment:NSTextAlignmentCenter font:14*AUTO_SIZE_SCALE_X];
        self.balanceLabel.textColor = FontUIColorGray;
    }
    return _balanceLabel;
}

- (UILabel *)subbalanceLabel {
    if (_subbalanceLabel == nil) {
        self.subbalanceLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.subbalanceLabel.textColor = FontUIColorGray;
        
    }
    return _subbalanceLabel;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"申请记录" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _directButton;
}

-(void)dButtonClick{
    [MobClick event:kApplyMoneyRecordOnClickEvent];
    self.directButton.enabled = NO;
    ApplyRecordControllerViewController*vc = [[ApplyRecordControllerViewController alloc]init];
    vc.titles = @"提现申请记录";
    vc.menuTag = 1;
    [self.navigationController pushViewController:vc animated:YES];
    self.directButton.enabled = YES;
}

- (UILabel *)balanceNumLabel {
    if (_balanceNumLabel == nil) {
        self.balanceNumLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:23*AUTO_SIZE_SCALE_X];
        self.balanceNumLabel.textColor = RedUIColorC1;
    }
    return _balanceNumLabel;
}

-(UIButton *)applyButton{
    if (_applyButton == nil ) {
        self.applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.applyButton.userInteractionEnabled = YES;
        [self.applyButton setBackgroundImage:[UIImage imageNamed:@"btn-login-red"] forState:UIControlStateNormal];
        [self.applyButton setTitle:@"申请提现" forState:UIControlStateNormal];
        [self.applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.applyButton.titleLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [self.applyButton addTarget:self action:@selector(applyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

-(void)applyBtnPressed:(UIButton * )sender{
    
    [MobClick event:kAppleyMoneyOnClickEvent];
    [self select];
    
}

-(void)requestID:(int)flag{
//    if (flag==0) {
//        AlipayWithdrawViewController *vc = [[AlipayWithdrawViewController alloc] init];
//        vc.titles = @"支付宝提现";
//        vc.swa_id = @"";
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        WithdrawViewController *vc = [[WithdrawViewController alloc] init];
//        vc.titles = @"个人银行卡提现";
//        vc.swa_id = @"";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] isWithdrawEnableResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            [self getAuch:flag];
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        
    }failuer:^(NSError *error){
        
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
   
}

-(void)getAuch:(int)flag{
    NSLog(@"flag------getauch-------%d",flag);
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetUserSalesmanIDInfoDtoResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            authdto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![authdto isEqual:[NSNull null]]){
                int wetherFlag = [[authdto objectForKey:@"us_id_status_code"] intValue];
                if (wetherFlag == 3 || wetherFlag == 0) {
                    ReviewPersonalInfoViewController *vc = [[ReviewPersonalInfoViewController alloc] init];
                    vc.authDictionary = authdto;
                    vc.titles = @"实名认证";
                    vc.gotoWhere = flag;
                    
                    vc.IsWithDrawPwdFlag = IsWithDrawPwdFlag;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    if (IsWithDrawPwdFlag == 0) {
                        
                        SettingPwdViewController *vc = [[SettingPwdViewController alloc] init];
                        vc.gotoWhere = flag;
                        vc.titles = @"设置提现密码";
                        [self.navigationController pushViewController:vc animated:YES];
                        return ;
                    }
                    if (flag==0) {
                        AlipayWithdrawViewController *vc = [[AlipayWithdrawViewController alloc] init];
                        vc.titles = @"支付宝提现";
                        vc.swa_id = @"";
                        vc.fromWhere = 0;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        WithdrawViewController *vc = [[WithdrawViewController alloc] init];
                        vc.titles = @"个人银行卡提现";
                        vc.swa_id = @"";
                        vc.fromWhere = 0;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)select{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"支付宝提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self requestID:0];
        }];
        
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"个人银行卡提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             [self requestID:1];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消提现" style:UIAlertActionStyleCancel handler:nil];
        [addPhoneAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [photoAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [cancelAction setValue:RedUIColorC1 forKey:@"titleTextColor"];
        [actionSheet addAction:addPhoneAction];
        [actionSheet addAction:photoAction];
        [actionSheet addAction:cancelAction];
        [self presentViewController:actionSheet animated:true completion:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消提现" destructiveButtonTitle:nil otherButtonTitles:@"个人银行卡提现",@"支付宝提现", nil];
        [actionSheet showInView:self.view];
#pragma clang diagnostic pop
        
    }
}

-(UIImageView *)applyrulesImageView{
    if (_applyrulesImageView == nil) {
        self.applyrulesImageView = [UIImageView new];
        self.applyrulesImageView.image = [UIImage imageNamed:@"icon-myBalanceHelp"];
    }
    return _applyrulesImageView;
}

- (UILabel *)applyrulesLabel {
    if (_applyrulesLabel == nil) {
        self.applyrulesLabel = [CommentMethod initLabelWithText:@"提现规则" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.applyrulesLabel.textColor = RedUIColorC1;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        self.applyrulesLabel.userInteractionEnabled = YES;
        [self.applyrulesLabel addGestureRecognizer:tap3];
    }
    return _applyrulesLabel;
}

-(UIView *)acountBgView{
    if (_acountBgView == nil) {
        self.acountBgView = [UIView new];
        self.acountBgView.backgroundColor = [UIColor whiteColor];
    }
    return _acountBgView;
}

- (UILabel *)acountLabel {
    if (_acountLabel == nil) {
        self.acountLabel = [CommentMethod initLabelWithText:@"账户变动明细" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.acountLabel.textColor = FontUIColorGray;
    }
    return _acountLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

@end
