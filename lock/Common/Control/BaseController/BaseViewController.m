//
//  BaseViewController.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BG_VIEW;
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    if (@available(iOS 11.0, *)) {
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
}
- (void)returnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//设置状态栏的颜色的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
#if LOCK_APP
    return UIStatusBarStyleLightContent;
#elif VANMALOCK_APP
    return UIStatusBarStyleDefault;
#endif
}


@end
