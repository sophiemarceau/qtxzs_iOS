//
//  ProjectController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ProjectController.h"

@interface ProjectController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate,MXPullDownMenuDelegate>{
    MXPullDownMenu *menu;
    BaseTableView * myTableView;
    noWifiView * failView;
    UILabel *titlelabel;
    NSMutableArray * projectListArray;
    int _pageForHot;
    
   NSMutableArray *menuArray;
   NSMutableArray *tittleArray;

}
@property (nonatomic,strong)UIButton *directButton;
@end

@implementation ProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    projectListArray = [[NSMutableArray alloc] initWithCapacity:0];
    [projectListArray addObject:@"1"];
    [projectListArray addObject:@"2"];
    menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    [menuArray addObjectsFromArray:@[ @[ @"默认排序", @"智能排序", @"最大佣金", @"成单数量", @"按关注度"],
                                     @[@"全部品类", @"餐饮小吃",@"服装鞋帽"],
                                     ]];
    tittleArray =  [[NSMutableArray alloc] initWithCapacity:0];
    
    self.titles =@"招商项目";
    [self initNavBarView];
    [self initMenu];
    [self initTableView];

    
}

-(void)initNavBarView{

    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom);
        make.right.equalTo(self.navView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(65*AUTO_SIZE_SCALE_X, navBtnHeight));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initMenu
{
    menu = [[MXPullDownMenu alloc] initWithArray:menuArray selectedColor:[UIColor redColor]];
    
    
    menu.backgroundColor =UIColorFromRGB(0xFFFFFF);
    menu.delegate = self;
    menu.frame = CGRectMake(0, kNavHeight, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    
    [self.view addSubview:menu];
    
}

-(void)initTableView
{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+50*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kTabHeight-kNavHeight-menu.frame.size.height)];
    myTableView.backgroundColor = [UIColor redColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = (175+10)*AUTO_SIZE_SCALE_X;
    
    [self.view addSubview:myTableView];
    //加载数据失败时显示
//    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
//    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    failView.hidden = YES;
//    [self.view addSubview:failView];
}


- (void)reloadButtonClick:(UIButton *)sender {
    [projectListArray removeAllObjects];
    [self showHudInView:self.view hint:@"正在加载"];
    [self loadData];
}

-(void)loadData
{
    //    [myTableView removeFromSuperview];
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
    _pageForHot = 1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
                           @"cityCode":cityCode,
                           @"pageStart":@"1",
                           @"pageOffset":@"20",
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        NDLog(@"发现首页数据 -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            //            [activityIndicator stopAnimating];
            //            activityIndicator.hidden = YES;
            
            //            failView.hidden = YES;
            //            [failView.activityIndicatorView stopAnimating];
            //            failView.activityIndicatorView.hidden = YES;
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [projectListArray addObjectsFromArray:array];
            [myTableView reloadData];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        //        [myTableView.foot finishRefreshing];
        //        [myTableView.head finishRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
        failView.hidden = NO;
        //        [failView.activityIndicatorView stopAnimating];
        //        failView.activityIndicatorView.hidden = YES;
    }];
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    //    [failView.activityIndicatorView startAnimating];
    //    failView.activityIndicatorView.hidden = NO;
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _pageForHot = 1;
    }
    else{
        _pageForHot ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",_pageForHot];
    NSString * pageOffset = @"15";
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString * cityCode = [userDefaults objectForKey:@"cityCode"];
    NSDictionary * dic = @{
                           //                           @"cityCode":cityCode,
                           @"pageStart":page,
                           @"pageOffset":pageOffset,
                           };
    [[RequestManager shareRequestManager] getDiscoverList:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];
        myTableView.hidden = NO;
        failView.hidden = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            //            failView.hidden = YES;
            //            [failView.activityIndicatorView stopAnimating];
            //            failView.activityIndicatorView.hidden = YES;
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [projectListArray removeAllObjects];
            }
            NSArray * array = [ NSArray arrayWithArray:[result objectForKey:@"discoverList"]];
            [projectListArray addObjectsFromArray:array];
            [myTableView reloadData];
            [refreshView endRefreshing];
            if (array.count<15 || array.count == 0) {
                [myTableView.foot finishRefreshing];
            }else{
                [myTableView.foot endRefreshing];
            }
        }else {
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        //        [myTableView.foot finishRefreshing];
        //        [myTableView.head finishRefreshing];
        
        //        failView.hidden = NO;
        //        [failView.activityIndicatorView stopAnimating];
        //        failView.activityIndicatorView.hidden = YES;
        [refreshView endRefreshing];
        [self hideHud];
        myTableView.hidden = YES;
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
    cell.backgroundColor = [UIColor clearColor];
    UIView *cellbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (175+10)*AUTO_SIZE_SCALE_X)];
    cellbackgroundView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [cell addSubview:cellbackgroundView];
   
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 175*AUTO_SIZE_SCALE_X)];
//    [imgV setImageWithURL:[NSURL URLWithString:[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"店铺、项目大图默认图"]];
    imgV.backgroundColor =[UIColor clearColor];
    [cellbackgroundView addSubview:imgV];
    
    UIView *transView = [[UIView alloc] initWithFrame:CGRectMake(0, cellbackgroundView.frame.size.height-70*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X)];
    UIColor *colorOne = [UIColor clearColor];
    UIColor *colorTwo = [UIColor blackColor];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = transView.bounds;
    
    [transView.layer insertSublayer:headerLayer atIndex:0];

    [cellbackgroundView addSubview:transView];
    
    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, kScreenWidth-24, 20*AUTO_SIZE_SCALE_X)];
    titlelabel.textColor =[UIColor whiteColor];
    titlelabel.text =@"大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司大力金刚北京分公司";
    titlelabel.numberOfLines = 1;
    titlelabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    [transView addSubview:titlelabel];
    titlelabel.textAlignment =NSTextAlignmentLeft;
//    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.navView.mas_bottom);
//        make.right.equalTo(self.navView.mas_right).offset(-5);
//        make.size.mas_equalTo(CGSizeMake(65*AUTO_SIZE_SCALE_X, navBtnHeight));
//    }];
    
    //这个frame是初设的，没关系，后面还会重新设置其size。

    UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9*AUTO_SIZE_SCALE_X,0,0)];
    [self returnlable:pricelabel WithString:@"673" Withindex:2 WithDocument:@"最高" WithDoc1:@"元"];
    [transView addSubview:pricelabel];
   
    UILabel *numberlabel = [[UILabel alloc] init];
    [self returnlable:numberlabel WithString:@"5" Withindex:2 WithDocument:@"已成" WithDoc1:@"单"];
    [numberlabel setFrame:CGRectMake(10*AUTO_SIZE_SCALE_X+pricelabel.frame.origin.x+pricelabel.frame.size.width, 9*AUTO_SIZE_SCALE_X+titlelabel.frame.size.height+titlelabel.frame.origin.y, numberlabel.width, numberlabel.height)];
    [transView addSubview:numberlabel];

    return cell;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(int)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 0;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X],};
    label.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    //    CGSize textSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, pricelabel.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    CGSize textSize = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
    [label setFrame:CGRectMake(12, 9*AUTO_SIZE_SCALE_X+titlelabel.frame.size.height+titlelabel.frame.origin.y, textSize.width, textSize.height)];
    [mutablestr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,index)];
    [mutablestr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(index,[string length])];
    [mutablestr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(mutablestr.length-1,1)];
    label.attributedText = mutablestr;
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
    DetailProjectViewController * vc = [[DetailProjectViewController alloc] init];
//            vc.ID = [[projectListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
//            vc.titles =[[projectListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    vc.titles =@"小米手机";
            [self.navigationController pushViewController:vc animated:YES];
    
    //    NSString * type = [NSString stringWithFormat:@"%@",[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    //    //0 门店 1服务 2 技师 3图文
    //    if ([type isEqualToString:@"3"]) {
    //        //发现详情页
    //        DetailFoundViewController * vc = [[DetailFoundViewController alloc] init];
    //        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    //        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    //    else if ([type isEqualToString:@"0"]) {
    //        //发现店铺详情页
    //        StoreFoundViewController * vc = [[StoreFoundViewController alloc] init];
    //        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    //        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    //    else if ([type isEqualToString:@"1"]) {
    //        //发现服务详情页
    //        ServiceFoundViewController * vc = [[ServiceFoundViewController alloc] init];
    //        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    //        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    //    else if ([type isEqualToString:@"2"]) {
    //        //发现技师详情页
    //        WorkerFoundViewController * vc = [[WorkerFoundViewController alloc] init];
    //        vc.ID = [[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    //        vc.titles =[[discoverListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}


// 实现代理.
#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"%ld -- %ld", column, row);
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"直接报备" forState:UIControlStateNormal];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(dButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}

-(void)dButtonClick{
    
        DirectReportViewController *vc = [[DirectReportViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
}
@end
