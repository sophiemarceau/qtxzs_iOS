//
//  SharedView.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SelectSharedTypeDelegate<NSObject>
- (void)SelectSharedTypeDelegateReturnPage:(NSDictionary*)returnTypeDic;
@end

@interface SharedView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
}
@property (nonatomic, strong) UIView  *bgclickview;
//@property (nonatomic, strong) UIImageView  *wechatImageView;
//@property (nonatomic, strong) UILabel  *wechatLabel;
//
//@property (nonatomic, strong) UIImageView  *wechatFriendImageView;
//@property (nonatomic, strong) UILabel  *wechatFriendLebel;

@property (nonatomic, strong) UIImageView  *lineImageView;
@property (nonatomic,strong) UIView *cancelView;
@property (nonatomic,strong) UILabel *cancelLabel;


@property (nonatomic,strong) NSString *sharefrom;

@property (nonatomic,strong) NSArray *dicarray;
//@property (nonatomic,assign)int shareButtonNumber;
//

-(void)showView;

@property(nonatomic, weak)id <SelectSharedTypeDelegate>delegate;
@end
