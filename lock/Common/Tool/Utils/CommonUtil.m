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
#import <CommonCrypto/CommonCryptor.h>

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
//获取B锁连接蓝牙钥匙密钥
+ (NSArray *)desDecodeWithCode:(NSString *)code withPassword:(NSString *)key {
    
    NSData * codeData = [[NSData alloc]initWithBase64EncodedString:code options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //设置密钥
    NSMutableString * keyString = [[NSMutableString alloc]initWithString:key];
    int mod = key.length % 8;
    if (mod > 0) {
        for (int i = 0; i < 8 - mod; i++){
            [keyString appendString:@"0"];
        }
    }
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [codeData length];
    size_t bufferPtrSize = dataLength + kCCBlockSizeAES128;
    unsigned char* buffer = (unsigned char *)malloc(bufferPtrSize);
    memset(buffer, 0, bufferPtrSize);
    
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,//解密
                                          kCCAlgorithmDES,//加密算法
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,//补码方式
                                          keyPtr,//传入的密钥
                                          kCCKeySizeDES,//密钥长度
                                          iv,//偏移向量
                                          [codeData bytes],//解密的数据
                                          [codeData length],//解密的数据的长度
                                          buffer,//解密完后，数据保存的地方
                                          bufferPtrSize,//解密后的数据需要的空间
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSMutableArray * array = [NSMutableArray new];
    for (int j = 0; j < 4; j++) {
        NSString * str = [plainText substringWithRange:NSMakeRange(j*2, 2)];
        NSString * str10 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
        [array addObject:[NSNumber numberWithInt:[str10 intValue]]];
    }
    return array;
}
//获取C锁连接蓝牙钥匙密钥
+ (NSString *)getCLockDesDecodeWithCode:(NSString *)code withPassword:(NSString *)key {
    
    NSData * codeData = [[NSData alloc]initWithBase64EncodedString:code options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //设置密钥
    NSMutableString * keyString = [[NSMutableString alloc]initWithString:key];
    int mod = key.length % 8;
    if (mod > 0) {
        for (int i = 0; i < 8 - mod; i++){
            [keyString appendString:@"0"];
        }
    }
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [codeData length];
    size_t bufferPtrSize = dataLength + kCCBlockSizeAES128;
    unsigned char* buffer = (unsigned char *)malloc(bufferPtrSize);
    memset(buffer, 0, bufferPtrSize);
    
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,//解密
                                          kCCAlgorithmDES,//加密算法
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,//补码方式
                                          keyPtr,//传入的密钥
                                          kCCKeySizeDES,//密钥长度
                                          iv,//偏移向量
                                          [codeData bytes],//解密的数据
                                          [codeData length],//解密的数据的长度
                                          buffer,//解密完后，数据保存的地方
                                          bufferPtrSize,//解密后的数据需要的空间
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

+ (NSString *)getBluetoothKeyMac:(NSString *)name {
    NSString * string = [name substringFromIndex:name.length - 12];
    NSMutableArray * array = [NSMutableArray new];
    for (int i = 0; i< 6; i++) {
        NSString * str = [string substringWithRange:NSMakeRange(10-i*2, 2)];
        [array addObject:str];
    }
    return [array componentsJoinedByString:@""];
}

// 判断是B锁 C锁
// true B锁 false C锁
+ (BOOL)getLockType {
    UserInfo * userInfo = [self getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    return !userInfo.wmSdk;
}
@end


