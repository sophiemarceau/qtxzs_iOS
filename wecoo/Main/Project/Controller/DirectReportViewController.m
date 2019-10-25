//
//  DirectReportViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/21.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "DirectReportViewController.h"
#import "publicTableViewCell.h"
#import "SubmitView.h"
#import "PlaceholderTextView.h"
#import "SubmintSuccessReportViewController.h"
#import "MOFSPickerManager.h"
#import "UnlockClientListViewController.h"

@interface DirectReportViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,SelectSuccessDelegate>{
    NSDictionary *DataDic;
    NSMutableArray *tradeArrray;
    NSMutableArray *budgetarrayData;
    NSMutableArray *planArrray;
    
    
    NSString* tradeindex;
    NSString* budgetindex;
    NSString* plantimeindex;
    NSString* districtindex;
    UIButton *btn;

}
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)UILabel *SubDescLabel;
@property (nonatomic,strong)ClientView *clientView;
@property (nonatomic,strong)ReportView *reportView;
@property (nonatomic,strong)UITableView *Tableview;
@property (nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong) SubmitView *subview;
@property (nonatomic,strong)UIButton *directButton;
@end

@implementation DirectReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles =@"按行业推荐";
    [self initTrade];
    [self initBudgeData];
    [self initPlanTimeData];
    [self.HeaderView addSubview:self.SubDescLabel];
    [self.HeaderView addSubview:self.clientView];
    [self.HeaderView addSubview:self.reportView];
    [self.HeaderView addSubview:self.remarkView];
//    [self.HeaderView addSubview:self.subtitleLabel];
    [self.HeaderView addSubview:self.subview];
    [self.view addSubview:self.Tableview];
    [self initNavBarView];
//    [self.view addSubview:self.SubDescLabel];
//    [self.view addSubview:self.clientView];
//    [self.view addSubview:self.reportView];
//    [self.view addSubview:self.remarkView];
//    [self.view addSubview:self.subview];
    
    self.SubDescLabel.frame = CGRectMake(15, 0, kScreenWidth-(15+25)*AUTO_SIZE_SCALE_X,85*AUTO_SIZE_SCALE_X);
    
    self.clientView.frame = CGRectMake(0, self.SubDescLabel.frame.size.height, kScreenWidth,217/2*AUTO_SIZE_SCALE_X);
    
    self.reportView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.clientView.frame.size.height+self.clientView.frame.origin.y, kScreenWidth,428/2*AUTO_SIZE_SCALE_X);
    
    self.remarkView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.reportView.frame.size.height+self.reportView.frame.origin.y, kScreenWidth,100*AUTO_SIZE_SCALE_X-1);

    
//    self.subtitleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X+self.remarkView.frame.size.height+self.remarkView.frame.origin.y, kScreenWidth-30,40*AUTO_SIZE_SCALE_X);
//    
    self.subview.frame = CGRectMake(0, self.remarkView.frame.origin.y+self.remarkView.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    
    CGRect  btnRect = CGRectMake(85*AUTO_SIZE_SCALE_X, self.subview.frame.size.height+ self.subview.frame.origin.y+15*AUTO_SIZE_SCALE_X, 210*AUTO_SIZE_SCALE_X, 18.5*AUTO_SIZE_SCALE_X);
    btn = [[UIButton alloc] initWithFrame:btnRect];
    btn.enabled = YES;
    [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    //    [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    btnRect.origin.y += (35+25)*AUTO_SIZE_SCALE_X;
    [btn setTitle:AgreeString forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 0;
    [btn setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X];
    btn.selected = YES;
    [btn setImage:[UIImage imageNamed:@"icon_agree_selected"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_agree_normal"] forState:UIControlStateSelected];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8*AUTO_SIZE_SCALE_X, 0, 0);
    [self.HeaderView addSubview:btn];
    self.HeaderView.frame = CGRectMake(0,
                                       0,
                                       kScreenWidth,
                                       self.SubDescLabel.frame.size.height+
                                       self.clientView.frame.size.height+self.subtitleLabel.frame.size.height+
                                       self.reportView.frame.size.height+25*AUTO_SIZE_SCALE_X+self.subview.frame.size.height+ self.remarkView.frame.size.height+15*AUTO_SIZE_SCALE_X+btn.frame.size.height);
    self.HeaderView.backgroundColor = [UIColor clearColor];
    [self.Tableview setFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    
    self.reportView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [self.reportView.tradeView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    [self.reportView.districtView addGestureRecognizer:tap2];
    
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BudgeTaped:)];
    [self.reportView.budgeView addGestureRecognizer:tap3];
    
    
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(planTaped:)];
    [self.reportView.planView addGestureRecognizer:tap4];
    
    [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.Tableview setTableHeaderView:self.HeaderView];
}

-(void)onRadioButtonValueChanged:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
}


-(void)initBudgeData{
    budgetarrayData= [NSMutableArray array];
    [budgetarrayData addObject:@{
                                 @"code":@"1",
                                 @"name":@"5-10万"
                                 }];
    [budgetarrayData addObject:@{
                                 @"code":@"2",
                                 @"name":@"10-30万"
                                 }];
    [budgetarrayData addObject:@{
                                 @"code":@"3",
                                 @"name":@"30-50万"
                                 }];
    [budgetarrayData addObject:@{
                                 @"code":@"4",
                                 @"name":@"50万以上"
                                 }];
}

-(void)initPlanTimeData{
    planArrray = [NSMutableArray arrayWithCapacity:0];
    NSArray *temp = @[
                                            @{
                                                @"code":@"1",
                                                @"name":@"2周以内"
                                                },
                                            @{
                                                @"code":@"2",
                                                @"name":@"1个月以内"
                                                },
                                            @{
                                                @"code":@"3",
                                                @"name":@"3个月以内"
                                                },
                                            @{
                                                @"code":@"4",
                                                @"name":@"更久"
                                                },
                                            ];
    [planArrray addObjectsFromArray:temp];
}

-(void)initTrade{
    tradeArrray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetLookupIndustryMapResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (array !=nil) {
                [tradeArrray addObjectsFromArray:array];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];

}

#pragma mark 登录
-(void)submitBtnPressed:(UIButton *)sender
{
    [MobClick event:kDirectReportSubmitEvent];
     self.subview.subButton.enabled = NO;
    if (self.clientView.clientNameContent.text.length==0||self.clientView.PhoneContent.text.length==0|| self.reportView.districtContent.text.length==0 ||self.reportView.budgetContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0|| self.reportView.tradeContent.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if (self.clientView.clientNameContent.text.length >12) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过12位请您重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    if (self.clientView.clientNameContent.text.length <2) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，至少2位 请您检查并输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }

    
    if (self.clientView.PhoneContent.text.length!=11) {
        [[RequestManager shareRequestManager] tipAlert:@"您的手机号输入有误，请您重新输入" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    if (!btn.selected) {
        [[RequestManager shareRequestManager] tipAlert:@"客户本人必须知晓并同意方可提交" viewController:self];
        self.subview.subButton.enabled = YES;
        return;
    }
    
    
    NSDictionary *dic = @{
                          @"report_customer_name":self.clientView.clientNameContent.text,
                          @"report_customer_tel":self.clientView.PhoneContent.text,
                          @"_report_customer_industry":tradeindex,
                          @"report_customer_area_agent":districtindex,
                          @"report_customer_budget":budgetindex,
                          @"report_customer_startdate":plantimeindex,
                          @"_report_customer_note":self.remarkView.text,
                          @"_project_id":@"",
                          
                          
                          };
    
    
    [[RequestManager shareRequestManager] AddCustomerReportResult:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"result-------->%@",result);
        if(IsSucess(result)){
            [[RequestManager shareRequestManager] tipAlert:@"正在提交中" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
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
    
    SubmintSuccessReportViewController *vc = [[SubmintSuccessReportViewController alloc] init];
    vc.titles = @"推荐客户";
    [self.navigationController pushViewController:vc animated:YES];
    self.subview.subButton.enabled = YES;
//    [self.delegate addSuccessReturnClientPage];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)disTaped:(UITapGestureRecognizer *)sender
{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
        NSString *address;
        NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
//        NSLog(@"addresstemparray----%@",addresstemparray);
        if (addresstemparray.count>0) {
            if (addresstemparray.count == 3) {
                if ([addresstemparray[addresstemparray.count-1] isEqualToString: addresstemparray[addresstemparray.count-2]]) {
                    address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[addresstemparray.count-2]];
                }else{
                    address = [NSString stringWithFormat:@"%@ %@ %@",addresstemparray[0],addresstemparray[1],addresstemparray[2]];
                }
            }else if(addresstemparray.count == 2){
                if ([addresstemparray[0] isEqualToString: addresstemparray[1]]) {
                    address = [NSString stringWithFormat:@"%@",addresstemparray[0]];
                }else{
                    address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[1]];
                }
                
            }
        }

//        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
        self.reportView.districtContent.text = address;
        
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex =temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    
    NSMutableArray *tradeList = [NSMutableArray new];
    for (NSDictionary *temp in tradeArrray) {
        [tradeList addObject:[temp objectForKey:@"name"]];
    }
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradeList tag:4 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        self.reportView.tradeContent.text = string;
        for (NSDictionary *temp in tradeArrray) {
            if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                tradeindex = [temp objectForKey:@"code"] ;
                break;
            }
        }
    } cancelBlock:^{
        
    }];
}

-(void)BudgeTaped:(UITapGestureRecognizer *)sender
{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    
    NSMutableArray *budgetList = [NSMutableArray new];
    for (NSDictionary *temp in budgetarrayData) {
        [budgetList addObject:[temp objectForKey:@"name"]];
    }
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:budgetList tag:5 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        self.reportView.budgetContent.text = string;
        for (NSDictionary *temp in budgetarrayData) {
            if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                budgetindex = [temp objectForKey:@"code"] ;
                break;
            }
        }
    } cancelBlock:^{
        
    }];
}

-(void)planTaped:(UITapGestureRecognizer *)sender{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    
    NSMutableArray *planList = [NSMutableArray new];
    for (NSDictionary *temp in planArrray) {
        [planList addObject:[temp objectForKey:@"name"]];
    }
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:planList tag:6 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        
        self.reportView.planBeginTimeContent.text = string;
        
        for (NSDictionary *temp in planArrray) {
            if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                plantimeindex = [temp objectForKey:@"code"] ;
                break;
            }
        }
    } cancelBlock:^{
        
    }];
}

-(void)selectSuccessReturnReportPage:(NSDictionary *)returnDic{
    NSLog(@"returnDic------->%@",returnDic);
    self.clientView.clientNameContent.text = [returnDic objectForKey:@"customer_name"];
    self.clientView.PhoneContent.text = [returnDic objectForKey:@"customer_tel"];
    self.clientView.PhoneContent.userInteractionEnabled = NO;
    self.clientView.clientNameContent.userInteractionEnabled = NO;
    self.clientView.clientNameContent.textColor = [UIColor grayColor];
    self.clientView.PhoneContent.textColor = [UIColor grayColor];
    
    self.reportView.districtContent.text = [returnDic objectForKey:@"customer_area_agent_name"];;
    districtindex = [returnDic objectForKey:@"customer_area_agent"];
    
    budgetindex = [NSString stringWithFormat:@"%d",[[returnDic objectForKey:@"customer_budget"] intValue]];
    for (NSDictionary *temp in budgetarrayData) {
        if ( [[temp objectForKey:@"code"] isEqualToString:budgetindex ]) {
            self.reportView.budgetContent.text = [temp objectForKey:@"name"] ;
            break;
        }
    }
    
    plantimeindex = [NSString stringWithFormat:@"%d",[[returnDic objectForKey:@"customer_startdate"] intValue]];
    for (NSDictionary *temp in planArrray) {
        if ( [[temp objectForKey:@"code"] isEqualToString:plantimeindex ]) {
            self.reportView.planBeginTimeContent.text = [temp objectForKey:@"name"] ;
            break;
        }
    }
    
    self.remarkView.text = [returnDic objectForKey:@"customer_note"];
    self.remarkView.placeholder = @"";
}


-(void)dButtonClick{
    [MobClick event:kProjectDetailSelectClientonClickEvent];
    UnlockClientListViewController *vc = [[UnlockClientListViewController alloc]init];
    vc.titles = @"选择客户";
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark TableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*AUTO_SIZE_SCALE_X;
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
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * publicCell = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = C2UIColorGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kDirectReportPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kDirectReportPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ClientView *)clientView {
    if (_clientView == nil) {
        self.clientView = [ClientView new];
        self.clientView.data = DataDic;
    }
    return _clientView;
}

- (ReportView *)reportView {
    if (_reportView == nil) {
        self.reportView = [ReportView new];
        self.reportView.userInteractionEnabled = YES;
        self.reportView.data = DataDic;
    }
    return _reportView;
}

- (UIView *)HeaderView {
    if (_HeaderView == nil) {
        self.HeaderView = [UIView new];
        self.HeaderView.backgroundColor = C2UIColorGray;
    }
    return _HeaderView;
}

- (UILabel *)SubDescLabel {
    if (_SubDescLabel == nil) {
        self.SubDescLabel = [CommentMethod initLabelWithText:@"如果您不确定客户适合哪个项目，可以在这里推荐到该行业，随后我们将人工筛选、匹配，成交后您仍能获得千元赏金" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.SubDescLabel.textColor = FontUIColorGray;
        self.SubDescLabel.numberOfLines = 3;
    }
    return _SubDescLabel;
}


- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"如果您不确定客户适合哪个项目，可以在这里推荐到该行业，随后我们将人工筛选、匹配，成交后您仍能获得千元赏金" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.textColor = FontUIColorGray;
        self.subtitleLabel.numberOfLines = 0;
        [self.subtitleLabel sizeToFit];
        self.subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
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
    }
    return _Tableview;
    
   
}

-(PlaceholderTextView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _remarkView.backgroundColor = [UIColor whiteColor];
        _remarkView.delegate = self;
        _remarkView.font = [UIFont systemFontOfSize:14.f];
        _remarkView.textColor = [UIColor blackColor];
        _remarkView.textAlignment = NSTextAlignmentLeft;
        _remarkView.editable = YES;
         _remarkView.textColor = FontUIColorBlack;
//        _remarkView.layer.cornerRadius = 4.0f;
        _remarkView.layer.borderColor = kTextBorderColor.CGColor;
//        _remarkView.layer.borderWidth = 0.5;
        _remarkView.placeholderColor = UIColorFromRGB(0xc4c3c9);
       _remarkView.placeholder = @"备注（选填）例：性别、年龄、过往投资经历、行业背景、经营现状等。请尽量详细描述，成交几率提升1倍";

    }
    
    return _remarkView;

}

-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor clearColor];
    }
    return _subview;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"选择客户" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}


-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(65*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}




@end

