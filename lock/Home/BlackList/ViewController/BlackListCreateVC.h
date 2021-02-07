//
//  BlackListCreateVC.h
//  lock
//
//  Created by 金万码 on 2021/2/5.
//  Copyright © 2021 li. All rights reserved.
//

#import "BaseViewController.h"
@class BlackListBean;

NS_ASSUME_NONNULL_BEGIN

@interface BlackListCreateVC : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle;
@property (nonatomic,strong)NSMutableArray * blacklistArray; //丢失钥匙信息

@end

NS_ASSUME_NONNULL_END
