//
//  MyInviteDetailViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/1/11.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "MyInviteDetailViewController.h"
#import "publicTableViewCell.h"
#import "noWifiView.h"
@interface MyInviteDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *dto;
    UITableView *myTableView;
    NSMutableArray *data;
    noWifiView * failView;
}
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *PhoneLabel;
@property(nonatomic,strong)UILabel *RewardBalanceLabel;
@end

@implementation MyInviteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleView];
    [self initTableView];
    [self initData];
    [self loadData];
}

-(void)initTableView{
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.origin.y+self.titleView.frame.size.height, kScreenWidth, kScreenHeight-(self.titleView.frame.origin.y+self.titleView.frame.size.height))];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.rowHeight = 120/2*AUTO_SIZE_SCALE_X+1;
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



-(void)initData{
     data =[NSMutableArray arrayWithCapacity:0];
}
-(void)loadData{
   
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic1 = @{
                           @"sil_id":[NSString stringWithFormat:@"%ld",self.sil_id],
                           };
    
    [[RequestManager shareRequestManager] GetBeInviterSalesmanDetailsDtoResult:dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            dto = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dto isEqual:[NSNull null]]){
                
                self.NameLabel.text = [NSString stringWithFormat:@"%@",[dto objectForKey:@"us_nickname"]];

                self.PhoneLabel.text = [NSString stringWithFormat:@"%@",[dto objectForKey:@"us_tel"]];
                
                self.RewardBalanceLabel.text = [NSString stringWithFormat:@"%@",[dto objectForKey:@"reward_balance"]];
                
                NSString *string = [NSString stringWithFormat:@"%@元",[dto objectForKey:@"reward_balance"]];
                NSString *str = [NSString stringWithFormat:@"%@%@",@"累计赏金:",string];
                int index = 5;
                
                NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
                
                [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(0,index)];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,index)];
                
                [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
                [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
                
                self.RewardBalanceLabel.attributedText = mutablestr;
                [self.RewardBalanceLabel sizeToFit];
                self.RewardBalanceLabel.frame = CGRectMake(kScreenWidth-15-self.RewardBalanceLabel.frame.size.width, 25*AUTO_SIZE_SCALE_X, self.RewardBalanceLabel.frame.size.width, 15*AUTO_SIZE_SCALE_X);
                NSArray * array =  [dto objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array !=nil)
                {
                    [data addObjectsFromArray:array];
                    [myTableView reloadData];
                    
                }else{
                    
                }
            }
        }
        failView.hidden = YES;
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        failView.hidden = NO;
    }];
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
    cell.backgroundColor = [UIColor whiteColor];
    UIView *CellBgView = [UIView new];
    CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 136/2*AUTO_SIZE_SCALE_X);
    CellBgView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:CellBgView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height, kScreenWidth, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [CellBgView addSubview:lineImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15*AUTO_SIZE_SCALE_X, 300*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = FontUIColorBlack;
    titleLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    titleLabel.text = [NSString stringWithFormat:@"%@",[data[indexPath.row] objectForKey:@"beInviterSalesman_describe"]];
    [CellBgView addSubview:titleLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-70*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = RedUIColorC1;
    statusLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    statusLabel.text = [NSString stringWithFormat:@"+%@",[data[indexPath.row] objectForKey:@"beInviterSalesman_balance"]];
    NSString *temp = [data[indexPath.row] objectForKey:@"beInviterSalesman_balance"];
    if ([temp isEqual:[NSNull null]] || temp ==nil) {
        statusLabel.hidden = YES;
    }
    [CellBgView addSubview:statusLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, 280*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.textColor = FontUIColorGray;
    subLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    subLabel.text = [data[indexPath.row] objectForKey:@"beInviterSalesman_date"];
    
//    NSArray *temparray  = [subString componentsSeparatedByString:@"@"];
//    if(![temparray isEqual:[NSNull null]] && temparray !=nil)
//    {
//        if (temparray.count==3) {
//            [self returnlable:subLabel WithString:temparray[1] Withindex:[temparray[0] length] WithDocument:temparray[0] WithDoc1:temparray[2]];
//            
//        }else{
//            
//            subLabel.text = [NSString stringWithFormat:@"%@",subString];
//        }
//    }
    
    [CellBgView addSubview:subLabel];
    
//    if(indexPath.row == data.count -1 ||data.count == 1){
//        lineImageView.hidden = YES;
//    }else{
//        lineImageView.hidden = NO;
//    }
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIView *)titleView {
    if (_titleView == nil) {
        self.titleView = [UIView new];
        self.titleView.backgroundColor = [UIColor clearColor];
        self.titleView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 65*AUTO_SIZE_SCALE_X);
        
    }
    return _titleView;
}

- (UILabel *)NameLabel {
    if (_NameLabel == nil) {
        self.NameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.NameLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, 215*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.NameLabel.textColor = FontUIColorBlack;
        [self.titleView addSubview:self.NameLabel];
    }
    return _NameLabel;
}

- (UILabel *)PhoneLabel {
    if (_PhoneLabel == nil) {
        self.PhoneLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.PhoneLabel.frame = CGRectMake(15, self.NameLabel.origin.y+self.NameLabel.frame.size.height+15*AUTO_SIZE_SCALE_X, kScreenWidth/2, 15*AUTO_SIZE_SCALE_X);
        self.PhoneLabel.textColor = FontUIColorBlack;
        [self.titleView addSubview:self.PhoneLabel];
    }
    return _PhoneLabel;
}

-(UILabel *)RewardBalanceLabel{
    if (_RewardBalanceLabel == nil) {
        self.RewardBalanceLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        
        self.RewardBalanceLabel.textColor = FontUIColorGray;
        [self.titleView addSubview:self.RewardBalanceLabel];
    }
    return _RewardBalanceLabel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyInviteDetailPage];//("PageOne"为页面名称，可自定义)
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyInviteDetailPage];
}

@end
