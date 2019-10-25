//
//  MyProjectViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/24.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyProjectViewController.h"
#import "noContent.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "BaseTableView.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "loginenterpriseViewController.h"
#import "CheckListViewController.h"


@interface MyProjectViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,UIGestureRecognizerDelegate>{
    UITableView *myTableView;
    noWifiView *failView;
    noContent *nocontent;
    UILabel *titlelabel;
    NSMutableArray *projectListArray;
    NSMutableArray *menuArray;
    NSArray *sortedArray;
    int _pageForHot;
    int current_page;
    int total_count;
 
    
    
}
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@property (nonatomic,strong)UIButton *directButton;
@property (nonatomic,strong)UIView *rightButton;
@end

@implementation MyProjectViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self initNavBarView];
    [self initTableView];
    [self loadlistData];
    self.titles = @"我的项目";
    projectListArray = [[NSMutableArray alloc] initWithCapacity:0];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [nocontent.noContentLabel removeFromSuperview];
    UILabel *noContentLabel = [CommentMethod initLabelWithText:@"当前上线项目为空，您可以拨打客服电话，将会有专属客服为您创建项目" textAlignment:NSTextAlignmentCenter font:15*AUTO_SIZE_SCALE_X];
    noContentLabel.textColor = FontUIColorGray;
    noContentLabel.numberOfLines = 2;
    noContentLabel.frame = CGRectMake(40*AUTO_SIZE_SCALE_X, 244*AUTO_SIZE_SCALE_X, kScreenWidth-80*AUTO_SIZE_SCALE_X, 42*AUTO_SIZE_SCALE_X);
    [nocontent addSubview:noContentLabel];
    
    WPHotspotLabel *phoneLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectZero];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary* style3 = @{@"body" :
                                 @[[UIFont fontWithName:@"PingFangSC-Regular" size:13.0*AUTO_SIZE_SCALE_X],
                                   UIColorFromRGB(0x999999)],
                             @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                 NSLog(@"Help action");
                             }],
                             @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                 NSLog(@"Settings action");
                             }],
                             @"u": @[[UIFont fontWithName:@"Helvetica" size:13.0*AUTO_SIZE_SCALE_X],
                                     RedUIColorC1],
                             };
    
    phoneLabel.attributedText = [@"<body>拨打客服电话：<body><u>400-900-1135</u>" attributedStringWithStyleBook:style3];
    phoneLabel.frame = CGRectMake(0, kScreenHeight-21*AUTO_SIZE_SCALE_X-100*AUTO_SIZE_SCALE_X, kScreenWidth, 21*AUTO_SIZE_SCALE_X);
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallTaped:)];
    [phoneLabel addGestureRecognizer:tap1];
    phoneLabel.userInteractionEnabled = YES;
    [nocontent addSubview:phoneLabel];
    //    [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    
   
}

-(void)CallTaped:(UITapGestureRecognizer *)sender{
    //    self.phoneLabel.userInteractionEnabled = NO;
    //    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009001135"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
     
                             completionHandler:^(BOOL success) {
                                 
                                 //                       NSLog(@"Open  %d",success);
                                 
                             }];
}

- (void)reloadButtonClick:(UIButton *)sender{
    [self loadlistData];
}

-(void)loadlistData{
    [projectListArray removeAllObjects];
    current_page = 0;
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchMyProjectDtosResult:dic viewController:self successData:^(NSDictionary *result){
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
            failView.hidden = NO;
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
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] SearchMyProjectDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
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
        
//        [cellbackgroundView addSubview:FlagimgV];
//        FlagimgV.hidden = YES;
//        int is_hot  = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"is_hot"] intValue];
//        if (is_hot == 1) {
//            FlagimgV.hidden = NO;
//            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
//            FlagLabel.textColor =  UIColorFromRGB(0xFFFFFF);
//            FlagLabel.text = @"热门";
//            FlagLabel.textAlignment = NSTextAlignmentCenter;
//            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
//            [FlagimgV addSubview:FlagLabel];
//        }
//        
//        int is_newest  = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"is_newest"] intValue];
//        if (is_newest == 1) {
//            FlagimgV.hidden = NO;
//            UILabel *FlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5*AUTO_SIZE_SCALE_X, FlagimgV.frame.size.width, 16.5*AUTO_SIZE_SCALE_X)];
//            FlagLabel.textColor = UIColorFromRGB(0xFFFFFF);
//            FlagLabel.text = @"最新";
//            FlagLabel.textAlignment = NSTextAlignmentCenter;
//            FlagLabel.font = [UIFont systemFontOfSize:23/2*AUTO_SIZE_SCALE_X];
//            [FlagimgV addSubview:FlagLabel];
//        }
        
        
        
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subLabel.textColor = UIColorFromRGB(0x999999);
        
        subLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, celltitleLabel.frame.origin.y+celltitleLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 16.5 *AUTO_SIZE_SCALE_X);
        subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        subLabel.textAlignment = NSTextAlignmentLeft;
        
        subLabel.text =
        [[projectListArray objectAtIndex:indexPath.row] objectForKey:@"company_name"];
        
        
        [cellbackgroundView addSubview:subLabel];
        
        UILabel *identity = [[UILabel alloc] initWithFrame:CGRectZero];
        identity.textColor = UIColorFromRGB(0x666666);
        
        identity.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, subLabel.frame.origin.y+subLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 235*AUTO_SIZE_SCALE_X, 18.5 *AUTO_SIZE_SCALE_X);
        identity.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
        identity.textAlignment = NSTextAlignmentLeft;
        
        identity.text =
        //        @"签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金签约佣金";
        [NSString stringWithFormat:@"身份：%@",[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"projectManagerKindName"]];
        
        
        [cellbackgroundView addSubview:identity];
        
        UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10+imgV.frame.origin.x+imgV.frame.size.width, cellbackgroundView.frame.size.height-21*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,117.5*AUTO_SIZE_SCALE_X ,21*AUTO_SIZE_SCALE_X)];
//        int first = [[projectListArray[indexPath.row] objectForKey:@"project_commission_first"] intValue];
//        int second = [[projectListArray[indexPath.row] objectForKey:@"project_commission_second"] intValue];
        NSString *str ;
        NSString *contentString;
        NSInteger index ;
//        if (first==second) {
//            str = [NSString stringWithFormat:@"%@",@"签约佣金"];
//            index = [str length];
//            contentString = [NSString stringWithFormat:@"%d",first];
//        }else{
//            str = [NSString stringWithFormat:@"%@",@"最高佣金"];
//            index = [str length];
//            int temp ;
//            if(first > second){
//                temp=first;
//            }else{
//                temp=second;
//            }
//            contentString = [NSString stringWithFormat:@"%d",temp];
//        }
        
        int first = [[projectListArray[indexPath.row] objectForKey:@"reportNum"] intValue];
        str = [NSString stringWithFormat:@"%@",@"报备"];
        index = [str length];
        contentString = [NSString stringWithFormat:@"%d",first];
        [self returnlable:pricelabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"条"WithFontSize:15*AUTO_SIZE_SCALE_X];
        
        [cellbackgroundView addSubview:pricelabel];
        
        UILabel *numberlabel = [[UILabel alloc] init];
        
        [self returnlable:numberlabel WithString:[NSString stringWithFormat:@"%d",[[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"reportWaitingAuditingNum"] intValue]] Withindex:3 WithDocument:@"未审核" WithDoc1:@"条" WithFontSize:13*AUTO_SIZE_SCALE_X];
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
    [MobClick event:kMyEnterpriseProjectListEveryEvent label:[NSString stringWithFormat:@"%ld",[[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    CheckListViewController * vc = [[CheckListViewController alloc] init];
    vc.menuTag = 1;
    vc.project_id = [[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNavBarView{
    [self.navView addSubview:self.rightButton];

}


- (UIView *)rightButton {
    if (_rightButton == nil) {
        self.rightButton = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-35, 20, 35, 44)];
        self.rightButton.userInteractionEnabled = YES;
        self.rightButton.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * buttonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)];
        [self.rightButton addGestureRecognizer:buttonTap];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,12, 20, 20)];
        imv.image = [UIImage imageNamed:@"icon_my_project_pc"];
        [self.rightButton addSubview:imv];
        [self.navView addSubview:self.rightButton];
    }
    return _rightButton;
}

-(void)initTableView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
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

-(void)rightClick{

    [MobClick event:kMyProjectPCEvent];
    
    
    loginenterpriseViewController * vc = [[loginenterpriseViewController alloc] init];

        [self.navigationController pushViewController:vc animated:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFromtEnterprisePage == 1) {
        [self cancelSideBack];
    }
    
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

-(void)backAction
{
    //    if (self.isBackFromOrderPay) {
    //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"本次订单还未付款,返回后将退出当前界面，您可在我的订单中继续操作此订单，是否退出当前界面" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    //        alert.tag = 1001;
    //        [alert show];
    ////        [self.navigationController popToRootViewControllerAnimated:YES];
    //
    //        return;
    //    }
    if (self.isFromtEnterprisePage) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
