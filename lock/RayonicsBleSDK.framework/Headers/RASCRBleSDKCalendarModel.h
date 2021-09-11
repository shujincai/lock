//
//  RASCRBleSDKCalendarModel.h
//  BlueToothSDK
//
//  Created by Piccolo on 2018/9/5.
//  Copyright © 2018 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSRABleScreenKeyDateType){
    
    NSRABleScreenKeyDateTypeDisabled = 0x00,
    NSRABleScreenKeyDateTypeNormal = 0x01,
    NSRABleScreenKeyDateTypeHoliday = 0x02,
    NSRABleScreenKeyDateTypeSpecialDayI = 0x03,
    NSRABleScreenKeyDateTypeSpecialDayII = 0x04,
};

@interface RASCRBleSDKCalendarModel : NSObject

@property (nonatomic, strong) NSString *dateString;//日期(MMdd)0606 --> 6月6日
@property (nonatomic, assign) NSRABleScreenKeyDateType dateType;

- (instancetype)initWithDateString:(NSString *)dateString dateType:(NSRABleScreenKeyDateType)dateType;

@end
