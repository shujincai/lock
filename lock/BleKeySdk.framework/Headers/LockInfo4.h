//
//  UserKeyInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockInfo4 : NSObject
@property (nonatomic, strong) NSString* lockId;
@property (nonatomic) int timeId;
-(instancetype)initLockInfo4:(NSString*)lockId timeId:(int)timeId;

@end

//@compatibility_alias UserKeyInfo WMUserKeyInfo;
NS_ASSUME_NONNULL_END
