//
//  SelectClientViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/23.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@protocol  SelectClientGroupDelegate<NSObject>
- (void)SelectClientGroupDelegateReturnPage:(NSDictionary*)returnTypeDic;
@end
@interface SelectClientViewController : BaseViewController

@property(nonatomic, weak)id <SelectClientGroupDelegate>delegate;
@end
