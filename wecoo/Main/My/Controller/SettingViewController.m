//
//  SettingViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/2.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "SettingViewController.h"
#import "publicTableViewCell.h"
#import "SVProgressHUD.h"
#import "LBClearCacheTool.h"
#import "AccoutnSecurityController.h"
#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *myTableView;
    NSArray *mydata;
    
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mydata = @[@"账号安全",@"清除缓存"];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.bounces = NO;
    myTableView.dataSource = self;
    myTableView.rowHeight = (50)*AUTO_SIZE_SCALE_X+1;
    
    [myTableView setTableFooterView:self.footView];
    [self.view addSubview:myTableView];
    [self.footView addSubview:self.quitButton];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mydata.count;
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
    if (indexPath.row == 0) {
        cell.textLabel.text = @"账号安全";
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-7*AUTO_SIZE_SCALE_X-15, 18*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
        arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        [cell addSubview:arrowImageView];
        
        
    }
    
    
    if (indexPath.row == 1) {
        NSString *fileSize = [LBClearCacheTool getCacheSizeWithFilePath:filePath];
        if ([fileSize integerValue] == 0) {
            cell.textLabel.text = @"清除缓存";
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",mydata[indexPath.row],fileSize];
        }
    }
    
   
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    cell.textLabel.textColor = FontUIColorBlack;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1&&indexPath.section==0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清除缓存吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [MobClick event:kClearCacheEvent];
            //清楚缓存
            BOOL isSuccess = [LBClearCacheTool clearCacheWithFilePath:filePath];
            if (isSuccess) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
            
            
        }   ];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //添加一个文本框到弹框控制器
        
        
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    if (indexPath.row == 0) {
        AccoutnSecurityController *vc =[[AccoutnSecurityController alloc] init];
        vc.titles =@"账号安全";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


-(UIView *)footView{
    if (_footView==nil) {
        self.footView = [UIView new];
        self.footView.frame = CGRectMake(0, 0,  kScreenWidth, 118/2*AUTO_SIZE_SCALE_X);
        self.footView.backgroundColor  = [UIColor clearColor];
    }
    return _footView;
}

-(UIButton *)quitButton{
    if (_quitButton==nil) {
        self.quitButton = [UIButton new];
        self.quitButton.frame = CGRectMake(0, 9*AUTO_SIZE_SCALE_X,  kScreenWidth, 100/2*AUTO_SIZE_SCALE_X);
        [self.quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.quitButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        self.quitButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.quitButton.backgroundColor = [UIColor whiteColor];
        [self.quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

-(void)quitButtonClick{
    //可更新
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要退出么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        
    }
    if(buttonIndex == 1)
    {
        
        [MobClick event:kQuitOnClickEvent];
        NSDictionary * dic = @{
                               @"qtx_auth":[[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"],
                               };
        
        [[RequestManager shareRequestManager] QuitResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"qtx_auth"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"qtx_auth"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
        }];
      
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSettingPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSettingPage];
}


@end
