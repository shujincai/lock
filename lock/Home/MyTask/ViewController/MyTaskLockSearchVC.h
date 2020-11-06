//
//  MyTaskLockSearchVC.h
//  lock
//
//  Created by 金万码 on 2020/11/5.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"
@class MyTaskListBean;

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskLockSearchVC : BaseViewController

@property (nonatomic,strong)MyTaskListBean * taskBean; //任务信息
@property (nonatomic,strong)NSString * type;//0注册钥匙 1注册锁 2我的任务

@end

NS_ASSUME_NONNULL_END
