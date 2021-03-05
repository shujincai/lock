//
//  UserKeyInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateSection.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserKeyInfo : NSObject
@property (nonatomic, strong) NSArray <DateSection*> *timeBlocks;
@property (nonatomic, strong) NSArray<NSString*> *lockIds;
@property (nonatomic, strong) NSArray<NSArray<NSString*>*> *pwds;

-(instancetype)initUserKeyInfo:(NSArray<DateSection*>*)timeBlocks lockIds:(NSArray<NSString*>*)lockIds;
-(instancetype)initUserKeyInfo:(NSArray<DateSection*>*)timeBlocks lockIds:(NSArray<NSString*>*)lockIds pwds:(NSArray<NSArray<NSString*>*>*) pwds;
@end

NS_ASSUME_NONNULL_END
