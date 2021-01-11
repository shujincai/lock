//
//  ApplyOpenLockDetailVC.h
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"
@class MyTaskListBean;

NS_ASSUME_NONNULL_BEGIN

@interface ApplyOpenLockDetailVC : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle;
@property (nonatomic,strong)MyTaskListBean * taskBean; //任务信息

@end

NS_ASSUME_NONNULL_END
