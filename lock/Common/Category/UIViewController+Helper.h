//
//  UIViewController+Helper.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Helper)

- (void)gennerateNavigationItemLeft;
- (void)gennerateNavigationItemReturnBtn:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
