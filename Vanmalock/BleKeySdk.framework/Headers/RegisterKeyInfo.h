//
//  RegisterKeyInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecretInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RegisterKeyInfo : NSObject
//必填
@property (nonatomic, strong) SecretInfo *secretInfo;
//可以为空
@property (nonatomic, strong) NSArray<NSString*> *pwds;

-(instancetype)initWithSecretInfo:(SecretInfo*)secretInfo;
-(instancetype)initWithSecretInfo:(SecretInfo*)secretInfo pwds:(NSArray<NSString*> *)pwds;
@end

NS_ASSUME_NONNULL_END
