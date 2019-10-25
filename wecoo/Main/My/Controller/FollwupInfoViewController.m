//
//  FollwupInfoViewController.m
//  wecoo
//
//  Created by 屈小波 on 2017/4/25.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "FollwupInfoViewController.h"








#import "noContent.h"
#import "infoCellTableViewCell.h"
#import "noWifiView.h"
#import "PlatformfeedbackViewController.h"
#import "timelineViewController.h"

@interface FollwupInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    noWifiView *failView;
    noContent *nocontent;
    infoCellTableViewCell *cell;
    int current_page;
    int total_count;
    int followup_id;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIView *TableHeadView;
@property (nonatomic,strong)UIView *platformView;
@property (nonatomic,strong)UIImageView *platformImage;
@property (nonatomic,strong)UILabel *platformLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *platformTitleLabel;
@property (nonatomic,strong)UILabel *platformTimeLabel;
@property (nonatomic,strong)UILabel *checkLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *enterpriseView;
@property (nonatomic,strong)UILabel *enterpriseLabel;
@property (nonatomic,strong)UIImageView *enterpriseImageView;
@property (nonatomic,strong)UIImageView *lineImageView2;

@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation FollwupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.view addSubview:self.myTableView];
    [self.platformView addSubview:self.platformImage];
    [self.platformView addSubview:self.platformLabel];
    [self.platformView addSubview:self.lineImageView];
    [self.platformView addSubview:self.platformTitleLabel];
    [self.platformView addSubview:self.platformTimeLabel];
    [self.platformView addSubview:self.checkLabel];
    [self.platformView addSubview:self.arrowImageView];
    [self.platformView addSubview:self.contentLabel];
    [self.TableHeadView addSubview:self.platformView];
    [self.TableHeadView addSubview:self.enterpriseView];
    [self.enterpriseView addSubview:self.enterpriseImageView];
    [self.enterpriseView addSubview:self.enterpriseLabel];
    [self.enterpriseView addSubview:self.lineImageView2];
    [self.myTableView setTableHeaderView:self.TableHeadView];
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initData{
    self.data = [NSMutableArray arrayWithCapacity:0];
}


-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    [self.data removeAllObjects];
    NSDictionary *dic1 = @{
                           
                           @"report_id":self.report_id
                           };
    
    [[RequestManager shareRequestManager] getFollowupInfoDtosResult:dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            
            
            
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"enterpriseFollowUpDtos"];
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                
                [self.data addObjectsFromArray:array];
                
            }else{
                
                
            }
            NSDictionary *platformFeedbackDic = [[result objectForKey:@"data"] objectForKey:@"platformFeedbackLogDto"];
            
            if (![platformFeedbackDic isEqual:[NSNull null]] && platformFeedbackDic != nil &&platformFeedbackDic.count !=0) {
                
                self.platformImage.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                self.platformLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19.5/2*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
                self.lineImageView.frame = CGRectMake(0, 40*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5);
                self.platformTitleLabel.frame = CGRectMake(15, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth/2-15, 45/2*AUTO_SIZE_SCALE_X);
                self.platformTimeLabel.frame = CGRectMake(15, self.platformTitleLabel.frame.origin.y+self.platformTitleLabel.frame.size.height+3*AUTO_SIZE_SCALE_X, kScreenWidth-30, 33/2*AUTO_SIZE_SCALE_X);
                self.platformTimeLabel.text = [platformFeedbackDic objectForKey:@"crl_createdtime"];
                self.checkLabel.frame = CGRectMake(kScreenWidth-15-50*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
                self.arrowImageView.frame = CGRectMake(kScreenWidth-15, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+15*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
                self.contentLabel.frame =CGRectMake(15, self.platformTimeLabel.frame.origin.y+self.platformTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-30,0);
                self.contentLabel.text = [platformFeedbackDic objectForKey:@"crl_note"];
                [self.contentLabel sizeToFit];
                self.platformView.frame = CGRectMake(0, 0, kScreenWidth, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10*AUTO_SIZE_SCALE_X);
                
                if (self.data.count==0) {
                    
                    
                }else{
                    self.enterpriseView.frame = CGRectMake(0, self.platformView.frame.origin.y+self.platformView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 40*AUTO_SIZE_SCALE_X);
                    
                    
                    self.enterpriseImageView.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X,30/2*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                    self.enterpriseLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19/2*AUTO_SIZE_SCALE_X, kScreenWidth-74/2*AUTO_SIZE_SCALE_X-15, 21*AUTO_SIZE_SCALE_X);
                    self.lineImageView2.frame = CGRectMake(0, self.enterpriseView.frame.size.height-0.5, kScreenWidth, 0.5);
                    
                }
                self.TableHeadView.frame = CGRectMake(0, 0, kScreenWidth, self.platformView.frame.size.height+10*AUTO_SIZE_SCALE_X+self.enterpriseView.frame.size.height);
                
                
                
                followup_id = [[platformFeedbackDic objectForKey:@"report_id"] intValue];
                
            }else{
                self.enterpriseView.frame = CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X);
                self.enterpriseImageView.frame = CGRectMake(15, 13*AUTO_SIZE_SCALE_X, 30/2*AUTO_SIZE_SCALE_X, 27.5/2*AUTO_SIZE_SCALE_X);
                self.enterpriseLabel.frame = CGRectMake(74/2*AUTO_SIZE_SCALE_X, 19/2*AUTO_SIZE_SCALE_X, kScreenWidth-74/2*AUTO_SIZE_SCALE_X-15, 21*AUTO_SIZE_SCALE_X);
                self.lineImageView2.frame = CGRectMake(0, self.enterpriseView.frame.size.height-0.5, kScreenWidth, 0.5);
                self.TableHeadView.frame = CGRectMake(0, 0, kScreenWidth, self.enterpriseView.frame.size.height);
                
            }
            
            
            [self.myTableView setFrame:CGRectMake(0, self.navView.frame.origin.y+self.navView.frame.size.height, kScreenWidth, kScreenHeight-self.navView.frame.size.height)];
            [self.myTableView reloadData];
            
            NSLog(@"platformFeedbackDic.count========%d",platformFeedbackDic.count);
            NSLog(@"self.data.count========%d",self.data.count);
            if (platformFeedbackDic.count == 0 && self.data.count==0) {
                nocontent.hidden = NO;
                
            }else{
                nocontent.hidden = YES;
                
            }
            
            failView.hidden = YES;
            
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){

        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        failView.hidden = NO;
        nocontent.hidden = YES;
    }];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"infocell";
    cell = [[infoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    cell.mydata = self.data[[indexPath row]];
    return [cell setCellHeight:@""];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"infocell";
    cell =(infoCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell = [[infoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTag:[indexPath row]];
    }
    if (self.data.count > 0) {
        cell.mydata = self.data[[indexPath row]];
        [cell setCellHeight:@""];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MobClick event:kMyReportProgress];
    timelineViewController *vc = [[timelineViewController alloc] init];
    vc.titles = @"跟进进度";
    vc.report_id =  [NSString stringWithFormat:@"%d",[[self.data[indexPath.row] objectForKey:@"report_id"] intValue]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)PlatFormTaped:(UITapGestureRecognizer *)sender
{
    [MobClick event:kPlatFormProgress];
    PlatformfeedbackViewController *vc = [[PlatformfeedbackViewController alloc] init];
    vc.titles = @"平台反馈";
    vc.search_id = [NSString stringWithFormat:@"%d",followup_id];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kFollowupTimelinePage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kFollowupTimelinePage];
}

-(UITableView *)myTableView{
    if (_myTableView == nil) {
        self.myTableView = [[UITableView alloc] init];
        [self.myTableView setTableHeaderView:self.TableHeadView];
        self.myTableView.backgroundColor = BGColorGray;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.delegate = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myTableView.dataSource = self;
        
        //加载数据失败时显示
        failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, self.navView.frame.origin.y+self.navView.frame.size.height, kScreenWidth, kScreenHeight-self.navView.frame.size.height)];
        [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        failView.hidden = YES;
        [self.view addSubview:failView];
        nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, self.navView.frame.origin.y+self.navView.frame.size.height, kScreenWidth, kScreenHeight-self.navView.frame.size.height)];
        //            [nocontent.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nocontent.hidden = YES;
        [self.view addSubview:nocontent];
    }
    return _myTableView;
}

- (UIView *)TableHeadView {
    if (_TableHeadView == nil) {
        self.TableHeadView = [UIView new];
        self.TableHeadView.backgroundColor = BGColorGray;
    }
    return _TableHeadView;
}
- (UIView *)platformView {
    if (_platformView == nil) {
        self.platformView = [UIView new];
        self.platformView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PlatFormTaped:)];
        [self.platformView addGestureRecognizer:tap1];
    }
    return _platformView;
}

- (UIView *)enterpriseView {
    if (_enterpriseView == nil) {
        self.enterpriseView = [UIView new];
        self.enterpriseView.backgroundColor = [UIColor whiteColor];
    }
    return _enterpriseView;
}


-(UIImageView *)platformImage{
    if (_platformImage == nil) {
        self.platformImage = [UIImageView new];
        
        self.platformImage.image = [UIImage imageNamed:@"icon_report_feedback"];
        
    }
    return _platformImage;
}

- (UILabel *)platformLabel {
    if (_platformLabel == nil) {
        self.platformLabel = [CommentMethod initLabelWithText:@"平台反馈" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.platformLabel.textColor = FontUIColorGray;
    }
    return _platformLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [[UIImageView alloc] init];
        [self.lineImageView setSize:CGSizeMake( kScreenWidth, 0.5)];
        self.lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

- (UILabel *)platformTitleLabel {
    if (_platformTitleLabel == nil) {
        self.platformTitleLabel = [CommentMethod initLabelWithText:@"渠天下客服" textAlignment:NSTextAlignmentLeft font:16*AUTO_SIZE_SCALE_X];
        self.platformTitleLabel.textColor = FontUIColorBlack;
        
        
    }
    return _platformTitleLabel;
}

- (UILabel *)platformTimeLabel {
    if (_platformTimeLabel == nil) {
        self.platformTimeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.platformTimeLabel.textColor = FontUIColorGray;
    }
    return _platformTimeLabel;
}

- (UILabel *)checkLabel {
    if (_checkLabel == nil) {
        self.checkLabel = [CommentMethod initLabelWithText:@"查看" textAlignment:NSTextAlignmentRight font:14*AUTO_SIZE_SCALE_X];
        self.checkLabel.textColor = FontUIColorGray;
    }
    return _checkLabel;
}

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        self.arrowImageView = [[UIImageView alloc] init];
        [self.arrowImageView setSize:CGSizeMake( 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
    }
    return _arrowImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.contentLabel.textColor = FontUIColorGray;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}

- (UILabel *)enterpriseLabel {
    if (_enterpriseLabel == nil) {
        self.enterpriseLabel = [CommentMethod initLabelWithText:@"企业跟进" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.enterpriseLabel.textColor = FontUIColorGray;
    }
    return _enterpriseLabel;
}

-(UIImageView *)enterpriseImageView{
    if (_enterpriseImageView == nil) {
        self.enterpriseImageView = [[UIImageView alloc] init];
        
        self.enterpriseImageView.image = [UIImage imageNamed:@"icon_report_follow_up"];
    }
    return _enterpriseImageView;
}

-(UIImageView *)lineImageView2{
    if (_lineImageView2 == nil) {
        self.lineImageView2 = [[UIImageView alloc] init];
        [self.lineImageView2 setSize:CGSizeMake( kScreenWidth, 0.5)];
        self.lineImageView2.backgroundColor = lineImageColor;
    }
    return _lineImageView2;
}

@end
