//
//  UserKeyInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LockInfo4.h"
#import "DateSection.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserKeyInfo4 : NSObject
@property (nonatomic, strong) NSArray <DateSection*> *timeBlocks;
@property (nonatomic, strong) NSArray<LockInfo4*> *locks;

-(instancetype)initUserKeyInfo4:(NSArray<DateSection*>*)timeBlocks lockIds:(NSArray<LockInfo4*>*)locks;
@end

//@compatibility_alias UserKeyInfo WMUserKeyInfo;
NS_ASSUME_NONNULL_END
