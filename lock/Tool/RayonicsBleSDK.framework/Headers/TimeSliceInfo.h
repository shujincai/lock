//
//  TimeSliceInfo.h
//  BlueToothSDK
//
//  Created by Piccolo on 2017/8/3.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeScaleInfo.h"

@interface TimeSliceInfo : NSObject

@property (nonatomic, strong) NSArray<TimeScaleInfo *> *timeScaleInfoArray;
@property (nonatomic, assign) NSInteger timeScaleCount;
@property (nonatomic, assign) NSInteger timeSliceID;

- (instancetype)initWithTimeSliceID:(NSInteger)timeSliceID timeScaleInfoArray:(NSArray <TimeScaleInfo *>*)timeScaleInfoArray;


@end
