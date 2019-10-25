//
//  EditClientViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/9.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "EditClientViewController.h"
#import "publicTableViewCell.h"
#import "SubmitView.h"
#import "PlaceholderTextView.h"
#import "ClientView.h"
#import "ReportView.h"
#import "MOFSPickerManager.h"
#import "SubmintSuccessReportViewController.h"

@interface EditClientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    NSDictionary *DataDic;
    NSMutableArray *tradeArrray;
    NSMutableArray *budgetarrayData;
    NSMutableArray *planArrray;
    
    NSString* tradeindex;
    NSString* budgetindex;
    NSString* plantimeindex;
    NSString* districtindex;
    
    NSDictionary *dto ;
    UIButton * btn;
    
}
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)ClientView *clientView;
@property (nonatomic,strong)ReportView *reportView;
@property (nonatomic,strong)UITableView *Tableview;
//@property (nonatomic,strong)STPickerSingle *sigleView;
//@property (nonatomic,strong)STPickerSingle *sigleView1;
//@property (nonatomic,strong)STPickerSingle *sigleView2;
//@property (nonatomic,strong)STPickerArea *areaView;
@property (nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)UILabel *subtitleLabel;





@property (nonatomic,strong) UIView *submitBGView;
@property (nonatomic,strong) UIButton *saveinfoButton;
@property (nonatomic,strong) UIButton *submitButton;

@end

@implementation EditClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    
    [self.HeaderView addSubview:self.clientView];
    [self.HeaderView addSubview:self.reportView];
    [self.HeaderView addSubview:self.remarkView];
    [self.HeaderView addSubview:self.subtitleLabel];
    [self.HeaderView addSubview:self.submitBGView];
    
    self.clientView.frame = CGRectMake(0, 0, kScreenWidth,217/2*AUTO_SIZE_SCALE_X);
    
    self.reportView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.clientView.frame.size.height+self.clientView.frame.origin.y, kScreenWidth,428/2*AUTO_SIZE_SCALE_X);
    
    self.remarkView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.reportView.frame.size.height+self.reportView.frame.origin.y, kScreenWidth,100*AUTO_SIZE_SCALE_X-1);
    
    self.subtitleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X+self.remarkView.frame.size.height+self.remarkView.frame.origin.y, kScreenWidth-30,40*AUTO_SIZE_SCALE_X);

    [self.HeaderView addSubview:self.submitBGView];
    
    self.submitBGView.frame = CGRectMake(0, self.remarkView.frame.origin.y+self.remarkView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 94*AUTO_SIZE_SCALE_X);
    

    if(self.isLocked == 0){
        [self.submitBGView addSubview:self.saveinfoButton];
        [self.submitBGView addSubview:self.submitButton];
        
        self.saveinfoButton.frame = CGRectMake(15, 50*AUTO_SIZE_SCALE_X, (kScreenWidth-45)/2, 44*AUTO_SIZE_SCALE_X);
        self.submitButton.frame = CGRectMake(30+(kScreenWidth-45)/2, 50*AUTO_SIZE_SCALE_X, (kScreenWidth-45)/2, 44*AUTO_SIZE_SCALE_X);

       
    }else{
        [self.submitBGView addSubview:self.saveinfoButton];
        self.saveinfoButton.frame = CGRectMake(15, 50*AUTO_SIZE_SCALE_X, (kScreenWidth-30), 44*AUTO_SIZE_SCALE_X);
    }
    
    CGRect  btnRect = CGRectMake(85*AUTO_SIZE_SCALE_X, self.submitBGView.frame.size.height+ self.submitBGView.frame.origin.y+15*AUTO_SIZE_SCALE_X, 210*AUTO_SIZE_SCALE_X, 18.5*AUTO_SIZE_SCALE_X);
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
                                       btn.frame.size.height+ btn.frame.origin.y+28*AUTO_SIZE_SCALE_X);
    [self.view addSubview:self.self.Tableview];
    self.HeaderView.backgroundColor = [UIColor clearColor];
    [self.Tableview setFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [self.Tableview setTableHeaderView:self.HeaderView];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [self.reportView.tradeView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    [self.reportView.districtView addGestureRecognizer:tap4];
    
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BudgeTaped:)];
    [self.reportView.budgeView addGestureRecognizer:tap2];
    
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(planTaped:)];
    [self.reportView.planView addGestureRecognizer:tap3];

}

-(void)onRadioButtonValueChanged:(UIButton*)sender
{
    sender.selected = !sender.selected;

}

-(void)initData{
    
    NSDictionary *dic = @{@"customer_id":self.customerID,};
    
    [[RequestManager shareRequestManager] getCustomerResult:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"result-------->%@",result);
        if(IsSucess(result)){
            dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){
                NSString *name = [dto objectForKey:@"customer_name"];
                self.clientView.clientNameContent.text = name;
                self.clientView.clientNameContent.textColor = FontUIColorGray;
                NSString *phone = [dto objectForKey:@"customer_tel"];
                self.clientView.PhoneContent.text = [NSString stringWithFormat:@"%@",phone];
                self.clientView.PhoneContent.textColor = FontUIColorGray;
                
                
                
                
                districtindex = [dto objectForKey:@"customer_area_agent"];
               
                [self initTrade];
                [self initBudgeData];
                [self initPlanTimeData];
                self.remarkView.text = [dto objectForKey:@"customer_note"];
                if (self.remarkView.text.length !=0) {
                    self.remarkView.placeholder =@"";
                }
//                self.reportView.districtContent.text = [dto objectForKey:@"customer_area_agent"];
               
                
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}

-(void)initTrade{
    tradeArrray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetLookupIndustryMapResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            
            if (array != nil) {
                [tradeArrray addObjectsFromArray:array];
                
                NSString *customer_industry = [dto objectForKey:@"customer_industry"];
                if(![customer_industry isEqual:[NSNull null]] && customer_industry !=nil)
                {
                    for (NSDictionary *temp in tradeArrray) {
                        if ( [[temp objectForKey:@"code"] isEqualToString:customer_industry]) {
                            self.reportView.tradeContent.text = [temp objectForKey:@"name"] ;
                            tradeindex = [temp objectForKey:@"code"] ;
                        }
                    }
                }
                
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)addSuccessReturnClientPage{
    
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
    NSString *customer_budget = [dto objectForKey:@"customer_budget"];
    if(![customer_budget isEqual:[NSNull null]] && customer_budget !=nil)
    {
        for (NSDictionary *temp in budgetarrayData) {
            if ( [[temp objectForKey:@"code"] isEqualToString:customer_budget]) {
                self.reportView.budgetContent.text = [temp objectForKey:@"name"] ;
                budgetindex = [temp objectForKey:@"code"] ;
            }
        }
    }
    
}

-(void)initPlanTimeData{
    planArrray = [NSMutableArray arrayWithCapacity:0];
    [planArrray addObjectsFromArray:@[
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
                                      ]];
    NSString *customer_startdate = [dto objectForKey:@"customer_startdate"];
    if(![customer_startdate isEqual:[NSNull null]] && customer_startdate !=nil)
    {
        for (NSDictionary *temp in planArrray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:customer_startdate]) {
                self.reportView.planBeginTimeContent.text = [temp objectForKey:@"name"] ;
                plantimeindex = [temp objectForKey:@"code"] ;
            }
            
        }

    }
    
    if([districtindex isEqual:[NSNull null]])
    {
        return ;
    }
    NSString *zipCode;
    
    NSString *middelFlag = [districtindex substringFromIndex:2];
//    NSLog(@"middelFlag--------%@",middelFlag);
    if([middelFlag isEqualToString:@"0000"]){
        zipCode = [NSString stringWithFormat:@"%@-%@",districtindex,districtindex] ;
    }else{
        NSString *lastflag = [districtindex substringFromIndex:4];
//        NSLog(@"lastflag--------%@",lastflag);
        if([lastflag isEqualToString:@"00"]){
            NSString *temp1 = [NSString stringWithFormat:@"%@0000",[districtindex substringToIndex:2]];
            zipCode = [NSString stringWithFormat:@"%@-%@",temp1,districtindex] ;
        }else{
            NSString *temp1 = [NSString stringWithFormat:@"%@0000",[districtindex substringToIndex:2]];
            NSString *temp2 = [NSString stringWithFormat:@"%@%@00",[districtindex substringToIndex:2],[districtindex substringWithRange:NSMakeRange(2, 2)]];
            zipCode = [NSString stringWithFormat:@"%@-%@-%@",temp1,temp2,districtindex] ;
            
        }
    }
   
//    NSLog(@"zipcode--------%@",[NSString stringWithFormat:@"%@",zipCode]);
    [[MOFSPickerManager shareManger] searchAddressByZipcode:zipCode block:^(NSString *addressStr){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *address;
            NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
//            NSLog(@"addresstemparray----%@",addresstemparray);
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
            // 更UI
            self.reportView.districtContent.text = address;
        });
    }];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    
    NSMutableArray *tradeList = [NSMutableArray new];
    for (NSDictionary *temp in tradeArrray) {
        [tradeList addObject:[temp objectForKey:@"name"]];
    }
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradeList tag:7 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
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


-(void)disTaped:(UITapGestureRecognizer *)sender
{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    [self resignFirstResponder];
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
        }        //        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
        self.reportView.districtContent.text = address;
        
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex =temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];

}

-(void)BudgeTaped:(UITapGestureRecognizer *)sender
{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
    NSLog(@"BudgeTaped----%@",budgetarrayData);
    NSMutableArray *budgetList = [NSMutableArray new];
    for (NSDictionary *temp in budgetarrayData) {
        [budgetList addObject:[temp objectForKey:@"name"]];
    }
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:budgetList tag:8 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
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
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:planList tag:9 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        
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

-(void)resignTextField{
    [self.clientView.clientNameContent resignFirstResponder];
    [self.clientView.PhoneContent resignFirstResponder];
}


#pragma mark 提交
-(void)saveBtnPressed:(UIButton *)sender
{
    self.submitButton.enabled = NO;
    if (self.clientView.clientNameContent.text.length==0||self.clientView.PhoneContent.text.length==0|| self.reportView.districtContent.text.length==0 ||self.reportView.budgetContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0|| self.reportView.tradeContent.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.submitButton.enabled = YES;
        return;
    }
    
    if (self.clientView.PhoneContent.text.length!=11) {
        [[RequestManager shareRequestManager] tipAlert:@"您的手机号输入有误，请您重新输入" viewController:self];
        self.submitButton.enabled = YES;
        return;
    }
    if (!btn.selected) {
        [[RequestManager shareRequestManager] tipAlert:@"客户本人必须知晓并同意方可提交" viewController:self];
        self.submitButton.enabled = YES;
        return;
    }

    NSDictionary *dic = @{
                          @"customer_id":self.customerID,
                          @"customer_industry":tradeindex,
                          @"customer_area_agent":districtindex,
                          @"customer_budget":budgetindex,
                          @"customer_startdate":plantimeindex,
                          @"_customer_note":self.remarkView.text,
                          };
    
    [[RequestManager shareRequestManager] UpdateCustomerResult:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"result-------->%@",result);
        if(IsSucess(result)){
            if (result != nil) {
                [[RequestManager shareRequestManager] tipAlert:@"修改成功" viewController:self];
                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            self.submitButton.enabled = YES;
        }    
    }failuer:^(NSError *error){
//        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.submitButton.enabled = YES;
    }];
}

-(void)returnListPage{
    [self.delegate edditSuccessReturnClientPage];
    [self.navigationController popViewControllerAnimated:YES];
    self.saveinfoButton.enabled = YES;
    self.submitButton.enabled = YES;
}

-(void)submitBtnPressed:(UIButton *)sender
{
    self.saveinfoButton.enabled = NO;
    self.submitButton.enabled = NO;
    if (self.clientView.clientNameContent.text.length==0||self.clientView.PhoneContent.text.length==0|| self.reportView.districtContent.text.length==0 ||self.reportView.budgetContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0|| self.reportView.tradeContent.text.length==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
        return;
    }
    
    if (self.clientView.PhoneContent.text.length!=11) {
        [[RequestManager shareRequestManager] tipAlert:@"您的手机号输入有误，请您重新输入" viewController:self];
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
        return;
    }
    
    if (self.clientView.clientNameContent.text.length >12) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过12位请您重新输入" viewController:self];
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
        return;
    }
    
    if (self.clientView.clientNameContent.text.length <2) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，至少2位 请您检查并输入" viewController:self];
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
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

        if(IsSucess(result)){
            if (result !=nil) {
//                [[RequestManager shareRequestManager] tipAlert:@"提交报备成功" viewController:self];
//                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                SubmintSuccessReportViewController *vc = [[SubmintSuccessReportViewController alloc] init];
                vc.fromclientFlag = 1;

                vc.titles = @"推荐客户";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            
        }
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
    }failuer:^(NSError *error){
        //        NSLog(@"error-------->%@",error);
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.saveinfoButton.enabled = YES;
        self.submitButton.enabled = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kMyClinetDetailPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyClinetDetailPage];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ClientView *)clientView {
    if (_clientView == nil) {
        self.clientView = [ClientView new];
        self.clientView.data = DataDic;
        self.clientView.clientNameContent.enabled =NO;
        self.clientView.clientNameContent.clearButtonMode = UITextFieldViewModeNever;
        self.clientView.PhoneContent.enabled =NO;
        self.clientView.PhoneContent.clearButtonMode = UITextFieldViewModeNever;
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

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"客户报备后，如果不匹配当前项目，我们会调剂到更合适的项目中" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.hidden = YES;
        self.subtitleLabel.textColor = FontUIColorGray;
        self.subtitleLabel.numberOfLines = 0;
        [self.subtitleLabel sizeToFit];
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
        _remarkView.textColor = FontUIColorBlack;
        
        _remarkView.textAlignment = NSTextAlignmentLeft;
        _remarkView.editable = YES;
        //        _remarkView.layer.cornerRadius = 4.0f;
        _remarkView.layer.borderColor = kTextBorderColor.CGColor;
        //        _remarkView.layer.borderWidth = 0.5;
        _remarkView.placeholderColor = UIColorFromRGB(0xc4c3c9);
        _remarkView.placeholder = @"备注（选填）例：性别、年龄、过往投资经历、行业背景、经营现状等。请尽量详细描述，成交几率提升1倍";
    }
    return _remarkView;
    
}

-(UIView *)submitBGView{
    if(_submitBGView == nil){
        self.submitBGView = [[UIView alloc]init];
        self.submitBGView.backgroundColor = [UIColor clearColor];
    }
    return _submitBGView;
}

-(UIButton *)submitButton{
    if (_submitButton ==nil) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.submitButton setTitle:@"推荐客户" forState:UIControlStateNormal];
        [self.submitButton setTintColor:[UIColor whiteColor]];
        [self.submitButton setBackgroundColor:RedUIColorC1];
        self.submitButton.userInteractionEnabled = YES;
        [self.submitButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.submitButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.submitButton.enabled = YES;
        
    }
    return _submitButton;
}

-(UIButton *)saveinfoButton{
    if (_saveinfoButton ==nil) {
        self.saveinfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveinfoButton setTitle:@"保存信息" forState:UIControlStateNormal];
        [self.saveinfoButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        [self.saveinfoButton setTintColor:[UIColor whiteColor]];
        
        self.saveinfoButton.userInteractionEnabled = YES;
        [self.saveinfoButton addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.saveinfoButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.saveinfoButton.enabled = YES;
        self.saveinfoButton.layer.borderColor = RedUIColorC1.CGColor;
        self.saveinfoButton.layer.borderWidth = 1.0;
        
    }
    return _saveinfoButton;
}

@end
