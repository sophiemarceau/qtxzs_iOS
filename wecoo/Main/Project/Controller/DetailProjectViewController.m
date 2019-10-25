//
//  DetailProjectViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/22.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "DetailProjectViewController.h"
#import "MCStopView.h"
#import "MCTableViewController.h"
#import "SDCycleScrollView.h"
#import "CommissionNoteView.h"
#import "ShowMaskView.h"
#import "ReportViewController.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "YXTabView.h"
#import "YX.h"
#import "WebViewController.h"
#import "ShowShareView.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "noWifiView.h"
#import "WXApi.h"
#import "GuideView.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "alreadySignListViewController.h"

#define KSegmentBarHeight 45*AUTO_SIZE_SCALE_X

@interface DetailProjectViewController ()<SDCycleScrollViewDelegate,SelectSharedTypeDelegate>{
    NSDictionary *dto;
    MCStopView * stopView;
    Boolean isProjectCollected;
    NSMutableArray *titlesArray;
    NSMutableArray *projectsignList;
    NSArray *silkbagArrray;
    NSString *project_desc;
    NSString *project_policy;
    NSString *project_commission_note;
    noWifiView * failView;
    NSDictionary *result1;
    NSDictionary *result2;
    NSDictionary *result3;
    NSDictionary *result4;
    NSError *error1;NSError *error2;NSError *error3;NSError *error4;
    UIView *indicateLine;
    
    NSString *image_url;
}

@property(nonatomic,strong)UIView *prepareHeaderView;
@property(nonatomic,strong)UILabel *subtitleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UILabel *alreadySignedLabel;
@property(nonatomic,strong)UILabel *commisionLabel;
@property(nonatomic,strong)UIImageView *arrowImageView1;
@property(nonatomic,strong)UIImageView *arrowImageView2;
@property(nonatomic,strong)UIImageView *voiceImageView2;
@property(nonatomic,strong)UIImageView *cancelImageView2;
@property(nonatomic,strong)UIView *cycleView;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView4;
@property(nonatomic,strong)UIView *collectView;
@property(nonatomic,strong)UIImageView *collectImageView;
@property(nonatomic,strong)UILabel *collectLabel;
@property(nonatomic,strong)UIButton *reportButton;
@property(nonatomic,strong)YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,strong)UIButton *directButton;
@property(nonatomic,strong)UIView *buttonImageView;
@property(nonatomic,strong)UIView *buttonImageView2;


@end

@implementation DetailProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kProjectDetailToPost object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(towebview:) name:kProjectDetailToPost object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kfinishLoadingView object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:kfinishLoadingView object:nil];

    
    [self initNavBarView];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    [self loadData];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

-(void)finish: (NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [LZBLoadingView dismissLoadingView];
  
    });
}



-(void)towebview : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"silk"];
    WebViewController *vc = [[WebViewController alloc] init];
    vc.webViewurl = canScroll;
    vc.fromWhere = @"silk";
    vc.webtitle = userInfo[@"webdesc"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0.;
        if (section==0) {
            height = [self prepareHeaderView].frame.size.height;
        }else if(section==1){
            height = CGRectGetHeight(self.view.frame)-kNavHeight-kTabTitleViewHeight;
        }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    if (section==0) {
        [cell.contentView addSubview:self.prepareHeaderView];
    }else if(section==1){
        NSArray *tabConfigArray = @[
                                            @{
                                            @"title":@"项目介绍",
                                            @"view":@"ProjectIntrduceTableView",
                                            @"data":project_desc,
                                            @"position":@0
                                            },
                                            @{
                                            @"title":@"招商详情",
                                            @"view":@"InvestmentDetailTableViw",
                                            @"data":project_policy,
                                            @"position":@1
                                            },
                                            @{
                                            @"title":@"锦囊",
                                            @"view":@"CommentView",
                                            @"data":silkbagArrray,
                                            @"position":@2
                                            }
                                            ];
        YXTabView *tabView = [[YXTabView alloc] initWithTabConfigArray:tabConfigArray];
        UIView * Line = [[UIView alloc] initWithFrame:CGRectMake(0, kTabTitleViewHeight*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5)];
        Line.backgroundColor = lineImageColor;
        [tabView addSubview:Line];
        [cell.contentView addSubview:tabView];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = round([_tableView rectForSection:1].origin.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY+1>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            
//            NSLog(@"滑动到顶端---------->%f",offsetY);
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
//            NSLog(@"离开顶端");
//            NSLog(@"离开顶端---------->%f",offsetY);
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 1;

    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
   [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    
     failView.hidden = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{
                              @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                              };
        
        [[RequestManager shareRequestManager] GetProjectDtoResult:dic0 viewController:self successData:^(NSDictionary *result){
            result1= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error1 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
   // 将第2个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
       
        NSDictionary *dic1 = @{
                              @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                              };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] IsProjectCollectedResult:dic1 viewController:self successData:^(NSDictionary *result){
            result2= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){

            error2 = error;
            NSLog(@"失败请求数据");
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        
        
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
     // 将第3个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic3 = @{
                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                               };
        // 开始网络请求任务

        [[RequestManager shareRequestManager] SearchReportListSignedUpDtoListResult:dic3 viewController:self successData:^(NSDictionary *result){
            result3= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error3 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });

    
    // 将第3个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic4 = @{
                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                               };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] AddProjectBrowsingRecordesult:dic4 viewController:self successData:^(NSDictionary *result){
            
            result4= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error4 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if (error1!=nil||error2!=nil||error3!=nil||error4!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
           
        }else{
//            NSLog(@"成功请求数据=1:%@",result1);
//            NSLog(@"成功请求数据=2:%@",result2);
//            NSLog(@"成功请求数据=3:%@",result3);
//            NSLog(@"成功请求数据=4:%@",result4);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更UI5
                [self initUIView];
               

            });
        }
    });
}


-(void)initUIView{
    if(IsSucess(result1)){
        dto = [[result1 objectForKey:@"data"] objectForKey:@"dto"];
        if(![dto isEqual:[NSNull null]]){
            self.titles =[dto objectForKey:@"project_name"];
            image_url = [dto objectForKey:@"project_pic_square"];
            self.subtitleLabel.text = dto[@"project_slogan"];
            self.descLabel.text = dto[@"project_strengths"];
            [self.descLabel sizeToFit];
            self.descLabel.frame =CGRectMake(self.descLabel.frame.origin.x, self.descLabel.frame.origin.y,self.descLabel.frame.size.width, self.descLabel.frame.size.height);
            NSString *countstr = [NSString stringWithFormat:@"%d",[[dto [@"projectExtDto"] objectForKey:@"pe_signed_count"]  intValue]];
            if (![countstr isEqual:[NSNull null]]&& (countstr.length>0)) {
                [self returnlable:self.alreadySignedLabel WithString:countstr Withindex:2 WithDocument:@"成交" WithDoc1:@"笔"];
            }
            int first = [[dto objectForKey:@"project_commission_first"] intValue];
            int second = [[dto objectForKey:@"project_commission_second"] intValue];
            NSString *str ;
            NSString *contentString;
            NSInteger index;
            
            if (first==second) {
                str = [NSString stringWithFormat:@"%@",@"签约佣金"];
                index = [str length];
                contentString = [NSString stringWithFormat:@"%d",first];
            }else{
                str = [NSString stringWithFormat:@"%@",@"签约佣金"];
                index = [str length];
                
                if(first > second){
                    
                    contentString = [NSString stringWithFormat:@"%d-%d",second,first];
                }else{
                    contentString = [NSString stringWithFormat:@"%d-%d",first,second];
                }
            }
            [self returnlable:self.commisionLabel WithString:contentString Withindex:index WithDocument:str WithDoc1:@"元"];
            
            self.alreadySignedLabel.frame = CGRectMake(15, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+5*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
            self.arrowImageView1.frame = CGRectMake(self.alreadySignedLabel.frame.origin.x
                                                    +self.alreadySignedLabel.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+10*AUTO_SIZE_SCALE_X,
                                                    7*AUTO_SIZE_SCALE_X,
                                                    13*AUTO_SIZE_SCALE_X);
            self.buttonImageView.frame = CGRectMake(self.alreadySignedLabel.frame.origin.x, self.alreadySignedLabel.frame.origin.y, self.alreadySignedLabel.frame.size.width+self.arrowImageView1.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.alreadySignedLabel.frame.size.height);
            self.arrowImageView2.frame = CGRectMake(self.commisionLabel.frame.origin.x
                                                    +self.commisionLabel.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+10*AUTO_SIZE_SCALE_X,
                                                    7*AUTO_SIZE_SCALE_X,
                                                    13*AUTO_SIZE_SCALE_X);
            self.buttonImageView2.frame = CGRectMake(self.commisionLabel.frame.origin.x, self.commisionLabel.frame.origin.y, self.commisionLabel.frame.size.width+self.arrowImageView2.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.commisionLabel.frame.size.height);
           
            titlesArray = [NSMutableArray new];
            NSString *messagestring = [dto objectForKey:@"project_message"];
            
            if (![messagestring isEqual:[NSNull null]] && (messagestring.length>0)) {
                NSArray *messagearray = [[RequestManager shareRequestManager] dictionaryWithJsonString:messagestring];
                if(![messagearray isEqual:[NSNull null]] && messagearray.count>0){
                    for (NSDictionary *dictemp in messagearray) {
                        [titlesArray addObject:[dictemp objectForKey:@"msg"]];
                    }
                }
            }
            indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0,(self.commisionLabel.frame.origin.y+self.commisionLabel.frame.size.height+5*AUTO_SIZE_SCALE_X-1), kScreenWidth, 0.5)];
            indicateLine.backgroundColor = lineImageColor;
            [self.prepareHeaderView addSubview:indicateLine];
            self.cycleScrollView4.titlesGroup = [titlesArray copy];
            if (titlesArray.count==0) {
                indicateLine.hidden = NO;
                self.cycleView.frame =CGRectZero;
                self.voiceImageView2.hidden = YES;
                self.cancelImageView2.hidden = YES;
                self.prepareHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.commisionLabel.frame.origin.y+self.commisionLabel.frame.size.height+5*AUTO_SIZE_SCALE_X);
            }else{
                indicateLine.hidden = YES;
                self.cycleView.frame =CGRectMake(0,
                                                 self.commisionLabel.frame.origin.y+self.commisionLabel.frame.size.height+5*AUTO_SIZE_SCALE_X,kScreenWidth,44*AUTO_SIZE_SCALE_X);
                self.prepareHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.cycleView.frame.origin.y+self.cycleView.frame.size.height+1);
            }
            

            silkbagArrray = [NSMutableArray new];
            NSString *bagstring = [dto objectForKey:@"project_silk_bag"];
            
            if (![bagstring isEqual:[NSNull null]] && (bagstring.length>0)) {
                silkbagArrray = [[RequestManager shareRequestManager] dictionaryWithJsonString:bagstring];
            }
            project_desc = [NSString stringWithFormat:@"%@%@",[dto [@"projectDescDto"] objectForKey:@"project_desc_url"],[NSString stringWithFormat:@"%ld",self.project_id]];
            project_policy = [NSString stringWithFormat:@"%@%@",[dto [@"projectDescDto"] objectForKey:@"project_policy_url"],[NSString stringWithFormat:@"%ld",self.project_id]];
            project_commission_note = [dto objectForKey:@"project_commission_note"];
            self.project_industry =[[dto objectForKey:@"project_industry"] integerValue];
//            NSLog(@"self.pro------industry--------->%d",self.project_industry);
            
            [self initUI];
        }
    }else{
        [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
    }
    if(IsSucess(result2)){
        Boolean flag = [[[result2 objectForKey:@"data"] objectForKey:@"result"] boolValue];
        if (flag) {
            self.collectImageView.image = [UIImage imageNamed:@"icon-collect-red"];
            self.collectLabel.text =@"已关注";
            isProjectCollected =YES;
        }else{
            self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
            self.collectLabel.text =@"关注";
            isProjectCollected = NO;
        }
    }else{
        [[RequestManager shareRequestManager] resultFail:result2 viewController:self];
    }
    if(IsSucess(result3)){
        NSArray *array = [[result3 objectForKey:@"data"] objectForKey:@"list"];
        projectsignList = [NSMutableArray arrayWithCapacity:0];
        if(![array isEqual:[NSNull null]] && array.count>0){
            [projectsignList addObjectsFromArray:array];
        }
    }else{
        [[RequestManager shareRequestManager] resultFail:result3 viewController:self];
    }
}

-(void)initUI{
    _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth, kScreenHeight-kNavHeight-kTabHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.reportButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

-(void)onAlreadySignedClick:(UITapGestureRecognizer *)sender{
//    if (projectsignList.count!=0) {
//         [MobClick event:kAlreadyEvent];
//    
//        ShowMaskView *show = [[ShowMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        show.signArray = projectsignList;
//        [show showView];
//        
//    }
    [MobClick event:kAlreadyEvent];
    alreadySignListViewController *vc = [[alreadySignListViewController alloc] init];
    vc.project_id =self.project_id;;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onCommssionlClick:(UITapGestureRecognizer *)sender{
     if(![project_commission_note isEqual:[NSNull null]] && project_commission_note !=nil && project_commission_note.length !=0){
         [MobClick event:kCommission_noteEvent];
        CommissionNoteView *show = [[CommissionNoteView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        show.noteString = project_commission_note;
        [show showView];
    }
}

-(void)onCollect:(UITapGestureRecognizer *)sender{
    [MobClick event:kProjectDetailCollectButtonclick];

    if (isProjectCollected) {
        NSDictionary *dic = @{
                              @"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],
                              };
        [[RequestManager shareRequestManager] ProjecDetailCancelCollectionRecordResult:dic viewController:self successData:^(NSDictionary *result){
            
            failView.hidden = YES;
            if(IsSucess(result)){
                Boolean flag = [[[result objectForKey:@"data"] objectForKey:@"result"] boolValue];
                if (flag) {
                    self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
                    isProjectCollected = NO;
                     self.collectLabel.text =@"关注";
                    [[RequestManager shareRequestManager] tipAlert:@"已取消关注" viewController:self];

                }else{
                    self.collectImageView.image = [UIImage imageNamed:@"icon-collect-red"];
                    isProjectCollected =YES;
                    self.collectLabel.text =@"关注";
                }
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){
            
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            failView.hidden = NO;
        }];
    }else{
        NSDictionary * dic = @{@"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],};
        [[RequestManager shareRequestManager] AddProjectCollectionRecordResult:dic viewController:self successData:^(NSDictionary *result){
            
            failView.hidden = YES;
            if(IsSucess(result)){
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
                isProjectCollected =YES;
                  self.collectImageView.image = [UIImage imageNamed:@"icon-collect-red"];
                self.collectLabel.text =@"已关注";

                [[RequestManager shareRequestManager] tipAlert:@"关注成功" viewController:self];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
                isProjectCollected =NO;
                self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
                 self.collectLabel.text =@"关注";
            }
        }failuer:^(NSError *error){
            
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            failView.hidden = NO;
        }];
    }
}

-(void)onCancelClick:(UITapGestureRecognizer *)sender{
    [MobClick event:kHiddenViewEvent];
    [self onHiddenView];
}

-(void)onHiddenView{
    [MobClick event:kProjectDetailCollectButtonclick];
    [_tableView beginUpdates];
    indicateLine.hidden = NO;
    [self.cycleView removeFromSuperview];
    self.prepareHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.commisionLabel.frame.origin.y+self.commisionLabel.frame.size.height+5*AUTO_SIZE_SCALE_X);
    [_tableView endUpdates];
}

-(void)onclickButton:(UIButton *)sender{
    [MobClick event:kProjectDetailonClickEvent];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] isReportAllowedResult :dic viewController:self successData:^(NSDictionary *result){
        
        if(IsSucess(result)){
            int  Flag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            if (Flag == 1) {
                ReportViewController *vc = [[ReportViewController alloc]init];
                vc.tradecode = [NSString stringWithFormat:@"%ld",(long)self.project_industry];
                vc.project_id = [NSString stringWithFormat:@"%ld",(long)self.project_id];
                vc.titles = @"推荐客户";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[RequestManager shareRequestManager] tipAlert:@"您暂不允许报备" viewController:self];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        sender.enabled = YES;
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        sender.enabled = YES;
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString *titles = self.subtitleLabel.text;
    NSString *desc = @"大众创业，万众创新，美好生活从发现好项目开始";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:desc thumImage:image_url];
    //设置网页地址"
    NSString *tempproject = [NSString stringWithFormat:@"projectDetails.html?project_id=%ld&user_id=%@",self.project_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    
    shareObject.webpageUrl =[NSString stringWithFormat:@"%@%@",BaseURLHTMLString,tempproject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

-(void)shareClick:(UIButton *)sender{
    [MobClick event:kShareProjectDetailEvent];
    SharedView *show = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    show.dicarray = @[
                      
                      @{@"icon-image":@"icon-shareWeixin",@"value":@"微信好友",@"shareflag":@"1"},
                      @{@"icon-image":@"icon-sharePyq",@"value":@"朋友圈",@"shareflag":@"2"},
                      @{@"icon-image":@"icon-shareQQ",@"value":@"QQ好友",@"shareflag":@"3"},
                      @{@"icon-image":@"icon-shareQzone@3x",@"value":@"QQ空间",@"shareflag":@"4"},
                      ] ;
    show.delegate = self;
    [show showView];
}

-(void)SelectSharedTypeDelegateReturnPage:(NSDictionary *)returnTypeDic{
    NSString *shared = returnTypeDic[@"shareflag"];
    if ([shared isEqualToString:@"1"]||[shared isEqualToString:@"2"]) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"您的设备没有安装微信"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if ([shared isEqualToString:@"1"]) {
        [MobClick event:kShareWechatFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    
    if ([shared isEqualToString:@"2"]) {
        [MobClick event:kShareWechatCircleOfFriend];
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if ([shared isEqualToString:@"0"]) {
        
       
    }
    if ([shared isEqualToString:@"3"]) {
        [self isQQInstall];
        [MobClick event:kShareQQFriendEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if ([shared isEqualToString:@"4"]) {
        [self isQQInstall];
        [MobClick event:kShareQQSpaceEvent];
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
    
}

-(void)isQQInstall{
    if (![QQApiInterface isQQInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的设备没有安装QQ"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kProjecrDetailPage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kProjecrDetailPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (self.newGuideFlag ==1) {
        GuideView *guide = [GuideView new];
        [guide showInView:self.view maskBtn:self.reportButton];
        self.newGuideFlag = 0;
    }
    
    
    
    
    
    
//    self.reportButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(onclickButton:) Title:@"报备客户" FontColor:[UIColor whiteColor] FontSize:14*AUTO_SIZE_SCALE_X];
//    
//    self.reportButton.frame = CGRectMake(self.collectView.frame.origin.x+self.collectView.frame.size.width, kScreenHeight-kTabHeight, kScreenWidth-self.collectView.frame.size.width, kTabHeight);

    
}

#pragma 懒加载
-(UIView *)prepareHeaderView{
    if(_prepareHeaderView==nil){
        self.prepareHeaderView = [UIView new];
        self.prepareHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 376/2*AUTO_SIZE_SCALE_X+1);
        self.prepareHeaderView.backgroundColor = [UIColor clearColor];
        [self.prepareHeaderView addSubview:self.subtitleLabel];
        [self.prepareHeaderView addSubview:self.descLabel];
        [self.prepareHeaderView addSubview:self.alreadySignedLabel];
        [self.prepareHeaderView addSubview:self.arrowImageView1];
        [self.prepareHeaderView addSubview:self.buttonImageView];
        [self.prepareHeaderView addSubview:self.buttonImageView2];
        [self.prepareHeaderView addSubview:self.commisionLabel];
        [self.prepareHeaderView addSubview:self.arrowImageView2];
        [self.cycleView addSubview:self.voiceImageView2];
        [self.cycleView addSubview:self.cancelImageView2];
        [self.prepareHeaderView addSubview:self.cycleView];
        [self.cycleView addSubview:self.cycleScrollView4];
    }
    return _prepareHeaderView;
}

-(UILabel *)subtitleLabel{
    if (_subtitleLabel == nil) {
        self.subtitleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.textColor = FontUIColorBlack;
        self.subtitleLabel.frame = CGRectMake(15, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30, 18*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        self.descLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.descLabel.textColor = FontUIColorGray;
        self.descLabel.frame =CGRectMake(15, self.subtitleLabel.frame.origin.y+self.subtitleLabel.frame.size.height+8*AUTO_SIZE_SCALE_X, kScreenWidth-30,136/2*AUTO_SIZE_SCALE_X);
        [self.descLabel setNumberOfLines:0];
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.descLabel.text = @"";
    }
    return _descLabel;
}

-(UILabel *)alreadySignedLabel{
    if (_alreadySignedLabel == nil) {
        self.alreadySignedLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.alreadySignedLabel.textColor = FontUIColorGray;
        self.alreadySignedLabel.frame = CGRectMake(15, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+5*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _alreadySignedLabel;
}

-(UILabel *)commisionLabel{
    if (_commisionLabel == nil) {
        self.commisionLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.commisionLabel.textColor = FontUIColorGray;
        self.commisionLabel.frame = CGRectMake(self.arrowImageView1.frame.origin.x
                                               +self.arrowImageView1.frame.size.width+35*AUTO_SIZE_SCALE_X,
                                               self.descLabel.frame.size.height+self.descLabel.frame.origin.y+5*AUTO_SIZE_SCALE_X,
                                               110*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X);
    }
    return _commisionLabel;
}

-(UIImageView *)arrowImageView1{
    if (_arrowImageView1 == nil) {
        self.arrowImageView1 = [UIImageView new];
        self.arrowImageView1.image = [UIImage imageNamed:@"icon-arrowRrightRed"];
        self.arrowImageView1.frame = CGRectMake(self.alreadySignedLabel.frame.origin.x
                                               +self.alreadySignedLabel.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+8*AUTO_SIZE_SCALE_X,
                                                7*AUTO_SIZE_SCALE_X,
                                                13*AUTO_SIZE_SCALE_X);
    }
    return  _arrowImageView1;
}


-(UIView *)buttonImageView{
    if(_buttonImageView == nil ){
        self.buttonImageView = [UIView new];
        self.buttonImageView.frame = CGRectMake(self.alreadySignedLabel.frame.origin.x, self.alreadySignedLabel.frame.origin.y, self.alreadySignedLabel.frame.size.width+self.arrowImageView1.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.alreadySignedLabel.frame.size.height);
        UITapGestureRecognizer *arrow1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAlreadySignedClick:)];
        self.buttonImageView.userInteractionEnabled = YES;
        [self.buttonImageView addGestureRecognizer:arrow1];
        
    }
    return _buttonImageView;
}

-(UIImageView *)arrowImageView2{
    if (_arrowImageView2 == nil) {
        self.arrowImageView2 = [UIImageView new];
        self.arrowImageView2.image = [UIImage imageNamed:@"icon-arrowRrightRed"];
        self.arrowImageView2.frame = CGRectMake(self.commisionLabel.frame.origin.x
                                                +self.commisionLabel.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.descLabel.frame.size.height+self.descLabel.frame.origin.y+8*AUTO_SIZE_SCALE_X,
                                                7*AUTO_SIZE_SCALE_X,
                                                13*AUTO_SIZE_SCALE_X);
        
        UITapGestureRecognizer *arrow2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCommssionlClick:)];
        self.arrowImageView2.userInteractionEnabled = YES;
        [self.arrowImageView2 addGestureRecognizer:arrow2];
    }
    return  _arrowImageView2;
}

-(UIView *)buttonImageView2{
    if(_buttonImageView2 == nil) {
        self.buttonImageView2 = [UIView new];
        self.buttonImageView2.frame = CGRectMake(self.commisionLabel.frame.origin.x, self.commisionLabel.frame.origin.y, self.commisionLabel.frame.size.width+self.arrowImageView2.frame.size.width+15/2*AUTO_SIZE_SCALE_X, self.commisionLabel.frame.size.height);
        UITapGestureRecognizer *arrow2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCommssionlClick:)];
        self.buttonImageView2.userInteractionEnabled = YES;
        [self.buttonImageView2 addGestureRecognizer:arrow2];
    }
    return _buttonImageView2;
}

-(UIImageView *)voiceImageView2{
    if (_voiceImageView2 == nil) {
        self.voiceImageView2 = [UIImageView new];
        self.voiceImageView2.image = [UIImage imageNamed:@"icon-broadcast"];
        self.voiceImageView2.frame = CGRectMake(15,(44-17)/2*AUTO_SIZE_SCALE_X,17*AUTO_SIZE_SCALE_X,17*AUTO_SIZE_SCALE_X);
    }
    return  _voiceImageView2;
}

-(UIImageView *)cancelImageView2{
    if (_cancelImageView2 == nil) {
        self.cancelImageView2 = [UIImageView new];
        self.cancelImageView2.image = [UIImage imageNamed:@"icon-broadcast-close"];
        self.cancelImageView2.frame = CGRectMake(kScreenWidth-15-18*AUTO_SIZE_SCALE_X,(44-18)/2*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer *cancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelClick:)];
        self.cancelImageView2.userInteractionEnabled = YES;
        [self.cancelImageView2 addGestureRecognizer:cancel];
        
    }
    return  _cancelImageView2;
}

-(UIView *)cycleView{
    if (_cycleView == nil) {
        self.cycleView = [UIView new];
        self.cycleView.backgroundColor = UIColorFromRGB(0xff9496);        
        self.cycleView.frame =CGRectMake(0,
        self.commisionLabel.frame.origin.y+self.commisionLabel.frame.size.height,kScreenWidth,44*AUTO_SIZE_SCALE_X);
    }
    return  _cycleView;
}

-(SDCycleScrollView *)cycleScrollView4{
    if (_cycleScrollView4 == nil) {
        self.cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( self.voiceImageView2.frame.size.width+self.voiceImageView2.frame.origin.x+10*AUTO_SIZE_SCALE_X,
                                                                                                     0,
                                                                                                     kScreenWidth-(self.voiceImageView2.frame.size.width+self.voiceImageView2.frame.origin.x+10*AUTO_SIZE_SCALE_X)-(self.cancelImageView2.frame.size.width+15), 44*AUTO_SIZE_SCALE_X) delegate:self placeholderImage:nil];
        self.cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.cycleScrollView4.onlyDisplayText = YES;
    }
    return _cycleScrollView4;
    
}


-(UIView *)collectView{
    if (_collectView == nil) {
        self.collectView = [UIView new];
        self.collectView.backgroundColor = UIColorFromRGB(0xffffff);
        self.collectView.frame =CGRectMake(0,
                                         kScreenHeight-kTabHeight,
                                         231/2*AUTO_SIZE_SCALE_X,
                                         kTabHeight);
        [self.collectView addSubview:self.collectImageView];
        [self.collectView addSubview:self.collectLabel];
        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCollect:)];
        self.collectView.userInteractionEnabled = YES;
        [self.collectView addGestureRecognizer:collect];
        UIImageView *lineimageview= [[UIImageView alloc] init];
        lineimageview.backgroundColor = lineImageColor;
        lineimageview.frame = CGRectMake(0, 0, self.collectView.frame.size.width, 0.5);
        [self.collectView addSubview:lineimageview];
      
    }
    return  _collectView;
}

-(UIButton *)reportButton{
    if (_reportButton == nil) {
        self.reportButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(onclickButton:) Title:@"推荐客户" FontColor:[UIColor whiteColor] FontSize:14*AUTO_SIZE_SCALE_X];
        
        self.reportButton.frame = CGRectMake(self.collectView.frame.origin.x+self.collectView.frame.size.width, kScreenHeight-kTabHeight, kScreenWidth-self.collectView.frame.size.width, kTabHeight);
       
    }
    return _reportButton;
}

-(UILabel *)collectLabel{
    if (_collectLabel == nil) {
        self.collectLabel = [CommentMethod initLabelWithText:@"关注" textAlignment:NSTextAlignmentCenter font:12*AUTO_SIZE_SCALE_X];
        self.collectLabel.textColor = FontUIColorGray;
        self.collectLabel.frame = CGRectMake(0,
                                               self.collectImageView.frame.size.height+self.collectImageView.frame.origin.y,
                                               self.collectView.frame.size.width    ,
                                               self.collectView.frame.size.height-self.collectImageView.frame.size.height-self.collectImageView.frame.origin.y);
    }
    return _collectLabel;
}

-(UIImageView *)collectImageView{
    
    if (_collectImageView == nil) {
        self.collectImageView = [UIImageView new];
        self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
        self.collectImageView.frame = CGRectMake((self.collectView.frame.size.width-21*AUTO_SIZE_SCALE_X)/2,
                                                 (7*AUTO_SIZE_SCALE_X),
                                                 21*AUTO_SIZE_SCALE_X,
                                                 20*AUTO_SIZE_SCALE_X);
    }
    return  _collectImageView;
}

- (UIButton *)directButton {
    if (_directButton == nil) {
        self.directButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directButton setTitle:@"" forState:UIControlStateNormal];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(60-21, 4.5, 17, 21)];
        imv.image = [UIImage imageNamed:@"icon-header-share"];
        [self.directButton addSubview:imv];
        [self.directButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directButton setBackgroundColor:[UIColor clearColor]];
        [self.directButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        self.directButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.directButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _directButton;
}

-(void)initNavBarView{
    [self.navView addSubview:self.directButton];
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom).offset(-7);
        make.right.equalTo(self.navView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

@end
