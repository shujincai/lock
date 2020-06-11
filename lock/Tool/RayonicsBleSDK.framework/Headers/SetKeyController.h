//
//  SetKeyController.h
//  test1
//
//  Created by Piccolo on 2017/4/19.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicInfo.h"
#import "ParticularInfo.h"
#import "ResultInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>



#define CLEAN_APP_OPEN 1
#define NOT_CLEAN_APP_OPEN 0

#define SDK_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define SDK_RELEASE_TIME @"2018-4-25"

//#define DEFINE_SYSCODE @[@0x37, @0x37, @0x37, @0x37]
#define DEFINE_SYSCODE @[@0x36, @0x36, @0x36, @0x36]
//#define DEFINE_SYSCODE @[@0x36, @0x36, @0x36, @0x37]
#define DEFINE_REGCODE @[@0x31, @0x31, @0x31, @0x31]



@protocol SetKeyControllerDelegate <NSObject>
@optional

- (void)requestResultInfo:(ResultInfo *)info;
- (void)scanedPeripheral:(CBPeripheral *)peripheral;
- (void)currentRssi:(NSNumber *)rssi;
- (void)activeReport:(NSData *)data;


- (void)requestInitSdkResultInfo:(ResultInfo *)info;
- (void)requestDestroyResultInfo:(ResultInfo *)info;
- (void)requestInitBleManagerResultInfo:(ResultInfo *)info;
- (void)requestDisconnectResultInfo:(ResultInfo *)info;
- (void)requestSetBlankKeyResultInfo:(ResultInfo *)info;
- (void)requestConnectResultInfo:(ResultInfo *)info;
- (void)requestSetRegisterKeyResultInfo:(ResultInfo *)info;
- (void)requestSetSettingKeyResultInfo:(ResultInfo *)info;
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
@end


@interface SetKeyController : NSObject


@property(nonatomic,weak) id<SetKeyControllerDelegate>delegate;

//+ (void)startBlueTooth:(id)delegate;

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
+ (void)connectBlueTooth:(CBPeripheral *)per withSyscode:(NSArray *)syscode withRegcode:(NSArray *)regcode withLanguageType:(RASCRBleSDKLanguageType)languageType needResetKey:(BOOL)needResetKey;
+ (void)disConnectBle;
//+ (void)registerKey:(NSArray *)syscode andRegcode:(NSArray *)regcode;
+ (void)destroyBle;
+ (void)setManager:(CBCentralManager *)manager peripheral:(CBPeripheral *)peripheral;
+ (void)releaseBleManager;

+ (void)privateInitKey;
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
+ (void)resetKey;
+ (void)setOnlineOpen:(BasicInfo *)basicInfo andOnlineOpenInfo:(OnlineOpenInfo *)onlineOpenInfo;

+ (void)readKeyBasicInfo;
+ (void)readKeyEvent;
+ (void)manageActiveReportingValueOfCharacteristic:(NSData *)activeReportingValue;

@end
