//
//  DateSection.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeSection.h"
NS_ASSUME_NONNULL_BEGIN

@interface DateSection : NSObject
@property (nonatomic, strong) NSDate *from;   //钥匙时间
@property (nonatomic, strong) NSDate *to;   //钥匙时间
//https://stackoverflow.com/questions/5197446/nsmutablearray-force-the-array-to-hold-specific-object-type-only
@property (nonatomic,strong) NSArray<TimeSection*> *times;

-(instancetype)initSection:(NSDate*)from to:(NSDate*)to;
-(instancetype)initSection:(NSDate*)from to:(NSDate*)to times:(NSArray<TimeSection*>*) times;
@end

NS_ASSUME_NONNULL_END
