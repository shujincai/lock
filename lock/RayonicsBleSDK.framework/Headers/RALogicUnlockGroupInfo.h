//
//  RALogicUnlockGroupInfo.h
//  BlueToothSDK
//
//  Created by Piccolo on 14/12/2017.
//  Copyright © 2017 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RALogicUnlockDetailInfo.h"

@interface RALogicUnlockGroupInfo : NSObject

@property (nonatomic, strong) NSArray <RALogicUnlockDetailInfo *> *detailInfoArray;
@property (nonatomic, assign) NSInteger groupID;
@property (nonatomic, strong) NSDate *beginTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, assign) NSInteger overTimeMinute;
@property (nonatomic, assign) NSInteger lockCount;

- (instancetype)initWithGroupID:(NSInteger)groupID beginTime:(NSDate *)beginTime endTime:(NSDate *)endTime overTimeMinute:(NSInteger)overTimeMinute detailInfoArray:(NSArray <RALogicUnlockDetailInfo *> *)logicUnlockDetailInfoArray;

@end
