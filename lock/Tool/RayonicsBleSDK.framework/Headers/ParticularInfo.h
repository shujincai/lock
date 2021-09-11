//
//  ParticularInfo.h
//  test1
//
//  Created by Piccolo on 2017/4/14.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RASCRBleSDKPublicEnum.h"
@class TimeSliceInfo, RALogicUnlockGroupInfo, RASCRBleSDKCalendarModel;

typedef NS_ENUM(NSUInteger, NSRASCRBleSDKKeyRotationAngleMode) {
    NSRASCRBleSDKKeyRotationAngleModeDefault = 0x00,
    NSRASCRBleSDKKeyRotationAngleModeOn,
    NSRASCRBleSDKKeyRotationAngleModeOff,
};

@interface ParticularInfo : NSObject

//- (id)initWithKeyType:(RASCRBleSDKKeyType) keyType;

@end



@interface BlankKeyInfo : ParticularInfo

//空白钥匙
@property (strong, nonatomic) NSArray *modifiedSyscode;//新系统码
@property (strong, nonatomic) NSArray *modifiedRegcode;//新锁匠码

@end


@interface RegisterKeyInfo : ParticularInfo

//系统码钥匙
@property (strong, nonatomic) NSArray *lockCylinderCode;//锁芯系统码
@property (strong, nonatomic) NSArray *newlockCylinderCode;//新锁匠码

@end

@interface SettingKeyInfo : ParticularInfo

//设置钥匙
@property (assign, nonatomic) NSInteger lockId;//锁ID
@property (assign, nonatomic) NSInteger lockGroupId;//锁组ID
@property (assign, nonatomic) NSInteger forbidFlag;//禁止标志

@end

@interface BlackListKeyInfo : ParticularInfo

//挂失钥匙
@property (strong, nonatomic) NSArray *blackKeyList;

@end




@interface UserKeyInfo : ParticularInfo

////用户钥匙

@property (strong, nonatomic) NSString *daylightSavingTimeBegin;//yy-MM-dd-HH 夏令时起
@property (strong, nonatomic) NSString *daylightSavingTimeEnd;//yy-MM-dd-HH 夏令时止
@property (strong, nonatomic) NSArray <TimeSliceInfo *> *timeSliceInfoArray;
@property (assign, nonatomic) NSInteger calendarYear;//日历年份
@property (strong, nonatomic) NSArray<RASCRBleSDKCalendarModel *> *calendarModelArray;
@property (assign, nonatomic) BOOL needCleanAppOpen;//是否清空时间片权限
@property (strong, nonatomic) NSArray *modifyKeyUnlockPowerArray;//修改权限数组
@property (assign, nonatomic) BOOL needCleanTempPermission;//是否清空临时权限
@property (strong, nonatomic) NSArray *tempOpenPowerArray;//临时权限数组
@property (assign, nonatomic) NSInteger tempOpenPowerCount;//临时开门权限数量
@property (assign, nonatomic) BOOL needCleanRangeTempPermission;//是否清空范围临时权限
@property (strong, nonatomic) NSArray *tempTimeRangeOpenPowerArray;//临时时间范围权限数组
@property (assign, nonatomic) NSInteger tempTimeRangeOpenPowerCount;//临时时间范围开门权限数量
@property (nonatomic, strong) NSArray <RALogicUnlockGroupInfo *> *logicUnlockGroupInfoArray;
@property (assign, nonatomic) NSRASCRBleSDKKeyRotationAngleMode rotationAngleMode;


@end


@interface OnlineOpenInfo : ParticularInfo

//在线开门
@property (strong, nonatomic) NSString *onlineOpenStartTime;//yy-MM-dd-HH-mm
@property (strong, nonatomic) NSString *onlineOpenEndTime;//yy-MM-dd-HH-mm
@property (assign, nonatomic) NSInteger idType;//0x00表示锁组ID ，0x01表示锁ID
@property (assign, nonatomic) NSInteger lockOrLockGroupId;
@property (assign, nonatomic) NSRASCRBleSDKKeyRotationAngleMode rotationAngleMode;

@end
