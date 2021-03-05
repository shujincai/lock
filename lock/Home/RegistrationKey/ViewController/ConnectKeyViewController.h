//
//  ConnectKeyViewController.h
//  lock
//
//  Created by 李金洋 on 2020/4/7.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"
@class BluetoothKeyBean;

NS_ASSUME_NONNULL_BEGIN

@interface ConnectKeyViewController : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle;
@property (strong, nonatomic) BluetoothKeyBean *keyDictionary;

@end

NS_ASSUME_NONNULL_END
