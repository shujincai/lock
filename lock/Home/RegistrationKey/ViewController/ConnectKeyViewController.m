//
//  ConnectKeyViewController.m
//  lock
//
//  Created by 李金洋 on 2020/4/7.
//  Copyright © 2020 li. All rights reserved.
//

#import "ConnectKeyViewController.h"
#import "ConnectKeyTableViewCell.h"
#import "RegistrationKeyModel.h"
#import "UserModel.h"
#import "RegistrationLockModel.h"
#import "RegistrationLockTFCell.h"

@interface ConnectKeyViewController ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfoB; //B钥匙信息
@property (nonatomic,strong)KeyInfo * keyInfoC; //C钥匙信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UITextField * keyTF;
@property (nonatomic,strong)UITextField * keyNameTF;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)NSInteger registerNumber;
@property (nonatomic,assign)BOOL isHide;
@property (nonatomic,assign)BOOL isHideInit;
@property (nonatomic,strong)NSString * setKeyId;
@property (nonatomic,assign)BOOL isExistence; // 是否存在

@end

@implementation ConnectKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_REG_KEY;
    self.registerNumber = 0;
    self.isHide = NO;
    self.isExistence = YES;
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [MBProgressHUD showActivityMessage:STR_CONNECTING];
    [self createTableView];
    if ([CommonUtil getLockType]) {
        [SetKeyController setDelegate:self];
        [SetKeyController initSDK];
    } else {
        self.bleKeysdk = [BleKeySdk shareKeySdk];
        [self.bleKeysdk setDelgate:self];
        [self.bleKeysdk connectToKey:_currentBle secret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] sign:0];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isHide == NO) {
            [MBProgressHUD hideHUD];
        }
    });
}
- (void)returnClick {
    if ([CommonUtil getLockType]) {
        [SetKeyController disConnectBle];
    } else {
        [self.bleKeysdk disConnectFromKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark B锁

//初始化
- (void)requestInitSdkResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        [SetKeyController connectBlueTooth:_currentBle withSyscode:[CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] withRegcode:[CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd] withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:NO];
    }
    
}
//连接
- (void)requestConnectResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {//连接失败
        if ([[info.feedBackDic objectForKey:@"error"] isEqualToString:@"check_sys_reg_code_failed_time_out"]||[[info.feedBackDic objectForKey:@"error"] isEqualToString:@"check_sys_reg_code_failed_verify"]) {//连接密钥错误
            if (self.registerNumber > 0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
                [SetKeyController disConnectBle];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }else {
                [SetKeyController disConnectBle];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.registerNumber++;
                    [SetKeyController connectBlueTooth:self.currentBle withSyscode:DEFINE_SYSCODE withRegcode:DEFINE_REGCODE withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:YES];
                });
            }
            
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }else {
        [SetKeyController readKeyBasicInfo];
    }
}
//获取钥匙数据
- (void)requestReadKeyInfoResultInfo:(ResultInfo *)info {
    self.isHide = YES;
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.keyInfoB = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        if (self.registerNumber > 0) {
            BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
            basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
            basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
            basicInfo.keyId = [self.keyInfoB.key_id intValue];
            BlankKeyInfo *blankKeyInfo = [[BlankKeyInfo alloc] init];
            blankKeyInfo.modifiedSyscode = [CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd];
            blankKeyInfo.modifiedRegcode = [CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd];
            [SetKeyController setBlankKey:basicInfo andBlankKeyInfo:blankKeyInfo];
        }
        [self.tableView reloadData];
        [self getKeyFactoryInfo];
    }
}

//通过出厂编号查询钥匙信息
- (void)getKeyFactoryInfo {
    RegistrationKeyExistenceRequest * request = [[RegistrationKeyExistenceRequest alloc]init];
    [MSHTTPRequest GET:[NSString stringWithFormat:kExistenceKey,_keyInfoB.read_key_serial_number] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        RegistrationKeyExistenceResponse * response = [[RegistrationKeyExistenceResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if (response.data) {
            self.isExistence = YES;
            [MBProgressHUD showMessage:STR_KEY_FACTORY_REPEAT_TIPS];
        }else {
            self.isExistence = NO;
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}

//设置锁密钥
- (void)requestSetRegisterKeyResultInfo:(ResultInfo *)info {
    [MBProgressHUD hideHUD];
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_SETTING_FAIL];
        return;
    }else {
        self.isHideInit = NO;
        [MBProgressHUD showActivityMessage:STR_PLEASE_CONNECT_LOCK];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isHideInit == NO) {
                [MBProgressHUD hideHUD];
            }
        });
    }
}
//获取锁数据
- (void)requestActiveReport:(ResultInfo *)info {
    self.isHideInit = YES;
    [MBProgressHUD hideHUD];
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
    }else {
        RegistrationLockInfoBean * lockInfo = [[RegistrationLockInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        if ([lockInfo.event_type isEqualToString:@"2"]) {
            [MBProgressHUD showError:STR_SETTING_SUCCESS];
        }else {
            [MBProgressHUD showError:STR_SETTING_FAIL];
        }
    }
}

//修改钥匙ID
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2&&[CommonUtil getLockType]) {
        if (self.isExistence == YES) {
            [MBProgressHUD showMessage:STR_KEY_FACTORY_REPEAT_TIPS];
            return;
        }
        if (self.setKeyId.length > 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_CHANGE_KEY_ID message:self.setKeyId preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showActivityMessage:STR_LOADING];
                BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                basicInfo.keyId = [self.setKeyId intValue];
                
                UserKeyInfo *userKeyInfo = [[UserKeyInfo alloc] init];
                [SetKeyController setUserKey:basicInfo andUserKeyInfo:userKeyInfo];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            [MBProgressHUD showActivityMessage:STR_LOADING];
            RequestBean * request = [[RequestBean alloc]init];
            [MSHTTPRequest GET:kKeyId parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
                [MBProgressHUD hideHUD];
                NSError * error = nil;
                RegistrationLockInitResponse * response = [[RegistrationLockInitResponse alloc]initWithDictionary:responseObject error:&error];
                if (error) {
                    [MBProgressHUD showMessage:STR_PARSE_FAILURE];
                    return ;
                }
                if ([response.resultCode intValue] != 0) {
                    [MBProgressHUD showError:response.msg];
                    return ;
                }else {
                    self.setKeyId = response.data.keyno;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_CHANGE_KEY_ID message:response.data.keyno preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [MBProgressHUD showActivityMessage:STR_LOADING];
                        BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                        basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                        basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                        basicInfo.keyId = [response.data.keyno intValue];
                        
                        UserKeyInfo *userKeyInfo = [[UserKeyInfo alloc] init];
                        [SetKeyController setUserKey:basicInfo andUserKeyInfo:userKeyInfo];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:STR_TIMEOUT];
            }];
        }
    }
}
- (void)requestSetUserKeyResultInfo:(ResultInfo *)info {
    [MBProgressHUD hideHUD];
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CHANGE_KEY_ID_FAIL];
    }else {
        self.keyInfoB.key_id = self.setKeyId;
        self.setKeyId = nil;
        [self.tableView reloadData];
    }
}


#pragma mark C锁

//侧滑返回上一页
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (self.bleKeysdk) {
        [self.bleKeysdk disConnectFromKey];
    }
}
//连接
-(void)onConnectToKey:(Result*)result {
    if (result.ret == NO) {//连接失败
        if ([result.msg isEqualToString:@"time_out"]||[result.msg isEqualToString:@"failed_verify"]) {//连接密钥错误
            if (self.registerNumber > 0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
                [self.bleKeysdk disConnectFromKey];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }else {
                [self.bleKeysdk disConnectFromKey];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.registerNumber++;
                    [self.bleKeysdk connectToKey:self.currentBle secret:@"FFFFFFFFFFFFFFFFFFFF" sign:0];
                });
            }
            
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
            [self.bleKeysdk disConnectFromKey];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }else {
        [self.bleKeysdk readKeyInfo];
    }
}
//获取钥匙数据
- (void)onReadKeyInfo:(Result<KeyInfo *> *)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.keyInfoC = result.obj;
        [self.bleKeysdk setDateTime:[NSDate date]];
    }
}
//校时
-(void)onSetDateTime:(Result*)result {
    self.isHideInit = YES;
    [MBProgressHUD hideHUD];
    if (result.ret == NO) {
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        if (self.registerNumber > 0) {
            //设置钥匙密钥
            [self.bleKeysdk setKeySecret:[[SecretInfo alloc] initSecret:@"FFFFFFFFFFFFFFFFFFFF" nowSecret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd]]];
        }
        [self.tableView reloadData];
    }
}

//设置开关锁钥匙--用户钥匙,isOnline 是否在线，在线断开连接后，钥匙不能开关锁
-(void)onSetUserKey:(Result*)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_SETTING_FAIL];
        return;
    }else {
        NSDate *from = [NSDate date];
        NSDate *to = [NSDate dateWithTimeIntervalSinceNow:7*24*60*60];
        WMRegisterKeyInfo * regkeyInfo = [[WMRegisterKeyInfo alloc] init];
        
        regkeyInfo.secretInfo = [[SecretInfo alloc] initSecret:@"FFFFFFFFFFFFFFFFFFFF" nowSecret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd]];
        //regkeyInfo.pwds = [[NSArray alloc] initWithObjects:@"123456",@"223456",@"323456", nil];
        [self.bleKeysdk setRegisterKey:from to:to registerKeyInfo:regkeyInfo];
    }
}
//设置锁密钥状态
- (void)onSetRegisterKey:(Result *)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_SETTING_FAIL];
        return;
    }else {
        [MBProgressHUD hideHUD];
        self.isHideInit = NO;
        [MBProgressHUD showActivityMessage:STR_PLEASE_CONNECT_LOCK];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isHideInit == NO) {
                [MBProgressHUD hideHUD];
            }
        });
    }
}

//获取锁数据
-(void)onReport:(Result<RecordInfo*>*) result {
    self.isHideInit = YES;
    [MBProgressHUD hideHUD];
    if (result.ret == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
    }else {
        if (result.obj.flag == 0) {
            [MBProgressHUD showError:STR_SETTING_SUCCESS];
        }else {
            [MBProgressHUD showError:STR_SETTING_FAIL];
        }
    }
}

#pragma mark 公共方法

- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//钥匙名称
        static NSString * reuseIdentifier =  @"RegistrationLockTFCell";
        RegistrationLockTFCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[RegistrationLockTFCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.topLabel.text = STR_KEY_NAME;
        cell.textField.placeholder = STR_KEY_NAME_TIPS;
        _keyNameTF = cell.textField;
        return cell;
    }else {//锁id
        static NSString * reuseIdentifier =  @"cell";
        ConnectKeyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[ ConnectKeyTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (indexPath.row == 1){
            if ([CommonUtil getLockType]) {
                if (_keyInfoB) {
                    cell.topLabel.text = [NSString stringWithFormat:@"MAC：%@",_keyInfoB.mac_address];
                }else {
                    cell.topLabel.text = @"MAC：";
                }
            } else {
                cell.topLabel.text = [NSString stringWithFormat:@"MAC：%@",_keyDictionary.mac];
            }
        }else if (indexPath.row == 2){
            
            if ([CommonUtil getLockType]) {
                if (_keyInfoB) {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@ID：%@",STR_KEY,_keyInfoB.key_id];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@ID：",STR_KEY];
                }
                
            } else {
                if (_keyInfoC) {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@ID：%@",STR_KEY,_keyInfoC.keyId];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@ID：",STR_KEY];
                }
            }
            
        }else if (indexPath.row == 3){
            if ([CommonUtil getLockType]) {
                if (_keyInfoB) {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@：%@",STR_KEY_NUMBER,_keyInfoB.read_key_serial_number];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@：",STR_KEY_NUMBER];
                }
            } else {
                if (_keyInfoC) {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@：%d",STR_KEY_HARDWARE_VERSION,_keyInfoC.ver];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@：",STR_KEY_HARDWARE_VERSION];
                }
            }
        }else if (indexPath.row == 4){
            if ([CommonUtil getLockType]) {
                if (_keyInfoB) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate *datenow = [NSDate date];
                    NSString *currentTimeString = [formatter stringFromDate:datenow];
                    cell.topLabel.text = [NSString stringWithFormat:@"%@%@：%@",STR_KEY,STR_TIME,currentTimeString];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@%@：",STR_KEY,STR_TIME];
                }
                
            } else {
                if (_keyInfoC) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSString *currentTimeString = [formatter stringFromDate:_keyInfoC.time];
                    cell.topLabel.text = [NSString stringWithFormat:@"%@%@：%@",STR_KEY,STR_TIME,currentTimeString];
                }else {
                    cell.topLabel.text = [NSString stringWithFormat:@"%@%@：",STR_KEY,STR_TIME];
                }
                
            }
        }
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 130;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * bgView = [[UIView alloc]init];
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:STR_INIT_LOCK_CODE forState:UIControlStateNormal];
    [changeBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    changeBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.cornerRadius = 4;
    [changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(30);
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.left.equalTo(bgView.mas_left).offset(30);
        make.right.equalTo(bgView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setTitle:STR_REGISTER forState:UIControlStateNormal];
    [regBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    regBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = 4;
    [regBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.top.equalTo(changeBtn.mas_bottom).offset(20);
        make.left.equalTo(bgView.mas_left).offset(30);
        make.right.equalTo(bgView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
    if ([CommonUtil getLockType]) {
        [changeBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateNormal];
        [changeBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateHighlighted];
        [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateNormal];
        [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateHighlighted];
    } else {
        [changeBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateNormal];
        [changeBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateHighlighted];
        [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateNormal];
        [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateHighlighted];
    }
    return bgView;
}

//设置初始化锁系统码钥匙
- (void)changeBtnClick:(UIButton *)btn {
    
    [MBProgressHUD showActivityMessage:STR_LOADING];
    if ([CommonUtil getLockType]) {
        BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
        basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
        basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
        basicInfo.keyId = [self.keyInfoB.key_id intValue];
        RegisterKeyInfo *registerKeyInfo = [[RegisterKeyInfo alloc] init];
        registerKeyInfo.lockCylinderCode = DEFINE_SYSCODE;
        registerKeyInfo.newlockCylinderCode = [CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd];
        [SetKeyController setRegisterKey:basicInfo andRegisterKeyInfo:registerKeyInfo];
    } else {
        //开始日期
        NSDate *fromDate = [NSDate date];
        //向前+7天，结束日期
        NSDate *toDate = [NSDate dateWithTimeIntervalSinceNow:24*7*60*60];
        
        NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
        [formatDate setDateFormat:@"yyyy-MM-dd"];
        NSString *stringDate = [formatDate stringFromDate:fromDate];
        
        NSDateFormatter *formatDateTime = [[NSDateFormatter alloc] init];
        [formatDateTime setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *fromTime1 = [stringDate stringByAppendingString:@" 00:00:00"];
        NSString *toTime1 = [stringDate stringByAppendingString:@" 12:00:00"];
        NSString *fromTime2 = [stringDate stringByAppendingString:@" 13:30:00"];
        NSString *toTime2 = [stringDate stringByAppendingString:@" 23:59:59"];
        // [formatter dateFromString:dateStr];
        NSArray<TimeSection*> *times = [NSArray arrayWithObjects:[[TimeSection alloc] initSection:[formatDateTime dateFromString:fromTime1] to:[formatDateTime dateFromString:toTime1]],[[TimeSection alloc] initSection:[formatDateTime dateFromString:fromTime2] to:[formatDateTime dateFromString:toTime2]], nil];
        //时间块，时间片
        NSArray<DateSection*> *dates =[NSArray arrayWithObjects:[[DateSection alloc] initSection:fromDate to:toDate times:times], nil];
        
        //锁号
        NSArray *lockIds = [NSArray arrayWithObjects:@"202006130001",@"202006130002",@"202006130003", nil];
        //密码列表
        /*
         NSArray<NSString*> *pwd1 = [NSArray arrayWithObjects:@"123456",@"223456",@"323456", nil];
         NSArray<NSString*> *pwd2 = [NSArray arrayWithObjects:@"A23456",@"B23456",@"C23456", nil];
         NSArray<NSArray<NSString*>*> *pwds = [NSArray arrayWithObjects:pwd1,pwd2, nil];
         
         UserKeyInfo *userkeyInfo = [[UserKeyInfo alloc] initUserKeyInfo:dates lockIds:lockIds pwds:pwds];
         */
        WMUserKeyInfo *userkeyInfo = [[WMUserKeyInfo alloc] initUserKeyInfo:dates lockIds:lockIds];
        [self.bleKeysdk setUserKey:userkeyInfo isOnline:NO];
    }
    
}

//注册钥匙
- (void)registerBtnClick:(UIButton *)btn {
    if (kStringIsEmpty(self.keyNameTF.text)) {
        [MBProgressHUD showMessage:STR_KEY_NAME_TIPS];
        return;
    }
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RegistrationKeyRegRequest * keyRequest = [[RegistrationKeyRegRequest alloc]init];
    keyRequest.keymode = @"0";
    keyRequest.keyname = _keyNameTF.text;
    keyRequest.keystatus = @"0";
    if ([CommonUtil getLockType]) {
        keyRequest.factoryno = _keyInfoB.read_key_serial_number;
        keyRequest.keyid = _keyInfoB.key_id;
        keyRequest.keytype = @"1";
        keyRequest.keyno = _keyInfoB.key_id;
        keyRequest.bleflag = [CommonUtil getBluetoothKeyMac:_currentBle.name];
    } else {
        keyRequest.factoryno = _keyInfoC.keyId;
        keyRequest.keyno = _keyInfoC.keyId;
        if (_keyInfoC.device == 1284) {
            keyRequest.keytype = @"3";
        }else {
            keyRequest.keytype = @"1";
        }
        keyRequest.bleflag = _keyInfoC.keyId;
    }
    
    [MSHTTPRequest POST:kRegKey parameters:[keyRequest toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [MBProgressHUD showMessage:STR_REG_KEY_SUCCESS];
            if ([CommonUtil getLockType]) {
                [SetKeyController disConnectBle];
            } else {
                [self.bleKeysdk disConnectFromKey];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            if ([response.resultCode intValue] == 15001) {//该钥匙信息不存在
                [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
            } else if([response.resultCode intValue] == 15002){//钥匙编号为空
                [MBProgressHUD showError:STR_KEY_NUMBER_EMPTY];
            }else if([response.resultCode intValue] == 15003){//钥匙名称为空
                [MBProgressHUD showError:STR_KEY_NAME_EMPTY];
            }else if([response.resultCode intValue] == 15004){//钥匙编号重复
                [MBProgressHUD showError:STR_KEY_NUMBER_REPEAT];
            }else if([response.resultCode intValue] == 15005){//钥匙名称重复
                [MBProgressHUD showError:STR_KEY_NAME_REPEAT];
            }else if([response.resultCode intValue] == 15013){//钥匙硬件编号重复
                [MBProgressHUD showError:STR_KEY_HARDWARE_NUMBER_REPEAT];
            }else if([response.resultCode intValue] == 15014){//钥匙编号已超出范围（1~65500）
                [MBProgressHUD showError:STR_KEY_NUMBER_RANGE];
            }else {
                [MBProgressHUD showError:STR_SUBMIT_DATA_FAIL];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
    
}

@end
