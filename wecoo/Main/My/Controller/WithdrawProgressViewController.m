//
//  WithdrawProgressViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/3.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "WithdrawProgressViewController.h"
#import "noWifiView.h"
#import "withdrawprogressTableviewCell.h"
#import "publicTableViewCell.h"
#import "AlipayWithdrawViewController.h"
#import "WithdrawViewController.h"
#import "noContent.h"
#import "ReviewPersonalInfoViewController.h"
#import "ProgressTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ProgressModel.h"

@interface WithdrawProgressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    noWifiView *failView;
//    withdrawprogressTableviewCell *cell;
    noContent *nocontent;
}

@property (nonatomic,strong)UITableView *timeTableView;
@property (nonatomic,strong)NSMutableArray *mydata;

@end

@implementation WithdrawProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kModifyWithdraw object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrawInfo:) name:kModifyWithdraw object:nil];
    self.mydata = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.timeTableView];
}

-(void)withdrawInfo:(NSNotification *)notification{
    NSDictionary *userInfo = notification.object;
    
    int swa_type = [[userInfo objectForKey:@"swa_type"] intValue];
    
    int link = [userInfo[@"link"] intValue];
    
    int swal_opertype = [userInfo[@"swal_opertype"] intValue];
    int swa_id = [userInfo[@"swa_id"] intValue];
    if (link == 0) {
        return;
    }
    if (swal_opertype == 3 && link == 2) {
        NSDictionary *dic = @{};
        [[RequestManager shareRequestManager] GetUserSalesmanIDInfoDtoResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                NSDictionary *authdto = [[result objectForKey:@"data"] objectForKey:@"dto"];
                if(![authdto isEqual:[NSNull null]]){
                    ReviewPersonalInfoViewController *vc = [[ReviewPersonalInfoViewController alloc] init];
                    vc.authDictionary = authdto;
                    vc.titles = @"实名认证";
                    vc.gotoWhere = 2-swa_type;
                    //swa_type{1,2}0 2-swa_type 支付宝 1个人银行卡
                    vc.fromWhere = 2;
                    vc.IsWithDrawPwdFlag = 1;
                    vc.swa_id = swa_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
        return;
    }

    if (swa_type == 1) {
        WithdrawViewController *vc = [[WithdrawViewController alloc] init];
        vc.swa_id = [NSString stringWithFormat:@"%d",[[userInfo objectForKey:@"swa_id"] intValue]];
        vc.titles = @"个人银行卡提现";
        vc.us_realname = [userInfo objectForKey:@"us_realname"];
        vc.gotoWhere =1;// gotowhere  修改提现 的时候 传1
        vc.fromWhere = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (swa_type == 2) {
        AlipayWithdrawViewController *vc = [[AlipayWithdrawViewController alloc] init];
        vc.swa_id = [NSString stringWithFormat:@"%d",[[userInfo objectForKey:@"swa_id"] intValue]];
        vc.titles = @"支付宝提现";
        vc.us_realname = [userInfo objectForKey:@"us_realname"];
        vc.gotoWhere =1;// gotowhere  修改提现 的时候 传1
        vc.fromWhere = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.mydata removeAllObjects];
//    [self.mydata addObjectsFromArray: [[NSArray alloc] initWithObjects:@"老夫聊发少年狂，治肾亏，不含糖。",
//        @"夜来幽梦忽还乡，学外语，\r\n新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
//                                           @"啦啦啦",
//                                           @"老夫聊发少年狂，治肾亏，不含糖。",
//                                           @"锦帽貂裘，千骑用康王。",
//                                           @"",
//                                           @"为报倾城随太守，三百年，九芝堂。酒酣胸胆尚开张，西瓜霜，喜之郎。",
//                                           @"持节云中，三金葡萄糖。会挽雕弓如满月，西北望 ，阿迪王。",
//                                           @"十年生死两茫茫，恒源祥，羊羊羊。",
//                                           @"千里孤坟，洗衣用奇强。",
//                                           @"纵使相逢应不识，补维C，施尔康。",
//                                           @"夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
//                                           @"啦啦啦",nil]]
//       ;
    
    NSDictionary *dic = @{
                          @"swa_id":self.swa_id,
                          };
    NSLog(@"dic--查询提现进度--%@",dic);
    [[RequestManager shareRequestManager] GetSalesmanWithdrawingApplicationLogListResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            NSLog(@"array----%@",array);
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.mydata addObjectsFromArray:array];
                
            }else{
                
            }
            
            if (self.mydata.count>0) {
                nocontent.hidden = YES;
                self.timeTableView.hidden = NO;
                
            }else{
                nocontent.hidden = NO;
                self.timeTableView.hidden = YES;
            }
            failView.hidden = YES;
            [self.timeTableView reloadData];
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
    }];
    
}


-(UITableView *)timeTableView{
    if (_timeTableView == nil) {
        self.timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) ];
        [self.timeTableView registerClass:[ProgressTableViewCell class] forCellReuseIdentifier:@"DetailTableViewCell"];
        self.timeTableView.showsVerticalScrollIndicator = NO;
        self.timeTableView.delegate = self;
        self.timeTableView.dataSource = self;
        self.timeTableView.bounces = NO;
        self.timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.timeTableView.backgroundColor = BGColorGray;
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.frame = CGRectMake(0, 0, kScreenWidth, 25*AUTO_SIZE_SCALE_X);
        self.timeTableView.tableFooterView =footerView;
        //加载数据失败时显示
        failView = [[noWifiView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        failView.hidden = YES;
        [self.view addSubview:failView];
        nocontent = [[noContent alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        nocontent.hidden = NO;
        [self.view addSubview:nocontent];
        
    }
    return _timeTableView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self initData];
}
- (void)configureCell:(ProgressTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.model  = [[ProgressModel alloc] initWithDictionary:[self.mydata objectAtIndex:indexPath.row]];
}

#pragma mark - TabelView数据源协议
//该方法指定了表格视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过indexpath缓存高度
    return [tableView fd_heightForCellWithIdentifier:@"DetailTableViewCell" cacheByIndexPath:indexPath configuration:^(ProgressTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

//该方法返回单元格对象，有多少行表格，则调用多少次
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    if (indexPath.row == 0 ) {
        [cell isHighLighted:YES];
    }else{
        [cell isHighLighted:NO];
    }
    
    [cell lineimageviewSetIndexPath:indexPath withCount:(int)self.mydata.count];
    
    if(indexPath.row == self.mydata.count-1 && self.mydata.count == 1){
        cell.lineImageView.hidden = YES;
    }else{
        cell.lineImageView.hidden = NO;
    }
    cell.dictionary = [self.mydata objectAtIndex:indexPath.row];
    return  cell;
}

#pragma mark - TabelView代理协议
//选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kWithdrawProgressPage];//("PageOne"为页面名称，可自定义)
    
    [self initData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kWithdrawProgressPage];
}

@end
