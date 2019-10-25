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
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *guideImages = @[
                             @"01",
                             @"02",
                             @"03",
//                             @"引导页_1@2x",
//                             @"引导页_2@2x",
//                             @"引导页_3@2x",
                             //                             @"Guide_ydy-4.png",
                             //                             @"Guide_ydy-5.png",
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
            UIButton *button = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(intoButtonAction:) Title:@""];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor =[UIColor clearColor];
            button.frame = CGRectMake(100*AUTO_SIZE_SCALE_X, kScreenHeight-75*AUTO_SIZE_SCALE_X, kScreenWidth-200*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
            [guideImageView addSubview:button];
            guideImageView.userInteractionEnabled = YES;
        }
    }

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
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
