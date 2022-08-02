//
//  BaseNavigationController.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:FONT_NAVI_TITLE, NSForegroundColorAttributeName:COLOR_WHITE}];
    if ([CommonUtil getLockType]) {
        [[UINavigationBar appearance] setBarTintColor:COLOR_BLUE];
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance * appearance = [UINavigationBarAppearance new];
            appearance.backgroundColor = COLOR_BLUE; //设置导航栏背景色
            appearance.shadowColor = COLOR_BLUE; // 设置分割线默认颜色
            appearance.titleTextAttributes = @{NSFontAttributeName:FONT_NAVI_TITLE, NSForegroundColorAttributeName:COLOR_WHITE}; //设置导航条标题颜色
            [UINavigationBar appearance].standardAppearance = appearance;
            [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        }
    } else {
        [[UINavigationBar appearance] setBarTintColor:COLOR_BTN_BG];
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance * appearance = [UINavigationBarAppearance new];
            appearance.backgroundColor = COLOR_BTN_BG; //设置导航栏背景色
            appearance.shadowColor = COLOR_BTN_BG; // 设置分割线默认颜色
            appearance.titleTextAttributes = @{NSFontAttributeName:FONT_NAVI_TITLE, NSForegroundColorAttributeName:COLOR_WHITE}; //设置导航条标题颜色
            [UINavigationBar appearance].standardAppearance = appearance;
            [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        }
    }
    //设置右滑返回手势的代理为自身
    WEAKSELF
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
}
#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}
//设置状态栏的颜色的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
