//
//  ReportDetailViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "EditClientViewController.h"
#import "publicTableViewCell.h"
#import "SubmitView.h"
#import "PlaceholderTextView.h"
#import "ClientView.h"
#import "ReportView.h"
#import "MOFSPickerManager.h"
#import "timelineViewController.h"
#import "noContent.h"
#import "infoCellTableViewCell.h"
#import "noWifiView.h"
#import "PlatformfeedbackViewController.h"
#import "FollwupInfoViewController.h"
@interface ReportDetailViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    NSDictionary *DataDic;
    NSMutableArray *tradeArrray;
    NSMutableArray *budgetarrayData;
    NSMutableArray *planArrray;
    
    NSString* tradeindex;
    NSString* budgetindex;
    NSString* plantimeindex;
    NSString* districtindex;
    NSDictionary *dto ;
   
    noWifiView *failView;
    noContent *nocontent;
    infoCellTableViewCell *cell;
    int current_page;
    int total_count;
    int followup_id;
}

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)ClientView *clientView;
@property (nonatomic,strong)ReportView *reportView;
@property (nonatomic,strong)UITableView *Tableview;
@property (nonatomic,strong)PlaceholderTextView *remarkView;
@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong)SubmitView *subview;
@property (nonatomic,strong)NSString *customerID;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIView *TableHeadView;
@property (nonatomic,strong)UIView *platformView;
@property (nonatomic,strong)UIImageView *platformImage;
@property (nonatomic,strong)UILabel *platformLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *platformTitleLabel;
@property (nonatomic,strong)UILabel *platformTimeLabel;
@property (nonatomic,strong)UILabel *checkLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *enterpriseView;
@property (nonatomic,strong)UILabel *enterpriseLabel;
@property (nonatomic,strong)UIImageView *enterpriseImageView;
@property (nonatomic,strong)UIImageView *lineImageView2;
@end

@implementation ReportDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    

    [self.view addSubview:self.menuView];
    UIButton *bb = [[UIButton alloc] init];
    bb.tag = [self.menuTag intValue] ;
    [self.menuView tapped:bb];
    [self.HeaderView addSubview:self.clientView];
    [self.HeaderView addSubview:self.reportView];
    [self.HeaderView addSubview:self.remarkView];
    [self.HeaderView addSubview:self.subtitleLabel];
    //    [self.HeaderView addSubview:self.subview];
    
    self.clientView.frame = CGRectMake(0, 0, kScreenWidth,217/2*AUTO_SIZE_SCALE_X);
    self.reportView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.clientView.frame.size.height+self.clientView.frame.origin.y, kScreenWidth,428/2*AUTO_SIZE_SCALE_X);
    self.remarkView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.reportView.frame.size.height+self.reportView.frame.origin.y, kScreenWidth,100*AUTO_SIZE_SCALE_X-1);
    self.subtitleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X+self.remarkView.frame.size.height+self.remarkView.frame.origin.y, kScreenWidth-30,40*AUTO_SIZE_SCALE_X);
    self.subview.frame = CGRectMake(0, self.subtitleLabel.frame.origin.y+self.subtitleLabel.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);
    self.HeaderView.frame = CGRectMake(0,
                                       self.menuView.frame.origin.y+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X,
                                       kScreenWidth,
                                       self.clientView.frame.size.height+self.subtitleLabel.frame.size.height+
                                       self.reportView.frame.size.height+25*AUTO_SIZE_SCALE_X+self.subview.frame.size.height+ self.remarkView.frame.size.height);
    [self.view addSubview:self.HeaderView];
    [self.view addSubview:self.myTableView];
    [self.platformView addSubview:self.platformImage];
    [self.platformView addSubview:self.platformLabel];
    [self.platformView addSubview:self.lineImageView];
    [self.platformView addSubview:self.platformTitleLabel];
    [self.platformView addSubview:self.platformTimeLabel];
    [self.platformView addSubview:self.checkLabel];
    [self.platformView addSubview:self.arrowImageView];
    [self.platformView addSubview:self.contentLabel];
    [self.TableHeadView addSubview:self.platformView];
    [self.TableHeadView addSubview:self.enterpriseView];
    [self.enterpriseView addSubview:self.enterpriseImageView];
    [self.enterpriseView addSubview:self.enterpriseLabel];
    [self.enterpriseView addSubview:self.lineImageView2];
    [self.myTableView setTableHeaderView:self.TableHeadView];
    [self loadInfoData];
    
    //    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    //    [self.reportView.tradeView addGestureRecognizer:tap1];
    //
    //    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    //    [self.reportView.districtView addGestureRecognizer:tap4];
    //
    //
    //    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BudgeTaped:)];
    //    [self.reportView.budgeView addGestureRecognizer:tap2];
    //
    //
    //    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(planTaped:)];
    //    [self.reportView.planView addGestureRecognizer:tap3];
    //
    //
    //    [self.subview.subButton addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initData{
    self.data = [NSMutableArray arrayWithCapacity:0];
}

-(void)loadInfoData{
    NSDictionary *dic = @{
                          @"report_id":[NSString stringWithFormat:@"%d",self.report_id],
                          };
    [[RequestManager shareRequestManager] GetCustomerReportDtoResult:dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){
                NSString *name = [dto objectForKey:@"report_customer_name"];
                self.clientView.clientNameContent.text = name;
                NSString *phone = [dto objectForKey:@"report_customer_tel"];
                self.clientView.PhoneContent.text = [NSString stringWithFormat:@"%@",phone];
                
                [self initTrade];
                [self initBudgeData];
                [self initPlanTimeData];
                self.remarkView.text = [dto objectForKey:@"report_customer_note"];
                if (self.remarkView.text.length !=0) {
                    self.remarkView.placeholder =@"";
                }
                //                self.reportView.districtContent.text = [dto objectForKey:@"report_customer_area_agent"];
                districtindex = [dto objectForKey:@"report_customer_area_agent"];
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
                        //                        NSLog(@"addresstemparray----%@",addresstemparray);
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
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
    
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [self.data removeAllObjects];
    NSDictionary *dic1 = @{

                           @"report_id":[NSString stringWithFormat:@"%d",self.report_id]
                           };
    
    [[RequestManager shareRequestManager] getFollowupInfoDtosResult:dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        NSLog(@"getFollowupInfoDtosResult---result--%@",result);
         if(IsSucess(result)){
             NSArray *array = [[result objectForKey:@"data"] objectForKey:@"enterpriseFollowUpDtos"];
             if(![array isEqual:[NSNull null]] && array !=nil)
             {
                 
                 [self.data addObjectsFromArray:array];
                 
             }else{
                 
                 
             }
             NSDictionary *platformFeedbackDic = [[result objectForKey:@"data"] objectForKey:@"platformFeedbackLogDto"];
             
             if (![platformFeedbackDic isEqual:[NSNull null]] && platformFeedbackDic != nil &&platformFeedbackDic.count !=0) {
                 
                 self.platformImage.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                 self.platformLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19.5/2*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
                 self.lineImageView.frame = CGRectMake(0, 40*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5);
                 self.platformTitleLabel.frame = CGRectMake(15, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth/2-15, 45/2*AUTO_SIZE_SCALE_X);
                 self.platformTimeLabel.frame = CGRectMake(15, self.platformTitleLabel.frame.origin.y+self.platformTitleLabel.frame.size.height+3*AUTO_SIZE_SCALE_X, kScreenWidth-30, 33/2*AUTO_SIZE_SCALE_X);
                 self.platformTimeLabel.text = [platformFeedbackDic objectForKey:@"crl_createdtime"];
                 self.checkLabel.frame = CGRectMake(kScreenWidth-15-50*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
                 self.arrowImageView.frame = CGRectMake(kScreenWidth-15, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
                 self.contentLabel.frame =CGRectMake(15, self.platformTimeLabel.frame.origin.y+self.platformTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30,0);
                 self.contentLabel.text = [platformFeedbackDic objectForKey:@"crl_note"];
                 [self.contentLabel sizeToFit];
                 self.platformView.frame = CGRectMake(0, 0, kScreenWidth, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10*AUTO_SIZE_SCALE_X);
                 
                 if (self.data.count==0) {
                     
                     
                 }else{
                     self.enterpriseView.frame = CGRectMake(0, self.platformView.frame.origin.y+self.platformView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 40*AUTO_SIZE_SCALE_X);
                     
                     
                     self.enterpriseImageView.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X,30/2*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                     self.enterpriseLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19/2*AUTO_SIZE_SCALE_X, kScreenWidth-74/2*AUTO_SIZE_SCALE_X-15, 21*AUTO_SIZE_SCALE_X);
                     self.lineImageView2.frame = CGRectMake(0, self.enterpriseView.frame.size.height-0.5, kScreenWidth, 0.5);
                     
                 }
                 self.TableHeadView.frame = CGRectMake(0, 0, kScreenWidth, self.platformView.frame.size.height+10*AUTO_SIZE_SCALE_X+self.enterpriseView.frame.size.height);
                 
                
                 
                 followup_id = [[platformFeedbackDic objectForKey:@"report_id"] intValue];
                 
             }else{
                 self.enterpriseView.frame = CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X);
                 self.enterpriseImageView.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 30/2*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                 self.enterpriseLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19/2*AUTO_SIZE_SCALE_X, kScreenWidth-74/2*AUTO_SIZE_SCALE_X-15, 21*AUTO_SIZE_SCALE_X);
                 self.lineImageView2.frame = CGRectMake(0, self.enterpriseView.frame.size.height-0.5, kScreenWidth, 0.5);
                 self.TableHeadView.frame = CGRectMake(0, 0, kScreenWidth, self.enterpriseView.frame.size.height);
                 
             }
             
            
             [self.myTableView setFrame:CGRectMake(0, self.navView.frame.origin.y+self.navView.frame.size.height+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-self.navView.frame.size.height-self.menuView.frame.size.height-10*AUTO_SIZE_SCALE_X)];
             [self.myTableView reloadData];
         

             if (platformFeedbackDic.count == 0 && self.data.count==0) {
                 nocontent.hidden = NO;
                 
             }else{
                 nocontent.hidden = YES;
   
             }
 
             failView.hidden = YES;

         }else{
             [[RequestManager shareRequestManager] resultFail:result viewController:self];
         }
     }failuer:^(NSError *error){
//         [self.myTableView.head endRefreshing];
//         [self.myTableView.foot endRefreshing];
         [LZBLoadingView dismissLoadingView];
         [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
         failView.hidden = NO;
         nocontent.hidden = YES;
     }];
}

#pragma mark 刷新数据
//-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
//{
//    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//        current_page = 0;
//        [self loadData];
//        return;
//    }
//    else{
//        current_page ++;
//    }
//    NSString * page = [NSString stringWithFormat:@"%d",current_page];
//    //        NSString * pageOffset = @"20";
//    NSDictionary *dic = @{
//                          @"_currentPage":page,
//                          @"_pageSize":@"",
//                          @"report_id":[NSString stringWithFormat:@"%d",self.report_id]
//                          };
//    [[RequestManager shareRequestManager]
//          getFollowupInfoDtosResult:dic
//     viewController:self successData:^(NSDictionary *result) {
//        failView.hidden = YES;
//        [refreshView endRefreshing];
//        if(IsSucess(result)){
//            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            
//            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                [self.data removeAllObjects];
//            }
//            
//            if(![array isEqual:[NSNull null]] && array !=nil)
//            {
//                [self.data addObjectsFromArray:array];
//            }else{
//            }
//            [self.myTableView reloadData];
//            
//            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                [self.myTableView.head endRefreshing];
//            }
//            if (self.data.count == total_count ) {
//                [self.myTableView.foot finishRefreshing];
//            }
//        }else{
//            [[RequestManager shareRequestManager] resultFail:result viewController:self];
//        }
//    } failuer:^(NSError *error) {
//        [refreshView endRefreshing];
//        failView.hidden = NO;
//    }];
//}


- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

#pragma mark menuViewDidSelect 代理
-(void)menuViewDidSelect:(NSInteger)number{
    self.menuTag = [NSString stringWithFormat:@"%ld",(long)number];
    if (number == 1) {
        self.HeaderView.hidden = NO;
        self.myTableView.hidden = YES;
    }else{
        self.HeaderView.hidden = YES;
        self.myTableView.hidden = NO;
    }
}

-(void)initTrade{
    tradeArrray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetLookupIndustryMapResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (array != nil) {
                [tradeArrray addObjectsFromArray:array];
                NSString *report_customer_industry = [dto objectForKey:@"report_customer_industry"];
                if(![report_customer_industry isEqual:[NSNull null]] && report_customer_industry !=nil)
                {
                    for (NSDictionary *temp in tradeArrray) {
                        if ( [[temp objectForKey:@"code"] isEqualToString:[dto objectForKey:@"report_customer_industry"]]) {
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
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
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
    NSString *report_customer_budget = [dto objectForKey:@"report_customer_budget"];
    if(![report_customer_budget isEqual:[NSNull null]] && report_customer_budget !=nil)
    {
        for (NSDictionary *temp in budgetarrayData) {
            if ( [[temp objectForKey:@"code"] isEqualToString:report_customer_budget]) {
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
    NSString *report_customer_startdate = [dto objectForKey:@"report_customer_startdate"];
    if(![report_customer_startdate isEqual:[NSNull null]] && report_customer_startdate !=nil)
    {
        for (NSDictionary *temp in planArrray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:report_customer_startdate]) {
                self.reportView.planBeginTimeContent.text = [temp objectForKey:@"name"] ;
                plantimeindex = [temp objectForKey:@"code"] ;
            }
        }
    }
}

-(void)disTaped:(UITapGestureRecognizer *)sender
{
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
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        
        districtindex =temparray[temparray.count-1];
        
    } cancelBlock:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyReportDetailPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyReportDetailPage];
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"infocell";
    cell = [[infoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    cell.mydata = self.data[[indexPath row]];
    return [cell setCellHeight:@""];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *simpleIdentify = @"infocell";
    cell =(infoCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell = [[infoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTag:[indexPath row]];
    }
    if (self.data.count > 0) {
        cell.mydata = self.data[[indexPath row]];
        [cell setCellHeight:@""];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [MobClick event:kMyReportProgress];
    timelineViewController *vc = [[timelineViewController alloc] init];
    vc.titles = @"跟进进度";
    vc.report_id =  [NSString stringWithFormat:@"%d",[[self.data[indexPath.row] objectForKey:@"report_id"] intValue]];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)PlatFormTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:kPlatFormProgress];
    PlatformfeedbackViewController *vc = [[PlatformfeedbackViewController alloc] init];
    vc.titles = @"平台反馈";
    vc.search_id = [NSString stringWithFormat:@"%d",followup_id];
    [self.navigationController pushViewController:vc animated:YES];
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
        self.HeaderView.backgroundColor = [UIColor clearColor];
    }
    return _HeaderView;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"客户报备后，如果不匹配当前项目，我们会调剂到更合适的项目中" textAlignment:NSTextAlignmentLeft font:13*AUTO_SIZE_SCALE_X];
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
        self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _remarkView.editable = NO;
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

- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"基本信息", @"跟进信息"];
    }
    return _menuView;
}

-(UITableView *)myTableView{
    if (_myTableView == nil) {
        self.myTableView = [[UITableView alloc] init];
        [self.myTableView setTableHeaderView:self.TableHeadView];
        self.myTableView.backgroundColor = BGColorGray;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.delegate = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myTableView.dataSource = self;
        self.myTableView.hidden = YES;
        //加载数据失败时显示
        failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navView.frame.size.height-self.menuView.frame.size.height-10*AUTO_SIZE_SCALE_X)];
        [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        failView.hidden = YES;
        [self.myTableView addSubview:failView];
        nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navView.frame.size.height-self.menuView.frame.size.height-10*AUTO_SIZE_SCALE_X)];
//            [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nocontent.hidden = YES;
        [self.myTableView addSubview:nocontent];
    }
    return _myTableView;
}

- (UIView *)TableHeadView {
    if (_TableHeadView == nil) {
        self.TableHeadView = [UIView new];
        self.TableHeadView.backgroundColor = BGColorGray;
    }
    return _TableHeadView;
}

- (UIView *)platformView {
    if (_platformView == nil) {
        self.platformView = [UIView new];
        self.platformView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PlatFormTaped:)];
        [self.platformView addGestureRecognizer:tap1];
    }
    return _platformView;
}

- (UIView *)enterpriseView {
    if (_enterpriseView == nil) {
        self.enterpriseView = [UIView new];
        self.enterpriseView.backgroundColor = [UIColor whiteColor];
    }
    return _enterpriseView;
}

-(UIImageView *)platformImage{
    if (_platformImage == nil) {
        self.platformImage = [UIImageView new];
        self.platformImage.image = [UIImage imageNamed:@"icon_report_feedback"];
        
    }
    return _platformImage;
}

- (UILabel *)platformLabel {
    if (_platformLabel == nil) {
        self.platformLabel = [CommentMethod initLabelWithText:@"平台反馈" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.platformLabel.textColor = FontUIColorGray;
    }
    return _platformLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [[UIImageView alloc] init];
        [self.lineImageView setSize:CGSizeMake( kScreenWidth, 0.5)];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

- (UILabel *)platformTitleLabel {
    if (_platformTitleLabel == nil) {
        self.platformTitleLabel = [CommentMethod initLabelWithText:@"渠到天下客服" textAlignment:NSTextAlignmentLeft font:16*AUTO_SIZE_SCALE_X];
        self.platformTitleLabel.textColor = FontUIColorBlack;
        
        
    }
    return _platformTitleLabel;
}

- (UILabel *)platformTimeLabel {
    if (_platformTimeLabel == nil) {
        self.platformTimeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.platformTimeLabel.textColor = FontUIColorGray;
    }
    return _platformTimeLabel;
}

- (UILabel *)checkLabel {
    if (_checkLabel == nil) {
        self.checkLabel = [CommentMethod initLabelWithText:@"查看" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.checkLabel.textColor = FontUIColorGray;
    }
    return _checkLabel;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        self.arrowImageView = [[UIImageView alloc] init];
        [self.arrowImageView setSize:CGSizeMake( 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
    }
    return _arrowImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.contentLabel.textColor = FontUIColorGray;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}

- (UILabel *)enterpriseLabel {
    if (_enterpriseLabel == nil) {
        self.enterpriseLabel = [CommentMethod initLabelWithText:@"企业跟进" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.enterpriseLabel.textColor = FontUIColorGray;
    }
    return _enterpriseLabel;
}

-(UIImageView *)enterpriseImageView{
    if (_enterpriseImageView == nil) {
        self.enterpriseImageView = [[UIImageView alloc] init];
        self.enterpriseImageView.image = [UIImage imageNamed:@"icon_report_follow_up"];
    }
    return _enterpriseImageView;
}

-(UIImageView *)lineImageView2{
    if (_lineImageView2 == nil) {
        self.lineImageView2 = [[UIImageView alloc] init];
//        [self.lineImageView2 setSize:CGSizeMake( kScreenWidth, 0.5)];
        self.lineImageView2.backgroundColor = lineImageColor;
    }
    return _lineImageView2;
}
//#pragma mark 提交
//-(void)submitBtnPressed:(UIButton *)sender
//{
//    self.subview.subButton.enabled = NO;
//    if (self.clientView.clientNameContent.text.length==0||self.clientView.PhoneContent.text.length==0|| self.reportView.districtContent.text.length==0 ||self.reportView.budgetContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0||self.reportView.planBeginTimeContent.text.length==0|| self.reportView.tradeContent.text.length==0) {
//        [[RequestManager shareRequestManager] tipAlert:@"您有必填项没有填写，请您检查并输入" viewController:self];
//        self.subview.subButton.enabled = YES;
//        return;
//    }
//    
//    if (self.clientView.PhoneContent.text.length!=11) {
//        [[RequestManager shareRequestManager] tipAlert:@"您的手机号输入有误，请您重新输入" viewController:self];
//        self.subview.subButton.enabled = YES;
//        return;
//    }
//    
//    NSDictionary *dic = @{
//                          
//                          @"customer_id":self.customerID,
//                          @"customer_industry":tradeindex,
//                          @"customer_area_agent":districtindex,
//                          @"customer_budget":budgetindex,
//                          @"customer_startdate":plantimeindex,
//                          @"_customer_note":self.remarkView.text,
//                          };
//    
//    [[RequestManager shareRequestManager] UpdateCustomerResult:dic viewController:self successData:^(NSDictionary *result){
//        
//        if(IsSucess(result)){
//            [[RequestManager shareRequestManager] tipAlert:@"修改成功" viewController:self];
//            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
//        }else{
//            [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            self.subview.subButton.enabled = YES;
//        }
//    }failuer:^(NSError *error){
//        
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        self.subview.subButton.enabled = YES;
//    }];
//}
//
//-(void)returnListPage{
//    //    [self.delegate edditSuccessReturnClientPage];
//    [self.navigationController popViewControllerAnimated:YES];
//    self.subview.subButton.enabled = YES;
//}
@end
