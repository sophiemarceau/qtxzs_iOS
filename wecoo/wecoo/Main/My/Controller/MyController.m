//
//  MyController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "MyController.h"
#import "noWifiView.h"
#import "publicTableViewCell.h"
#import "MyReportListViewController.h"
@interface MyController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * myTableView;
    noWifiView * failView;
}

@end

@implementation MyController

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    [self.navView removeFromSuperview];
    self.myheadView.frame = CGRectMake(0, 0, kScreenWidth, 224*AUTO_SIZE_SCALE_X);
    self.myReportView.frame = CGRectMake(0, self.myheadView.frame.size.height+self.myheadView.frame.origin.y, kScreenWidth, 125*AUTO_SIZE_SCALE_X);
    [self.MyTableHeadView addSubview:self.myheadView];
    [self.MyTableHeadView addSubview:self.myReportView];
    self.MyTableHeadView.frame = CGRectMake(0, 0, kScreenWidth, self.myheadView.frame.size.height+self.myReportView.frame.size.height);
    [self initTableView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickmyReport:)];
    [self.myReportView.reporteView addGestureRecognizer:tap];
    
}


-(void)onClickmyReport:(UITapGestureRecognizer *)sender
{
        MyReportListViewController * vc = [[MyReportListViewController alloc] init];
        vc.titles =@"我的报备";
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)initData{
    self.mydata =[NSMutableArray arrayWithCapacity:0];
    
    [self.mydata addObjectsFromArray: @[
                                        @{@"imagename":@"icon-myCustomer",
                                          @"imageLabel":@"我的客户"
                                          },
                                        @{
                                            @"imagename":@"icon-myFavorites",
                                            @"imageLabel":@"我的收藏"
                                            },
                                        @{
                                            @"imagename":@"icon-myWithdrawals",
                                            @"imageLabel":@"账户体现"
                                            },
                                        @{
                                            @"imagename":@"icon-myBunos",
                                            @"imageLabel":@"奖励活动"
                                            },
                                        @{
                                            @"imagename":@"icon-myComplaint",
                                            @"imageLabel":@"投诉建议"
                                            },
                                        @{
                                            @"imagename":@"icon-myWanzhuan",
                                            @"imageLabel":@"玩转问渠道"
                                            },
                                        @{
                                            @"imagename":@"icon-myAbout",
                                            @"imageLabel":@"关于我们"
                                            },
                                        @{
                                            @"imagename":@"icon-mySet",
                                            @"imageLabel":@"设置"
                                            }
                                        ]];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView setTableHeaderView:self.MyTableHeadView];
    
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

#pragma mark tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ((int)indexPath.row==3) {
        return 71*AUTO_SIZE_SCALE_X;
    }
    return 52*AUTO_SIZE_SCALE_X;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mydata.count;
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
    cell.backgroundColor = BGColorGray;
    UIView *CellBgView = [UIView new];
    CellBgView.frame = CGRectMake(0, 0, kScreenWidth, 52*AUTO_SIZE_SCALE_X);
    CellBgView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.frame = CGRectMake(15, 15, 19*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X);
    iconImageView.image = [UIImage imageNamed:[self.mydata[indexPath.row] objectForKey:@"imagename"]];
    [CellBgView addSubview:iconImageView];
    [cell addSubview:CellBgView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CellBgView.frame.size.height, kScreenWidth, 0.5)];
    lineImageView.image = [UIImage imageNamed:@"item_line"];
    [CellBgView addSubview:lineImageView];
    
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    iconLabel.textAlignment = NSTextAlignmentLeft;
    iconLabel.textColor = UIColorFromRGB(0x333333);
    iconLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    iconLabel.text =[self.mydata[indexPath.row] objectForKey:@"imageLabel"];
    [CellBgView addSubview:iconLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, 18*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
    [CellBgView addSubview:arrowImageView];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50*AUTO_SIZE_SCALE_X-15-7*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X)];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.textColor = UIColorFromRGB(0x333333);
    numberLabel.font=[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    numberLabel.text =@"1";
    [CellBgView addSubview:numberLabel];
    
    if ((int)indexPath.row==3 || (int)indexPath.row==7 ||(int)indexPath.row==2) {
        lineImageView.hidden = YES;
    }
    if ((int)indexPath.row==3) {
         CellBgView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 52*AUTO_SIZE_SCALE_X);
        return cell;
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"ndexPath.row -- %ld",(long)indexPath.row);
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MyHeadView *)myheadView{
    if (_myheadView == nil) {
        self.myheadView = [MyHeadView new];
        NSDictionary *data = [[NSDictionary alloc] init];
        self.myheadView.data = data;
        self.myheadView.backgroundColor = [UIColor whiteColor];
    }
    return _myheadView;
}

-(myReportView *)myReportView{
    if (_myReportView == nil) {
        self.myReportView = [myReportView new];
        NSDictionary *data = [[NSDictionary alloc] init];
        self.myReportView.data = data;
        self.myReportView.backgroundColor = BGColorGray;

    }
    return _myReportView;
}


-(UIView *)MyTableHeadView{
    if (_MyTableHeadView == nil) {
        self.MyTableHeadView = [UIView new];
        self.MyTableHeadView.backgroundColor = BGColorGray;
        
    }
    return _MyTableHeadView;
}


@end
