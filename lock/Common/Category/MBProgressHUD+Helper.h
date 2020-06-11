//
//  MBProgressHUD+Helper.h
//  lock
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 li. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Helper)

#pragma mark 在指定的view上显示hud
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showWarning:(NSString *)Warning toView:(UIView *)view;
+ (MBProgressHUD *)showActivityMessage:(NSString*)message view:(UIView *)view;
+ (MBProgressHUD *)showProgressMessage:(NSString *)message toView:(UIView *)view;

#pragma mark 在window上显示hud
+ (void)showMessage:(NSString *)message;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showWarning:(NSString *)Warning;
+ (MBProgressHUD *)showActivityMessage:(NSString*)message;
+ (MBProgressHUD *)showProgressMessage:(NSString *)message;

#pragma mark 移除hud
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end

NS_ASSUME_NONNULL_END
