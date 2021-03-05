//
//  TimeSection.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeSection : NSObject
@property (nonatomic, strong) NSDate *from;   //钥匙时间
@property (nonatomic, strong) NSDate *to;   //钥匙时间

-(instancetype)initSection:(NSDate*)from to:(NSDate*)to;
@end

NS_ASSUME_NONNULL_END
