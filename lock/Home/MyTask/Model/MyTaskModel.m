//
//  MyTaskModel.m
//  lock
//
//  Created by admin on 2020/5/27.
//  Copyright © 2020 li. All rights reserved.
//

#import "MyTaskModel.h"

@implementation MyTaskNumberRequest

@end

@implementation MyTaskNumberResponse

@end

@implementation MyTaskListRequest

@end

@implementation MyTaskListResponse

@end

@implementation MyTaskListPage

@end

@implementation MyTaskListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"taskid"]]];
}
@end

@implementation MyTaskTimeRangeListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"timeid"]]];
}
@end

@implementation UnlockListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"listid"]]];
}
@end

@implementation MyTaskValidRequest

@end

@implementation MyTaskValidResponse

@end

@implementation MyTaskSwitchLockInfoBean

@end

@implementation MyTaskUploadKeyDataReqest

@end

@implementation MyTaskFingerprintListRequest

@end

@implementation MyTaskFingerprintListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"fid"]]];
}
@end

@implementation MyTaskFingerprintListResponse

@end
