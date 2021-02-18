//
//  LockReplaceDetailVC.h
//  lock
//
//  Created by 金万码 on 2021/2/7.
//  Copyright © 2021 li. All rights reserved.
//

#import "BaseViewController.h"
@class LockReplaceListBean;

NS_ASSUME_NONNULL_BEGIN

@interface LockReplaceDetailVC : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle;
@property (nonatomic,strong)LockReplaceListBean * replaceLockBean;// 替换锁信息

@end

NS_ASSUME_NONNULL_END
