//
//  UnlockClientListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "UnlockClientListViewController.h"
#import "BaseTableView.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "noContent.h"

@interface UnlockClientListViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    NSMutableArray *data;
    UITableViewRowAction *deleteRowAction;
    NSString *_customer_islocked;
    int current_page;
    int total_count;
    noContent *nocontent;
}


@property (nonatomic,strong)UILabel *subtitleView;
@end

@implementation UnlockClientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [NSMutableArray arrayWithCapacity:0];

    [self.view addSubview:self.subtitleView];
    [self initTableView];
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    _customer_islocked =@"0";
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          
                          @"_customer_islocked":_customer_islocked,
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] GetsearchCustomerResult:dic viewController:self successData:^(NSDictionary *result){
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
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];

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
    
    //        NSString * pageOffset = @"20";
    _customer_islocked =@"0";
    NSDictionary *dic = @{
                          @"_customer_islocked":_customer_islocked,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] GetsearchCustomerResult:dic viewController:self successData:^(NSDictionary *result) {
        [refreshView endRefreshing];
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

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.subtitleView.frame.origin.y+self.subtitleView.frame.size.height, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.subtitleView.frame.size.height))];
    
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 50*AUTO_SIZE_SCALE_X;
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, self.subtitleView.frame.origin.y+self.subtitleView.frame.size.height, kScreenWidth, kScreenHeight-(self.navView.frame.size.height+self.subtitleView.frame.size.height))];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (void)reloadButtonClick:(UIButton *)sender {
    
    [self loadData];
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3*AUTO_SIZE_SCALE_X, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = FontUIColorGray;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"customer_name"];
    nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    [bgView addSubview:nameLabel];
    [cell addSubview:bgView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height, kScreenWidth, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [bgView addSubview:lineImageView];
    
    if ((int)indexPath.row==data.count-1) {
        lineImageView.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    
    [MobClick event:kSelectClientListEvent label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"customer_id"] integerValue]]];
    [self.delegate selectSuccessReturnReportPage: data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)subtitleView {
    if (_subtitleView == nil) {
        self.subtitleView = [CommentMethod initLabelWithText:@"被锁定的客户已帮您隐藏" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.subtitleView.backgroundColor = [UIColor clearColor];
        self.subtitleView.textColor = FontUIColorGray;
        self.subtitleView.frame = CGRectMake(15, kNavHeight, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
        
    }
    return _subtitleView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kUnlockClientListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kUnlockClientListPage];
}

@end
