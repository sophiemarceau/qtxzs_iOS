//
//  efficiencyDetailListViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/7.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "efficiencyDetailListViewController.h"
#import "BaseTableView.h"
#import "noContent.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"

@interface efficiencyDetailListViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent * nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;

}

@end

@implementation efficiencyDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initdata];
    [self initTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-(kNavHeight))];
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 136/2*AUTO_SIZE_SCALE_X+1;
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, myTableView.frame.origin.y, kScreenWidth, kScreenHeight-kNavHeight)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData
{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSalesmanReporteffectiverateListResult:dic viewController:self successData:^(NSDictionary *result){
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
            }else{
            }
            
            [myTableView reloadData];
            if (data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
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
        nocontent.hidden = YES;
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
    }
    else{
        current_page++;
    }
    
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    
    //        NSString * pageOffset = @"20";
    
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSalesmanReporteffectiverateListResult:dic viewController:self successData:^(NSDictionary *result) {
        
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            //            NSLog(@"projectListArray----->%lu",(unsigned long)projectListArray.count);
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
        nocontent.hidden = YES;
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
    if (data.count>0) {
        
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = RedUIColorC1;
    if([[data[indexPath.row] objectForKey:@"srl_addsubflag"] intValue]==1){
        numberLabel.text = [NSString stringWithFormat:@"+%@",[data[indexPath.row] objectForKey:@"srl_number"] ];
    }else{
        numberLabel.text = [NSString stringWithFormat:@"-%@",[data[indexPath.row] objectForKey:@"srl_number"] ];
    }
    
    numberLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    numberLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30, 12*AUTO_SIZE_SCALE_X);
    [cell addSubview:numberLabel];
    
    UILabel *descriLabel = [[UILabel alloc] init];
    descriLabel.textAlignment = NSTextAlignmentLeft;
    descriLabel.textColor = FontUIColorGray;
    descriLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"srl_desc"] ];
    descriLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    descriLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X+numberLabel.frame.size.height+numberLabel.frame.origin.y, kScreenWidth-30, 15*AUTO_SIZE_SCALE_X);
    [cell addSubview:descriLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 136/2*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [cell addSubview:lineImageView];
    if ((int)indexPath.row==(data.count-1)) {
        lineImageView.hidden = YES;        
    }
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = FontUIColorGray;
    timeLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"srl_createdtime"] ];
    timeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    timeLabel.frame = CGRectMake(kScreenWidth-15-200*AUTO_SIZE_SCALE_X, numberLabel.frame.origin.y,200*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    [cell addSubview:timeLabel];
    }
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kEfficiencyListPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kEfficiencyListPage];
}
@end
