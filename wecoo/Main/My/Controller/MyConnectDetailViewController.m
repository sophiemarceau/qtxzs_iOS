//
//  MyConnectDetailViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/20.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyConnectDetailViewController.h"
#import "BaseTableView.h"
#import "noContent.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"

@interface MyConnectDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate>{
    BaseTableView * myTableView;
    noWifiView * failView;
    noContent *nocontent;
    NSMutableArray *data;
    int current_page;
    int total_count;
    NSDictionary *dto;
    int badge;
    double balance;
    NSDictionary  *authdto;
    UIWebView *webView;
    UIView *nocontentView;
    UIView *tableviewHeader;
    NSString *userPhoto;
    NSString *nameString;
    
    
    
    NSString *parent_sil_id;
    int level;
    NSString *user_id_str;
}


@property (nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)UILabel *higherLevelLabel;
@property(nonatomic,strong)UILabel *higherLevelLabel1;
@property(nonatomic,strong)UIButton *higherButton;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIView *highbgView;
@property(nonatomic,strong)UIView *headerbgview;
@property(nonatomic,strong)UILabel *tableheaderLabel;
@property(nonatomic,strong)UIImageView *lineImageView;
@property(nonatomic,strong)UIImageView *phoneIconImageView;


@end

@implementation MyConnectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableviewHeader= [UIView new];
    tableviewHeader.backgroundColor = BGColorGray;
    [self initdata];
    [self initTableView];
    [self loadData];
}


-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
}

- (void)nextLevelOnclick:(UIButton *)sender {
    [MobClick event:kMyConnectBossEvent];
    self.higherButton.enabled = NO;
    MyConnectDetailViewController *vc = [[MyConnectDetailViewController alloc]init];
    vc.titles = @"用户详情";
    vc.sil_id = parent_sil_id;
    [self.navigationController pushViewController:vc animated:YES];
    self.higherButton.enabled = YES;

}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic = @{
                          @"sil_id":[NSString stringWithFormat:@"%@",self.sil_id]
                          };
    [[RequestManager shareRequestManager] GetConnectionDetailResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                NSDictionary *connectdto =[[result objectForKey:@"data"] objectForKey:@"dto"];
                self.myconnectheaderview.dataDic = connectdto;
                level = [[connectdto objectForKey:@"level"] intValue];
                
                if (level != 1) {
                    parent_sil_id = [connectdto objectForKey:@"parent_sil_id"];
                    self.higherLevelLabel1.text = [NSString stringWithFormat:@"%@ %@",[connectdto objectForKey:@"parent_user_nickname"],[connectdto objectForKey:@"parent_user_tel"]];
                }
                parent_sil_id = [connectdto objectForKey:@"parent_sil_id"];
                if(level == 1){
                    [tableviewHeader addSubview:self.myconnectheaderview];
                    [tableviewHeader addSubview:self.headerbgview];
                    self.headerbgview.backgroundColor = [UIColor whiteColor];
                    [self.headerbgview addSubview:self.tableheaderLabel];
                    [self.headerbgview addSubview:self.lineImageView];
                    self.myconnectheaderview.frame = CGRectMake(0, 0, kScreenWidth, 465/2*AUTO_SIZE_SCALE_X);
                    self.headerbgview.frame = CGRectMake(0,self.myconnectheaderview.frame.origin.y+self.myconnectheaderview.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
                    self.tableheaderLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
                    tableviewHeader.frame = CGRectMake(0, 0, kScreenWidth, self.headerbgview.frame.size.height+self.headerbgview.frame.origin.y);
                    self.lineImageView.frame = CGRectMake(15, self.headerbgview.frame.size.height-1, kScreenWidth-15, 0.5);
                    self.phoneIconImageView.hidden = NO;
                    user_id_str = [connectdto objectForKey:@"user_id_str"];
                }else{
                    [tableviewHeader addSubview:self.myconnectheaderview];
                    [tableviewHeader addSubview:self.highbgView];
                    self.highbgView.backgroundColor = [UIColor whiteColor];
                    [self.highbgView addSubview:self.higherLevelLabel];
                    [self.highbgView addSubview:self.arrowImageView];
                    [self.highbgView addSubview:self.higherLevelLabel1];
                    [self.highbgView addSubview:self.higherButton];
                    
                    [tableviewHeader addSubview:self.headerbgview];
                    self.headerbgview.backgroundColor = [UIColor whiteColor];
                    [self.headerbgview addSubview:self.tableheaderLabel];
                    [self.headerbgview addSubview:self.lineImageView];
                    self.myconnectheaderview.frame = CGRectMake(0, 0, kScreenWidth, 465/2*AUTO_SIZE_SCALE_X);
                    self.highbgView.frame = CGRectMake(0, self.myconnectheaderview.frame.origin.y+self.myconnectheaderview.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
                    self.higherButton.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
                    self.higherLevelLabel.frame = CGRectMake(15, 0, 65*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
                    self.arrowImageView.frame = CGRectMake(kScreenWidth-15-7*AUTO_SIZE_SCALE_X, (44-16)/2*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
                    self.higherLevelLabel1.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2-30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
                    self.headerbgview.frame = CGRectMake(0, self.highbgView.frame.origin.y+self.highbgView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
                    self.tableheaderLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 44*AUTO_SIZE_SCALE_X);
                    tableviewHeader.frame = CGRectMake(0, 0, kScreenWidth, self.headerbgview.frame.size.height+self.headerbgview.frame.origin.y);
                    self.lineImageView.frame = CGRectMake(15, self.headerbgview.frame.size.height-1, kScreenWidth-15, 0.5);
                    self.phoneIconImageView.hidden = YES;
                }
                myTableView.tableHeaderView = tableviewHeader;
                
                [self loadListData];
            }
            failView.hidden = YES;
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];
    
    
}

-(void)loadListData{
    
    current_page = 0;
    [data removeAllObjects];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"sil_id":[NSString stringWithFormat:@"%@",self.sil_id]
                          };
    
    [[RequestManager shareRequestManager] SearchConnectionDynamicDtosResult:dic viewController:self successData:^(NSDictionary *result){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            if (result != nil) {
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array !=nil)
                {
                    [data addObjectsFromArray:array];
                    
                }else{
                    
                }
                [myTableView reloadData];
                failView.hidden = YES;
                if (data.count == total_count || data.count == 0) {
                    [myTableView.foot finishRefreshing];
                }
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [myTableView.head endRefreshing];
        [myTableView.foot endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];
    
}

#pragma mark 刷新数据
-(void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        current_page = 0;
        [self loadListData];
        return;
    }
    else{
        current_page ++;
    }
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          @"sil_id":[NSString stringWithFormat:@"%@",self.sil_id]
                          };
    [[RequestManager shareRequestManager] SearchConnectionDynamicDtosResult:dic viewController:self successData:^(NSDictionary *result) {
        failView.hidden = YES;
        
        if(IsSucess(result)){
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
                [data removeAllObjects];
            }
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [data addObjectsFromArray:array];
            }else{
            }
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


-(void)CallTaped:(UITapGestureRecognizer *)sender{
    self.phoneIconImageView.userInteractionEnabled = NO;
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic = @{
                          @"user_id_str":user_id_str,
                          };
    NSLog(@"dic======%@",dic);

    [[RequestManager shareRequestManager] GetUserTelResult:dic viewController:self successData:^(NSDictionary *result){
//        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            NSLog(@"str======%@",result);
            if (result != nil) {
                [MobClick event:kMyConnectCallEvent];
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                 
                   completionHandler:^(BOOL success) {
                       
//                       NSLog(@"Open  %d",success);
                       
                   }];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
            }
            failView.hidden = YES;
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        
    }failuer:^(NSError *error){
        [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];

}

- (void)todoSomething:(id)sender
{
    //在这里做按钮的想做的事情。
    self.phoneIconImageView.userInteractionEnabled = YES;
}

#pragma mark tableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    }
    if (data.count >0) {
        cell.backgroundColor = [UIColor whiteColor];
        UIView *CellBgView = [UIView new];
        CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 116/2*AUTO_SIZE_SCALE_X);
        CellBgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:CellBgView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height-1, kScreenWidth, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [CellBgView addSubview:lineImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15*AUTO_SIZE_SCALE_X, 300*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = FontUIColorBlack;
        titleLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        titleLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"describe"]];
        [CellBgView addSubview:titleLabel];
        
        UILabel *datalabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.size.height+titleLabel.frame.origin.y+5*AUTO_SIZE_SCALE_X,kScreenWidth-30, 15*AUTO_SIZE_SCALE_X)];
        datalabel.textAlignment = NSTextAlignmentLeft;
        datalabel.textColor = FontUIColorGray;
        datalabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        datalabel.text = [NSString stringWithFormat:@"%@", [data[indexPath.row] objectForKey:@"sal_createdtime"]];
        [CellBgView addSubview:datalabel];
        
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/2-15, 15*AUTO_SIZE_SCALE_X,kScreenWidth/2, 15*AUTO_SIZE_SCALE_X)];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.textColor = RedUIColorC1;
        moneyLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        NSString *contribution_sum= [data[indexPath.row] objectForKey:@"contribution_sum"];
        if (contribution_sum != nil) {
            moneyLabel.text = [NSString stringWithFormat:@"+%@",[data[indexPath.row] objectForKey:@"contribution_sum"]];
        }
        
        [CellBgView addSubview:moneyLabel];
        
        //    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 280*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
        //    subLabel.textAlignment = NSTextAlignmentLeft;
        //    subLabel.textColor = FontUIColorGray;
        //    subLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        //    NSString *subString = [NSString stringWithFormat:@"%@ %@",[data[indexPath.row] objectForKey:@"beInviterSalesman_date"],[data[indexPath.row] objectForKey:@"beInviterSalesman_describe"]];
        //    NSArray *temparray  = [subString componentsSeparatedByString:@"@"];
        //    if(![temparray isEqual:[NSNull null]] && temparray !=nil)
        //    {
        //        if (temparray.count==3) {
        //            [self returnlable:subLabel WithString:temparray[1] Withindex:[temparray[0] length] WithDocument:temparray[0] WithDoc1:temparray[2]];
        //
        //        }else{
        //
        //            subLabel.text = [NSString stringWithFormat:@"%@",subString];
        //            subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        //        }
        //    }
        //    
        //    [CellBgView addSubview:subLabel];
        
        if((indexPath.row == data.count -1 && data.count>1) || data.count == 1){
            lineImageView.hidden = YES;
        }else{
            lineImageView.hidden = NO;
        }

    }
    
    return cell;
    
}

//-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
//    
//    label.numberOfLines = 1;
//    
//    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
//    
//    label.textAlignment =NSTextAlignmentLeft;
//    
//    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
//    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
//    
//    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
//    label.attributedText = mutablestr;
//    
//    [label sizeToFit];
//    return label;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [data[indexPath.row] objectForKey:@"imageLabel"];
//    MyInviteDetailViewController * vc = [[MyInviteDetailViewController alloc] init];
//    vc.sil_id = [[[data objectAtIndex:indexPath.row] objectForKey:@"sil_id"] integerValue];
//    vc.titles =@"邀请的成员";
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(MyConnectHeaderView *)myconnectheaderview{
    if (_myconnectheaderview == nil) {
        self.myconnectheaderview = [[MyConnectHeaderView alloc] initWithFrame:CGRectZero];
        self.myconnectheaderview.backgroundColor = BGColorGray;
        [self.myconnectheaderview addSubview:self.phoneIconImageView];
//        self.myconnectheaderview.backgroundColor = [UIColor clearColor];
    }
    return _myconnectheaderview;
}

-(UILabel *)higherLevelLabel{
    if (_higherLevelLabel == nil ) {
        self.higherLevelLabel = [CommentMethod initLabelWithText:@"上级人脉" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.higherLevelLabel.backgroundColor = [UIColor whiteColor];
        self.higherLevelLabel.textColor = FontUIColorBlack;
    }
    return _higherLevelLabel;
}

-(UILabel *)higherLevelLabel1{
    if (_higherLevelLabel1 == nil ) {
        self.higherLevelLabel1 = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.higherLevelLabel1.backgroundColor = [UIColor clearColor];
        self.higherLevelLabel1.textColor = FontUIColorBlack;
    }
    return _higherLevelLabel1;
}


-(UIButton *)higherButton{
    if (_higherButton == nil ) {
        self.higherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.higherButton.backgroundColor = [UIColor clearColor];
        [self.higherButton addTarget:self action:@selector(nextLevelOnclick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _higherButton;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
//        self.arrowImageView.backgroundColor = [UIColor blueColor];
    }
    return _arrowImageView;
}

-(UILabel *)tableheaderLabel{
    if (_tableheaderLabel == nil ) {
        self.tableheaderLabel = [CommentMethod initLabelWithText:@"用户动态" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.tableheaderLabel.backgroundColor = [UIColor whiteColor];
        self.tableheaderLabel.textColor = FontUIColorBlack;
    }
    return _tableheaderLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil ) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


-(UIImageView *)phoneIconImageView{
    if (_phoneIconImageView == nil ) {
        self.phoneIconImageView = [UIImageView new];
        self.phoneIconImageView.image = [UIImage imageNamed:@"icon-phone"];
        self.phoneIconImageView.frame = CGRectMake(kScreenWidth-15-24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallTaped:)];
        [self.phoneIconImageView addGestureRecognizer:tap1];
        self.phoneIconImageView.userInteractionEnabled = YES;
    }    return _phoneIconImageView;
}
//-(void)initNavBarView{
//    [self.navView addSubview:self.directButton];
//    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.navView.mas_bottom);
//        make.right.equalTo(self.navView.mas_right).offset(0);
//        make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, navBtnHeight));
//    }];
//}

-(void)initTableView{
    myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.delegates = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView = tableviewHeader;
    myTableView.rowHeight = 116/2*AUTO_SIZE_SCALE_X;

    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(UIView *)highbgView{
    if (_highbgView == nil ) {
        self.highbgView = [UIView new];
        self.highbgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _highbgView;
}

-(UIView *)headerbgview{
    if (_headerbgview == nil ) {
        self.headerbgview = [UIView new];
        self.headerbgview.backgroundColor = [UIColor whiteColor];
    }
    return _headerbgview;
}

@end
