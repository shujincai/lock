//
//  RegistrationKeyViewController.h
//  lock
//
//  Created by 李金洋 on 2020/4/3.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseTableViewController.h"
@class MyTaskListBean;
@class UnlockListBean;

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationKeyViewController : BaseViewController

@property (nonatomic,strong)NSString * type;//0注册钥匙 1注册锁 2我的任务
@property (nonatomic,strong)MyTaskListBean * taskBean;
@property (nonatomic,strong)UnlockListBean * lockBean;

@end

NS_ASSUME_NONNULL_END
