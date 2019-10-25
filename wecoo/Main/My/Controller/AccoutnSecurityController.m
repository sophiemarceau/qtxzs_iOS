//
//  AccoutnSecurityController.m
//  wecoo
//
//  Created by 屈小波 on 2017/3/30.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "AccoutnSecurityController.h"
#import "publicTableViewCell.h"
#import "ModifyPwdViewController.h"
#import "ForgetPwdViewController.h"
#import "SettingPwdViewController.h"
@interface AccoutnSecurityController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * myTableView;
    NSMutableArray *data;
    int IsWithDrawPwdFlag;
}

@end

@implementation AccoutnSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self initTableView];
    
    [self loadData];
}

-(void)loadData{
    NSDictionary *dic1 = @{};
    
    [[RequestManager shareRequestManager] IsWithdrawPwdNullResult:dic1 viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        
        if(IsSucess(result)){
            //true:设置过提现密码 false:没有设置过
            IsWithDrawPwdFlag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            NSLog(@"result-GetIsWithdrawPwd--IsWithDrawPwdFlag-->%d",IsWithDrawPwdFlag);
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];

}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    if (data.count > 0 ) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54*AUTO_SIZE_SCALE_X)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20*AUTO_SIZE_SCALE_X, kScreenWidth/2-15-20*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = FontUIColorBlack;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [bgView addSubview:nameLabel];
        
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, 18*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        [bgView addSubview:arrowImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height, kScreenWidth, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [bgView addSubview:lineImageView];
        
//        if ((int)indexPath.row==(data.count-1)) {
//            lineImageView.hidden = YES;
//        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsWithDrawPwdFlag == 0) {
         [[RequestManager shareRequestManager] tipAlert:@"请在首次提现时设置提现密码后再进行此操作" viewController:self];
        return ;
    }
    
    if (indexPath.row == 0) {
        ModifyPwdViewController *vc = [[ModifyPwdViewController alloc] init];
        vc.titles = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 1) {
         ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
         vc.titles = @"重置提现密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kAccountSecurityPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAccountSecurityPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initdata{
    data = [NSMutableArray arrayWithCapacity:0];
    [data addObject:@{@"name":@"修改提现密码"}];
    [data addObject:@{@"name":@"忘记提现密码"}];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-(kNavHeight))];
    myTableView.backgroundColor = BGColorGray;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 54*AUTO_SIZE_SCALE_X;
    [self.view addSubview:myTableView];
}

@end
