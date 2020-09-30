//
//  SwitchLockViewController.h
//  lock
//
//  Created by 金万码 on 2020/6/9.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"
@class MyTaskListBean;
@class UnlockListBean;

NS_ASSUME_NONNULL_BEGIN

@interface SwitchLockViewController : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle; //当前蓝牙
@property (nonatomic,strong)MyTaskListBean * taskBean; //任务信息
@property (nonatomic,strong)UnlockListBean * lockBean; //锁信息

@end

NS_ASSUME_NONNULL_END
