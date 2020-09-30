//
//  WorkListViewController.h
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkListViewController : BaseViewController
@property (nonatomic, strong) NSString * startStr; //开始日期
@property (nonatomic, strong) NSString * endStr; //结束日期

@end

NS_ASSUME_NONNULL_END
