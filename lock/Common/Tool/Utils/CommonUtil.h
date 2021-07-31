//
//  CommonUtil.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JSONModel;
@interface CommonUtil : NSObject

/**
 保存信息到UserDefault

 @param obj value
 @param key key
 */
+ (void)saveObjectToUserDefault:(JSONModel*)obj forKey:(NSString*)key;

/**
 获取信息从UserDefault
 
 @param key key
 */
+ (id)getObjectFromUserDefaultWith:(Class)clazz forKey:(NSString*)key;

/**
 删除数据从UserDefault

 @param key key
 */
+ (void)removeObjectFromUserDefaultWith:(NSString*)key;

/**
 *
 *  保存字符串到UserDefault
 *
 *  @param value value
 *  @param key key
 */
+ (void)saveStringToUserDefault:(NSString*)value forKey:(NSString*)key;

/**
 *
 *  获取字符串从UserDefault
 *
 *  @param key key
 *
 *  @return value
 */
+ (NSString*)getStringFromUserDefault:(NSString*)key;
/**
 *
 *  判断当前网络
 *
 *  @return 网络情况
 */
+ (BOOL)connectedToNetwork;

//获取当前时间
+(NSString*)getCurrentTimes;

//获取B锁连接蓝牙钥匙密钥
+ (NSArray *)desDecodeWithCode:(NSString *)code withPassword:(NSString *)key;

//获取C锁连接蓝牙钥匙密钥
+ (NSString *)getCLockDesDecodeWithCode:(NSString *)code withPassword:(NSString *)key;

// 通过蓝牙钥匙名称获取mac地址
+ (NSString *)getBluetoothKeyMac:(NSString *)name;

// 判断是B锁 C锁
// true B锁 false C锁
+ (BOOL)getLockType;

// 获取当前系统语言是否是中文
+ (BOOL)getAppleLanguages;

@end

NS_ASSUME_NONNULL_END
