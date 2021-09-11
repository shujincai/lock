//
//  RASCRBleSDKPeripheralModel.h
//  BlueToothSDK
//
//  Created by Piccolo on 2019/3/4.
//  Copyright © 2019 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface RASCRBleSDKPeripheralModel : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSString *peripheralName;
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral peripheralName:(NSString *)peripheralName RSSI:(NSNumber *)RSSI;

@end

NS_ASSUME_NONNULL_END
