//
//  ProgressModel.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ProgressModel.h"

@implementation ProgressModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _identifier = [self uniqueIdentifier];
        NSString *info = @"";
        info = [info stringByAppendingString:dictionary[@"swal_opertype_name"]];
        
        int swal_opertype = [dictionary[@"swal_opertype"] intValue];
        int link = [dictionary[@"link"] intValue];
        int swa_type = [[dictionary objectForKey:@"swa_type"] intValue];
        
        if (swal_opertype == 1) {
            if (![dictionary[@"swa_sum_str"] isEqual:[NSNull null]] && dictionary[@"swa_sum_str"] !=nil && ![dictionary[@"swa_sum_str"] isEqualToString:@""]) {
                info = [info stringByAppendingFormat:@" <a>%@</a>",dictionary[@"swa_sum_str"]];
            }
            if (swa_type == 1) {
                info = [info stringByAppendingFormat:@"\r\n%@",@"提现方式：个人银行卡提现"];
            }else{
                info = [info stringByAppendingFormat:@"\r\n%@",@"提现方式：支付宝提现"];
            }
        }
        
        if (swal_opertype == 2) {
            
        }
        
        if (swal_opertype == 3) {
            if (link == 2) {
                info = [info stringByAppendingFormat:@", 去<help><u>%@</u></help>",@"修改认证信息"];
            }
            if (![dictionary[@"swal_desc"] isEqualToString:@""]) {
                info = [info stringByAppendingFormat:@"\r\n%@%@",@"原因：",dictionary[@"swal_desc"]];
            }
        }
        if (swal_opertype == 4) {
            
            if (link == 0) {
                info = [info stringByAppendingFormat:@",%@",@"已修改信息"];
            }else{
                info = [info stringByAppendingFormat:@", 去<help><u>%@</u></help>",@"修改申请信息"];
                if(![dictionary[@"swal_desc"] isEqual:[NSNull null]] && dictionary[@"swal_desc"] !=nil)
                {
                    if (![dictionary[@"swal_desc"] isEqualToString:@""]) {
                        info = [info stringByAppendingFormat:@"\r\n%@%@",@"原因：",dictionary[@"swal_desc"]];
                    }
                }
            }
        }
        if (swal_opertype == 5) {
            
        }
        if (swal_opertype == 6) {
            info = [info stringByAppendingFormat:@"\r\n%@%@ %@",@"打款账号:",dictionary[@"us_realname"],dictionary[@"account"]];
        }

        _title = info;
        _title2 = dictionary[@"swal_createdtime"];
        
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}
@end
