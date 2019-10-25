//
//  EditClientViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/9.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@protocol  EditSuccessDelegate<NSObject>
- (void)edditSuccessReturnClientPage;
@end
@interface EditClientViewController : BaseViewController
@property(nonatomic, weak)id <EditSuccessDelegate>delegate;

@property(nonatomic,strong)NSString *customerID;

@property(nonatomic,assign)int isLocked;
@end
