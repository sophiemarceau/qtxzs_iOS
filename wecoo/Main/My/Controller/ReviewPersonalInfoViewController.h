//
//  ReviewPersonalInfoViewController.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/12/10.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "ClientView.h"
@interface ReviewPersonalInfoViewController : BaseViewController
@property(nonatomic,strong)NSDictionary *authDictionary;
@property (nonatomic,assign)int gotoWhere;
@property (nonatomic,assign)int fromWhere;
@property (nonatomic,assign)int swa_id;
@property (nonatomic,assign)int IsWithDrawPwdFlag;
@end
