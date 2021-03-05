//
//  WriteListCreateVC.m
//  lock
//
//  Created by 金万码 on 2021/2/5.
//  Copyright © 2021 li. All rights reserved.
//

#import "WriteListCreateVC.h"
#import "SwitchLockListCell.h"
#import "RegistrationKeyModel.h"
#import "RegistrationLockModel.h"
#import "BlackListModel.h"
#import "MyTaskModel.h"

#if LOCK_APP
@interface WriteListCreateVC ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate>
@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfo; //钥匙信息
@property (nonatomic,strong)RegistrationLockInfoBean * lockInfo; //锁信息
#elif VANMALOCK_APP
@interface WriteListCreateVC ()<UITableViewDataSource,UITableViewDelegate,KeyDelegate>
@property (nonatomic,strong)KeyInfo * keyInfo; //钥匙信息
@property (nonatomic,strong)RecordInfo * lockInfo; //锁信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
#endif

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)BOOL isHide; //根据加载时间判断是否隐藏加载框

@end

@implementation WriteListCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_CREATE_WHITE_KEY;
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
#if LOCK_APP
    [SetKeyController setDelegate:self];
    [SetKeyController initSDK];
#elif VANMALOCK_APP
    self.bleKeysdk = [BleKeySdk shareKeySdk];
    [self.bleKeysdk setDelgate:self];
    MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
    infoBean.name = STR_INIT_SUCCESS;
    infoBean.time = [self getCurrentTime];
    infoBean.iamgeName = @"ic_switch_init";
    [self.listArray addObject:infoBean];
    [self.tableView reloadData];
    //连接钥匙
    [self.bleKeysdk connectToKey:_currentBle secret:[CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] sign:0];
#endif
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)returnClick {
#if LOCK_APP
    [SetKeyController disConnectBle];
#elif VANMALOCK_APP
    [self.bleKeysdk disConnectFromKey];
#endif
    [self.navigationController popViewControllerAnimated:YES];
}

#if LOCK_APP
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
        [SetKeyController connectBlueTooth:_currentBle withSyscode:[CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] withRegcode:[CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd] withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:NO];
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
        self.keyInfo = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        [self getKeyInfoDetail:self.keyInfo.key_id];
    }
}
#elif VANMALOCK_APP
//侧滑返回上一页
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    [self.bleKeysdk disConnectFromKey];
}
//连接钥匙
- (void)onConnectToKey:(Result *)result {
    if (result.ret == NO) {
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
        self.keyInfo = result.obj;
        //校时
        [self.bleKeysdk setDateTime:[NSDate date]];
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
        [self getKeyInfoDetail:self.keyInfo.keyId];
    }
}
#endif

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
#if LOCK_APP
                    [SetKeyController disConnectBle];
#elif VANMALOCK_APP
                    [self.bleKeysdk disConnectFromKey];
#endif
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([response.data.keystatus isEqualToString:@"3"]){ // 丢失
                    [MBProgressHUD showError:STR_KEY_LOSE];
#if LOCK_APP
                    [SetKeyController disConnectBle];
#elif VANMALOCK_APP
                    [self.bleKeysdk disConnectFromKey];
#endif
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([response.data.keystatus isEqualToString:@"1"]){ // 领出
                    [MBProgressHUD showError:STR_KEY_TASK_OUT];
#if LOCK_APP
                    [SetKeyController disConnectBle];
#elif VANMALOCK_APP
                    [self.bleKeysdk disConnectFromKey];
#endif
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    self.isHide = YES;
                    [MBProgressHUD hideHUD];
                    MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
                    infoBean.name = STR_PLEASE_CREATE_WHITE_KEY;
                    infoBean.time = [self getCurrentTime];
                    infoBean.iamgeName = @"ic_switch_create";
                    [self.listArray addObject:infoBean];
                    [self.tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
#if LOCK_APP
                [SetKeyController disConnectBle];
#elif VANMALOCK_APP
                [self.bleKeysdk disConnectFromKey];
#endif
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            if ([response.resultCode intValue]== 15020) {//无部门权限可以操作该钥匙
                [MBProgressHUD showError:STR_KEY_NO_DEPT_POWER];
            }else {
                [MBProgressHUD showError:response.msg];
            }
#if LOCK_APP
            [SetKeyController disConnectBle];
#elif VANMALOCK_APP
            [self.bleKeysdk disConnectFromKey];
#endif
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
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
    if (_listArray.count == 3) {
        return  80;
    }else {
        return 5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_listArray.count == 3) {
        UIView * bgView = [[UIView alloc]init];
        UIButton * relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [relieveBtn setTitle:STR_CREATE forState:UIControlStateNormal];
        [relieveBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        relieveBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
        relieveBtn.layer.masksToBounds = YES;
        relieveBtn.layer.cornerRadius = 4;
        [relieveBtn addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
#if LOCK_APP
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BLUE] forState:UIControlStateNormal];
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BLUE] forState:UIControlStateHighlighted];
#elif VANMALOCK_APP
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateNormal];
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BTN_BG] forState:UIControlStateHighlighted];
#endif
        [bgView addSubview:relieveBtn];
        [relieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX).offset(0);
            make.bottom.equalTo(bgView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        return bgView;
    }else {
        return nil;
    }
    
}
//获取当前时间
- (NSString*)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

//创建白钥匙

- (void)createBtnClick:(UIButton *)btn {
    [MBProgressHUD showActivityMessage:STR_LOADING];
#if LOCK_APP
    BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
    basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
    basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
    basicInfo.keyId = [self.keyInfo.key_id intValue];
    BlackListKeyInfo *blackListKeyInfo = [[BlackListKeyInfo alloc] init];
    [SetKeyController setBlackListKey:basicInfo andBlackListKeyInfo:blackListKeyInfo];
    
#elif VANMALOCK_APP
    [self.bleKeysdk clearBlocklistFlag];
#endif
}

#if LOCK_APP
- (void)requestSetBlackListKeyResultInfo:(ResultInfo *)info{
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CREATE_WHITE_KEY_FAIL];
        return;
    }else {
        [self setWhiteList:self.keyInfo.key_id];
    }
}
#elif VANMALOCK_APP
- (void)onClearBlocklistFlag:(Result *)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CREATE_WHITE_KEY_FAIL];
        return;
    }else {
        [self setWhiteList:self.keyInfo.keyId];
    }
}
#endif

- (void)setWhiteList:(NSString *)keyId {
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest PUT:[NSString stringWithFormat:kSetKeyFlag,keyId,2] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
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
            [MBProgressHUD showError:STR_CREATE_WHITE_KEY_SUCCESS];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end


