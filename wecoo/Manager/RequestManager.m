//
//  RequestManager.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/20.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "RequestManager.h"
#import "NetworkManager.h"
#import "OpenUDID.h"
#import <commoncrypto/CommonDigest.h>
#define   kNetWorkManager   [NetworkManager SharedNetworkManager]

#pragma 接口汇总
#define HTJD_Quit @"/user/toBlank4MachineIdentificationCode/" //支持绑定手机号码发送，和登陆发送
#define HTJD_sendSms @"/user/sendvalidatecodesms/" //支持绑定手机号码发送，和登陆发送
#define HTJD_login @"/user/login/" 
#define HTJD_lookupIndustryMap @"/wecoo/lookupIndustryAll/"
#define HTJD_lookupBankAll @"/wecoo/lookupBankAll/"
#define HTJD_searchCustomer @"/report/searchCustomerDtos/"
#define HTJD_addCustomer @"/report/addCustomer/"
#define HTJD_updateCustomer @"/report/updateCustomer/"
#define HTJD_getCustomer @"/report/getCustomerDto4User/"
#define HTJD_deleteCustomer @"/report/deleteCustomer/"
#define HTJD_getMyCustomerReportCount @"/report/getMyCustomerReportCount/"
#define HTJD_searchMyCustomerReportDtosVerifying @"/report/searchMyCustomerReportDtosVerifying/"
#define HTJD_searchMyCustomerReportDtosFollowing @"/report/searchMyCustomerReportDtosFollowing/"
#define HTJD_searchMyCustomerReportDtosInspecting @"/report/searchMyCustomerReportDtosInspecting/"
#define HTJD_searchMyCustomerReportDtosSignedUp @"/report/searchMyCustomerReportDtosSignedUp/"
#define HTJD_searchMyCustomerReportDtosBack @"/report/searchMyCustomerReportDtosBack/"
#define HTJD_searchReportProgress @"/report/searchReportProgress/"
#define HTJD_addCustomerReport @"/report/addCustomerReport/"
#define HTJD_getCustomerReportDto @"/report/getCustomerReportDto/"
#define HTJD_getSalesmanUserRelatedCount @"/wecoo/getSalesmanUserRelatedCount/"
#define HTJD_updateUserSalesmanInfo @"/user/updateUserSalesmanInfo/"
#define HTJD_getUserDetail @"/user/getUserDetail/"
#define HTJD_getReportEffectiveRate @"/user/getReportEffectiveRate/"
#define HTJD_searchSalemanAccountLogDtos @"/account/searchSalemanAccountLogDtos/"
#define HTJD_getLastWithdrawalRecord @"/account/getLastWithdrawalRecord/"
#define HTJD_applyWithdraw @"/account/applyWithdraw/"
#define HTJD_getSysMsgUnReadCount @"/message/getSysMsgUnReadCount/"
#define HTJD_searchSysMsgDtos @"/message/searchSysMsgDtos/"
#define HTJD_updateSysMsgToRead @"/message/updateSysMsgToRead/"
#define HTJD_submitFeedback @"/wecoo/submitFeedback/"
#define HTJD_addProjectCollectionRecord @"/wecoo/addProjectCollectionRecord/"
#define HTJD_searchProjectCollectionRecordDtos @"/wecoo/searchProjectCollectionRecordDtos/"
#define HTJD_cancelProjectCollectionRecord @"/wecoo/cancelProjectCollectionRecord/"
#define HTJD_ProjectDetailCancelCollectionRecord @"/wecoo/cancelProjectCollection/"
#define HTJD_isProjectCollected @"/wecoo/isProjectCollected/"
#define HTJD_searchAdDtoList @"/wecoo/searchAdDtoList/"
#define HTJD_getProjectDto @"/project/getProjectDto/"
#define HTJD_searchProjects @"/project/searchProjects/"
#define HTJD_searchPromotingProjects @"/project/searchPromotingProjects/"
#define HTJD_getActivityDto @"/activity/getActivityDto/"
#define HTJD_searchActivityDtos4Show @"/activity/searchActivityDtos4Show/"
#define HTJD_submitJoiningInfo @"/wecoo/submitJoiningInfo/"
#define HTJD_submitManufacturerRecommendInfo @"/wecoo/submitManufacturerRecommendInfo/"
#define HTJD_uploadPhoto @"/image/uploadPhoto/"
#define HTJD_uploadPic @"/image/uploadPic/"
#define HTJD_uploadCompFile @"/image/uploadCompFile/"
#define HTJD_addProjectBrowsingRecord @"/wecoo/addProjectBrowsingRecord/"
#define HTJD_searchReportListSignedUpDtoList @"/report/searchReportListSignedUpDtoList/"
#define HTJD_getVersionInfo @"/wecoo/checkForUpdates/"
#define HTJD_getLoadingPic @"/wecoo/getLoadingPic/"
#define HTJD_isNewGuide @"/account/isShowNewbieGuide/"
#define HTJD_getWithdrawingLimit @"/account/getWithdrawingLimit/"
#define HTJD_searchSalesmanReporteffectiverateList @"/wecoo/searchSalesmanReporteffectiverateLogDtos/"
#define HTJD_getReportLockTime @"/report/getReportLockTime/"
#define HTJD_getUserSalesmanIDInfoDto @"/user/getUserSalesmanIDInfoDto/"
#define HTJD_submitIDInfo @"/user/submitIDInfo/"
#define HTJD_getClientBalance @"/user/getUserSalesmanBalance/"
#define HTJD_isWithdrawEnable @"/account/isWithdrawEnable/"
#define HTJD_isReportAllowed @"/report/isReportAllowed/"
#define HTJD_GetMyInviteInformationResult @"/wecoo/searchBeInviterSalesmanDtos/"
#define HTJD_GetInvitationSalesmanRewardBalance @"/wecoo/getInvitationSalesmanRewardBalance/"
#define HTJD_GetBeInviterSalesmanDetailsDto @"/wecoo/getBeInviterSalesmanDetailsDto/"
#define HTJD_GetBeInviterSalesmanDetailsDto @"/wecoo/getBeInviterSalesmanDetailsDto/"
#define HTJD_GetLastWithdrawalRecordByTypeDto @"/account/getLastWithdrawalRecordByType/"
#define HTJD_GetSendValidateCodeSmsByUserIdDto @"/user/sendValidateCodeSmsByUserId/"
#define HTJD_ApplyWithdrawByAlipay @"/account/applyWithdrawByAlipay/"
#define HTJD_ApplyWithdrawByCard @"/account/applyWithdrawByCard/"
#define HTJD_SearchSalesmanWithdrawingApplicationDtos @"/account/searchSalesmanWithdrawingApplicationDtos/"
#define HTJD_SearchSalesmanWithdrawingApplicationDtos @"/account/searchSalesmanWithdrawingApplicationDtos/"
#define HTJD_GetSalesmanWithdrawingApplicationLogList @"/account/getSalesmanWithdrawingApplicationLogList/"
#define HTJD_UpdateApplyWithdrawByAlipay @"/account/updateApplyWithdrawByAlipay/"
#define HTJD_UpdateApplyWithdrawByCard @"/account/updateApplyWithdrawByCard/"
#define HTJD_GetSalesmanWithdrawingApplicationDto @"/account/getSalesmanWithdrawingApplicationDto/"
#define HTJD_SearchConnectionDtosResult @"/wecoo/searchConnectionDtos/"
#define HTJD_GetMyConnectionCountAndContributionSum @"/wecoo/getMyConnectionCountAndContributionSum/"
#define HTJD_GetConnectionDetail @"/wecoo/getConnectionDetail/"
#define HTJD_SearchConnectionDynamicDtos @"/account/searchConnectionDynamicDtos/"
#define HTJD_GetMyContributionSumByLevelAndKind @"/account/getMyContributionSumByLevelAndKind/"
#define HTJD_SearchConnectionDynamicDtos @"/account/searchConnectionDynamicDtos/"
#define HTJD_SearchConnectionContributionDtos @"/account/searchConnectionContributionDtos/"
#define HTJD_GetUserTel @"/user/getUserTel/"
#define HTJD_IsWithdrawPwdNull @"/user/isWithdrawPwdNull/"
#define HTJD_SetUpWithdrawPwd @"/user/setUpWithdrawPwd/"
#define HTJD_IsWithdrawPwdRight @"/user/isWithdrawPwdRight/"
#define HTJD_ModifyWithdrawPwd @"/user/modifyWithdrawPwd/"
#define HTJD_ResetWithdrawPwd  @"/user/resetWithdrawPwd/"
#define HTJD_ApplyWithdrawByCardNewNew @"/account/applyWithdrawByCardNew/"
#define HTJD_UpdateApplyWithdrawByCardNew @"/account/updateApplyWithdrawByCardNew/"
#define HTJD_ApplyWithdrawByAlipayNew @"/account/applyWithdrawByAlipayNew/"
#define HTJD_UpdateApplyWithdrawByAlipayNew @"/account/updateApplyWithdrawByAlipayNew/"
#define HTJD_SearchParentCustomerReportDtosVerifying  @"/report/searchParentCustomerReportDtosVerifying/"
#define HTJD_SearchParentCustomerReportDtosFollowing  @"/report/searchParentCustomerReportDtosFollowing/"
#define HTJD_SearchParentCustomerReportDtosSignedUp  @"/report/searchParentCustomerReportDtosSignedUp/"
#define HTJD_SearchParentCustomerReportDtosBack  @"/report/searchParentCustomerReportDtosBack/"
#define HTJD_SearchCustomerFollowUpInfoDto @"/report/searchCustomerFollowUpInfoDto/"
#define HTJD_searchPlatformFeedbackCrlDtoList @"/report/searchPlatformFeedbackCrlDtoList/"
#define HTJD_SearchSimpleAppProjectDtos @"/project/searchSimpleAppProjectDtos/"
#define HTJD_GetWaitingAuditingNum @"/report/getWaitingAuditingNum/"
#define HTJD_SearchCustomerReportDtosByProManager @"/report/searchCustomerReportDtosByProManager4App/"
#define HTJD_SearchMyProjectDtos @"/project/searchMyProjectDtos/"
#define HTJD_CreateCompanyAccountAndInformation @"/user/createCompanyAccountAndInformation/"
#define HTJD_GetCustomerTelByReportIdStr @"/report/getCustomerTelByReportIdStr/"
#define HTJD_SearchCustomerReportLogs @"/customerReportLog/searchCompanyCustomerReportLogDtos/"
#define HTJD_PassAuditing4App @"/report/passAuditing4App/"
#define HTJD_ApplySignedUpAuditing4App @"/report/applySignedUpAuditing4App/"
#define HTJD_SendBackCustomerReport4App @"/report/sendBackCustomerReport4App/"
#define HTJD_AddCustomerReportLogSingle4App @"/customerReportLog/addCustomerReportLogSingle4App/"

#define HTJD_GetWithdrawRules @"/wecoo/getWithdrawRules/"
#define HTJD_SearchReportList @"/report/searchReportListSignedUpDtos/"
static RequestManager *shareRusult;

@interface RequestManager ()

@property(nonatomic ,strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation RequestManager
-(id) init
{
    self = [super init];
    //            _locService = [[BMKLocationService alloc]init];
    //            _locService.delegate =self;
    //            [_locService startUserLocationService];
    //    [self startUpdatingLocation];
    self.lat = @"";
    self.longti =  @"";
    self.eventPageCount = 50;
    self.cityname =@"";
    
    return self;
}

+(RequestManager *)shareRequestManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareRusult = [[self alloc]init];
        
    });
    return shareRusult;
}

#pragma 1.0版本 接口请求方法
-(NSString *)getPathWithServiceName:(NSString *)serviceName WithBody:(NSDictionary *)BodyDic{
    
    NSString *requestPath =nil;
    
    NSDictionary *content =@{
                             @"head":[self getHeadDictionaryWithServicesName:serviceName],
                             @"body":BodyDic,
                             };
    
    NSString *contentString = [self jsonStringWithDictionary:content];//转为json string
    
    NSData *contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];//转为NSData
    /*
     String content=injs.toString();//转成 string
     String contentbase64 = Base64.String2Base64(content);//把content base64
     String key =MD5v2.md532(contentbase64+"huatuozx");key是 content和 huotuozx拼接而成的key md5编码后
     
     String urlString = "http://182.92.223.9:8080/huatuo/servlet/getdata?sid=1&content="+StringUtil.urlEncoder(contentbase64)+"&key="+key;
     */
    NSString *after_contentStrBase64 = [self Base64Encode:contentData];//base64编码
    //    NSLog(@"after----------->%@",after_contentStrBase64);
    //    NSString *contentStr = [after_contentStrBase64 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *contentStr =[self URLEncodedString:after_contentStrBase64];//urlEncode
    
    NSString *keystr =[NSString stringWithFormat:@"%@%@",after_contentStrBase64 ,SENDPASSWORD];
//    NSLog(@"%@",keystr);
    NSString *key = [self md5:keystr];
//    NSLog(@"%@",key);
    NSDictionary *postdata =@{
                              @"sid":@"1",
                              @"content":contentStr,
                              @"key":key
                              };
    
    requestPath =[NSString stringWithFormat:@"?sid=%@&content=%@&key=%@",[postdata objectForKey:@"sid"],[postdata objectForKey:@"content"],[postdata objectForKey:@"key"]];
//    NSLog(@"requestPath------%@",requestPath);
    return requestPath;
}


#pragma md5 加密
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}


- (NSString *)URLEncodedString:(NSString *)beforeString
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)beforeString,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    return outputStr;
}

#pragma BASE 64编码
-(NSString *) Base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B','C', 'D', 'E','F', 'G', 'H','I', 'J', 'K','L', 'M', 'N','O', 'P',
        'Q', 'R','S', 'T', 'U','V', 'W', 'X','Y', 'Z', 'a','b', 'c', 'd','e', 'f',
        'g', 'h','i', 'j', 'k','l', 'm', 'n','o', 'p', 'q','r', 's', 't','u', 'v',
        'w', 'x','y', 'z', '0','1', '2', '3','4', '5', '6','7', '8', '9','+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i <3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] &0xFC) >> 2;
        output[1] = ((input[0] &0x03) << 4) | ((input[1] &0xF0) >> 4);
        output[2] = ((input[1] &0x0F) << 2) | ((input[2] &0xC0) >> 6);
        output[3] = input[2] &0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
    
}

#pragma  从NSDictionary中获取json 串 封装
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

#pragma  从NSObject中获取json 串 封装
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

#pragma  从NSString中获取json 串 封装
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

#pragma  从NSArray中获取json 串 封装
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

#pragma jsonString JSON格式的字符串 @return 返回字典

-(NSArray *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma 1.0 请求 数据报文头 封装
-(NSDictionary *)getHeadDictionaryWithServicesName:(NSString*)servicename{
    NSDictionary *head =@{
                          @"client":@"ios",
                          @"deviceID":[self opendUDID],
                          @"screenPixel":@"320*480",
                          @"longitude":self.longti,
                          @"latitude":self.lat,
                          @"version"
                          @"servicesName":servicename,
                          @"messageID":@"",
                          @"channelCode":@"",
                        };
    return head;
}

-(NSString *)opendUDID{
    return  [OpenUDID value];
}



//取消请求
- (void)cancelAllRequest
{
    [kNetWorkManager cancelAllRequest];
}

#pragma mark -2.0 接口 封装Content
-(NSDictionary *)translateParams:(NSDictionary *)params{
    
    //    //公共交互报文
    NSDictionary *PublicDictionary =@{
                                      @"client":@"ios",
                                      @"deviceID":[self opendUDID],
                                      @"screenPixel":@"320*480",
                                      @"longitude":self.longti,
                                      @"latitude":self.lat,
                                      
                                      @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                      //                          @"messageID":@"",
                                      @"channelCode":@"",
                                      //sign 也是必填的需要添加的 一项
                                      };
    
    //    NSDictionary *PublicDictionary =@{@"a":@"1"};
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:params];
    
    NSMutableDictionary *mutableDic =   [self filterParamters:beforeDic];// 过滤掉 空参数 和 参数名为 sign signtype的 键值对
    
    NSString  *translateString=[self createSign:mutableDic];
    //         NSLog(@"sign------->%@",translateString);
    translateString =[translateString stringByAppendingString:POST_key];
    //        NSLog(@"transl------->%@",translateString);
    NSString *sign =[self md5:translateString];
    
    [mutableDic setObject:[sign lowercaseString] forKey:@"sign"];
    //     NSLog(@"mutableDic------->%@",mutableDic);
    NSString *contentString =    [self jsonStringWithDictionary:mutableDic];
    
    //    NSLog(@"contentString------->%@",contentString);
    
    NSData *contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];//转为NSData
    
    NSString *after_contentStrBase64String = [contentData base64EncodedStringWithOptions:0];
    //        NSLog(@"Base64String------->%@",after_contentStrBase64String);
    //			Map<String, Object> paramsMap = new HashMap<String, Object>();
    //			paramsMap.put("content", content);
    //			String result = httpClient.post(serverUrl + params.getUrl(), paramsMap);
    //    String result = httpClient.get(serverUrl + params.getUrl() + "?content=" + content);
    NSString *after_contentStrBase64 = [self Base64Encode:contentData];//base64编码
    //    NSLog(@"after_contentStrBase64------->%@",after_contentStrBase64String);
    
    //    NSString *contentStr =[self URLEncodedString:after_contentStrBase64];//urlEncode
    NSDictionary *content =@{
                             @"content":after_contentStrBase64
                             };
    //     NSLog(@"content------->%@",content);
    
    return content;
}

-(NSMutableDictionary *)filterParamters:(NSMutableDictionary *)params{
    
    NSMutableDictionary *filterDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (params ==NULL ||params.count<=0) {
        return filterDictionary;
    }
    for (NSString *keyString in params.allKeys) {
        NSString *value =[params objectForKey:keyString];
        if (value ==NULL ||[value isEqualToString:@""] || [[keyString lowercaseString] isEqualToString:@"sign"]|| [[keyString lowercaseString ]isEqualToString:@"sign_type"]) {
            continue;
        }
        [filterDictionary setObject:value forKey:keyString];
    }
    
    return filterDictionary;
}

-(NSString *)createSign:(NSMutableDictionary *)params{
    NSArray *keys = [params allKeys];
    
    //    NSLog(@"keys :%@", keys);
    
    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:sort];
    //    NSLog(@"字符串数组排序结果%@",sortedKeys);//所有的键集合的排序
    
    NSString *strstring = @"";
    //    //所有值集合
    //    NSArray *values = [params allValues];
    //    NSLog(@"values :%@", values);
    for (int i =0; i<sortedKeys.count; i++) {
        NSString *key =sortedKeys[i];
        NSString *key_value = [params objectForKey:key];
        if (i == sortedKeys.count - 1) {     //拼接时，不包括最后一个&字符
            strstring =[NSString stringWithFormat:@"%@%@=%@",strstring,key,key_value];
        } else {
            strstring =[NSString stringWithFormat:@"%@%@=%@&",strstring,key,key_value];
        }
    }
    //    NSLog(@"%@",strstring);
    return strstring;
}


-(NSDictionary *)AddPublicParams:(NSDictionary *)params{
    NSLog(@"qtx_auth------>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"]);
    //    //公共交互报文
    NSDictionary *PublicDictionary =@{
                                      @"qtx_auth":[[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"],
                                      @"source":@"2",
                                      };
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:params];
//    NSLog(@"--post Data--------%@",beforeDic);
    return beforeDic;
}

-(void)loginCancel:(NSDictionary *)resultDic{
    NSString *qtxStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"qtx_auth"];
    if (qtxStr) {
        [self tipAlert:[resultDic objectForKey:@"msg"]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"qtx_auth"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    }
}


#pragma mark - 4.3.11	App退出时，清除机器码
- (void)QuitResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    //    NSDictionary *postdic = [self translateParams:dataDic];
    
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_Quit WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result---------获取验证码----%@",result);
                                           success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 获取验证码
- (void)GetVerifyCodeResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    //    NSDictionary *postdic = [self translateParams:dataDic];
    
    [kNetWorkManager requestPostWithParameters:dataDic
                                       ApiPath:
     HTJD_sendSms WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result---------获取验证码----%@",result);
                                           success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 登录
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors
{
    
    NSDictionary *PublicDictionary =@{
                                       @"machine_identification_code":[self opendUDID],
                                      };
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    [beforeDic addEntriesFromDictionary:dataDic];
//    NSDictionary *postdic = [self translateParams:beforeDic];
//    NSLog(@"beforeDic--------->%@",beforeDic);
    
    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_login WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"\nresult-------登录------%@",result);
//                                            int flag = [[result objectForKey:@"flag"] intValue];
                                           success(result);
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.1.1	获取行业数据字典
- (void)GetLookupIndustryMapResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_lookupIndustryMap WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取行业数据字典--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                        } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.1.2	获取银行数据字典
- (void)GetlookupBankAllMapResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_lookupBankAll WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取银行数据字典--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.2.1	获取客户列表
- (void)GetsearchCustomerResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchCustomer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取客户列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.2.2	添加客户
- (void)GetaddCustomerResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];

    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addCustomer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--添加客户--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.3	修改客户
- (void)UpdateCustomerResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];

    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateCustomer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--修改客户--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.4	通过ID获取一条客户记录
- (void)getCustomerResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getCustomer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--通过ID获取一条客户记录--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.5	删除客户
- (void)DeleteClientResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_deleteCustomer WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--删除客户--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.6	我的报备-数量统计
- (void)GetMyCustomerReportCountResult:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getMyCustomerReportCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-数量统计--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.7	我的报备-核实中
- (void)SearchMyCustomerReportDtosVerifyingResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyCustomerReportDtosVerifying WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-核实中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.8	我的报备-跟进中
- (void)SearchMyCustomerReportDtosFollowingResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyCustomerReportDtosFollowing WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-跟进中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.9	我的报备-考察中
- (void)SearchMyCustomerReportDtosInspectingResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyCustomerReportDtosInspecting WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-考察中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.10	我的报备-已签约
- (void)SearchMyCustomerReportDtosSignedUpResult:(NSDictionary *)dataDic
                                    viewController:(UIViewController *)controller
                                       successData:(SuccessData)success
                                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyCustomerReportDtosSignedUp WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-已签约--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.11	我的报备-已退回
- (void)SearchMyCustomerReportDtosBackResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchMyCustomerReportDtosBack WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--我的报备-已退回--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.12	查看报备进度
- (void)SearchReportProgressResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
      HTJD_searchReportProgress WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查看报备进度--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.13	添加报备
- (void)AddCustomerReportResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addCustomerReport WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--添加报备--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.14	通过ID获取报备记录详情
- (void)GetCustomerReportDtoResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getCustomerReportDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--通过ID获取报备记录详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.3.2	统计我的相关数（客户数关注数活动数）
- (void)GetSalesmanUserRelatedCountResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSalesmanUserRelatedCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--统计我的相关数（客户数关注数活动数）--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.3.3	个人资料修改
- (void)UpdateUserSalesmanInfoResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateUserSalesmanInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--个人资料修改--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.3.4	获取业务员用户信息详情
- (void)GetUserDetailResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserDetail WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.3.5	获取用户报备质量分
- (void)GetReportEffectiveRateResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getReportEffectiveRate WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取用户报备质量分--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.4.1	账户变动明细
- (void)SearchSalemanAccountLogDtosResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchSalemanAccountLogDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--账户变动明细--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.2.15	获取报备客户记录的锁定时间（天数）
- (void)GetReportLockTimeResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getReportLockTime WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--账户变动明细--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.4.3 获取提现申请的最低余额限制
- (void)getWithdrawingLimitResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getWithdrawingLimit WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.4.3 获取提现申请的最低余额限制--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.4.2	获取上一次提现记录（获取上一次提现银行卡信息）
- (void)GetLastWithdrawalRecordResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getLastWithdrawalRecord WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取上一次提现记录（获取上一次提现银行卡信息）--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.4.3	申请提现
- (void)ApplyWithdrawResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_applyWithdraw WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--申请提现--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.1	获取未读系统消息的数量
- (void)GetSysMsgUnReadCountResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getSysMsgUnReadCount WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取未读系统消息的数量--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.2	获取系统消息列表
- (void)SearchSysMsgDtosResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchSysMsgDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取系统消息列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.3	消息置为已读
- (void)UpdateSysMsgToReadResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_updateSysMsgToRead WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--消息置为已读--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.4	创建投诉/意见反馈
- (void)SubmitFeedbackResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_submitFeedback  WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--创建投诉/意见反馈--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.5	关注项目/悬赏
- (void)AddProjectCollectionRecordResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addProjectCollectionRecord WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--关注项目/悬赏--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.6	获取关注项目列表/我的关注
- (void)SearchProjectCollectionRecordDtosResult:(NSDictionary *)dataDic
                                 viewController:(UIViewController *)controller
                                    successData:(SuccessData)success
                                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchProjectCollectionRecordDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--	获取关注项目列表/我的关注--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

- (void)AddProjectBrowsingRecordesult:(NSDictionary *)dataDic
                                 viewController:(UIViewController *)controller
                                    successData:(SuccessData)success
                                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_addProjectBrowsingRecord WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--	AddProjectBrowsingRecordesult--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.7	取消项目关注/收藏
- (void)CancelProjectCollectionRecordResult:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_cancelProjectCollectionRecord WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--取消项目关注/收藏--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.7	项目详情 取消项目关注/收藏
- (void)ProjecDetailCancelCollectionRecordResult:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ProjectDetailCancelCollectionRecord WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--项目详情取消项目关注/收藏--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



#pragma mark -4.5.8	查看项目是否已关注 未添加
- (void)IsProjectCollectedResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_isProjectCollected WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查看项目是否已关注--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.5.9	获取banner列表(app端)
- (void)SearchAdDtoListResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchAdDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取banner列表(app端)--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.6.1	获取单个项目详情
- (void)GetProjectDtoResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getProjectDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取单个项目详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.6.2	获取项目的成交名单
- (void)SearchReportListSignedUpDtoListResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchReportListSignedUpDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.6.2----获取项目的成交名单--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.6.2	APP获取项目列表
- (void)SearchProjectsResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchProjects WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--APP获取项目列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.6.3	APP获取首页推荐项目列表
- (void)SearchPromotingProjectsResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchPromotingProjects WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--APP获取首页推荐项目列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.7.1	获取单个活动详情
- (void)GetActivityDtoResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getActivityDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取单个活动详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.7.2	APP（前端）获取活动列表
- (void)SearchActivityDtos4ShowResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchActivityDtos4Show WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--APP（前端）获取活动列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.8.1	APP（前端）提交外包招商加盟信息
- (void)SubmitJoiningInfoResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_submitJoiningInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--APP（前端）提交外包招商加盟信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.9.1	APP（前端）提交招商厂商引荐信息
- (void)SubmitManufacturerRecommendInfoResult:(NSDictionary *)dataDic
                               viewController:(UIViewController *)controller
                                  successData:(SuccessData)success
                                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_submitManufacturerRecommendInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--	APP（前端）提交招商厂商引荐信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark 4.3.6	上传头像 / 上传手持身份证正面照片
- (void)SubmitImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestUploadImageWithParameters:postdic SendImageData:sendData FileName:filename ApiPath:
     HTJD_uploadPhoto WithHeader:header onTarget:controller success:^(NSDictionary *result, NSDictionary *headers) {
//         NSLog(@"result--	4.3.6	上传头像--%@",result);
         int flag = [[result objectForKey:@"flag"] intValue];
         if (flag == -1) {
             [self loginCancel:result];
         }else{
             success(result);
         }
     } failure:^(NSError *error) {
         errors(error);
     }];

}

#pragma mark 4.4.20	企业上传图片
- (void)ComplaintUploadImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    [kNetWorkManager requestUploadImageWithParameters:postdic SendImageData:sendData FileName:filename ApiPath:
     HTJD_uploadPic WithHeader:header onTarget:controller success:^(NSDictionary *result, NSDictionary *headers) {
//         NSLog(@"result-------4.5.4	上传图片文件（如投诉建议功能上传图片）------%@",result);
         int flag = [[result objectForKey:@"flag"] intValue];
         if (flag == -1) {
             [self loginCancel:result];
         }else{
             success(result);
         }
     } failure:^(NSError *error) {
         errors(error);
     }];
    
}

#pragma mark 4.5.4	上传图片文件（企业申请 功能上传图片）
- (void)UploadCompFileUploadImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    [kNetWorkManager requestUploadImageWithParameters:postdic SendImageData:sendData FileName:filename ApiPath:
     HTJD_uploadCompFile WithHeader:header onTarget:controller success:^(NSDictionary *result, NSDictionary *headers) {
//                  NSLog(@"result-------4.5.4	上传图片文件（企业申请 功能上传图片）------%@",result);
         int flag = [[result objectForKey:@"flag"] intValue];
         if (flag == -1) {
             [self loginCancel:result];
         }else{
             success(result);
         }
     } failure:^(NSError *error) {
         errors(error);
     }];
    
}

#pragma mark - 4.5.13	检查产品版本更新
- (void)getVersionInfo:(NSDictionary *)postdic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
//    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getVersionInfo
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result------- 4.5.13	检查产品版本更新------%@",result);
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.5.14	获取打开APP时的加载图片（及对应跳转的Url）
/*
 
 返回值 	 备注
 flag	调用成功与否标识（0，失败；1，成功）；
 data	pic：欢迎页图片地址
 pic_url：欢迎页跳转地址，如果返回值为""则表示没有跳转地址。
 project_id：条状项目 id，如果返回值为"0"则表示没有项目。
 */
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors
{
    NSDictionary *PublicDictionary =@{@"source":@"2",};
    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                      PublicDictionary];
    //添加 各个不同接口需要请求的参数
    [beforeDic addEntriesFromDictionary:dataDic];

    [kNetWorkManager requestPostWithParameters:beforeDic
                                       ApiPath:
     HTJD_getLoadingPic
                                    WithHeader:nil
                                      onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           NSLog(@"result-------4.5.14	获取打开APP时的加载图片（及对应跳转的Url）------%@",result);
                                           success(result);
                                           
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -首页是否显示新手引导
- (void)NewGuideResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_isNewGuide WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--首页是否显示新手引导--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.15	查询用户报备质量分变更记录
- (void)SearchSalesmanReporteffectiverateListResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchSalesmanReporteffectiverateList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--我的报备-核实中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.3.8	获取业务员实名认证信息
- (void)GetUserSalesmanIDInfoDtoResult:(NSDictionary *)dataDic
                                     viewController:(UIViewController *)controller
                                        successData:(SuccessData)success
                                            failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getUserSalesmanIDInfoDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员实名认证信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark 4.3.9	业务员提交实名认证信息
- (void)SalesmanSubmitIDInfoResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
//    NSLog(@"postidc==============?%@",postdic);
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_submitIDInfo WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员实名认证信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark 4.3.7	获取业务员账户余额
- (void)getClientBalanceResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_getClientBalance WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                                      NSLog(@"result--获获取业务员账户余额-%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark 4.4.6	当前业务员是否可申请提现
- (void)isWithdrawEnableResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_isWithdrawEnable WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员实名认证信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark 4.2.16	用户当天是否允许报备
- (void)isReportAllowedResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_isReportAllowed WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.2.16	用户当天是否允许报备--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.18	查询邀请记录列表
- (void)GetMyInviteInformationResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetMyInviteInformationResult WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询邀请记录列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.5.16	获取用户头像邀请码邀请人数和总奖金
- (void)GetInvitationSalesmanRewardBalanceResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetInvitationSalesmanRewardBalance WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.17	查询被邀请人详情
- (void)GetBeInviterSalesmanDetailsDtoResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetBeInviterSalesmanDetailsDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.7	获取用户最后一次提现记录
- (void)GetLastWithdrawalRecordByTypeResult:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetLastWithdrawalRecordByTypeDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取用户最后一次提现记录--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.8	根据UserId发送验证码
- (void)SendValidateCodeSmsByUserIdResult:(NSDictionary *)dataDic
                           viewController:(UIViewController *)controller
                              successData:(SuccessData)success
                                  failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetSendValidateCodeSmsByUserIdDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.9	支付宝申请提现接口
- (void)ApplyWithdrawByAlipayResult:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ApplyWithdrawByAlipay WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.10	银行卡申请提现接口
- (void)ApplyWithdrawByCardDtoResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ApplyWithdrawByCard WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.11	查询用户的申请记录
- (void)SearchSalesmanWithdrawingApplicationDtosResult:(NSDictionary *)dataDic
                                        viewController:(UIViewController *)controller
                                           successData:(SuccessData)success
                                               failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchSalesmanWithdrawingApplicationDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查询用户的申请记录--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.12	查询提现进度
- (void)GetSalesmanWithdrawingApplicationLogListResult:(NSDictionary *)dataDic
                                        viewController:(UIViewController *)controller
                                           successData:(SuccessData)success
                                               failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetSalesmanWithdrawingApplicationLogList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                            NSLog(@"result--查询提现进度--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.13	修改申请提现接口-支付宝
- (void)UpdateApplyWithdrawByAlipayDtoResult:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_UpdateApplyWithdrawByAlipay WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.14	修改申请提现接口-银行卡
- (void)UpdateApplyWithdrawByCardDtoResult:(NSDictionary *)dataDic
                            viewController:(UIViewController *)controller
                               successData:(SuccessData)success
                                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_UpdateApplyWithdrawByCard WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark -4.4.15	根据提现Id 返回一条提现记录
- (void)GetSalesmanWithdrawingApplicationDtoDtoResult:(NSDictionary *)dataDic
                                       viewController:(UIViewController *)controller
                                          successData:(SuccessData)success
                                              failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetSalesmanWithdrawingApplicationDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--查询被邀请人详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.19	查询我的人脉列表
- (void)SearchConnectionDtosResult:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchConnectionDtosResult WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查询我的人脉列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.5.20	获取用户头像邀请码邀请人数和总奖金
- (void)GetMyConnectionCountAndContributionSumResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success
                                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetMyConnectionCountAndContributionSum WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                            NSLog(@"result--获取用户头像邀请码邀请人数和总奖金--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.5.18	查询我的人脉详情
- (void)GetConnectionDetailResult:(NSDictionary *)dataDic
                                      viewController:(UIViewController *)controller
                                         successData:(SuccessData)success
                                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetConnectionDetail WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查询我的人脉详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.17	查询我的人脉收益-统计总金额
- (void)GetMyContributionSumByLevelAndKindResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetMyContributionSumByLevelAndKind WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                          NSLog(@"result--查询我的人脉收益-统计总金额--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.18	查询我的人脉详情下的动态
- (void)SearchConnectionDynamicDtosResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchConnectionDynamicDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                            NSLog(@"result--查询我的人脉详情下的动态--%@",result);
//                                           NSLog(@"result--查询我的人脉详情下的动态--%d",[[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue]);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.16	查询我的人脉收益
- (void)SearchConnectionContributionDtosResult:(NSDictionary *)dataDic
                                viewController:(UIViewController *)controller
                                   successData:(SuccessData)success
                                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchConnectionContributionDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];

}

#pragma mark -4.3.1	根据用户Id查询用户手机号
- (void)GetUserTelResult:(NSDictionary *)dataDic
                                viewController:(UIViewController *)controller
                                   successData:(SuccessData)success
                                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetUserTel WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}


#pragma mark -4.3.13	获取用户是否设置过提现密码
- (void)IsWithdrawPwdNullResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_IsWithdrawPwdNull WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取用户是否设置过提现密码--%@",result);
                                           
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -4.3.14	设置提现密码
- (void)SetUpWithdrawPwdResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SetUpWithdrawPwd WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -4.3.15	提现密码是否输入正确
- (void)IsWithdrawPwdRightResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_IsWithdrawPwdRight WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -4.3.16	修改提现密码
- (void)ModifyWithdrawPwdResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ModifyWithdrawPwd WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -4.3.17	重置密码
- (void)ResetWithdrawPwdResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ResetWithdrawPwd WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           //                                           NSLog(@"result--获取业务员用户信息详情--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark -4.4.10NEW	银行卡申请提现接口
- (void)ApplyWithdrawByCardDtoResultNew:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ApplyWithdrawByCardNewNew WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--NEW	银行卡申请提现接口--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.14New	修改申请提现接口-银行卡
- (void)UpdateApplyWithdrawByCardDtoResultNew:(NSDictionary *)dataDic
                            viewController:(UIViewController *)controller
                               successData:(SuccessData)success
                                   failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_UpdateApplyWithdrawByCardNew WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--New	修改申请提现接口-银行卡--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.4.9New	支付宝申请提现接口
- (void)ApplyWithdrawByAlipayResultNew:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ApplyWithdrawByAlipayNew WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.4.9New	支付宝申请提现接口--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}



#pragma mark -4.4.13New	修改申请提现接口-支付宝
- (void)UpdateApplyWithdrawByAlipayDtoResultNew:(NSDictionary *)dataDic
                              viewController:(UIViewController *)controller
                                 successData:(SuccessData)success
                                     failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_UpdateApplyWithdrawByAlipayNew WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.4.13New	修改申请提现接口-支付宝--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.2.17	客户跟进信息
- (void)getFollowupInfoDtosResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchCustomerFollowUpInfoDto WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--客户跟进信息--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.2.18	我推荐的客户-核实中
- (void)SearchParentCustomerReportDtosVerifyingResult:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchParentCustomerReportDtosVerifying WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                                      NSLog(@"result--我推荐的客户-核实中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.19	我推荐的客户-跟进中
- (void)SearchParentCustomerReportDtosFollowingResult:(NSDictionary *)dataDic
                                       viewController:(UIViewController *)controller
                                          successData:(SuccessData)success
                                              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchParentCustomerReportDtosFollowing WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                                      NSLog(@"result--我推荐的客户-跟进中--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.20	我推荐的客户-已签约
- (void)SearchParentCustomerReportDtosSignedUpResult:(NSDictionary *)dataDic
                                       viewController:(UIViewController *)controller
                                          successData:(SuccessData)success
                                              failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchParentCustomerReportDtosSignedUp WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                                      NSLog(@"result--我推荐的客户-已签约--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.21	我推荐的客户-已退回
- (void)SearchParentCustomerReportDtosBackResult:(NSDictionary *)dataDic
                                      viewController:(UIViewController *)controller
                                         successData:(SuccessData)success
                                             failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchParentCustomerReportDtosBack WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                                      NSLog(@"result--我推荐的客户-已退回--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.22	查看平台反馈列表
- (void)SearchPlatformFeedbackCrlDtoListResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_searchPlatformFeedbackCrlDtoList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查看平台反馈列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.6.5	获取项目列表
- (void)SearchSimpleAppProjectDtosResult:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchSimpleAppProjectDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取项目列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.23	获取所有审核中报备数
- (void)GetWaitingAuditingNumResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetWaitingAuditingNum WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--获取项目列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.2.28	审核列表
- (void)SearchCustomerReportDtosByProManager4AppResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchCustomerReportDtosByProManager WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--审核列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.6.6	根据用户 id 获取项目列表
- (void)SearchMyProjectDtosResult:(NSDictionary *)dataDic
                                        viewController:(UIViewController *)controller
                                           successData:(SuccessData)success
                                               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchMyProjectDtos WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--4.6.6	根据用户 id 获取项目列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.4.19	企业账号申请
- (void)CreateCompanyAccountAndInformationResult:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_CreateCompanyAccountAndInformation WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--企业账号申请--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -4.2.24	根据报备 id 加密串获取客户的手机号
- (void)GetCustomerTelByReportIdStrResult:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetCustomerTelByReportIdStr WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--根据报备 id 加密串获取客户的手机号--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
    
}

#pragma mark - 4.2.30	查询报备沟通记录
- (void)searchCustomerReportLogsResult:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchCustomerReportLogs WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--查询报备沟通记录--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.25	通过审核
- (void)PassAuditing4AppResult:(NSDictionary *)dataDic
                                        viewController:(UIViewController *)controller
                                           successData:(SuccessData)success
                                               failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_PassAuditing4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--通过审核--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.26	签约打款
- (void)ApplySignedUpAuditing4AppResult:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_ApplySignedUpAuditing4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--签约打款--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}


#pragma mark - 4.2.27报备退回
- (void)SendBackCustomerReport4App:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SendBackCustomerReport4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--报备退回--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark - 4.2.29	添加报备沟通记录
- (void)AddCustomerReportLogSingle4App:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_AddCustomerReportLogSingle4App WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"result--添加报备沟通记录--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -APP获取提现规则文案
- (void)GetWithdrawRulesResult:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success
                                 failuer:(ErrorData)errors
{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_GetWithdrawRules WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
//                                           NSLog(@"APP获取提现规则文案--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}

#pragma mark -分页获取已签约报备列表
- (void)SearchAlreadyReportListDtosResult:(NSDictionary *)dataDic
                                 viewController:(UIViewController *)controller
                                    successData:(SuccessData)success
                                        failuer:(ErrorData)errors{
    NSDictionary *postdic = [self AddPublicParams:dataDic];
    [kNetWorkManager requestPostWithParameters:postdic
                                       ApiPath:
     HTJD_SearchReportList WithHeader:nil onTarget:nil
                                       success:^(NSDictionary *result, NSDictionary *headers) {
                                           NSLog(@"result--	分页获取已签约报备列表--%@",result);
                                           int flag = [[result objectForKey:@"flag"] intValue];
                                           if (flag == -1) {
                                               [self loginCancel:result];
                                           }else{
                                               success(result);
                                           }
                                       } failure:^(NSError *error) {
                                           errors(error);
                                       }];
}
#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller
{
    if ([results isKindOfClass:[NSNull class]]) {
        return;
    }
//    [controller.view makeToast:results duration:2.0 position:@"bottom"];
    [controller.view makeToast:results duration:2.8 position:@"center"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    return;
}

- (void)tipAlert:(NSString *)results
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:results
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result WithController:(UIViewController *)controller
{
    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
        NSString *info =  [result objectForKey:@"msg"];
         [self tipAlert:info viewController:controller];
    }
}

//弹出错误提示
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller
{
    if (![[result objectForKey:@"msg"] isKindOfClass:[NSNull class]]) {
        NSString *info =  [result objectForKey:@"msg"];
        [self tipAlert:info viewController:controller];
    }
}




@end
