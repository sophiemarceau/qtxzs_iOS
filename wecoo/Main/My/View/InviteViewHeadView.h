//
//  InviteViewHeadView.h
//  wecoo
//
//  Created by 屈小波 on 2017/1/11.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewHeadView : UIView{
  
  
    CGFloat lineheight;
}
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *InviteCodeLabel;
@property(nonatomic,strong)UIButton *CopyButton;
@property(nonatomic,strong)UIImageView *inviteiconImageView;
@property(nonatomic,strong)UIImageView *moneyiconImageView;
@property(nonatomic,strong)UILabel *inviteLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *invitePersonCountLabel;
@property(nonatomic,strong)UILabel *inviteActivityTotallMoneyLabel;
@property(nonatomic,strong)UIImageView *verticalLineImageView;
@property(nonatomic,strong)UIImageView *horizontalLineImageView;


@property(nonatomic,strong)NSDictionary *data;//接收数据的字典
@property(nonatomic,strong)NSString *flag;
@end
