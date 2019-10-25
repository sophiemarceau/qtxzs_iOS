//
//  ActivityListViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/1.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ActivityListViewController.h"
#import "BaseTableView.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "ActivityDetailViewController.h"
#import "noContent.h"

@interface ActivityListViewController ()<menuViewDelegate,UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent *nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;
    NSString *activity_status;
}
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initdata];
    [self loadData];
    [self.view addSubview:self.menuView];
    [self initTableView];
    
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
    [self loadData];
}


-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    activity_status = @"1";
    current_page = 0;
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [data removeAllObjects];
    NSDictionary *dic = @{
                          
                          @"activity_status":activity_status,
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };

    [[RequestManager shareRequestManager] SearchActivityDtos4ShowResult:dic viewController:self successData:^(NSDictionary *result){
        
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
            if (data.count == total_count || total_count == 0) {
                [myTableView.foot finishRefreshing];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
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
    
    NSDictionary *dic = @{
                          
                          @"activity_status":activity_status,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchActivityDtos4ShowResult:dic viewController:self successData:^(NSDictionary *result) {
        
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



-(void)menuViewDidSelect:(NSInteger)number{
    self.menuTag = [NSString stringWithFormat:@"%ld",(long)number];
    
    activity_status = [NSString stringWithFormat:@"%ld",(long)number];
    
    NSLog(@"activity_status---%ld",number);
//    _customer_islocked  = [NSString stringWithFormat:@"%ld",(long)number-2];
//    NSLog(@"menuViewDidSelect---%@",_customer_islocked);
    if(number==2){
        [MobClick event:kActivityHistroy];
        activity_status = @"3";
    }
    [self loadData];
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, self.menuView.frame.origin.y+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(kNavHeight+self.menuView.frame.size.height+10*AUTO_SIZE_SCALE_X))];
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 62*AUTO_SIZE_SCALE_X;
    
    [self.view addSubview:myTableView];
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"ndexPath.row -- %ld",(long)data.count);
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
    if (data.count > 0 ) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 62*AUTO_SIZE_SCALE_X)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-15-7*AUTO_SIZE_SCALE_X-15, 14*AUTO_SIZE_SCALE_X)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = FontUIColorBlack;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"activity_name"];
        nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [bgView addSubview:nameLabel];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,nameLabel.frame.origin.y+nameLabel.frame.size.height + 15/2*AUTO_SIZE_SCALE_X, kScreenWidth/2, 11*AUTO_SIZE_SCALE_X)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = FontUIColorGray;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"activity_createdtime"];
        dateLabel.font = [UIFont systemFontOfSize:11*AUTO_SIZE_SCALE_X];
        [bgView addSubview:dateLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, 18*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        [bgView addSubview:arrowImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height-1, kScreenWidth-15, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [bgView addSubview:lineImageView];
        
        if ((int)indexPath.row==(data.count-1)) {
            lineImageView.hidden = YES;
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([activity_status isEqualToString:@"3"]) {
        [MobClick event:kActivityHistroyDetail label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"activity_id"] integerValue]]];

    }else{
        [MobClick event:kActivityDetail label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"activity_id"] integerValue]]];

    }
    
//    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
    int tempid = [[data[indexPath.row] objectForKey:@"activity_id"] intValue];
    vc.activity_id = tempid;
    vc.titles = @"奖励活动";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kActivityPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kActivityPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (menuVIew *)menuView {
    if (_menuView == nil) {
        self.menuView = [[menuVIew alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.menuView.isNotification = YES;
        self.menuView.delegate = self;
        self.menuView.menuArray = @[@"进行中", @"历史活动"];
    }
    return _menuView;
}



@end
