//
//  RALogicUnlockDetailInfo.h
//  BlueToothSDK
//
//  Created by Piccolo on 14/12/2017.
//  Copyright © 2017 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RALogicUnlockDetailInfo : NSObject

@property (nonatomic, assign) NSInteger groupID;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, assign) NSInteger degreeID;
@property (nonatomic, assign) NSInteger lockID;

- (instancetype)initWithGroupID:(NSInteger)groupID serial:(NSInteger)serial degreeID:(NSInteger)degreeID lockID:(NSInteger)lockID;

@end
