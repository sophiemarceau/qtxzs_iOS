//
//  ProgressModel.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy, readonly) NSString *identifier;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *title2;
@end
