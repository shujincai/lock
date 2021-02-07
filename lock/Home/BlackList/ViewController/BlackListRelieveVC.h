//
//  BlackListRelieveVC.h
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import "BaseViewController.h"
@class BlackListBean;

NS_ASSUME_NONNULL_BEGIN

@interface BlackListRelieveVC : BaseViewController

@property (strong, nonatomic) CBPeripheral *currentBle;
@property (nonatomic,strong)BlackListBean * blacklistBean; //黑名单信息

@end

NS_ASSUME_NONNULL_END
