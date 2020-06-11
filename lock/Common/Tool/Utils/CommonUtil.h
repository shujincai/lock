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
@end

NS_ASSUME_NONNULL_END
