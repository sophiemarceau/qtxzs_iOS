//
//  SharedView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SharedView.h"
#import "SharedcellTableViewCell.h"
@implementation SharedView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}


- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *topbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-400/2*AUTO_SIZE_SCALE_X)];
    topbgView.alpha = 0.4;
    topbgView.backgroundColor = [UIColor blackColor];
    [self addSubview:topbgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-400/2*AUTO_SIZE_SCALE_X, kScreenWidth, 400/2*AUTO_SIZE_SCALE_X)];
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    self.bgclickview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400/2*AUTO_SIZE_SCALE_X)];
    self.bgclickview.backgroundColor = [UIColor whiteColor];
    self.lineImageView = [UIImageView new];
    self.lineImageView.frame = CGRectMake(0, self.bgclickview.frame.size.height-48*AUTO_SIZE_SCALE_X+1, kScreenWidth, 0.5);
    self.lineImageView.backgroundColor = lineImageColor;
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,self.bgclickview.frame.size.height-48*AUTO_SIZE_SCALE_X,kScreenWidth, 48*AUTO_SIZE_SCALE_X)];
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelLabel.text = @"取消分享";
    self.cancelLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    self.cancelLabel.textColor = FontUIColorBlack;
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    UIImageView *cancelImageview= [UIImageView new];
    cancelImageview.frame = CGRectMake(0 ,self.bgclickview.frame.size.height-48*AUTO_SIZE_SCALE_X,kScreenWidth, 48*AUTO_SIZE_SCALE_X);
    self.cancelLabel.userInteractionEnabled = YES;
    self.bgclickview.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    cancelImageview.userInteractionEnabled = YES;
    [cancelImageview addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    topbgView.userInteractionEnabled = YES;
    [topbgView addGestureRecognizer:tapGesture1];
    [bgView addSubview:self.bgclickview];

    [self.bgclickview addSubview:self.lineImageView];
    [self.bgclickview addSubview:self.cancelLabel];
    [self.bgclickview addSubview:cancelImageview];

    myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [myTableView.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    myTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    myTableView.dataSource = self;
    myTableView.delegate  = self;
    
    myTableView.scrollEnabled = YES;
    myTableView.userInteractionEnabled = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView registerClass:[SharedcellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SharedcellTableViewCell class])];
    myTableView.frame = CGRectMake(0, self.bgclickview.frame.size.height-48*AUTO_SIZE_SCALE_X, kScreenWidth, self.bgclickview.frame.size.height-48*AUTO_SIZE_SCALE_X);
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView setBackgroundColor:[UIColor whiteColor]];
    [self.bgclickview addSubview:myTableView];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dicarray.count == 4) {
        return myTableView.rowHeight = kScreenWidth/4;
    }else {
        return myTableView.rowHeight = 80*AUTO_SIZE_SCALE_X;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dicarray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    SharedcellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SharedcellTableViewCell class]) forIndexPath:indexPath];
    cell.shareCountFlag = (int)self.dicarray.count;
    cell.dictionary = self.dicarray[indexPath.row];

    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissContactView];
    [self.delegate SelectSharedTypeDelegateReturnPage:self.dicarray[indexPath.row]];
}


#pragma mark - 手势点击事件,移除View
- (void)dismissView:(UITapGestureRecognizer *)tapGesture{
    [self dismissContactView];
}

-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
//        weakSelf.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

// 这里加载在了window上
-(void)showView
{
    [UIView animateWithDuration:0.25 animations:^{
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        [window addSubview:self];
//        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }completion:^(BOOL finished) {
        
    }];

}

//-(UIImageView *)wechatImageView{
//    if (_wechatImageView == nil) {
//        _wechatImageView = [UIImageView new];
//        _wechatImageView.image = [UIImage imageNamed:@"icon-invitation-weixin"];
//        self.wechatImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
//        self.wechatImageView.frame = CGRectMake(73*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
//        self.wechatImageView.layer.masksToBounds = YES;
//        
//    }
//    return _wechatImageView;
//}
//
//-(UIImageView *)wechatFriendImageView{
//    if (_wechatFriendImageView == nil) {
//        _wechatFriendImageView = [UIImageView new];
//        _wechatFriendImageView.image = [UIImage imageNamed:@"icon-invitation-pyq"];
//        self.wechatFriendImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
//        self.wechatFriendImageView.frame = CGRectMake(kScreenWidth-(73*AUTO_SIZE_SCALE_X)-50*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
//        self.wechatFriendImageView.layer.masksToBounds = YES;
//        
//    }
//    return _wechatFriendImageView;
//}



@end
