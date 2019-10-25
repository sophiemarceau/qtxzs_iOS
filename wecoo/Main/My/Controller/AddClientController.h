//
//  AddClientController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/8.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@protocol  AddSuccessDelegate<NSObject>
- (void)addSuccessReturnClientPage;
@end

@interface AddClientController : BaseViewController
@property(nonatomic, weak)id <AddSuccessDelegate>delegate;
@end
