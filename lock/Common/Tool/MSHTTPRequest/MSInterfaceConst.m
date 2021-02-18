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
//根据钥匙编号获取钥匙详细信息
NSString *const kKeyDetail = @"api/v1/app/keys/%@";
//注册锁
NSString *const kRegLock = @"api/v1/app/locks";
//修改密码
NSString *const kChangePW = @"api/v1/app/workers/password";
//锁出厂编号
NSString *const kLockId = @"api/v1/app/locks/factoryno";
//钥匙出厂编号
NSString *const kKeyId = @"api/v1/app/keys/factoryno";
//通过出厂编号查询钥匙信息
NSString *const kExistenceKey = @"api/v1/app/keys/existence/%@";
//获取锁列表
NSString *const kLockTree = @"api/v1/app/locks/tree";
//审核开关锁任务, 可批量审核
NSString *const kTaskAuthid = @"api/v1/app/keydatas/auth/%ld?auth=%ld";
//获取已领出钥匙列表
NSString *const kKeyTaskOutdatas = @"api/v1/app/keys";
//钥匙挂失
NSString *const kBlackListLoss = @"api/v1/app/keys/blacklists/%@";
//获取黑名单列表
NSString *const kBlackList = @"api/v1/app/keys/blacklists";
//设置黑、白钥匙  keyflag钥匙标识：1-黑钥匙，2-白钥匙
NSString *const kSetKeyFlag = @"api/v1/app/keys/%@?keyflag=%ld";
//获取锁详情 替换锁
NSString *const kLockDetail = @"api/v1/app/locks/%@";
