//
//  BasicInfo.h
//  test1
//
//  Created by Piccolo on 2017/4/14.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RASCRBleSDKPublicEnum.h"

@interface BasicInfo : NSObject

- (id)initBasicInfo;


@property(strong, nonatomic) NSArray *regCode;
@property(strong, nonatomic) NSArray *sysCode;
@property(assign, nonatomic) RASCRBleSDKKeyType keyType;
@property(assign, nonatomic) NSInteger groupId;
@property(assign, nonatomic) NSInteger usingState;//0 使用中 ;其他 禁用中;
@property(assign, nonatomic) NSInteger verifyDay;//钥匙验证天数,钥匙在范围内必须重新更新钥匙制作时间，0为不启用（0-65535天）
@property(strong, nonatomic) NSDate *keyTime;

@property(assign, nonatomic) RASCRBleSDKLanguageType languageType;


@property(strong, nonatomic) NSString *keyValidityPeriodStart;//yy-MM-dd-HH-mm 有效期起
@property(strong, nonatomic) NSString *keyValidityPeriodEnd;//yy-MM-dd-HH-mm 有效期止
@property(assign, nonatomic) NSInteger keyId;

@property(strong, nonatomic) NSString *keyMadeTime;//钥匙制作时间

@property(strong, nonatomic) NSString *taskId;

@end


