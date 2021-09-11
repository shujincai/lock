//
//  RASCRBleSDKPublicEnum.h
//  BlueToothSDK
//
//  Created by Piccolo on 2018/4/25.
//  Copyright © 2018 Piccolo. All rights reserved.
//

#ifndef RASCRBleSDKPublicEnum_h
#define RASCRBleSDKPublicEnum_h

typedef NS_ENUM(NSUInteger, RASCRBleSDKKeyHardwareType) {
    
    RASCRBleSDKKeyHardwareTypeUnknow = 0x00,//未知钥匙
    RASCRBleSDKKeyHardwareTypeOrdinary = 0x01,//普通屏幕钥匙(Rayo-001)
    RASCRBleSDKKeyHardwareTypeStandard = 0x02,//标准屏幕钥匙(3005)
    RASCRBleSDKKeyHardwareTypeNoScreen = 0x03,//屏幕不会亮的带屏钥匙(3009)
    RASCRBleSDKKeyHardwareTypeNoScreenBlueShell = 0x04,//蓝壳钥匙(3018)
};

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

typedef NS_ENUM(NSUInteger, RASCRBleSDKIDType){
    RASCRBleSDKIDTypeLockID = 0x1,
    RASCRBleSDKIDTypeGroupID = 0x0,
};

typedef NS_ENUM(NSUInteger, RASCRBleSDKLanguageType){
    RASCRBleSDKLanguageTypeChinese = 0x0,
    RASCRBleSDKLanguageTypeEnglish = 0x1,
};

typedef NS_ENUM(NSUInteger, RASCRBleSDKEventType){
    RASCRBleSDKEventTypeOpenSuccess = 0x01,//开锁成功
    RASCRBleSDKEventTypeSetupSuccess = 0x02,//设置成功
    RASCRBleSDKEventTypeSetupFailed = 0x03,//设置失败
    RASCRBleSDKEventTypePermissionExpired = 0x04,//超出有效期
    RASCRBleSDKEventTypePermissionDenied = 0x05,//无权限
    RASCRBleSDKEventTypeOutsideTimeZone = 0x06,//时间片外
    RASCRBleSDKEventTypeSyscodeError = 0x07,//系统码错误
    RASCRBleSDKEventTypeInBlacklist = 0x08,//黑名单
    RASCRBleSDKEventTypeCommunicationError = 0x09,//通讯错误
    RASCRBleSDKEventTypeReadLockID = 0x0a,//读取锁号
    RASCRBleSDKEventTypeReadLockSerialNumber = 0x0b,//读取锁编号
    RASCRBleSDKEventTypeReadLockVersion = 0x0c,//读取锁版本
    RASCRBleSDKEventTypeUnlockSuccess = 0x0d,//锁正转
    RASCRBleSDKEventTypeLockSuccess = 0x0e,//锁反转
    RASCRBleSDKEventTypeCharging = 0x0f,
    RASCRBleSDKEventTypeReadLockAngle = 0x10,//读取锁角度
    RASCRBleSDKEventTypeCharged = 0x11,
    RASCRBleSDKEventTypeUncharged = 0x12,
};


#endif /* RASCRBleSDKPublicEnum_h */
