//
//  SwitchLockDateViewController.h
//  lock
//
//  Created by 金万码 on 2022/8/1.
//  Copyright © 2022 li. All rights reserved.
//

#import "BaseViewController.h"
@class MyTaskDateListBean;

NS_ASSUME_NONNULL_BEGIN

@interface SwitchLockDateViewController : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle; //当前蓝牙
@property (nonatomic,strong)MyTaskDateListBean * taskBean; //任务信息

@end

NS_ASSUME_NONNULL_END
