//
//  MSInterfaceConst.h
//  MSNetwork
//
//  Created by lztb on 2019/8/29.
//  Copyright © 2019 lztbwlkj. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */
#define DevelopSever 0
#define TestSever    1
#define ProductSever 0

/** 接口前缀-开发服务器*/
UIKIT_EXTERN NSString *const kApiPrefix;

#pragma mark - 详细接口地址
/** 登录*/
UIKIT_EXTERN NSString *const kLogin;
/** 退出*/
UIKIT_EXTERN NSString *const kExit;
//查询开锁记录
UIKIT_EXTERN NSString *const kLockdatas;
//获取任务列表
UIKIT_EXTERN NSString *const kKeydatas;
//获取任务总数
UIKIT_EXTERN NSString *const kCount;
//获取任务列表
UIKIT_EXTERN NSString *const kTaskList;
//根据任务ID判断任务是否有效
UIKIT_EXTERN NSString *const kTaskValid;
//注册蓝牙钥匙
UIKIT_EXTERN NSString *const kRegKey;
//根据钥匙编号获取钥匙详细信息
UIKIT_EXTERN NSString *const kKeyDetail;
//注册锁
UIKIT_EXTERN NSString *const kRegLock;
//修改密码
UIKIT_EXTERN NSString *const kChangePW;
//锁出厂编号
UIKIT_EXTERN NSString *const kLockId;
//钥匙出厂编号
UIKIT_EXTERN NSString *const kKeyId;
//通过出厂编号查询钥匙信息
UIKIT_EXTERN NSString *const kExistenceKey;
//获取锁列表
UIKIT_EXTERN NSString *const kLockTree;
//审核开关锁任务
UIKIT_EXTERN NSString *const kTaskAuthid;
//获取已领出钥匙列表
UIKIT_EXTERN NSString *const kKeyTaskOutdatas;
//钥匙挂失
UIKIT_EXTERN NSString *const kBlackListLoss;
//获取黑名单列表
UIKIT_EXTERN NSString *const kBlackList;
//设置黑、白钥匙
UIKIT_EXTERN NSString *const kSetKeyFlag;
//获取锁详情 替换锁
UIKIT_EXTERN NSString *const kLockDetail;
//获取任务指纹列表
UIKIT_EXTERN NSString *const kTaskFingerprintList;
