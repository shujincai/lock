//
//  LockReplaceDetailVC.m
//  lock
//
//  Created by 金万码 on 2021/2/7.
//  Copyright © 2021 li. All rights reserved.
//

#import "LockReplaceDetailVC.h"
#import "SwitchLockListCell.h"
#import "RegistrationKeyModel.h"
#import "RegistrationLockModel.h"
#import "LockReplaceModel.h"
#import "MyTaskModel.h"


@interface LockReplaceDetailVC ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfoB; //B钥匙信息
@property (nonatomic,strong)RegistrationLockInfoBean * lockInfoB; //B锁信息
@property (nonatomic,strong)KeyInfo * keyInfoC; //C钥匙信息
@property (nonatomic,strong)RecordInfo * lockInfoC; //C锁信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)BOOL isHide; //根据加载时间判断是否隐藏加载框
@property (nonatomic,assign)BOOL isLockHide; //根据加载时间判断是否隐藏连接锁加载框
@property (nonatomic,strong)NSString * setLockId; //设置锁ID
@property (nonatomic,strong)UITextField * reasonTF;

@end

@implementation LockReplaceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_LOCK_REPLACE;
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    self.isHide = NO;
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [MBProgressHUD showActivityMessage:STR_CONNECTING];
    //当加载15秒钟判断加载框是否显示，当显示进行隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isHide == NO) {
            [MBProgressHUD hideHUD];
        }
    });
    [self createTableView];
    if ([CommonUtil getLockType]) {
        [SetKeyController setDelegate:self];
        [SetKeyController initSDK];
    } else {
        self.bleKeysdk = [BleKeySdk shareKeySdk];
        [self.bleKeysdk setDelgate:self];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_INIT_SUCCESS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_init";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
        //连接钥匙 根据钥匙系统码和锁注册码连接钥匙
        [self.bleKeysdk connectToKey:_currentBle secret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] sign:[CommonUtil getAppleLanguages] ? 0: 1];
    }
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)returnClick {
    if ([CommonUtil getLockType]) {
        [SetKeyController disConnectBle];
    } else {
        [self.bleKeysdk disConnectFromKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
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
    return _listArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"SwitchLockListCell";
    SwitchLockListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SwitchLockListCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyTaskSwitchLockInfoBean * listBean = [_listArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = listBean.name;
    cell.timeLabel.text = listBean.time;
    cell.headerImageV.image = [UIImage imageNamed:listBean.iamgeName];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
    
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
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_INIT_SUCCESS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_init";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
        //连接钥匙
        [SetKeyController connectBlueTooth:_currentBle withSyscode:[CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] withRegcode:[CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd] withLanguageType:[CommonUtil getAppleLanguages] ? RASCRBleSDKLanguageTypeChinese : RASCRBleSDKLanguageTypeEnglish needResetKey:NO];
    }
    
}
//连接
- (void)requestConnectResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_CONNECT_KEY_SUCCESS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_key";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
        [SetKeyController readKeyBasicInfo];
    }
}
//获取钥匙数据
- (void)requestReadKeyInfoResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.keyInfoB = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        [self getKeyInfoDetail:self.keyInfoB.key_id];
    }
}
//设置开关锁 获取锁号
- (void)requestSetOnlineOpenResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.isHide = YES;
        [MBProgressHUD hideHUD];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_PLEASE_CONNECT_LOCK;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_lock";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
    }
}
//获取锁数据
- (void)requestActiveReport:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.lockInfoB = [[RegistrationLockInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        if ([self.lockInfoB.event_type isEqualToString:@"5"]) { //没有权限开锁
            if ([self.replaceLockBean.lockno isEqualToString:self.lockInfoB.lock_id]) {
                [MBProgressHUD showError:STR_REPLACE_MINE_TPS];
            }else {
                [self getLockDetail:self.lockInfoB.lock_id];
            }
        }
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
- (void)onConnectToKey:(Result *)result {
    if (result.ret == NO|| result.code < 0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_CONNECT_KEY_SUCCESS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_key";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
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
        [self getKeyInfoDetail:self.keyInfoC.keyId];
    }
}
//校时
-(void)onSetDateTime:(Result*)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        [self.bleKeysdk setReadLockIdKey];
    }
}
//设置读取锁号钥匙
-(void)onSetReadLockIdKey:(Result*)result{
    [MBProgressHUD hideHUD];
    if (result.ret == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.isHide = YES;
        [MBProgressHUD hideHUD];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_PLEASE_CONNECT_LOCK;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_lock";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
    }
}
//获取锁数据
- (void)onReport:(Result<RecordInfo *> *)result {
    [MBProgressHUD hideHUD];
    if (result.ret == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.lockInfoC = result.obj;
        if ([self.replaceLockBean.lockno isEqualToString:self.lockInfoC.lockid]) {
            [MBProgressHUD showError:STR_REPLACE_MINE_TPS];
        }else {
            [self getLockDetail:self.lockInfoC.lockid];
        }
    }
}

#pragma mark 公共方法

// 获取钥匙详情
- (void)getKeyInfoDetail:(NSString *)keyId {
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest GET:[NSString stringWithFormat:kKeyDetail,keyId] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        KeyInfoDetailResponse * response = [[KeyInfoDetailResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            if (response.data) {
                if ([response.data.keystatus isEqualToString:@"2"]) { // 损坏
                    [MBProgressHUD showError:STR_KEY_DAMAGED];
                    if ([CommonUtil getLockType]) {
                        [SetKeyController disConnectBle];
                    } else {
                        [self.bleKeysdk disConnectFromKey];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([response.data.keystatus isEqualToString:@"3"]){ // 丢失
                    [MBProgressHUD showError:STR_KEY_LOSE];
                    if ([CommonUtil getLockType]) {
                        [SetKeyController disConnectBle];
                    } else {
                        [self.bleKeysdk disConnectFromKey];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    if ([CommonUtil getLockType]) {
                        // 设置开关锁模式，获取锁号
                        BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                        basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                        basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                        basicInfo.keyId = [self.keyInfoB.key_id intValue];
                        
                        OnlineOpenInfo *onlineOpenInfo = [[OnlineOpenInfo alloc] init];
                        onlineOpenInfo.onlineOpenStartTime = @"00-01-01-00-00";
                        onlineOpenInfo.onlineOpenEndTime = @"99-12-31-23-59";
                        [SetKeyController setOnlineOpen:basicInfo andOnlineOpenInfo:onlineOpenInfo];
                    } else {
                        //校时
                        [self.bleKeysdk setDateTime:[NSDate date]];
                    }
                    
                }
            } else {
                [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
                if ([CommonUtil getLockType]) {
                    [SetKeyController disConnectBle];
                } else {
                    [self.bleKeysdk disConnectFromKey];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            if ([response.resultCode intValue]== 15020) {//无部门权限可以操作该钥匙
                [MBProgressHUD showError:STR_KEY_NO_DEPT_POWER];
            }else {
                [MBProgressHUD showError:response.msg];
            }
            if ([CommonUtil getLockType]) {
                [SetKeyController disConnectBle];
            } else {
                [self.bleKeysdk disConnectFromKey];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}


/// 获取锁详情
/// @param lockId 锁号
- (void)getLockDetail:(NSString *)lockId {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest GET:[NSString stringWithFormat:kLockDetail,lockId] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        LockReplaceDetailResponse * response = [[LockReplaceDetailResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD showError:response.msg];
            return ;
        }else {
            NSString * title = nil;
            if (response.data) {
                title = [NSString stringWithFormat:STR_REPLACE_LOCK_EXIT,response.data.lockname];
            }else {
                title = STR_REPLACE_LOCK_NEW;
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = STR_PLEASE_REPLACE_REASON;
                self.reasonTF = textField;
                
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.reasonTF.text.length <= 0) {
                    [MBProgressHUD showMessage:STR_REPLACE_REASON_EMPTY];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                [self saveReplaceLockInfo:response.data withLockId:lockId];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}

//保存替换锁信息

- (void)saveReplaceLockInfo:(LockReplaceListBean *)replaceInfo withLockId:(NSString *)lockId {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    LockReplaceRequest * request = [[LockReplaceRequest alloc]init];
    request.newlockno = lockId;
    request.replacereason = self.reasonTF.text;
    [MSHTTPRequest PATCH:[NSString stringWithFormat:kLockDetail,self.replaceLockBean.lockno] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD showError:response.msg];
            return ;
        }else {
            [MBProgressHUD showError:STR_REPLACE_SUCCESS];
            [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_LOCK_REPLACE_SUCCESS object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}

//获取当前时间
- (NSString*)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
@end
