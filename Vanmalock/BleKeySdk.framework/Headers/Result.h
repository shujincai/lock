//
//  Result.h
//  BleKeySdk
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020年 jwm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface Result<__covariant T> : NSObject
@property (nonatomic) bool ret; //总包数
@property (nonatomic) int code;//当前包数
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) T obj;

-(instancetype)initResult:(bool)ret code:(int)code msg:(NSString*)msg;
-(instancetype)initResult:(bool)ret code:(int)code msg:(NSString*)msg obj:(T)obj;
@end

NS_ASSUME_NONNULL_END
