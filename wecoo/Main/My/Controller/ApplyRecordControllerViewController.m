//
//  ApplyRecordControllerViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2017/2/2.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ApplyRecordControllerViewController.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "timelineViewController.h"
#import "noContent.h"
#import "menuVIew.h"
#import "WithdrawProgressViewController.h"
@interface ApplyRecordControllerViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent * nocontent;
    NSMutableArray *data;
    int flagIndex;
    int current_page;
    int total_count;
    NSString *swa_status;
}

@property (nonatomic,strong)menuVIew *menuView;

@end

@implementation ApplyRecordControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReloadwithDrawRecord object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWithDraw) name:kReloadwithDrawRecord object:nil];
    [self initdata];
    
    [self.view addSubview:self.menuView];
    UIButton *bb = [[UIButton alloc] init];
    bb.tag = self.menuTag ;
    [self.menuView tapped:bb];
    [self initTableView];
}

-(void)reloadWithDraw{
     [self loadDataWithFlagindex:flagIndex];
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    flagIndex = self.menuTag;
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height+self.menuView.frame.size.height+1, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.menuView.frame.size.height+1))];
    
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 138/2*AUTO_SIZE_SCALE_X;
    
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadDataWithFlagindex:flagIndex];
}

-(void)loadDataWithFlagindex:(int)Index
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];
    if (Index ==1) {
         swa_status = @"";
    }
    if (Index ==2) {
        swa_status = @"0";
    }
    if (Index ==3) {
        swa_status = @"1";
    }
    if (Index ==4) {
        swa_status = @"2";
    }

    
    NSDictionary *dic =    @{
                             @"_swa_status":swa_status,
                             @"_currentPage":@"",
                             @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSalesmanWithdrawingApplicationDtosResult:dic viewController:self successData:^(NSDictionary *result){
        
//         NSLog(@"SearchSalesmanWithdrawingApplicationDtosResult----%@",result);
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];

            }else{
            }
            
            [myTableView reloadData];
            if (data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            
            failView.hidden = YES;
            if (data.count == total_count ) {
                [myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];

    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        nocontent.hidden = YES;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
    }
    else{
        current_page ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    
    NSDictionary *dic = @{
                          @"_swa_status":swa_status,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };

    [[RequestManager shareRequestManager] SearchSalesmanWithdrawingApplicationDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        
        
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
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 1;
    
    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}

#pragma menu代理
-(void)menuViewDidSelect:(NSInteger)number{
    flagIndex = (int)number;
    NSLog(@"flagIndex------>%d",flagIndex);
    [self loadDataWithFlagindex:flagIndex];
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
        cell.backgroundColor = BGColorGray;
    }
    if (data.count > 0) {
    
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.frame = CGRectMake(0, 0, kScreenWidth, 138/2*AUTO_SIZE_SCALE_X);
        [cell addSubview:backgroundView];
        
        UILabel *nameLabel =  [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth/2-15, 27/2*AUTO_SIZE_SCALE_X);
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = FontUIColorBlack;
        nameLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        [backgroundView addSubview:nameLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.frame = CGRectMake(15, 28/2*AUTO_SIZE_SCALE_X+nameLabel.frame.origin.y+nameLabel.frame.size.height, kScreenWidth/2-15, 27/2*AUTO_SIZE_SCALE_X);
        
        dateLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.textColor = FontUIColorGray;
        [backgroundView addSubview:dateLabel];
        
        if (data.count > 0) {
            int index ;
            NSString *string = nil;
            NSString *str = nil;
            NSString *des = @"提现申请金额：";
            string = [NSString stringWithFormat:@"%@", [data[indexPath.row] objectForKey:@"swa_sum_str"] ];
            str = [NSString stringWithFormat:@"%@%@",des,string];
            index = (int)[des length] ;
            //    NSLog(@"%d",index);
            //    NSLog(@"%@",str);
            NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
            
            [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorGray range:NSMakeRange(0,index)];
            [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
            
            [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
            [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
            
            nameLabel.attributedText = mutablestr;
            [nameLabel sizeToFit];
            
            dateLabel.text =  [data[indexPath.row] objectForKey:@"swa_createdtime"];
            UILabel *flagLabel =  [[UILabel alloc] init];
            flagLabel.frame = CGRectMake(kScreenWidth-15-120/2*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 120/2*AUTO_SIZE_SCALE_X, 27/2*AUTO_SIZE_SCALE_X);
            flagLabel.textAlignment = NSTextAlignmentRight;
            flagLabel.textColor = FontUIColorBlack;
            flagLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
            flagLabel.text = [data[indexPath.row] objectForKey:@"swa_status_name"];
            //    int flag =0 ;
            //    if (flag ==0) {
            //
            //    }else if(flag ==1){
            //        flagLabel.text =@"待打款";
            //    }else if (flag ==2){
            //        flagLabel.text =@"打款失败";
            //    }
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 138/2*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5)];
            lineImageView.backgroundColor = lineImageColor;
            [cell addSubview:lineImageView];
            if ((int)indexPath.row==(data.count-1)) {
                lineImageView.hidden = YES;
            }
            [backgroundView addSubview:flagLabel];
        }

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MobClick event:kApplyMoneyRecordProgressOnClickEvent label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"swa_id"] integerValue]]];
    WithdrawProgressViewController *vc = [[WithdrawProgressViewController alloc] init];
    vc.titles = @"提现进度";
    int tempid = [[data[indexPath.row] objectForKey:@"swa_id"] intValue];

    vc.swa_id = [NSString stringWithFormat:@"%d",tempid];
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyyApplyRecordListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyyApplyRecordListPage];
}

- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"全部记录", @"待打款", @"已打款", @"打款失败"];
    }
    return _menuView;
}

@end
