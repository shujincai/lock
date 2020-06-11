//
//  CommonUtil.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "CommonUtil.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation CommonUtil

+ (void)saveObjectToUserDefault:(JSONModel*)obj forKey:(NSString*)key
{
    if (obj) {
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setObject:[obj toDictionary] forKey:key];
        [def synchronize];
    }
}
+ (id)getObjectFromUserDefaultWith:(Class)clazz forKey:(NSString*)key
{
    if ([clazz isSubclassOfClass:[JSONModel class]] && key) {
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [def dictionaryForKey:key];
        
        return [[clazz alloc] initWithDictionary:dic error:nil];
    }
    else {
        return nil;
    }
}

/**
 *
 *  移除本地数据
 *
 *  @param key 关键字
 */
+ (void)removeObjectFromUserDefaultWith:(NSString*)key
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    // 移除
    [def removeObjectForKey:key];
    
    [def synchronize];
}

/**
 *
 *  保存字符串到UserDefault
 *
 *  @param value value
 *  @param key key
 */
+ (void)saveStringToUserDefault:(NSString*)value forKey:(NSString*)key
{
    if (!value || !key)
        return;
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:value forKey:key];
    [def synchronize];
}

/**
 *
 *  获取字符串从UserDefault
 *
 *  @param key key
 *
 *  @return value
 */
+ (NSString*)getStringFromUserDefault:(NSString*)key
{
    if (!key)
        return nil;
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}
/**
 *
 *  判断当前网络
 *
 *  @return 网络情况
 */
+ (BOOL)connectedToNetwork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL,
                                                                                               (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}
@end
