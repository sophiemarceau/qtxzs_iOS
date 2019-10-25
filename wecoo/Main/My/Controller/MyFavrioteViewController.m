//
//  MyFavrioteViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/26.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyFavrioteViewController.h"
#import "noContent.h"
#import "DetailProjectViewController.h"

@interface MyFavrioteViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView *failView;
    noContent *nocontent;
    NSMutableArray *data;
    UITableViewRowAction *deleteRowAction;
    favoriteTableViewCell *cell;
    
//    int flagIndex;
    int current_page;
    int total_count;
}

@end

@implementation MyFavrioteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initdata];
    [self loadData];
    
    
    [self initTableView];
    
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

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];

}


-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 107*AUTO_SIZE_SCALE_X+1;
    [self.view addSubview:myTableView];
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
    
    [[RequestManager shareRequestManager] SearchProjectCollectionRecordDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
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
            if (data.count ==total_count) {
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
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    
    
    //        NSString * pageOffset = @"20";
    
    NSDictionary *dic = @{
                          
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    
    [[RequestManager shareRequestManager] SearchProjectCollectionRecordDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        
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

#pragma mark tableView代理
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了取消删除");
        NSDictionary *dic = @{
                              
                              @"pcr_id":[data[indexPath.row] objectForKey:@"pcr_id"],
                              };
        
        [[RequestManager shareRequestManager] CancelProjectCollectionRecordResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                Boolean flag = [[[result objectForKey:@"data"] objectForKey:@"result"] boolValue];
                if (flag) {
                    [self loadData];
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
        
    }];
    
    deleteRowAction.backgroundColor = RedUIColorC1;
    return @[deleteRowAction];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"favoriteTableViewCell";
    cell =(favoriteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell = [[favoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTag:[indexPath row]];
    }
    cell.celldata = data[indexPath.row];
    [cell insertData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    [MobClick event:kMyCollectListSelectOnclick label:[NSString stringWithFormat:@"%ld",[[[data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    if ( [[[data objectAtIndex:indexPath.row] objectForKey:@"project_status"] intValue]==1) {
        DetailProjectViewController *vc = [[DetailProjectViewController alloc] init];
        vc.titles =[[data objectAtIndex:indexPath.row] objectForKey:@"project_name"];
        vc.project_id = [[[data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       [[RequestManager shareRequestManager] tipAlert:@"您关注的项目已过期" viewController:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyCollectListPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyCollectListPage];
}



@end
