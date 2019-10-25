//
//  DirectReportViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/21.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "DirectReportViewController.h"
#import "STPickerSingle.h"
#import "STPickerArea.h"
#import "publicTableViewCell.h"
#import "SubmitView.h"
@interface DirectReportViewController ()<STPickerSingleDelegate,STPickerAreaDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *DataDic;

}
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)UILabel *SubDescLabel;
@property (nonatomic,strong)ClientView *clientView;
@property (nonatomic,strong)ReportView *reportView;
@property (nonatomic,strong)UITableView *Tableview;
@property (nonatomic,strong)STPickerSingle *sigleView;
@property (nonatomic,strong)STPickerArea *areaView;
@property (nonatomic,strong)UIView *remarkView;

@property (nonatomic,strong) SubmitView *subview;

@end

@implementation DirectReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles =@"直接报备客户";
    
    

    [self.HeaderView addSubview:self.SubDescLabel];
    [self.HeaderView addSubview:self.clientView];
    [self.HeaderView addSubview:self.reportView];
    [self.HeaderView addSubview:self.subview];
    
    self.SubDescLabel.frame = CGRectMake(15, 0, kScreenWidth-(15+25)*AUTO_SIZE_SCALE_X,85*AUTO_SIZE_SCALE_X);
    
    self.clientView.frame = CGRectMake(0, self.SubDescLabel.frame.size.height, kScreenWidth,212*AUTO_SIZE_SCALE_X);
    
    self.reportView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X+self.clientView.frame.size.height+self.clientView.frame.origin.y, kScreenWidth,334*AUTO_SIZE_SCALE_X);
    
    self.subview.frame = CGRectMake(0, self.reportView.frame.origin.y+self.reportView.frame.size.height, kScreenWidth,84*AUTO_SIZE_SCALE_X);

    self.HeaderView.frame = CGRectMake(0, 0, kScreenWidth,self.SubDescLabel.frame.size.height+self.clientView.frame.size.height+self.reportView.frame.size.height+10*AUTO_SIZE_SCALE_X+self.subview.frame.size.height);
    
    [self.view addSubview:self.Tableview];
    [self.Tableview setFrame:CGRectMake(0, self.navView.frame.origin.y+self.navView.frame.size.height, kScreenWidth, kScreenHeight-self.navView.frame.size.height)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BudgeTaped:)];
    [self.reportView.budgeView addGestureRecognizer:tap];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTaped:)];
    [self.reportView.districtView addGestureRecognizer:tap1];
    
    
    
    
}

-(void)BudgeTaped:(UITapGestureRecognizer *)sender
{
    NSMutableArray *arrayData = [NSMutableArray array];
    for (int i = 1; i < 1000; i++) {
        NSString *string = [NSString stringWithFormat:@"%d", i];
        [arrayData addObject:string];
    }
    [self.sigleView setArrayData:arrayData];
    [self.sigleView show];
}

-(void)disTaped:(UITapGestureRecognizer *)sender
{
    
    
    [self.areaView show];
}

#pragma mark TableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*AUTO_SIZE_SCALE_X;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * publicCell = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:publicCell];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = C2UIColorGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark pikVIew single
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    
}


#pragma mark pikVIew area
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ClientView *)clientView {
    if (_clientView == nil) {
        self.clientView = [ClientView new];
        self.clientView.data = DataDic;
    }
    return _clientView;
}

- (ReportView *)reportView {
    if (_reportView == nil) {
        self.reportView = [ReportView new];
        self.reportView.userInteractionEnabled = YES;
        self.reportView.data = DataDic;
    }
    return _reportView;
}

- (UIView *)HeaderView {
    if (_HeaderView == nil) {
        self.HeaderView = [UIView new];
        self.HeaderView.backgroundColor = C2UIColorGray;
    }
    return _HeaderView;
}

- (UILabel *)SubDescLabel {
    if (_SubDescLabel == nil) {
        self.SubDescLabel = [CommentMethod initLabelWithText:@"如果您不确认客户适合哪个项目，可以在这里直接报备。直接报备后，我们人工分配项目经理，签约后根据项目确定佣金" textAlignment:NSTextAlignmentLeft font:14*AUTO_SIZE_SCALE_X];
        self.SubDescLabel.textColor = FontUIColorGray;
        self.SubDescLabel.numberOfLines = 3;
    }
    return _SubDescLabel;
}

- (STPickerSingle *)sigleView {
    if (_sigleView == nil) {
        self.sigleView = [[STPickerSingle alloc]init];
        [self.sigleView setContentMode:STPickerContentModeBottom];
        self.sigleView.delegate = self;
    }
    return _sigleView;
}

-(STPickerArea *)areaView{
    if (_areaView == nil) {
        self.areaView = [[STPickerArea alloc]init];
        [self.areaView setContentMode:STPickerContentModeBottom];
        self.areaView.delegate = self;
    }
    return _areaView;
}

-(UITableView *)Tableview{
    if (_Tableview == nil) {
        self.Tableview = [[UITableView alloc] init];
        [self.Tableview setTableHeaderView:self.HeaderView];
        self.Tableview.delegate = self;
        self.Tableview.dataSource = self;
        self.Tableview.bounces = NO;
        //    myTableView.rowHeight = 300;
        self.Tableview.showsVerticalScrollIndicator = NO;
        self.Tableview.backgroundColor = C2UIColorGray;
    }
    return _Tableview;
    
   
}

-(UIView *)remarkView{
    if (_remarkView == nil) {
        self.remarkView = [[STPickerArea alloc]init];
        
        
    }
    return _remarkView;
}

-(UIView *)subview{
    if(_subview == nil){
        self.subview = [[SubmitView alloc]init];
        self.subview.backgroundColor = [UIColor clearColor];
    }
    return _subview;
}

@end

