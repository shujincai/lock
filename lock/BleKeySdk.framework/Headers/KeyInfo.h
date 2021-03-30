//
//  KeyInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

enum KeyMode {
    BlankKey = 0x00,         //说明：模式位为0x00为空白钥匙
    EmergencyKeyy = 0x09,     //说明：模式位位0x09为万能钥匙模式 应急钥匙
    UserKeyy = 0x0A,          //说明：模式位为0x0A为开关锁模式  用户钥匙(开关锁钥匙)
    EventsKeyy = 0x10,        //说明：模式位为0x10为管理模式下的事件钥匙              事件钥匙
    LockSecretKeyy = 0x11,    //说明：模式位为0x11为管理模式下的初始化钥匙         初始化锁钥匙
    BlockListKeyy = 0x12,     //说明：模式位为0x12为管理模式下的黑名单钥匙          黑名单钥匙
    ReadLockIdKeyy = 0x13     //说明：模式位为0x13为管理模式下的采集锁ID钥匙       读取锁ID钥匙
};
typedef enum KeyMode KeyMode;

@interface KeyInfo : NSObject

@property (nonatomic, strong) NSString *keyId;   //钥匙ID
@property (nonatomic) int device;  //设备类别
@property (nonatomic) int protocol; //钥匙协议类别
@property (nonatomic, strong) NSDate *time;   //钥匙时间
@property (nonatomic) int ver;    //钥匙硬件版本
@property (nonatomic) KeyMode mode; //钥匙模式
@property (nonatomic, strong) NSString *sign;
@property (nonatomic) bool blocklistflag; //黑名单标记
@property (nonatomic) float voltage;
@property (nonatomic) bool online;
@end

NS_ASSUME_NONNULL_END
