//
//  SettingViewController.h
//  lock
//
//  Created by 李金洋 on 2020/3/25.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : BaseViewController
@property (nonatomic, copy)void(^sendValueBlock)(NSString *valueString);

@end

NS_ASSUME_NONNULL_END
