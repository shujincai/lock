//
//  RASCRBleSDKPublicEnum.h
//  BlueToothSDK
//
//  Created by Piccolo on 2018/4/25.
//  Copyright © 2018 Piccolo. All rights reserved.
//

#ifndef RASCRBleSDKPublicEnum_h
#define RASCRBleSDKPublicEnum_h

typedef NS_ENUM(unsigned char, RASCRBleSDKKeyType){
    
    RASCRBleSDKKeyTypeUser = 0x50,                             //用户钥匙
    RASCRBleSDKKeyTypeSetting = 0x12,                          //设置钥匙
    RASCRBleSDKKeyTypeRegister = 0x11,                         //密码钥匙 RegisterKey
    RASCRBleSDKKeyTypeConstruction = 0x23,                     //施工钥匙
    RASCRBleSDKKeyTypeEmergency = 0xF6,                        //应急钥匙
    RASCRBleSDKKeyTypeBlackList = 0x15,                        //挂失钥匙
    RASCRBleSDKKeyTypeVerify = 0x20,                           //锁号钥匙
    RASCRBleSDKKeyTypeTrace = 0x21,                            //追溯钥匙
    RASCRBleSDKKeyTypeLogout = 0xF2,                           //注销钥匙
    RASCRBleSDKKeyTypeBlank = 0x0,                             //空白钥匙
    RASCRBleSDKKeyTypeAudit = 0x13,                            //事件钥匙
    
};

typedef NS_ENUM(NSUInteger, RASCRBleSDKLockIDType){
    RASCRBleSDKLockIDTypeSimgle = 0x1,
    RASCRBleSDKLockIDTypeGroup = 0x0,
};

typedef NS_ENUM(NSUInteger, RASCRBleSDKLanguageType){
    RASCRBleSDKLanguageTypeChinese = 0x0,
    RASCRBleSDKLanguageTypeEnglish = 0x1,
};

typedef NS_ENUM(NSUInteger, RASCRBleSDKEventType){
    RASCRBleSDKEventTypeOpenSuccess = 0x01,
    RASCRBleSDKEventTypeSetupSuccess = 0x02,
    RASCRBleSDKEventTypeSetupFailed = 0x03,
    RASCRBleSDKEventTypePermissionExpired = 0x04,
    RASCRBleSDKEventTypePermissionDenied = 0x05,
    RASCRBleSDKEventTypeOutsideTimeZone = 0x06,
    RASCRBleSDKEventTypeSyscodeError = 0x07,
    RASCRBleSDKEventTypeInBlacklist = 0x08,
    RASCRBleSDKEventTypeCommunicationError = 0x09,
    RASCRBleSDKEventTypeReadLockID = 0x0a,
    RASCRBleSDKEventTypeReadLockSerialNumber = 0x0b,
    RASCRBleSDKEventTypeReadLockVersion = 0x0c,
    RASCRBleSDKEventTypeUnlockSuccess = 0x0d,
    RASCRBleSDKEventTypeLockSuccess = 0x0e,
    RASCRBleSDKEventTypeCharging = 0x0f,
    RASCRBleSDKEventTypeReadLockAngle = 0x10,
    RASCRBleSDKEventTypeCharged = 0x11,
    RASCRBleSDKEventTypeUncharged = 0x12,
};


#endif /* RASCRBleSDKPublicEnum_h */
