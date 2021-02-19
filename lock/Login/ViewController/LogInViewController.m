//
//  LogInViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/25.
//  Copyright © 2020 li. All rights reserved.
//

#import "LogInViewController.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import "UserModel.h"

@interface LogInViewController ()<UINavigationControllerDelegate>
@property(nonatomic,strong)RJTextField * password;
@property(nonatomic,strong)RJTextField * account;
@property(nonatomic,strong)UILabel * addressLabel;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"网络缓存大小cache = %fKB",[MSNetwork getAllHttpCacheSize]/1024.f);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getCurrentNetworkStatus];
    });
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    UIImageView * image = [UIImageView new];
    image.frame = self.view.bounds;
    image.image = [UIImage imageNamed:@"LoginBg"];
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    __weak typeof(self) weakSelf =  self;
    
    
    self.account = [[RJTextField alloc]init];
    self.account.placeholder = STR_ACCOUNT;
    self.account.tag = 10000;
    self.account.textField.text = kFetchMyDefault(@"appusername");
    //    self.account.textField.text = @"sjc";
    [image addSubview:self.account];
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-60);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 60));
    }];
    
    UIImageView * Titleimage = [UIImageView new];
    Titleimage.image = [UIImage imageNamed:@"login_pic"];
    [image addSubview:Titleimage];
    [Titleimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.bottom.equalTo(self.account.mas_top).offset(-40);
        make.size.mas_equalTo(CGSizeMake(180, 120));
    }];
    
    self.password = [[RJTextField alloc]init];
    self.password.tag = 10001;
    self. password.placeholder = STR_PASSWORD;
    self.password.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.password.textField.secureTextEntry = YES;
    //    self.password.textField.text = @"123";
    [image addSubview:self.password];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.account.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 60));
    }];
    
    SZKButton * logInBtn = [[SZKButton alloc]initWithFrame:CGRectZero title:STR_LOGIN titleColor:COLOR_WHITE titleFont:18 cornerRadius:4 backgroundColor:UIColor.blueColor backgroundImage:NULL image:NULL];
    logInBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [image addSubview:logInBtn];
    [logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(30);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(UISCREEN_WIDTH-60, 40));
    }];
    [logInBtn setClicAction:^(UIButton * _Nonnull sender) {
        [weakSelf getNetWork];
    }];
    
    
    UIView * rightView = [UIView new];
    rightView.backgroundColor = COLOR_GREEN;
    rightView.layer.masksToBounds = YES;
    rightView.layer.cornerRadius = 5;
    [image addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logInBtn.mas_bottom).offset(30);
        make.right.equalTo(logInBtn.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    SZKLabel * setLabel = [SZKLabel labelWithFrame:CGRectZero text:STR_SETTING textColor:UIColor.whiteColor font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.clearColor];
    [rightView addSubview: setLabel];
    [setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView.mas_centerY).offset(0);
        make.centerX.equalTo(rightView.mas_centerX).offset(-7);
        make.height.mas_equalTo(20);
    }];
    UIImageView * rightImage = [UIImageView new];
    rightImage.image = [UIImage imageNamed:@"ctl_setting"];
    [rightView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setLabel.mas_right).offset(2);
        make.centerY.equalTo(rightView.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    
    [rightView addGestureRecognizer:tap];
    
    
    self.addressLabel = [UILabel new];
    self.addressLabel.text = kFetchMyDefault(@"address");
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.textColor = COLOR_GROY;
    [self.view addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-(10+TABBAR_AREA_HEIGHT));
        make.height.mas_equalTo(20);
    }];
}
-(void)tapView:(UITapGestureRecognizer *)sender{
    SettingViewController * setting = [SettingViewController new];
    [setting setSendValueBlock:^(NSString * _Nonnull valueString) {
        self.addressLabel.text = valueString;
        kSaveMyDefault(@"address", valueString);
        
    }];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:animated];
}

//登录请求 获取token
-(void)getNetWork{
    if (kStringIsEmpty(self.addressLabel.text)) {
        [MBProgressHUD showMessage:STR_ADDRESS_TIPS];
        return;
    }
    if (kStringIsEmpty(self.account.textField.text)) {
        [MBProgressHUD showMessage:STR_ACCOUNT_TIPS];
        return;
    }
    if (kStringIsEmpty(self.password.textField.text)) {
        [MBProgressHUD showMessage:STR_PASSWORD_TIPS];
        return;
    }
    [MBProgressHUD showActivityMessage:STR_LOADING];
    UserTokenRequest * request = [[UserTokenRequest alloc]init];
    request.username = self.account.textField.text;
    request.password = self.password.textField.text;
    [MSHTTPRequest POST:kLogin parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
         NSError * error = nil;
        UserInfoResponse * response = [[UserInfoResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            if (response.data.wmSdk == false) {
                kSaveMyDefault(@"token", response.data.token);
                kSaveMyDefault(@"appusername", response.data.appusername);
                [CommonUtil saveObjectToUserDefault:response.data forKey:@"userInfo"];
                NSDictionary *tokenDic =@{@"token":response.data.token};
                [MSNetwork setBaseParameters:tokenDic];
                [MSNetwork setHeadr:tokenDic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self gotoMain];
                });
            }else {
                [MBProgressHUD showError:STR_WRONG_ACCOUNT_PASSWORD];
            }
        }else {
            if ([response.resultCode intValue] == 20001) {//用户名错误
                [MBProgressHUD showError:STR_USER_NAME_ERROR];
            } else if ([response.resultCode intValue] == 20002) {//密码错误
                [MBProgressHUD showError:STR_PASSWORD_ERROR];
            }else if ([response.resultCode intValue] == 20003) {//用户不存在
                [MBProgressHUD showError:STR_USER_NON_EXISTENT];
            }else {
                [MBProgressHUD showError:response.msg];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}


-(void)gotoMain{
    MainViewController *mainViewController=[[MainViewController alloc] init];
    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:mainViewController];
    self.view.window.rootViewController=nav;
}
- (void)getCurrentNetworkStatus
{
    if (kIsNetwork) {
        NSLog(@"有网络");
        if (kIsWWANNetwork) {
            NSLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    } else {
        NSLog(@"无网络");
    }
    
    //    }
}
@end
