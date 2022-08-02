//
//  Sdk.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Result.h"
#import "KeyInfo.h"
#import "RecordInfo.h"
#import "RecordBean.h"
#import "UserKeyInfo.h"
#import "UserKeyInfo4.h"
#import "LockInfo4.h"
#import "DateSection.h"
#import "RegisterKeyInfo.h"


@protocol KeyDelegate <NSObject>
@optional
//扫描蓝牙
//NSDictionary keyId,mac
-(void)onScanedPeripheral:(CBPeripheral *)peripheral keyIdData:(NSDictionary *)keyIdData RSSI:(NSNumber *)RSSI;

-(void)onScanFinished;
//连接蓝牙钥匙 , 如果成功需要判断 code （密钥是否正确）
-(void)onConnectToKey:(Result*)result;
//与钥匙断开连接
-(void)onDisconnectFromKey:(Result*)result;
//校时
-(void)onSetDateTime:(Result*)result;
//读取钥匙记录 ,clearFlag 读取成功后是否清除数据
// total 总包数 ,index 当前包
-(void)onReadKeyRecords:(Result<RecordBean*>*) result;
-(void)onReport:(Result<RecordInfo*>*) result;
//删除数据
-(void)onClearRecords:(Result*)result;
//设置空白钥匙
-(void)onSetBlankKey:(Result*)result;
//设置管理钥匙 ,有效时间段
-(void)onSetManagerKey:(Result*)result;
//设置开关锁钥匙--用户钥匙,isOnline 是否在线，在线断开连接后，钥匙不能开关锁
-(void)onSetUserKey:(Result*)result;
//设置事件钥匙
-(void)onSetEventsKey:(Result*)result;
//设置黑名单钥匙
-(void)onSetBlockListKey:(Result*)result;
//设置读取锁号钥匙
-(void)onSetReadLockIdKey:(Result*)result;
//设置注册钥匙，设置锁的密钥，锁的密码等
-(void)onSetRegisterKey:(Result*)result;
//清除黑名单钥匙
-(void)onClearBlocklistFlag:(Result*)result;
//读取钥匙信息 读取钥匙信息(钥匙ID,钥匙时间，钥匙硬件版本号码、钥匙模式、国内外、黑名单标记、电池电量)
-(void)onReadKeyInfo:(Result<KeyInfo*>*) result;
//设置钥匙 密钥
-(void)onSetKeySecret:(Result*)result;
//在线授权
-(void)onSetOnline:(Result*)result;
//指纹授权
-(void)onSetFingers:(Result*)result;
-(void)onDeleteFingerprint:(Result*)result;
-(void)onSetFingerprint:(Result*)result;

-(void)onCommand:(NSData*)result;
@end
//=========================
@interface BleKeySdk: NSObject
+(instancetype)shareKeySdk;

-(void)initSdk;
-(void)setDelgate:(id)delgate;
//开始扫描
-(void)startScan:(int) timeOut;
//停止扫描
-(void)stopScan;
//链接钥匙
-(void)connectToKey:(CBPeripheral *)peripheral secret:(NSString*)secret sign:(int)sign;
//断开链接
-(void)disConnectFromKey;
-(void)setDateTime:(NSDate*) date;
-(void)readKeyRecords:(bool) clearFlag;
-(void)clearRecords;
-(void)setBlankKey;
-(void)setManagerKey:(NSDate*) from to:(NSDate*)to;
-(void)setUserKey:(WMUserKeyInfo*) userKeyInfo isOnline:(bool) isOnline;
-(void)setEventsKey:(NSDate*) from to:(NSDate*)to;
-(void)setBlockListKey:(NSDate*)from to:(NSDate*)to keyIds:(NSArray<NSString*>*)keyIds;
-(void)setReadLockIdKey;
-(void)setRegisterKey:(NSDate*)from to:(NSDate*)to registerKeyInfo:(WMRegisterKeyInfo*) registerKeyInfo;
-(void)clearBlocklistFlag;
-(void)readKeyInfo;
-(void)setKeySecret:(SecretInfo*)secretInfo;
-(void)setOnline;
-(void)setFingers:(NSArray<NSNumber*>*)ids;
-(void)deleteFingerprint:(NSNumber*) fid;
-(void)setFingerprint:(NSNumber*)fid fea:(NSString*)fea;
//2022-07-29 增加，一个锁可以对应多个日期段
-(void)setUserKey4:(UserKeyInfo4*) userKeyInfo isOnline:(bool) isOnline;

-(void)destory;
-(NSString*) getSdkVersion;

@end
