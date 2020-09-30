//
//  ChangePasswordVC.m
//  lock
//
//  Created by 金万码 on 2020/6/11.
//  Copyright © 2020 li. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "LogInViewController.h"
#import "SystemParameterModel.h"

@interface ChangePasswordVC ()

@property(nonatomic,strong)RJTextField * oldPassword;
@property(nonatomic,strong)RJTextField * newsPassword;
@property(nonatomic,strong)RJTextField * confirmPassword;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = STR_CHANGE_PASSWORD;
    self.view.backgroundColor = COLOR_WHITE;
    [self initLayout];
}

- (void)initLayout {
    WS(weakSelf);
    self.oldPassword = [[RJTextField alloc]init];
    self.oldPassword.placeholder = STR_OLD_PASSWORD;
    self.oldPassword.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.oldPassword.textField.secureTextEntry = YES;
    [self.view addSubview:self.oldPassword];
    [self.oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT+10);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 60));
    }];
    self.newsPassword = [[RJTextField alloc]init];
    self.newsPassword.placeholder = STR_NEWS_PASSWORD;
    self.newsPassword.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.newsPassword.textField.secureTextEntry = YES;
    [self.view addSubview:self.newsPassword];
    [self.newsPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPassword.mas_bottom).offset(0);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 60));
    }];
    self.confirmPassword = [[RJTextField alloc]init];
    self.confirmPassword.placeholder = STR_CONFIRM_PASSWORD;
    self.confirmPassword.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.confirmPassword.textField.secureTextEntry = YES;
    [self.view addSubview:self.confirmPassword];
    [self.confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newsPassword.mas_bottom).offset(0);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 60));
    }];
    
    SZKButton * changeBtn = [[SZKButton alloc]initWithFrame:CGRectZero title:STR_CHANGE_PASSWORD titleColor:UIColor.whiteColor titleFont:18 cornerRadius:4 backgroundColor:COLOR_BLUE backgroundImage:NULL image:NULL];
    changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:changeBtn];
    [changeBtn setClicAction:^(UIButton * _Nonnull sender) {//修改密码
        if (kStringIsEmpty(weakSelf.oldPassword.textField.text)) {//原密码为空
            [MBProgressHUD showMessage:STR_PLEASE_OLD_PWD];
            return;
        }
        if (kStringIsEmpty(weakSelf.newsPassword.textField.text)) {//新密码为空
            [MBProgressHUD showMessage:STR_PLEASE_NEWS_PWD];
            return;
        }
        if (kStringIsEmpty(weakSelf.confirmPassword.textField.text)) {//确认密码为空
            [MBProgressHUD showMessage:STR_PLEASE_CONFIRM_PWD];
            return;
        }
        if (![weakSelf.newsPassword.textField.text isEqualToString:weakSelf.confirmPassword.textField.text]) {//新密码与确认密码不一致
            [MBProgressHUD showMessage:STR_PASSWORD_ATYPISM];
            return;
        }
        if ([weakSelf.newsPassword.textField.text isEqualToString:weakSelf.oldPassword.textField.text]) {
            //原密码与新密码一致
            [MBProgressHUD showMessage:STR_NEW_OLD_EQUAL];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_DEFINE_CHANGE_PWD message:STR_DEFINE_QUIT preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf getChangePassword];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
}
//修改密码
- (void)getChangePassword {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    ChangePasswordRequest * request = [[ChangePasswordRequest alloc]init];
    request.oldpwd = self.oldPassword.textField.text;
    request.newpwd = self.newsPassword.textField.text;
    [MSHTTPRequest POST:kChangePW parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [self exitAccount];
        }else {
            [MBProgressHUD hideHUD];
            if ([response.resultCode intValue] == 20004) {//原密码错误
                [MBProgressHUD showError:STR_OLD_PASSWORD_ERROR];
            }else {
                [MBProgressHUD showError:response.msg];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
    
}
//退出账号
- (void)exitAccount {
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest requestWithMethod:MSRequestMethodDELETE url:kLogin parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:STR_CHANGE_PWD_SUCCESS];
            [CommonUtil removeObjectFromUserDefaultWith:@"token"];
            [CommonUtil removeObjectFromUserDefaultWith:@"userInfo"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LogInViewController * loginViewController=[[LogInViewController alloc] init];
                BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:loginViewController];
                self.view.window.rootViewController=nav;
            });
        }else {
            [MBProgressHUD showError:response.msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end
