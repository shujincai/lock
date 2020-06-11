//
//  MSInterfaceConst.m
//  MSNetwork
//
//  Created by lztb on 2019/8/29.
//  Copyright © 2019 lztbwlkj. All rights reserved.
//

#import "MSInterfaceConst.h"

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"接口服务器的请求前缀 例: http://192.168.10.10:8080";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"http://192.168.1.14:8080";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"http://192.168.1.14:8080";
#endif



/** 登录*/
NSString *const kLogin = @"api/v1/app/token";
/** 平台会员退出*/
NSString *const kExit = @"exit";
//查询开锁记录
NSString *const kLockdatas = @"api/v1/app/lockdatas";
//获取任务列表
NSString *const kKeydatas = @"api/v1/app/keydatas";
//d获取任务总数
NSString *const kCount = @"api/v1/app/keydatas/count";
//获取任务列表
NSString *const kTaskList = @"api/v1/app/keydatas";
//根据任务ID判断任务是否有效
NSString *const kTaskValid = @"api/v1/app/keydatas/%@";
//注册蓝牙钥匙
NSString *const kRegKey = @"api/v1/app/keys";
//注册锁
NSString *const kRegLock = @"api/v1/app/locks";
//修改密码
NSString *const kChangePW = @"api/v1/app/workers/password";
