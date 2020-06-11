//
//  TimeScaleInfo.h
//  BlueToothSDK
//
//  Created by Piccolo on 2017/8/3.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeScaleInfo : NSObject

@property (assign, nonatomic) NSInteger timeScaleID;//时间段编号
@property (assign, nonatomic) NSInteger timeSliceID;
@property (strong, nonatomic) NSString *timeScaleStartTime;//时间段开始时间 HH-mm
@property (strong, nonatomic) NSString *timeScaleEndTime;//时间段结束时间 HH-mm
@property (strong, nonatomic) NSString *weekdayFlag;//星期标志
@property (strong, nonatomic) NSString *calendarFlag;//日历标志

- (instancetype)initWithTimeScaleID:(NSInteger)timeScaleID timeSliceID:(NSInteger)timeSliceID timeScaleStartTime:(NSString *)timeScaleStartTime timeScaleEndTime:(NSString *)timeScaleEndTime weekdayFlag:(NSString *)weekdayFlag clendarFlag:(NSString *)calendarFlag;

@end
