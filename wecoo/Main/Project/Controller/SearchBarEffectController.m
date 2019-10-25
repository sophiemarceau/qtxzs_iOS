//
//  SearchBarEffectController.m
//  微信搜索模糊效果
//
//  Created by MAC on 17/4/1.
//  Copyright © 2017年 MyanmaPlatform. All rights reserved.
//

#import "SearchBarEffectController.h"
#import "Masonry.h"
#import "noContent.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"
#import "MXPullDownMenu.h"
#import "UIImageView+WebCache.h"
#import "DetailProjectViewController.h"

#define kWindow [UIApplication sharedApplication].keyWindow
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface SearchBarEffectController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MXPullDownMenuDelegate>{
    MXPullDownMenu *menu;
    noWifiView * failView;
    noContent * nocontent;    
    NSArray *sortedArray;
    int _pageForHot;
    int current_page;
    int total_count;
    NSString *project_sort;
    NSString *project_industry;
    NSMutableArray *menuListData;
}

@property(nonatomic , strong)UIView * HeaderView;
@property(nonatomic , strong)UIView * backView;
@property(nonatomic , strong)UIView * headView;
@property(nonatomic , strong)UILabel * headerLabel;

@end

@implementation SearchBarEffectController
static NSString * const searchCell= @"searchCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        [self setUpSearch];
        project_industry =@"";
        project_sort = @"5";
        self.ListArray =[NSMutableArray arrayWithCapacity:0];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:khiddenKeyboard object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserInfo) name:khiddenKeyboard object:nil];
    }
    return self;
}

- (void)setUpSearch
{
    [self addSubview:self.headView];
    self.backView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self addSubview:self.searchBar];
    [self addSubview:self.backView];
//    [self addSubview:self.HeaderView];
//    self.HeaderView.frame = CGRectMake(0, self.searchBar.frame.origin.y+self.searchBar.frame.size.height, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH-self.searchBar.frame.origin.y-self.searchBar.frame.size.height);
    }];
    [_backView addSubview:self.tableView];
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenH-self.searchBar.frame.origin.y-self.searchBar.frame.size.height);
       //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self loadTop5Data];
}

- (void)reloadButtonClick:(UIButton *)sender{
    [self loadlistData];
}

#pragma mark tableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ListArray.count;
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
    if (self.ListArray.count > 0) {
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
        [imgV setImageWithURL:[NSURL URLWithString:[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_pic_square"]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
        imgV.backgroundColor =[UIColor clearColor];
        [cellbackgroundView addSubview:imgV];
        UILabel *celltitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125*AUTO_SIZE_SCALE_X, 15, 190*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X)];
        celltitleLabel.textColor = UIColorFromRGB(0x333333);
        celltitleLabel.text = [[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_name"];
        celltitleLabel.numberOfLines = 1;
        celltitleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [cellbackgroundView addSubview:celltitleLabel];
        UIImageView * FlagimgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-(15+35)*AUTO_SIZE_SCALE_X, 0, 35*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X)];
        [FlagimgV setImage:[UIImage imageNamed:@"bg_money_reward_hot_new"]];
        
        [cellbackgroundView addSubview:FlagimgV];
        FlagimgV.hidden = YES;
        int is_hot  = [[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"is_hot"] intValue];
        if (is_hot == 1) {
            FlagimgV.hidden = NO;
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
            FlagLabel.textColor =  UIColorFromRGB(0xFFFFFF);
            FlagLabel.text = @"热门";
            FlagLabel.textAlignment = NSTextAlignmentCenter;
            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
            [FlagimgV addSubview:FlagLabel];
        }
        
        int is_newest  = [[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"is_newest"] intValue];
        if (is_newest == 1) {
            FlagimgV.hidden = NO;
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
            FlagLabel.textColor = UIColorFromRGB(0xFFFFFF);
            FlagLabel.text = @"最新";
            FlagLabel.textAlignment = NSTextAlignmentCenter;
            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
            [FlagimgV addSubview:FlagLabel];
        }
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(125*AUTO_SIZE_SCALE_X, celltitleLabel.frame.origin.y+celltitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
        subLabel.textColor = UIColorFromRGB(0x999999);
        subLabel.text =[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_slogan"];
        subLabel.numberOfLines = 3;
        subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        [cellbackgroundView addSubview:subLabel];
        
        UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10+imgV.frame.origin.x+imgV.frame.size.width, cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,117.5*AUTO_SIZE_SCALE_X ,21*AUTO_SIZE_SCALE_X)];
        int first = [[self.ListArray[indexPath.row] objectForKey:@"project_commission_first"] intValue];
        int second = [[self.ListArray[indexPath.row] objectForKey:@"project_commission_second"] intValue];
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
        
        [self returnlable:pricelabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"元"];
        
        [cellbackgroundView addSubview:pricelabel];
        
        UILabel *numberlabel = [[UILabel alloc] init];
        [self returnlable:numberlabel WithString:[NSString stringWithFormat:@"%d",[[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_signed_count"] intValue]] Withindex:3 WithDocument:@"已签约" WithDoc1:@"单"];
        [numberlabel setFrame:CGRectMake(kScreenWidth-numberlabel.width-15,
                                         cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, numberlabel.width,
                                         numberlabel.height)];
        [cellbackgroundView addSubview:numberlabel];
    }
    return cell;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    label.numberOfLines = 1;
    //    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X],};
    label.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
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
    [MobClick event:kProjectListEvent label:[NSString stringWithFormat:@"%ld",[[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    [self.delegate addSuccessReturnClientPage:[self.ListArray objectAtIndex:indexPath.row]];
    [self hidden];
}

// 实现代理.
#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row{
    
    
    if (column ==0) {
        project_sort = [menuListData[column][row] objectForKey:@"code"];
    }
    
    if (column ==1) {
        
        project_industry = [menuListData[column][row] objectForKey:@"code"];
    }
    [self loadlistData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
//    [self filterContentForSearchText:searchText scope:self.searchBar.scopeButtonTitles[1]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if(searchBar.text.length>10){
        [self makeToast:@"您输入的项目名称，不能超过10个字 请您重新输入" duration:2.8 position:@"center"];
        return;
    }
    if (menu.hidden) {
        menu.hidden = NO;
        
        menu.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);

        _tableView.frame = CGRectMake(0, menu.frame.origin.y+menu.frame.size.height, kScreenWidth, self.backView.frame.size.height-menu.frame.size.height);
        nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height)];
        //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nocontent.hidden = YES;
        [_tableView addSubview:nocontent];
    }
    [self loadlistData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hidden];
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//    NSMutableArray *tempResults = [NSMutableArray array];
//    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//    
//    for (int i = 0; i < self.effectArray.count; i++) {
//        
//        NSString * storeString = self.effectArray[i];
//        NSRange storeRange = NSMakeRange(0, storeString.length);
//        
//        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
//        
//        if (foundRange.length) {
//            
//            NSDictionary *dic=@{@"nickName":storeString};
//            [tempResults addObject:dic];
//        }
//    }
//    [self.projectListArray removeAllObjects];
//    [self.projectListArray addObjectsFromArray:tempResults];
//    [self.tableView reloadData];
//}

-(void)initMenu:(NSMutableArray *)menuArray{
     
    menuListData = menuArray;
    menu = [[MXPullDownMenu alloc] initWithArray:menuArray selectedColor:RedUIColorC1];
    menu.backgroundColor = UIColorFromRGB(0xFFFFFF);
    menu.delegate = self;

    [self.backView addSubview:menu];
    menu.hidden =  YES;
}



-(void)loadlistData{
//    if(self.searchBar.text.length>10 || self.searchBar.text.length==0){
////        [self makeToast:@"您输入的项目名称，不能超过10个字 请您重新输入" duration:2.8 position:@"center"];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        return;
//    }
    [self.ListArray removeAllObjects];
    current_page = 0;
     NSLog(@"dic-----searchBar---->%@",[NSString stringWithFormat:@"%@",self.searchBar.text]);
     NSLog(@"dic------project_sort--->%@",project_sort);
     NSLog(@"dic-----project_industry---->%@",project_industry);
    NSDictionary *dic = @{
                          @"_name": [NSString stringWithFormat:@"%@",self.searchBar.text],
                          @"_project_sort":project_sort,
                          @"_project_industry":project_industry,
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    NSLog(@"dic--------->%@",dic);
    [[RequestManager shareRequestManager] SearchSimpleAppProjectDtosResult:dic viewController:nil successData:^(NSDictionary *result){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.ListArray addObjectsFromArray:array];
            }else{
            }
            failView.hidden = YES;
            
            if (self.ListArray.count>0) {
                nocontent.hidden = YES;
                
            }else{
                nocontent.hidden = NO;
                
            }
            if (self.ListArray.count == total_count || self.ListArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.ListArray.count > 0) {
                NSString *str ;
                NSString *contentString;
                NSInteger index ;
                str = [NSString stringWithFormat:@"%@%ld条“",@"搜索到",self.ListArray.count];
                index = [str length];
                contentString = [NSString stringWithFormat:@"%@",self.searchBar.text];
                [self returnlable:self.headerLabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"“的相关数据"];
            }
            if([self.searchBar.text isEqualToString:@""]){                
                self.tableView.tableHeaderView.hidden = YES;
                self.HeaderView.frame = CGRectMake(0, 0, 0, 0);
            }else{
                self.tableView.tableHeaderView.hidden = NO;
                self.HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
            }
            [self.tableView reloadData];
        }else{
            [self makeToast:[result objectForKey:@"msg"] duration:2.8 position:@"center"];
            
        }
    }failuer:^(NSError *error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self makeToast:@"网络加载失败,请重试" duration:2.8 position:@"center"];
        
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        failView.hidden = NO;
    }];
    
}

#pragma mark 刷新数据
-(void)refreshViewStart{
    if(self.searchBar.text.length>10 || self.searchBar.text.length==0){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    current_page++;
    
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    
    //        NSString * pageOffset = @"20";
    
    NSDictionary *dic = @{
                          
                          @"_project_sort":project_sort,
                          @"_project_industry":project_industry,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSimpleAppProjectDtosResult:dic viewController:nil successData:^(NSDictionary *result) {
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.ListArray addObjectsFromArray:array];
                
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
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (self.ListArray.count == total_count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self makeToast:[result objectForKey:@"msg"] duration:2.8 position:@"center"];
        }
    } failuer:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        nocontent.hidden = YES;
        failView.hidden = NO;
        [self makeToast:@"网络加载失败,请重试" duration:2.8 position:@"center"];
    }];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 20, kScreenW, 44);
        [_searchBar sizeToFit];
        [_searchBar setPlaceholder:@"请输入项目名称，不超过10个字"];
        [_searchBar setDelegate:self];
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
        [_searchBar setTranslucent:NO];//设置是否透明
        [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
        [_searchBar setShowsCancelButton:YES];
        _searchBar.tintColor = RedUIColorC1;
        _searchBar.backgroundColor = [UIColor redColor];
        for(id cc in [_searchBar.subviews[0] subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            }
        }
        UIImage* searchBarBg = [self GetImageWithColor:RedUIColorC1 andHeight:44];
        //设置背景图片
        [_searchBar setBackgroundImage:searchBarBg];
        //设置背景色
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        //设置文本框背景
//        [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    }
    return _searchBar;
}

-(UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = BGColorGray;
    }
    return  _backView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
         _tableView.tableHeaderView =self.HeaderView;
        
//        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+50*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight-menu.frame.size.height)];
        [self setTableFooter];
        [self setTableHeader];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 140*AUTO_SIZE_SCALE_X;
        _tableView.userInteractionEnabled = YES;
        
        
    }
    return _tableView;
}



- (UIView *)HeaderView {
    if (_HeaderView == nil) {
        self.HeaderView = [UIView new];
        self.HeaderView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
        [self.HeaderView addSubview:self.headerLabel];
    }
    return _HeaderView;
}

#pragma mark UITableView + 下拉刷新 默认
- (void)setTableHeader
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadlistData];
    }];
    //    // 马上进入刷新状态
    //    [myTableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 自定义刷新控件(自动回弹)
- (void)setTableFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshViewStart)];
}

//- (void)setEffectArray:(NSArray *)effectArray
//{
//    _effectArray = effectArray;
//}

//- (NSMutableArray *)projectListArray
//{
//    if (_projectListArray == nil) {
//        _projectListArray = [NSMutableArray array];
//    }
//    return _projectListArray;
//}

-(void)loadTop5Data{
    
    NSDictionary *dic = @{
                          @"_project_sort":@"5",
                          @"_project_industry":@"",
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchSimpleAppProjectDtosResult:dic viewController:nil successData:^(NSDictionary *result){
        
            if(IsSucess(result)){
                NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil ){
                    if (array.count>5) {
                        for (int i = 0; i< 5; i++) {
                            [self.ListArray addObject:array[i]];
                            self.tableView.tableHeaderView.hidden = NO;
                        }
                    }else{
                        self.tableView.tableHeaderView.hidden = YES;
                    }
                }else{
                self.tableView.tableHeaderView.hidden = YES;
                }
            [self.tableView reloadData];
        }else{
            self.tableView.tableHeaderView.hidden = YES;
        }
    }failuer:^(NSError *error){
        self.tableView.tableHeaderView.hidden = YES;
    }];
}

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc]init];
        _headView.frame = CGRectMake(0, 0, kScreenW, 20);
        _headView.backgroundColor = RedUIColorC1;
    }
    return _headView;
}

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        self.headerLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.headerLabel.textColor = FontUIColorGray;
        self.headerLabel.frame = CGRectMake(15, 10*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
//        [self.headerLabel sizeToFit];
//        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height, kScreenWidth, 0.5)];
//        lineImageView.backgroundColor = lineImageColor;
//        [bgView addSubview:lineImageView];
    }
    return _headerLabel;
}

-(void)setMenuArray:(NSMutableArray *)menuArray{
    
    [self initMenu:menuArray];
}


- (void)hidden
{
    [self removeFromSuperview];
}

- (void)show
{
    [UIView transitionWithView:kWindow duration:0.35 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [kWindow addSubview:self];
        
    } completion:^(BOOL finished) {
        finished = NO;
        [self.searchBar becomeFirstResponder];
       
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)changeUserInfo{
    
    [self.searchBar resignFirstResponder];
}
@end
