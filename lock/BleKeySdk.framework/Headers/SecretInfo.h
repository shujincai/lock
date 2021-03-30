//
//  SecretInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecretInfo : NSObject
@property (nonatomic, strong) NSString * oldSecret;
@property (nonatomic, strong) NSString * nowSecret;
-(instancetype)initSecret:(NSString*)oldSecret nowSecret:(NSString*)nowSecret;
@end

NS_ASSUME_NONNULL_END
