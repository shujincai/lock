//
//  ResultInfo.h
//  BlueToothSDK
//
//  Created by Piccolo on 2017/4/26.
//  Copyright © 2017年 Piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RASCRBleSDKPublicEnum.h"

@interface ResultInfo : NSObject

@property(assign, nonatomic) BOOL feedBackState;
@property(strong, nonatomic) NSMutableDictionary *feedBackDic;
@property(strong, nonatomic) NSMutableDictionary *detailDic;






@end
