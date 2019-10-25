//
//  MyController.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "MyHeadView.h"
#import "myReportView.h"


@interface MyController : BaseViewController
@property (nonatomic,strong)MyHeadView *myheadView;
@property (nonatomic,strong)myReportView *myReportView;
@property (nonatomic,strong)UIView *MyTableHeadView;
@property (nonatomic,strong)NSMutableArray *mydata;


-(void)pushview;

-(void)pushMyInviteView;
@end
