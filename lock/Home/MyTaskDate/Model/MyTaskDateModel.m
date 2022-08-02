//
//  MyTaskDateModel.m
//  lock
//
//  Created by 金万码 on 2022/7/30.
//  Copyright © 2022 li. All rights reserved.
//

#import "MyTaskDateModel.h"

@implementation LockDateListBean

@end

@implementation UnlockDateListBean

@end

@implementation MyTaskDateListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"taskid"]]];
}
@end

@implementation MyTaskDateListPage

@end

@implementation MyTaskDateListResponse

@end
