//
//  RegistrationKeyViewController.h
//  lock
//
//  Created by 李金洋 on 2020/4/3.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"
@class MyTaskListBean;
@class UnlockListBean;
@class BlackListBean;
@class LockReplaceListBean;
@class MyTaskDateListBean;

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationKeyViewController : BaseViewController

@property (nonatomic,strong)NSString * type;//0注册钥匙 1注册锁 2我的任务 3申请开锁 4解除挂失 5创建黑钥匙 6创建白钥匙 7替换锁 8郑州粮库开关锁
@property (nonatomic,strong)MyTaskListBean * taskBean; //任务信息
@property (nonatomic,strong)UnlockListBean * lockBean; //锁信息
@property (nonatomic,strong)BlackListBean * blacklistBean; //黑名单信息
@property (nonatomic,strong)NSMutableArray * blacklistArray; //丢失钥匙信息
@property (nonatomic,strong)LockReplaceListBean * replaceLockBean;// 替换锁信息
@property (nonatomic,strong)MyTaskDateListBean * taskDateBean; //任务信息

@end

NS_ASSUME_NONNULL_END
