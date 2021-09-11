//
//  RASCRBleSDKPublicUtil.h
//  RayonicsBleSDK
//
//  Created by Piccolo on 2018/10/22.
//  Copyright © 2018年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RASCRBleSDKPublicEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class RASCRBleSDKPeripheralModel, CBPeripheral;

@interface RASCRBleSDKPublicUtil : NSObject

+ (RASCRBleSDKKeyHardwareType)keyHardwareTypeFromPeripheralName:(NSString *)name;
+ (NSString *)keyTagNameFromBleType:(RASCRBleSDKKeyHardwareType)type;
+ (BOOL)supportTimeRangeTempOpenFromPeripheralName:(NSString *)peripheralName HDVersion:(NSString *)HDVersion;
+ (BOOL)peripheralModelArray:(NSArray<RASCRBleSDKPeripheralModel *> *)peripheralModelArray containsPeripheral:(CBPeripheral *)peripheral;
+ (NSMutableArray<RASCRBleSDKPeripheralModel *> *)sortedPeripheralModelArrayFromArray:(NSMutableArray<RASCRBleSDKPeripheralModel *> *)array;
+ (NSDate *)dateAfterDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSArray<NSNumber *> *)arrayFromStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
