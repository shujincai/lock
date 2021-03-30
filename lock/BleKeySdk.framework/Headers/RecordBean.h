//
//  RecordBean.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordBean : NSObject
@property (nonatomic) int total; //总包数
@property (nonatomic) int index;//当前包数
@property (nonatomic, strong) NSArray<RecordInfo*> *recordInfos;
@end

NS_ASSUME_NONNULL_END
