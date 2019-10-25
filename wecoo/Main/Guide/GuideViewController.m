//
//  GuideViewController.m
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/18.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *intoButton;

@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *guideImages = @[
                             @"01-1242x2208",
                             @"02-1242x2208",
                             @"03-1242x2208",
                             ];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth*guideImages.count, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    //bottom  480/3 =    500*145
    
    for (int i = 0; i < guideImages.count; i++) {
        NSString *guideImageName = guideImages[i];
        //创建操作指南图片视图
        UIImageView *guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:guideImageName]];
        guideImageView.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:guideImageView];
        
        if (i == guideImages.count -1) {
            UIButton *button = [CommentMethod createButtonWithImageName:@"btn-loading" Target:self Action:@selector(intoButtonAction:) Title:@""];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor =[UIColor clearColor];
            button.frame = CGRectMake(100*AUTO_SIZE_SCALE_X, kScreenHeight-75*AUTO_SIZE_SCALE_X, kScreenWidth-200*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
            [guideImageView addSubview:button];
            guideImageView.userInteractionEnabled = YES;
        }
    }
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-30*AUTO_SIZE_SCALE_X, kScreenWidth, 30)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = NO;
    self.pageControl.selected = NO;
    [self.view addSubview:self.pageControl];  //将UIPageControl添加到主界面上。

}

- (void)intoButtonAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //滑动到末尾，这两个值是相等的：
    //scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.width
    CGFloat width =  scrollView.contentSize.width;
    CGFloat scWidth = scrollView.frame.size.width;
    CGFloat  sub = scrollView.contentOffset.x -width+ scWidth;
    if (sub > 30) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
        
        
        
//        MainViewController *main = [[MainViewController alloc]init];
//        /*
//         如果视图view直接或间接的显示在window上,则通过view.window能获取到window对象
//         */
//        self.view.window.rootViewController = main;
//        
//        //放大动画
//        main.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.6];
//        main.view.transform = CGAffineTransformIdentity;//还原
//        [UIView commitAnimations];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //更新UIPageControl的当前页
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kGuideViewPage];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kGuideViewPage];
}

@end
