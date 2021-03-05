//
//  RecordInfo.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordInfo : NSObject
//{\"cmd\":%d,\"flag\":%d,\"lockid\":\"%s\",\"time\":\"%s\",\"status\":%d,\"finger\":%d}
@property (nonatomic) int cmd;
@property (nonatomic) int flag;
@property (nonatomic, strong) NSString *lockid;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic) int status;
@property (nonatomic) int finger;
@property (nonatomic) int flag1;

-(instancetype)initRecordInfo:(NSString*)lockid flag:(int)flag cmd:(int)cmd time:(NSDate*)time status:(int)status finger:(int)finger flag1:(int)flag1;
@end

NS_ASSUME_NONNULL_END
