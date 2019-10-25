//
//  UnlockClientListViewController.h
//  wecoo
//
//  Created by 屈小波 on 2016/11/4.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@protocol  SelectSuccessDelegate<NSObject>
- (void)selectSuccessReturnReportPage:(NSDictionary*)clientDic;
@end
@interface UnlockClientListViewController : BaseViewController
@property(nonatomic, weak)id <SelectSuccessDelegate>delegate;

@end
