//
//  ProgressRecordViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/26.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ProgressRecordViewController.h"
#import "noWifiView.h"
#import "ProgressRecordTableViewCell.h"
#import "publicTableViewCell.h"
#import "confirmreviewgobackViewController.h"
#import "confirmreviewpassViewController.h"
#import "Signup4MoneyViewController.h"
#import "noContent.h"
@interface ProgressRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    noWifiView *failView;
    noContent *nocontent;
    ProgressRecordTableViewCell *cell;
}
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@property (nonatomic,strong)UITableView *timeTableView;
@property (nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)UIView *footView1,*footView2;

@property(nonatomic,strong)UIButton *quitButton;
@property(nonatomic,strong)UIImageView *phoneImageView;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UIView *phoneView;


@property(nonatomic,strong)UIImageView *addRecordImageView;
@property(nonatomic,strong)UILabel *addRecordLabel;
@property(nonatomic,strong)UIView *addRecordView;
@property(nonatomic,strong)UIImageView * followImageView ,*footPhoneImageView ,*verticallineImageView;
@property(nonatomic,strong)UIView *followView,  *footPhoneView;
@property(nonatomic,strong)UILabel  *followrecordLabel;
@property(nonatomic,strong)UILabel *phoneLabel2;
@end

@implementation ProgressRecordViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kRefreshProgressList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadclient) name:kRefreshProgressList object:nil];
    [super viewDidLoad];
    self.titles =@"跟进记录";
    self.mydata = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.timeTableView];
    [self.view addSubview:self.footView1];
    [self.view addSubview:self.footView2];
    if (self.fromtype == 0) {
        self.footView2.hidden = YES;
        self.footView1.hidden = NO;
    }else{
        self.footView2.hidden = NO;
        self.footView1.hidden = YES;
    }
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-ktabFootHeight*AUTO_SIZE_SCALE_X)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    failView.backgroundColor = [UIColor whiteColor];
    
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

    
    [self initData];
}

-(void)onaddRecordViewClick:(UITapGestureRecognizer *)sender{
    [[sender view] setUserInteractionEnabled:NO];

    [MobClick event:kFromProgressListAddRecordButtonEvent];
    AddCommunicationRecordViewController *vc = [[AddCommunicationRecordViewController alloc] init];
    vc.report_id = self.report_id;
    [self.navigationController pushViewController:vc animated:YES];
    [[sender view] setUserInteractionEnabled:YES];

}
-(void)onphoneviewClick:(UITapGestureRecognizer *)sender{
    [[sender view] setUserInteractionEnabled:NO];
    NSLog(@"dic======%@",self.report_id);
    [MobClick event:kFromProgressListPhoneButtonEvent];
    NSDictionary *dic = @{
                          @"report_id_str":self.report_str,
                          };
    NSLog(@"dic======%@",dic);
    
    [[RequestManager shareRequestManager] GetCustomerTelByReportIdStrResult:dic viewController:self successData:^(NSDictionary *result){
         [[sender view] setUserInteractionEnabled:YES];
        //        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            NSLog(@"result======%@",result);
            if (result != nil) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                 
                                         completionHandler:^(BOOL success) {
                                         }];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                //                    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[sender view] setUserInteractionEnabled:YES];

        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)onclickButton:(UIButton *)sender{
    
    
    if (sender.tag == 0) {
        [MobClick event:kFromProgressListQuitButtonEvent];
        confirmreviewgobackViewController *vc = [[confirmreviewgobackViewController alloc] init];
        vc.report_id = self.report_id;
        [self.navigationController pushViewController:vc animated:YES];
//        self.quitButton.tag = 0;
    }else{
        if ([self.confirmPassButton.titleLabel.text isEqualToString:@"确认通过"]) {
            [MobClick event:kFromProgressListConfirmButtonEvent];
            confirmreviewpassViewController *vc = [[confirmreviewpassViewController alloc] init];
            vc.report_id = self.report_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MobClick event:kFromProgressListConfirmButtonEvent];
            Signup4MoneyViewController *vc = [[Signup4MoneyViewController alloc] init];
            vc.report_id = self.report_id;
            vc.project_id = self.project_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.mydata removeAllObjects];
    //    [self.mydata addObjectsFromArray: [[NSArray alloc] initWithObjects:@"老夫聊发少年狂，治肾亏，不含糖。",
    //    @"夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
    //                                       @"啦啦啦",
    //                                       @"老夫聊发少年狂，治肾亏，不含糖。",
    //                                       @"锦帽貂裘，千骑用康王。",
    //                                       @"",
    //                                       @"为报倾城随太守，三百年，九芝堂。酒酣胸胆尚开张，西瓜霜，喜之郎。",
    //                                       @"持节云中，三金葡萄糖。会挽雕弓如满月，西北望 ，阿迪王。",
    //                                       @"十年生死两茫茫，恒源祥，羊羊羊。",
    //                                       @"千里孤坟，洗衣用奇强。",
    //                                       @"纵使相逢应不识，补维C，施尔康。",
    //                                       @"夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
    //                                       @"啦啦啦",nil]]
    //   ;
    
    NSDictionary *dic = @{
                          
                          @"report_id":self.report_id,
                          };
    NSLog(@"dic-----%@",dic);
    [[RequestManager shareRequestManager] searchCustomerReportLogsResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.mydata addObjectsFromArray:array];
                
            }else{
            }
            
            [self.timeTableView reloadData];
            
            if (self.mydata.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            failView.hidden = NO;
        }
        
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        nocontent.hidden = YES;
    }];
    
}

-(UITableView *)timeTableView{
    if (_timeTableView == nil) {
        self.timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-ktabFootHeight*AUTO_SIZE_SCALE_X) ];
        self.timeTableView.showsVerticalScrollIndicator = NO;
        self.timeTableView.delegate = self;
        self.timeTableView.dataSource = self;
        self.timeTableView.bounces = NO;
        self.timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.timeTableView.backgroundColor = BGColorGray;
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.frame = CGRectMake(0, 0, kScreenWidth, 25*AUTO_SIZE_SCALE_X);
        self.timeTableView.tableFooterView =footerView;
        
        
    }
    return _timeTableView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    
    [self initData];
}

-(void)reloadclient{
    [self initData];
}


#pragma mark - TabelView数据源协议
//该方法指定了表格视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSLog(@"count---%lu",(unsigned long)self.mydata.count);
    return self.mydata.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"ProgressRecordTableViewCell";
    //按时间分组，假设这里[0,2],[3,5],[6,9]是同一天
    cell = [[ProgressRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    if (indexPath.row==0) {
        return [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"]  isHighLighted:YES isRedColor:YES isZero:YES isLastData:NO];
    }else {
        return [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"]  isHighLighted:NO isRedColor:NO isZero:NO isLastData:YES];
    }
    
    //    if(self.mydata.count-1==indexPath.row)
    
}

//该方法返回单元格对象，有多少行表格，则调用多少次
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"ProgressRecordTableViewCell";
//    cell =(ProgressRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    cell =(ProgressRecordTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ProgressRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setTag:[indexPath row]];
    }
    CGFloat height;
    if (indexPath.row==0) {
        height = [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"] isHighLighted:YES isRedColor:YES isZero:YES isLastData:NO];
    }else {
        height = [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"] isHighLighted:NO isRedColor:NO isZero:NO isLastData:YES];
    }
    
    if(indexPath.row==0){
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, cell.timeImageView.frame.origin.y+cell.timeImageView.frame.size.height, 0.5, height-(cell.timeImageView.frame.origin.y+cell.timeImageView.frame.size.height));
        
    }else if(indexPath.row ==self.mydata.count-1){
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, 0, 0.5, cell.timeImageView.frame.origin.y);
    }else{
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, 0,0.5, height);
    }
    if(indexPath.row == self.mydata.count -1&&self.mydata.count == 1){
        cell.lineImageView.hidden = YES;
    }else{
        cell.lineImageView.hidden = NO;
    }
    cell.lbDate.text = [[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_createdtime"];
    cell.progressdesLabel.text = [NSString stringWithFormat:@"%@%@",[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"si_name"],[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"kindName"]];
    return  cell;
    
}

#pragma mark - TabelView代理协议
//选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //     NSLog(@"count---%lu",(unsigned long)indexPath.row);
}





-(UIImageView *)addRecordImageView{
    if (_addRecordImageView == nil) {
        self.addRecordImageView = [UIImageView new];
        self.addRecordImageView.image = [UIImage imageNamed:@"icon_enterprise_review_add"];
        self.addRecordImageView.frame = CGRectMake((155/2-20)/2*AUTO_SIZE_SCALE_X,
                                               5.5*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X);
    }
    return  _addRecordImageView;
}

-(UILabel *)addRecordLabel{
    if (_addRecordLabel == nil) {
        self.addRecordLabel = [CommentMethod initLabelWithText:@"添加记录" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.addRecordLabel.textColor = FontUIColorBlack;
        self.addRecordLabel.frame = CGRectMake(0, 28.5*AUTO_SIZE_SCALE_X, 155/2*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    }
    return _addRecordLabel;
}

-(UIView *)addRecordView{
    if (_addRecordView == nil) {
        self.addRecordView = [UIView new];
        self.addRecordView.backgroundColor = [UIColor whiteColor];
        self.addRecordView.frame =CGRectMake(0,0,155/2*AUTO_SIZE_SCALE_X,
                                         ktabFootHeight*AUTO_SIZE_SCALE_X);
        [self.addRecordView addSubview:self.addRecordImageView];
        [self.addRecordView addSubview:self.addRecordLabel];
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onaddRecordViewClick:)];
        self.addRecordView.userInteractionEnabled = YES;
        [self.addRecordView addGestureRecognizer:phonetap];
        UIImageView *lineimageview= [[UIImageView alloc] init];
        lineimageview.backgroundColor = lineImageColor;
        lineimageview.frame = CGRectMake(0, 0, self.phoneView.frame.size.width, 0.5);
        [self.addRecordView addSubview:lineimageview];
        
    }
    return  _addRecordView;
}

-(UIImageView *)phoneImageView{
    if (_phoneImageView == nil) {
        self.phoneImageView = [UIImageView new];
        self.phoneImageView.image = [UIImage imageNamed:@"icon_enterprise_review_phone"];
        self.phoneImageView.frame = CGRectMake((155/2-20)/2*AUTO_SIZE_SCALE_X,
                                               5.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return  _phoneImageView;
}

-(UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"拨打电话" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.phoneLabel.textColor = FontUIColorBlack;
        self.phoneLabel.frame = CGRectMake(0, 28.5*AUTO_SIZE_SCALE_X, 155/2*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        
    }
    return _phoneLabel;
}

-(UIView *)phoneView{
    if (_phoneView == nil) {
        self.phoneView = [UIView new];
        self.phoneView.backgroundColor = [UIColor whiteColor];
        self.phoneView.frame =CGRectMake(self.addRecordView.frame.origin.x+self.addRecordView.frame.size.width,0,155/2*AUTO_SIZE_SCALE_X, ktabFootHeight*AUTO_SIZE_SCALE_X);
        [self.phoneView addSubview:self.phoneImageView];
        [self.phoneView addSubview:self.phoneLabel];
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onphoneviewClick:)];
        self.phoneView.userInteractionEnabled = YES;
        [self.phoneView addGestureRecognizer:phonetap];
        UIImageView *lineimageview= [[UIImageView alloc] init];
        lineimageview.backgroundColor = lineImageColor;
        lineimageview.frame = CGRectMake(0, 0, self.phoneView.frame.size.width, 0.5);
        [self.phoneView addSubview:lineimageview];
        
    }
    return  _phoneView;
}

-(UIView *)footView1{
    if (_footView1 == nil) {
        self.footView1 = [UIView new];
        self.footView1.backgroundColor = [UIColor whiteColor];
        self.footView1.frame =CGRectMake(0,
                                        kScreenHeight-ktabFootHeight*AUTO_SIZE_SCALE_X,
                                        kScreenWidth,
                                        ktabFootHeight*AUTO_SIZE_SCALE_X);
        UIImageView *linImageView1 = [UIImageView new];
        linImageView1.backgroundColor = lineImageColor;
        linImageView1.frame = CGRectMake(0, 0, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
        [self.footView1 addSubview:linImageView1];
        [self.footView1 addSubview:self.addRecordView];
        [self.footView1 addSubview:self.phoneView];
        [self.footView1 addSubview:self.quitButton];
        [self.footView1 addSubview:self.confirmPassButton];
        
        //        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCollect:)];
        //        self.collectView.userInteractionEnabled = YES;
        //        [self.collectView addGestureRecognizer:collect];
        //        UIImageView *lineimageview= [[UIImageView alloc] init];
        //        lineimageview.backgroundColor = lineImageColor;
        //        lineimageview.frame = CGRectMake(0, 0, self.collectView.frame.size.width, 0.5);
        //        [self.collectView addSubview:lineimageview];
        
    }
    return  _footView1;
}

-(UIButton *)quitButton{
    if (_quitButton == nil) {
        self.quitButton = [CommentMethod createButtonWithBackgroundColor:FontUIColorGray Target:self Action:@selector(onclickButton:) Title:@"退回" FontColor:[UIColor whiteColor] FontSize:14*AUTO_SIZE_SCALE_X];
        self.quitButton.tag = 0;
        self.quitButton.frame = CGRectMake(kScreenWidth-2*110*AUTO_SIZE_SCALE_X,
                                                  0,
                                                  110*AUTO_SIZE_SCALE_X,
                                                  ktabFootHeight*AUTO_SIZE_SCALE_X);
        
    }
    return _quitButton;
}

-(UIButton *)confirmPassButton{
    if (_confirmPassButton == nil) {
        self.confirmPassButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(onclickButton:) Title:@"确认通过" FontColor:[UIColor whiteColor] FontSize:14*AUTO_SIZE_SCALE_X];
        self.confirmPassButton.tag = 1;
        
        self.confirmPassButton.frame = CGRectMake(kScreenWidth-110*AUTO_SIZE_SCALE_X,
                                                  0,
                                                  110*AUTO_SIZE_SCALE_X,
                                                  ktabFootHeight*AUTO_SIZE_SCALE_X);
    }
    return _confirmPassButton;
}


-(UIView *)footView2{
    if (_footView2 == nil) {
        self.footView2 = [UIView new];
        self.footView2.backgroundColor = [UIColor whiteColor];
        self.footView2.frame =CGRectMake(0,
                                         kScreenHeight-ktabFootHeight*AUTO_SIZE_SCALE_X,
                                         kScreenWidth,
                                         ktabFootHeight*AUTO_SIZE_SCALE_X);
        
        self.footView2.userInteractionEnabled = YES;
        
        [self.footView2 addSubview:self.followView];
        [self.followView addSubview:self.followImageView];
        [self.followView addSubview:self.followrecordLabel];
        
        [self.footView2 addSubview:self.footPhoneView];
        [self.footPhoneView addSubview:self.footPhoneImageView];
        [self.footPhoneView addSubview:self.phoneLabel2];
        [self.footView2 addSubview:self.verticallineImageView];
        UIImageView *linImageView1 = [UIImageView new];
        linImageView1.backgroundColor = lineImageColor;
        linImageView1.frame = CGRectMake(0, 0, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
        [self.footView2 addSubview:linImageView1];
        //        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCollect:)];
        //        self.collectView.userInteractionEnabled = YES;
        //        [self.collectView addGestureRecognizer:collect];
        //        UIImageView *lineimageview= [[UIImageView alloc] init];
        //        lineimageview.backgroundColor = lineImageColor;
        //        lineimageview.frame = CGRectMake(0, 0, self.collectView.frame.size.width, 0.5);
        //        [self.collectView addSubview:lineimageview];
        
    }
    return  _footView2;
}


-(UIView *)followView{
    if (_followView == nil) {
        self.followView = [UIView new];
        self.followView.backgroundColor = [UIColor whiteColor];
        self.followView.frame = CGRectMake(0, 0, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onaddRecordViewClick:)];
        self.followView.userInteractionEnabled = YES;
        [self.followView addGestureRecognizer:phonetap];
        
    }
    return  _followView;
}

-(UIImageView *)followImageView{
    if (_followImageView == nil) {
        self.followImageView = [UIImageView new];
        self.followImageView.image = [UIImage imageNamed:@"icon_enterprise_review_add"];
        self.followImageView.frame = CGRectMake(84.5*AUTO_SIZE_SCALE_X,
                                                6.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return  _followImageView;
}

- (UILabel *)followrecordLabel {
    if (_followrecordLabel == nil) {
        self.followrecordLabel = [CommentMethod initLabelWithText:@"添加记录" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.followrecordLabel.frame = CGRectMake(0, 29.5*AUTO_SIZE_SCALE_X,kScreenWidth/2, 15*AUTO_SIZE_SCALE_X);
        self.followrecordLabel.textColor = FontUIColorBlack;
    }
    return _followrecordLabel;
}




-(UIView *)footPhoneView{
    if (_footPhoneView == nil) {
        self.footPhoneView = [UIView new];
        self.footPhoneView.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onphoneviewClick:)];
        self.footPhoneView.userInteractionEnabled = YES;
        [self.footPhoneView addGestureRecognizer:phonetap];
    }
    return  _footPhoneView;
}

- (UIImageView *)footPhoneImageView {
    if (_footPhoneImageView == nil) {
        self.footPhoneImageView = [UIImageView new];
        self.footPhoneImageView.image = [UIImage imageNamed:@"icon_enterprise_review_phone"];
        self.footPhoneImageView.frame = CGRectMake(84.5*AUTO_SIZE_SCALE_X,
                                                6.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return _footPhoneImageView;
}



- (UILabel *)phoneLabel2 {
    if (_phoneLabel2 == nil) {
        self.phoneLabel2 = [CommentMethod initLabelWithText:@"拨打电话" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.phoneLabel2.frame = CGRectMake(0, 29.5*AUTO_SIZE_SCALE_X, kScreenWidth/2, 15*AUTO_SIZE_SCALE_X);
        self.phoneLabel2.textColor = FontUIColorBlack;
    }
    return _phoneLabel2;
}




-(UIImageView *)verticallineImageView{
    if (_verticallineImageView == nil) {
        self.verticallineImageView = [UIImageView new];
        self.verticallineImageView.backgroundColor = lineImageColor;
        self.verticallineImageView.frame = CGRectMake(kScreenWidth/2,
                                                      14.5*AUTO_SIZE_SCALE_X,
                                                      0.5,
                                                      20*AUTO_SIZE_SCALE_X);
    }
    return  _verticallineImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kProgressRecordPage];//("PageOne"为页面名称，可自定义)
    // 右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kProgressRecordPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}


//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self startSideBack];
//}
///**
// * 关闭ios右滑返回
// */
//-(void)cancelSideBack{
//    self.isCanUseSideBack = NO;
//    
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate=self;
//    }
//}

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
