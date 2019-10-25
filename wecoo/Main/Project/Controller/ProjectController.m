//
//  ProjectController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ProjectController.h"
#import "UnlockClientListViewController.h"
#import "noContent.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "SearchViewController.h"

@interface ProjectController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,UIGestureRecognizerDelegate,MXPullDownMenuDelegate,searchSuccessDelegate>{
    MXPullDownMenu *menu;
    UITableView * myTableView;
    noWifiView * failView;
    noContent * nocontent;
    UILabel *titlelabel;
    NSMutableArray * projectListArray;
    NSMutableArray *menuArray;
    NSArray *sortedArray;
    int _pageForHot;
    int current_page;
    int total_count;
    NSString *project_sort;
    NSString *project_industry;
    NSMutableArray * recommendListArray;
    SearchBarEffectController *search;
    NSMutableArray *searchMenuArray;
}
@property (nonatomic,strong)UIButton *directButton;
@property (nonatomic,strong)UIView *searchButton;
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@end

@implementation ProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles =@"悬赏大厅";
    project_industry =@"";
    project_sort = @"5";
    projectListArray = [[NSMutableArray alloc] initWithCapacity:0];
    recommendListArray = [[NSMutableArray alloc] initWithCapacity:0];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight+50*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
//    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    
    
    [self loadData];
    
}

-(void)getIndustry{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    sortedArray = @[
                    @{@"code":@"5",
                      @"name":@"综合排序"},
                    @{@"code":@"6",
                      @"name":@"按上线时间"},
                    @{@"code":@"2",
                      @"name":@"按赏金"},
                    @{@"code":@"4",
                      @"name":@"按关注"},
                    ];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] GetLookupIndustryMapResult:dic viewController:self successData:^(NSDictionary *result){
        failView.hidden = YES;
        if(IsSucess(result)){
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if (![array isEqual:[NSNull null]] && (array.count>0)) {
                NSMutableArray *indusArray = [NSMutableArray arrayWithObject:
                                              @{
                                                @"code":@"",
                                                @"name":@"全部行业",
                                                @"icon_ios_2x":@"icon_classification_all"
                                                }
                                              ];
                [indusArray addObjectsFromArray:array];
                [menuArray addObject:sortedArray];
                [menuArray addObject:indusArray];
                if (searchMenuArray ==nil) {
                    searchMenuArray = [[NSMutableArray alloc] initWithCapacity:0];
                    [searchMenuArray addObject:sortedArray];
                    [searchMenuArray addObject:indusArray];
                }
                [self initMenu];
                [self initNavBarView];
                [self initTableView];
                [self loadlistData];
            }else{
                 failView.hidden = YES;
            }
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (void)reloadButtonClick:(UIButton *)sender{
    [self loadData];
}

-(void)loadData{
    [self getIndustry];
}

#pragma mark UITableView + 下拉刷新 默认
- (void)setTableHeader
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadlistData];
    }];
    
//    // 马上进入刷新状态
//    [myTableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 自定义刷新控件(自动回弹)
- (void)setTableFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    myTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshViewStart)];
}
-(void)loadlistData{
    [projectListArray removeAllObjects];
    current_page = 0;
    NSDictionary *dic = @{
                          @"_project_sort":project_sort,
                          @"_project_industry":project_industry,
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSimpleAppProjectDtosResult:dic viewController:self successData:^(NSDictionary *result){
//        [myTableView.head endRefreshing];
//        [myTableView.foot endRefreshing];
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [projectListArray addObjectsFromArray:array];

            }else{
            }
            failView.hidden = YES;
            [myTableView reloadData];
           
            if (projectListArray.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            if (projectListArray.count == total_count || projectListArray.count == 0) {
                [myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (projectListArray.count>0) {
                [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        failView.hidden = NO;
    }];

}

#pragma mark 刷新数据
-(void)refreshViewStart{
   
    current_page++;
 
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    
    //        NSString * pageOffset = @"20";
    
    NSDictionary *dic = @{
                          
                          @"_project_sort":project_sort,
                          @"_project_industry":project_industry,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSimpleAppProjectDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            NSLog(@"projectListArray----->%lu",(unsigned long)projectListArray.count);

            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [projectListArray addObjectsFromArray:array];
                
            }else{
                
            }
//            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
//                if (projectListArray.count>0) {
//                    nocontent.hidden = YES;
//                }else{
//                    nocontent.hidden = NO;
//                }
//            }
            failView.hidden = YES;
            [myTableView reloadData];
            [myTableView.mj_footer endRefreshing];

            
            if (projectListArray.count == total_count) {
                [myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    } failuer:^(NSError *error) {
        [myTableView.mj_footer endRefreshing];
        nocontent.hidden = YES;
        failView.hidden = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initMenu{
//    NSLog(@"menuArray------%@",menuArray);
    menu = [[MXPullDownMenu alloc] initWithArray:menuArray selectedColor:RedUIColorC1];
    menu.backgroundColor =UIColorFromRGB(0xFFFFFF);
    menu.delegate = self;
    menu.frame = CGRectMake(0, kNavHeight, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    [self.view addSubview:menu];
}

-(void)initNavBarView{
    [self.navView addSubview:self.searchButton];
//    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.navView.mas_bottom);
//        make.left.equalTo(self.navView.mas_left).offset(15);
//        
//    }];
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

-(void)initTableView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+50*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight-menu.frame.size.height)];
    [self setTableFooter];
    [self setTableHeader];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
//    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 140*AUTO_SIZE_SCALE_X;
    [self.view addSubview:myTableView];
   
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return projectListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (projectListArray.count > 0) {
        cell.backgroundColor = [UIColor clearColor];
        UIView *cellbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (130)*AUTO_SIZE_SCALE_X)];
        cellbackgroundView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [cell addSubview:cellbackgroundView];
        
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X)];
        imgV.layer.cornerRadius = 20;
        imgV.layer.borderWidth=1.0;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [UIColorFromRGB(0xEFEFEF) CGColor];
        imgV.layer.cornerRadius = 4;
        [imgV setImageWithURL:[NSURL URLWithString:[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_pic_square"]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
        imgV.backgroundColor =[UIColor clearColor];
        [cellbackgroundView addSubview:imgV];
        
        UILabel *celltitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125*AUTO_SIZE_SCALE_X, 15, 190*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X)];
        celltitleLabel.textColor = UIColorFromRGB(0x333333);
        celltitleLabel.text = [[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_name"];
        celltitleLabel.numberOfLines = 1;
        celltitleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [cellbackgroundView addSubview:celltitleLabel];
        UIImageView * FlagimgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-(15+35)*AUTO_SIZE_SCALE_X, 0, 35*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X)];
        [FlagimgV setImage:[UIImage imageNamed:@"bg_money_reward_hot_new"]];
        
        [cellbackgroundView addSubview:FlagimgV];
        FlagimgV.hidden = YES;
        int is_hot  = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"is_hot"] intValue];
        if (is_hot == 1) {
            FlagimgV.hidden = NO;
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
            FlagLabel.textColor =  UIColorFromRGB(0xFFFFFF);
            FlagLabel.text = @"热门";
            FlagLabel.textAlignment = NSTextAlignmentCenter;
            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
            [FlagimgV addSubview:FlagLabel];
        }
        
        int is_newest  = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"is_newest"] intValue];
        if (is_newest == 1) {
            FlagimgV.hidden = NO;
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
            FlagLabel.textColor = UIColorFromRGB(0xFFFFFF);
            FlagLabel.text = @"最新";
            FlagLabel.textAlignment = NSTextAlignmentCenter;
            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
            [FlagimgV addSubview:FlagLabel];
        }
        
        
       
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subLabel.textColor = UIColorFromRGB(0x999999);
        
        subLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, celltitleLabel.frame.origin.y+celltitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 0);
        subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        subLabel.textAlignment = NSTextAlignmentLeft;
        subLabel.numberOfLines = 0;
        subLabel.text =
//        @"签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金";
        [[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_slogan"];
        [subLabel sizeToFit];
        
        if(subLabel.frame.size.height > 50*AUTO_SIZE_SCALE_X){
            subLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, celltitleLabel.frame.origin.y+celltitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        }
        [cellbackgroundView addSubview:subLabel];
        
        UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10+imgV.frame.origin.x+imgV.frame.size.width, cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,117.5*AUTO_SIZE_SCALE_X ,21*AUTO_SIZE_SCALE_X)];
        int first = [[projectListArray[indexPath.row] objectForKey:@"project_commission_first"] intValue];
        int second = [[projectListArray[indexPath.row] objectForKey:@"project_commission_second"] intValue];
        NSString *str ;
        NSString *contentString;
        NSInteger index ;
        if (first==second) {
            str = [NSString stringWithFormat:@"%@",@"签约佣金"];
            index = [str length];
            contentString = [NSString stringWithFormat:@"%d",first];
        }else{
            str = [NSString stringWithFormat:@"%@",@"最高佣金"];
            index = [str length];
            int temp ;
            if(first > second){
                temp=first;
            }else{
                temp=second;
            }
            contentString = [NSString stringWithFormat:@"%d",temp];
        }
        
        [self returnlable:pricelabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"元"WithFontSize:15*AUTO_SIZE_SCALE_X];
        
        [cellbackgroundView addSubview:pricelabel];

        UILabel *numberlabel = [[UILabel alloc] init];
        [self returnlable:numberlabel WithString:[NSString stringWithFormat:@"%d",[[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_signed_count"] intValue]] Withindex:3 WithDocument:@"已签约" WithDoc1:@"单" WithFontSize:13*AUTO_SIZE_SCALE_X];
        [numberlabel setFrame:CGRectMake(kScreenWidth-numberlabel.width-15,
                                         cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, numberlabel.width,
                                         numberlabel.height)];
        [cellbackgroundView addSubview:numberlabel];
        
        
        
        //        [transView addSubview:titlelabel];
        //        titlelabel.textAlignment =NSTextAlignmentLeft;
        //    UIView *transView = [[UIView alloc] initWithFrame:CGRectMake(0, cellbackgroundView.frame.size.height-70*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X)];
        //    UIColor *colorOne = [UIColor clearColor];
        //    UIColor *colorTwo = [UIColor blackColor];
        //    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        //    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        //    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
        //    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        //
        //    //crate gradient layer
        //    CAGradientLayer *headerLayer = [CAGradientLayer layer];
        //
        //    headerLayer.colors = colors;
        //    headerLayer.locations = locations;
        //    headerLayer.frame = transView.bounds;
        //
        //    [transView.layer insertSublayer:headerLayer atIndex:0];
        
//        UIImageView *transView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellbackgroundView.frame.size.height-70*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X)];
//        transView.image = [UIImage imageNamed:@"cover-project"];
//        [cellbackgroundView addSubview:transView];
//        
//        titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, kScreenWidth-24, 20*AUTO_SIZE_SCALE_X)];
//        titlelabel.textColor =[UIColor whiteColor];
//        titlelabel.text =[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_slogan"];
//        titlelabel.numberOfLines = 1;
//        titlelabel.font = [UIFont systemFontOfSize:18*AUTO_SIZE_SCALE_X];
//        [transView addSubview:titlelabel];
//        titlelabel.textAlignment =NSTextAlignmentLeft;
//        
//        UILabel *imageview = [[UILabel alloc ] initWithFrame:CGRectMake(15, titlelabel.frame.size.height+titlelabel.frame.origin.y+8*AUTO_SIZE_SCALE_X, 77/2*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
//        imageview.backgroundColor = RedUIColorC1;
//        imageview.layer.cornerRadius = 5;
//        imageview.layer.masksToBounds = YES;
//        [transView addSubview:imageview];
//        imageview.textColor = [UIColor whiteColor];
//        imageview.textAlignment = NSTextAlignmentCenter;
//        imageview.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
//        imageview.text = @"赏金";
//        

    }
    
    return cell;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2 WithFontSize:(CGFloat)fontsize{
    
    label.numberOfLines = 1;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X],};
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    label.textColor =UIColorFromRGB(0x333333);
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
//    [mutablestr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(mutablestr.length-1,1)];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:kProjectListEvent label:[NSString stringWithFormat:@"%ld",[[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    
    DetailProjectViewController * vc = [[DetailProjectViewController alloc] init];
    vc.titles =[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_name"];
    vc.project_id = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}


// 实现代理.
#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row{
//    NSLog(@"%ld -- %ld", column, row);
    if (column ==0) {
        project_sort = [menuArray[column][row] objectForKey:@"code"];
    }
    if (column ==1) {
        project_industry = [menuArray[column][row] objectForKey:@"code"];
    }
    [self loadlistData];
}

- (UIView *)searchButton {
    if (_searchButton == nil) {
        self.searchButton = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
        self.searchButton.userInteractionEnabled = YES;
        self.searchButton.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * buttonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
        [self.searchButton addGestureRecognizer:buttonTap];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(15,10, 23, 23)];
        imv.image = [UIImage imageNamed:@"icon_header_search"];
        [self.searchButton addSubview:imv];
        [self.navView addSubview:self.searchButton];
    }
    return _searchButton;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"按行业推荐" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}

-(void)dButtonClick{
    [MobClick event:kDirectReportEvent];
    self.directButton.enabled = NO;
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] isReportAllowedResult :dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result)){
            int  Flag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            if (Flag == 1) {
                DirectReportViewController*vc = [[DirectReportViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        self.directButton.enabled = YES;
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.directButton.enabled = YES;
    }];
}

-(void)searchClick{
//    NSLog(@"search recommendListArray---------%d",recommendListArray.count);
//    NSLog(@"search searchMenuArray---------%d",searchMenuArray.count);
    [MobClick event:kSearchEvent];

    
    
    SearchViewController * vc = [[SearchViewController alloc] init];
    vc.searchMenuArray =searchMenuArray;
    vc.menuArray = menuArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap:(UITapGestureRecognizer*)tap{
    [search.searchBar resignFirstResponder];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kPageTwo];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kPageTwo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}


/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
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
