//
//  timelineViewController.m
//  wecoo
//
//  Created by 屈小波 on 2016/10/27.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "timelineViewController.h"
#import "noWifiView.h"
#import "timeTableViewCell.h"
#import "publicTableViewCell.h"

@interface timelineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    noWifiView *failView;
    timeTableViewCell *cell;
}
@property (nonatomic,strong)UITableView *timeTableView;
@property (nonatomic,strong)NSMutableArray *mydata;
@end

@implementation timelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mydata = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.timeTableView];
    [self initData];
   
    
}
-(void)initData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.mydata removeAllObjects];
//    [self.mydata addObjectsFromArray: [[NSArray alloc] initWithObjects:@"老夫聊发少年狂，治肾亏，不含糖。",
//    @"夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
//                                       @"啦啦啦",
//                                       @"老夫聊发少年狂，治肾亏，不含糖。",
//                                       @"锦帽貂裘，千骑用康王。",
//                                       @"",
//                                       @"为报倾城随太守，三百年，九芝堂。酒酣胸胆尚开张，西瓜霜，喜之郎。",
//                                       @"持节云中，三金葡萄糖。会挽雕弓如满月，西北望 ，阿迪王。",
//                                       @"十年生死两茫茫，恒源祥，羊羊羊。",
//                                       @"千里孤坟，洗衣用奇强。",
//                                       @"纵使相逢应不识，补维C，施尔康。",
//                                       @"夜来幽梦忽还乡，学外语，新东方。相顾无言，洗洗更健康。得年年断肠处，找工作，富士康",
//                                       @"啦啦啦",nil]]
//   ;

    NSDictionary *dic = @{
                          
                          @"report_id":self.report_id,
                          };
    NSLog(@"dic-----%@",dic);
    [[RequestManager shareRequestManager] SearchReportProgressResult:dic viewController:self successData:^(NSDictionary *result){
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
        if(IsSucess(result)){
            NSArray * array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil)
            {
                [self.mydata addObjectsFromArray:array];
               
            }else{
            }
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(UITableView *)timeTableView{
    if (_timeTableView == nil) {
        self.timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) ];
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
        failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kTabHeight)];
        [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        failView.hidden = YES;
        [self.view addSubview:failView];
        
    }
    return _timeTableView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    
    [self initData];
}

#pragma mark - TabelView数据源协议
//该方法指定了表格视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"count---%lu",(unsigned long)self.mydata.count);
    return self.mydata.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"timeTableViewCell";
    //按时间分组，假设这里[0,2],[3,5],[6,9]是同一天
     cell = [[timeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    if (indexPath.row==0) {
         return [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"]  isHighLighted:YES isRedColor:YES isZero:YES isLastData:NO];
    }else {
        return [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"]  isHighLighted:NO isRedColor:NO isZero:NO isLastData:YES];
    }
    
//    if(self.mydata.count-1==indexPath.row)
 
}

//该方法返回单元格对象，有多少行表格，则调用多少次
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"timeTableViewCell";
    cell =(timeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell = [[timeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setTag:[indexPath row]];
    }
    CGFloat height;
    if (indexPath.row==0) {
        height = [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"] isHighLighted:YES isRedColor:YES isZero:YES isLastData:NO];
    }else {
        height = [cell setCellHeight:[[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_note"] isHighLighted:NO isRedColor:NO isZero:NO isLastData:YES];
    }
    
    if(indexPath.row==0){
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, cell.timeImageView.frame.origin.y+cell.timeImageView.frame.size.height, 0.5, height-(cell.timeImageView.frame.origin.y+cell.timeImageView.frame.size.height));
        
    }else if(indexPath.row ==self.mydata.count-1){
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, 0, 0.5, cell.timeImageView.frame.origin.y);
    }else{
        [cell addSubview:cell.lineImageView];
        cell.lineImageView.frame = CGRectMake(17*AUTO_SIZE_SCALE_X, 0,0.5, height);
    }
    if(indexPath.row == self.mydata.count -1&&self.mydata.count == 1){
        cell.lineImageView.hidden = YES;
    }else{
        cell.lineImageView.hidden = NO;
    }
    cell.lbDate.text = [[self.mydata objectAtIndex:indexPath.row] objectForKey:@"crl_createdtime"];
    return  cell;

}

#pragma mark - TabelView代理协议
//选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     NSLog(@"count---%lu",(unsigned long)indexPath.row);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kMessageTimelinePage];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMessageTimelinePage];
}

@end
