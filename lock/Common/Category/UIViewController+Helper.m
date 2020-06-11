//
//  UIViewController+Helper.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

/**
 *  自定义左侧标题
 */
- (void)gennerateNavigationItemLeft {
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"] forState:UIControlStateNormal];
    [leftButton setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    leftButton.titleLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H1);
    [leftButton sizeToFit];
    leftButton.userInteractionEnabled = NO;
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
/**
 *  左侧返回按钮
 */
- (void)gennerateNavigationItemReturnBtn:(SEL)selector
{
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"ctl_back_white"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end
