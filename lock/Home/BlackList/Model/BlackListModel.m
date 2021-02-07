//
//  BlackListModel.m
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import "BlackListModel.h"

@implementation BlackListRequest

@end

@implementation BlackListBean
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:[NSDictionary dictionaryWithObjects:@[@"id"] forKeys:@[@"blackid"]]];
}
@end

@implementation BlackListPage

@end

@implementation BlackListResponse

@end
