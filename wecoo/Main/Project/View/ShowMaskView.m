//
//  ShowMaskView.m
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "ShowMaskView.h"
#import "publicTableViewCell.h"

@implementation ShowMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 0.8;
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    self.ruleLabel =  [CommentMethod initLabelWithText:@"成交名单" textAlignment:NSTextAlignmentCenter font:20*AUTO_SIZE_SCALE_X];
    self.ruleLabel.textColor = [UIColor whiteColor];
    self.ruleLabel.frame =  CGRectMake(15, 90*AUTO_SIZE_SCALE_X, kScreenWidth-30, 20*AUTO_SIZE_SCALE_X);
    [self addSubview:self.ruleLabel];
 
    self.line1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.ruleLabel.frame.origin.y+self.ruleLabel.frame.size.height+ 25*AUTO_SIZE_SCALE_X, kScreenWidth-30, 0.5)];
    self.line1ImageView.backgroundColor = UIColorFromRGB(0xAAAAAA);
    [self addSubview:self.line1ImageView];
    
    [self addSubview:self.signTableView];
   
    self.signTableView.frame = CGRectMake(0, self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+30*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(self.line1ImageView.frame.origin.y+self.line1ImageView.frame.size.height+60*AUTO_SIZE_SCALE_X+95*AUTO_SIZE_SCALE_X));
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.image = [UIImage imageNamed:@"icon-close"];
    cancelImageview.frame = CGRectMake((kScreenWidth-50*AUTO_SIZE_SCALE_X)/2 ,kScreenHeight-95*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
    [self addSubview:cancelImageview];
}

#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    [self dismissContactView];
}

-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

-(void)showView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [self.signTableView reloadData];
    [window addSubview:self];
}

-(UITableView *)signTableView{
    if(_signTableView == nil){
        _signTableView = [[UITableView alloc] init];
        _signTableView.delegate = self;
        _signTableView.dataSource = self;
        _signTableView.bounces = NO;
        _signTableView.rowHeight = 30*AUTO_SIZE_SCALE_X;
        _signTableView.showsVerticalScrollIndicator = NO;
        _signTableView.backgroundColor = [UIColor clearColor];
        _signTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return  _signTableView;
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _signArray.count;
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
    cell.backgroundColor = [UIColor clearColor];
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30*AUTO_SIZE_SCALE_X)];
    
    NSString *namestring = [NSString stringWithFormat:@"%@ (%@)",[[_signArray objectAtIndex:indexPath.row] objectForKey:@"report_customer_name"],[[_signArray objectAtIndex:indexPath.row] objectForKey:@"report_customer_area_agent_name"]];
    UILabel *nameLabel = [CommentMethod createLabelWithText:namestring TextColor:[UIColor whiteColor] BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font: 13*AUTO_SIZE_SCALE_X];
    nameLabel.frame = CGRectMake(15, 0, kScreenWidth-90*AUTO_SIZE_SCALE_X-15-10, 30*AUTO_SIZE_SCALE_X);
    
//    UILabel *phoneLabel = [CommentMethod createLabelWithText:[[_signArray objectAtIndex:indexPath.row] objectForKey:@"report_customer_tel"] TextColor:[UIColor whiteColor] BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentRight Font: 13*AUTO_SIZE_SCALE_X];
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:13*AUTO_SIZE_SCALE_X];
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.text = [[_signArray objectAtIndex:indexPath.row] objectForKey:@"report_customer_tel"];
//    [CommentMethod createLabelWithFont:13*AUTO_SIZE_SCALE_X Text:[[_signArray objectAtIndex:indexPath.row] objectForKey:@"report_customer_tel"]];
     phoneLabel.font  = [UIFont fontWithName:@"Arial" size:13*AUTO_SIZE_SCALE_X];//设置文字类型与大小
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.frame = CGRectMake(kScreenWidth-90*AUTO_SIZE_SCALE_X-15, 0, 90*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
    
    [bgview addSubview:nameLabel];
    [bgview addSubview:phoneLabel];
    [cell addSubview:bgview];
    return cell;
}

-(void)setSignArray:(NSMutableArray *)signArray{
    _signArray = signArray;
}

@end
