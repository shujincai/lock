//
//  SetKeyController.h
//
//  Created by Piccolo on 2017/4/19.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RASCRBleSDKPublicEnum.h"

//After the bluetooth disconnect, the permission turn back to 'NSRAPermissionFlagOfflineOpenOnly'.
//While set user key.
typedef NS_ENUM(NSUInteger, NSRAPermissionFlag) {
    NSRAPermissionFlagOnlineOpenAndOffLineOpen = 0x00,
    NSRAPermissionFlagOnlineOpenOnly = 0x01,
    NSRAPermissionFlagOfflineOpenOnly = 0xff,
};

@class RASCRBleSDKPeripheralModel, BasicInfo, ParticularInfo, ResultInfo, BlackListKeyInfo, BlankKeyInfo, RegisterKeyInfo, SettingKeyInfo, UserKeyInfo, OnlineOpenInfo;

#define DEFINE_SYSCODE @[@0x36, @0x36, @0x36, @0x36]
#define DEFINE_REGCODE @[@0x31, @0x31, @0x31, @0x31]

@protocol SetKeyControllerDelegate <NSObject>
@optional

- (void)scannedPeripheralModel:(RASCRBleSDKPeripheralModel *)peripheralModel;
- (void)currentRssi:(NSNumber *)rssi;

- (void)requestInitSdkResultInfo:(ResultInfo *)info;
- (void)requestDestroyResultInfo:(ResultInfo *)info;
- (void)requestInitBleManagerResultInfo:(ResultInfo *)info;
- (void)requestDisconnectResultInfo:(ResultInfo *)info;
- (void)requestSetBlankKeyResultInfo:(ResultInfo *)info;
- (void)requestConnectResultInfo:(ResultInfo *)info;
- (void)requestSetRegisterKeyResultInfo:(ResultInfo *)info;
- (void)requestSetSettingKeyResultInfo:(ResultInfo *)info;
- (void)requestGetSettingKeyInfoResultInfo:(ResultInfo *)info;
- (void)requestSetTraceKeyResultInfo:(ResultInfo *)info;
- (void)requestSetBlackListKeyResultInfo:(ResultInfo *)info;
- (void)requestSetVerifyKeyResultInfo:(ResultInfo *)info;
- (void)requestSetAuditKeyResultInfo:(ResultInfo *)info;
- (void)requestSetEmergencyKeyResultInfo:(ResultInfo *)info;
- (void)requestSetConstructionKeyResultInfo:(ResultInfo *)info;
- (void)requestSetLogoutKeyResultInfo:(ResultInfo *)info;
- (void)requestResetKeyResultInfo:(ResultInfo *)info;
- (void)requestSetUserKeyResultInfo:(ResultInfo *)info;
- (void)requestReadKeyInfoResultInfo:(ResultInfo *)info;
- (void)requestReadKeyEventResultInfo:(ResultInfo *)info;
- (void)requestSetOnlineOpenResultInfo:(ResultInfo *)info;
- (void)requestActiveReport:(ResultInfo *)info;
- (void)requestInitKeyResultInfo:(ResultInfo *)info;
- (void)requestSetKeyRotationAngleEnabledResultInfo:(ResultInfo *)info;
- (void)requestSetKeyTaskIdResultInfo:(ResultInfo *)info;
- (void)requestGetKeyTaskIdResultInfo:(ResultInfo *)info;
- (void)requestGetKeySecretResultInfo:(ResultInfo *)info;

@end


@interface SetKeyController : NSObject

@property(nonatomic,weak) id<SetKeyControllerDelegate>delegate;

/**
 *获取单例对象的方法
 */

+ (void)initSDK;
+ (instancetype)sharedManager;
//+ (CBPeripheral *)getCurrentBle;
+ (CBPeripheralState)getCurrentBleState;
+ (void)setDelegate:(id)delegate;

+ (void)initBlueToothManager;
+ (void)startScan;
+ (void)stopScan;
+ (void)connectBlueTooth:(CBPeripheral *)peripheral withSyscode:(NSArray *)syscode withRegcode:(NSArray *)regcode withLanguageType:(RASCRBleSDKLanguageType)languageType needResetKey:(BOOL)needResetKey;
+ (void)connectBlueTooth:(CBPeripheral *)peripheral originalSyscode:(NSArray *)originalSyscode syscode:(NSArray *)syscode originalRegcode:(NSArray *)originalRegcode regcode:(NSArray *)regcode languageType:(RASCRBleSDKLanguageType)languageType needResetKey:(BOOL)needResetKey;
+ (void)disConnectBle;
+ (void)destroyBle;
+ (void)setManager:(CBCentralManager *)manager peripheral:(CBPeripheral *)peripheral;
+ (void)releaseBleManager;

+ (void)privateInitKey:(CBPeripheral *)peripheral;
+ (void)setBlankKey:(BasicInfo *)basicInfo andBlankKeyInfo:(BlankKeyInfo *)blankKeyInfo;
+ (void)setRegisterKey:(BasicInfo *)basicInfo andRegisterKeyInfo:(RegisterKeyInfo *)resigerKeyInfo;
+ (void)setSettingKey:(BasicInfo *)basicInfo andSettingKeyInfo:(SettingKeyInfo *)settingKeyInfo;
+ (void)setTraceKey:(BasicInfo *)basicInfo;
+ (void)setBlackListKey:(BasicInfo *)basicInfo andBlackListKeyInfo:(BlackListKeyInfo *)blackListKeyInfo;
+ (void)setVerifyKey:(BasicInfo *)basicInfo;
+ (void)setAuditKey:(BasicInfo *)basicInfo;
+ (void)setEmergencyKey:(BasicInfo *)basicInfo;
+ (void)setConstructionKey:(BasicInfo *)basicInfo;
+ (void)setLogoutKey:(BasicInfo *)basicInfo;
+ (void)setUserKey:(BasicInfo *)basicInfo andUserKeyInfo:(UserKeyInfo *)userKeyInfo;
/** onlineoOpen :
 * CN--是否在钥匙蓝牙连接的时候去判断开门权限,默认为NO,蓝牙连接状态忽略离线权限.
 * EN--Whether to judge the opening permission when the key is connected by bluetooth, and the default is NO(the offline permission is ignored in the bluetooth connection state)
 * onlineOpen ? NSRAPermissionFlagOnlineOpenAndOffLineOpen : NSRAPermissionFlagOfflineOpenOnly
 */
+ (void)setUserKey:(BasicInfo *)basicInfo andUserKeyInfo:(UserKeyInfo *)userKeyInfo onlineOpen:(BOOL)onlineOpen;
+ (void)setUserKey:(BasicInfo *)basicInfo andUserKeyInfo:(UserKeyInfo *)userKeyInfo permissionFlag:(NSRAPermissionFlag)permissionFlag;
+ (void)resetKey;
+ (void)setOnlineOpen:(BasicInfo *)basicInfo andOnlineOpenInfo:(OnlineOpenInfo *)onlineOpenInfo;
+ (void)setKeyRotationAngleEnabled:(BOOL)enabled;
+ (void)setKeyTaskId:(NSString *)taskId;
+ (void)readKeyTaskId;

+ (void)readKeyBasicInfo;
+ (void)getSettingKeyInfo;
+ (void)readKeyEvent;
+ (void)readKeyEventClean:(BOOL)clean;
+ (void)manageActiveReportingValueOfCharacteristic:(NSData *)activeReportingValue;
+ (void)getKeySecretsFromPosition:(NSUInteger)position size:(NSUInteger)size;


/**
 * V0.0.72
 * Fix the V208 crash in iPhone 6
 * May 21 2021
 */

/**
 * V0.0.73
 * Fix the issue while the key not support task id
 * May 25 2021
 */

@end
