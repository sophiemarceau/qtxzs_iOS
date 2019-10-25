//
//  SearchViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/19.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchBarEffectController.h"
#import "DetailProjectViewController.h"
#import "Masonry.h"
#import "noContent.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"
#import "MXPullDownMenu.h"
#import "UIImageView+WebCache.h"
#import "DetailProjectViewController.h"

static NSString * const searchCell= @"searchCell";
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MXPullDownMenuDelegate>{
//    SearchBarEffectController *search;

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
    int suggestFlag;
}

@property(nonatomic , strong)UIView * HeaderView;
@property(nonatomic , strong)UIView * backView;
@property(nonatomic , strong)UIView * headView;
@property(nonatomic , strong)UILabel * headerLabel;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    suggestFlag = 1;
    UIView *arrrow = self.navView.subviews[1];
    arrrow.hidden = YES;
//    search = [[SearchBarEffectController alloc]init];
//    search.delegate = self;
//    search.menuArray = self.searchMenuArray;
//    [search show];
    self.view.backgroundColor = BGColorGray;
    
    [self setUpSearch];
    project_industry =@"";
    project_sort = @"5";
    self.ListArray =[NSMutableArray arrayWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:khiddenKeyboard object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserInfo) name:khiddenKeyboard object:nil];
}

- (void)setUpSearch
{
    
    self.backView.userInteractionEnabled = YES;
    
    [self.navView addSubview:self.searchBar];
    [self.view addSubview:self.backView];
    
//    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.searchBar.mas_bottom);
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(kScreenHeight-kNavHeight);
//    }];
    _backView.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight);
    [_backView addSubview:self.HeaderView];
    self.HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
    
    [_backView addSubview:self.tableView];
    _tableView.frame = CGRectMake(0, self.HeaderView.frame.origin.y+self.HeaderView.frame.size.height, kScreenWidth, _backView.frame.size.height-(self.HeaderView.frame.origin.y+self.HeaderView.frame.size.height));
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height)];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.searchBar becomeFirstResponder];
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
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
            FlagLabel.textColor =  UIColorFromRGB(0xFFFFFF);
            FlagLabel.text = @"热门";
            FlagLabel.textAlignment = NSTextAlignmentCenter;
            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
            [FlagimgV addSubview:FlagLabel];
        }
        
        int is_newest  = [[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"is_newest"] intValue];
        if (is_newest == 1) {
            FlagimgV.hidden = NO;
            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
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
        [[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_slogan"];
        [subLabel sizeToFit];
        
        if(subLabel.frame.size.height > 50*AUTO_SIZE_SCALE_X){
            subLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, celltitleLabel.frame.origin.y+celltitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        }
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
        
        [self returnlable:pricelabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"元" WithFontSize:15*AUTO_SIZE_SCALE_X];
        
        [cellbackgroundView addSubview:pricelabel];
        
        UILabel *numberlabel = [[UILabel alloc] init];
        [self returnlable:numberlabel WithString:[NSString stringWithFormat:@"%d",[[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_signed_count"] intValue]] Withindex:3 WithDocument:@"已签约" WithDoc1:@"单" WithFontSize:13*AUTO_SIZE_SCALE_X];
        [numberlabel setFrame:CGRectMake(kScreenWidth-numberlabel.width-15,
                                         cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, numberlabel.width,
                                         numberlabel.height)];
        [cellbackgroundView addSubview:numberlabel];
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
    [MobClick event:kProjectListEvent label:[NSString stringWithFormat:@"%ld",[[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
        DetailProjectViewController * vc = [[DetailProjectViewController alloc] init];
        vc.titles =[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_name"];
        vc.project_id = [[[self.ListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
//    [self hidden];
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

        [[RequestManager shareRequestManager] tipAlert:@"您输入的项目名称，不能超过10个字 请您重新输入" viewController:self];
        return;
    }
    if (menu.hidden) {
        menu.hidden = NO;
        
        menu.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
        self.HeaderView.frame = CGRectMake(0, menu.frame.size.height, kScreenWidth, self.HeaderView.frame.size.height);
        _tableView.frame = CGRectMake(0, self.HeaderView.origin.y+self.HeaderView.frame.size.height, kScreenWidth, self.backView.frame.size.height-(self.HeaderView.origin.y+self.HeaderView.frame.size.height));
        nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height)];
        //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nocontent.hidden = YES;
        [_tableView addSubview:nocontent];
    }
    [self loadlistData];
    [self searchBarResignAndChangeUI];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hidden];
}

//2、UISearchBar结束编辑

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [self searchBarResignAndChangeUI];
    
}

//searchBarResignAndChangeUI方法的实现如下：

- (void)searchBarResignAndChangeUI{
    
    [_searchBar resignFirstResponder];//失去第一响应
    
    [self changeSearchBarCancelBtnTitleColor:_searchBar];//改变布局
    
}



#pragma mark - 遍历改变搜索框 取消按钮的文字颜色
- (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
    
    if (view) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *getBtn = (UIButton *)view;
            
            [getBtn setEnabled:YES];//设置可用
            
            [getBtn setUserInteractionEnabled:YES];
            
            //设置取消按钮字体的颜色“#0374f2”
            
            [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateReserved];
            
            [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            
            return;
            
        }else{
            
            for (UIView *subView in view.subviews) {
                
                [self changeSearchBarCancelBtnTitleColor:subView];
                
            }
            
        }
        
    }else{
        
        return;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initMenu:(NSMutableArray *)menuArray{
    
    menuListData = menuArray;
    menu = [[MXPullDownMenu alloc] initWithArray:menuArray selectedColor:RedUIColorC1];
    menu.backgroundColor = UIColorFromRGB(0xFFFFFF);
    menu.delegate = self;
    
    [self.backView addSubview:menu];
    menu.hidden =  YES;
}


-(void)loadlistData{
    if (self.searchBar.text.length>0 &&[self.headerLabel.text isEqualToString:@"推荐项目"]) {
        suggestFlag = 0;
    }
    
    if(self.searchBar.text.length>10){
        [[RequestManager shareRequestManager] tipAlert:@"您输入的项目名称，不能超过10个字 请您重新输入" viewController:self];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (suggestFlag ==1) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
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
            
            NSString *str ;
            NSString *contentString;
            NSInteger index ;
            str = [NSString stringWithFormat:@"%@%d条“",@"搜索到",total_count];
            index = [str length];
            contentString = [NSString stringWithFormat:@"%@",self.searchBar.text];
            [self returnlable:self.headerLabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"“的相关数据" WithFontSize:14*AUTO_SIZE_SCALE_X];
            

            if([self.searchBar.text isEqualToString:@""]){
                self.HeaderView.hidden = YES;
                self.HeaderView.frame = CGRectMake(0, self.HeaderView.origin.y, 0, 0);
                
            }else{
                self.HeaderView.hidden = NO;
                self.HeaderView.frame = CGRectMake(0, self.HeaderView.origin.y, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
            }
            _tableView.frame = CGRectMake(0, self.HeaderView.origin.y+self.HeaderView.frame.size.height, kScreenWidth, self.backView.frame.size.height-(self.HeaderView.origin.y+self.HeaderView.frame.size.height));
            nocontent.frame =CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height);
            
            [self.tableView reloadData];
            if(self.ListArray.count>0){
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

        }else{

            [[RequestManager shareRequestManager] resultFail:result viewController:self];
            
        }
    }failuer:^(NSError *error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        failView.hidden = NO;
    }];
    
}

#pragma mark 刷新数据
-(void)refreshViewStart{
    if (self.searchBar.text.length>0 &&[self.headerLabel.text isEqualToString:@"推荐项目"]) {
        suggestFlag = 0;
    }
    if (suggestFlag ==1) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
//    if(self.searchBar.text.length>10 || self.searchBar.text.length==0){
//        
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        return;
//    }else{
//        if([self.headerLabel.text isEqualToString:@"推荐项目"] && self.searchBar.text.length > 0){
//            [self.ListArray removeAllObjects];
//        }
//    }
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
            if (menu.hidden) {
                menu.hidden = NO;
                
                menu.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
                self.HeaderView.frame = CGRectMake(0, menu.frame.size.height, kScreenWidth, self.HeaderView.frame.size.height);
                _tableView.frame = CGRectMake(0, self.HeaderView.origin.y+self.HeaderView.frame.size.height, kScreenWidth, self.backView.frame.size.height-(self.HeaderView.origin.y+self.HeaderView.frame.size.height));
                nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height)];
                //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                nocontent.hidden = YES;
                [_tableView addSubview:nocontent];
            }
            if([self.searchBar.text isEqualToString:@""]){
                self.HeaderView.hidden = YES;
                self.HeaderView.frame = CGRectMake(0, self.HeaderView.origin.y, 0, 0);
                
            }else{
                self.HeaderView.hidden = NO;
                self.HeaderView.frame = CGRectMake(0, self.HeaderView.origin.y, kScreenWidth, 30*AUTO_SIZE_SCALE_X);
            }
            _tableView.frame = CGRectMake(0, self.HeaderView.origin.y+self.HeaderView.frame.size.height, kScreenWidth, self.backView.frame.size.height-(self.HeaderView.origin.y+self.HeaderView.frame.size.height));
            nocontent.frame =CGRectMake(0, 0,  _tableView.frame.size.width, _tableView.frame.size.height);

            NSString *str ;
            NSString *contentString;
            NSInteger index ;
            str = [NSString stringWithFormat:@"%@%d条“",@"搜索到",total_count];
            index = [str length];
            contentString = [NSString stringWithFormat:@"%@",self.searchBar.text];
            [self returnlable:self.headerLabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"“的相关数据" WithFontSize:14*AUTO_SIZE_SCALE_X];

            failView.hidden = YES;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (self.ListArray.count == total_count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            
            
        }else{
            
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    } failuer:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        nocontent.hidden = YES;
        failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
//        _tableView.tableHeaderView =self.HeaderView;
        
        //        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+50*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight-menu.frame.size.height)];
        [self setTableFooter];
        [self setTableHeader];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BGColorGray;
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
                        self.HeaderView.hidden = NO;
                    }
                }else{
                    self.HeaderView.hidden = YES;
                }
            }else{
                self.HeaderView.hidden = YES;
            }
            self.headerLabel.text = @"推荐项目";
            [self.tableView reloadData];
        }else{
            self.HeaderView.hidden = YES;
        }
    }failuer:^(NSError *error){
        self.HeaderView.hidden = YES;
    }];
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = BGColorGray;
    }
    return  _backView;
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
//    [self removeFromSuperview];
     [self.navigationController popViewControllerAnimated:YES];
}
//
//- (void)show
//{
//    [UIView transitionWithView:kWindow duration:0.35 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [kWindow addSubview:self];
//        
//    } completion:^(BOOL finished) {
//        finished = NO;
//        [self.searchBar becomeFirstResponder];
//        
//    }];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)changeUserInfo{
    
    [self.searchBar resignFirstResponder];
}






@end
