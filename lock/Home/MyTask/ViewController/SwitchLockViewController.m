//
//  SwitchLockViewController.m
//  lock
//
//  Created by 金万码 on 2020/6/9.
//  Copyright © 2020 li. All rights reserved.
//

#import "SwitchLockViewController.h"
#import "SwitchLockListCell.h"
#import "RegistrationKeyModel.h"
#import "RegistrationLockModel.h"
#import "MyTaskModel.h"

@interface SwitchLockViewController ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfoB; //B钥匙信息
@property (nonatomic,strong)RegistrationLockInfoBean * lockInfoB; //B锁信息
@property (nonatomic,strong)KeyInfo * keyInfoC; //C钥匙信息
@property (nonatomic,strong)RecordInfo * lockInfoC; //C锁信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)UITextField * keyTF;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)BOOL isHide; //根据加载时间判断是否隐藏加载框

@end

@implementation SwitchLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_SWITH_LOCK;
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
        //初始化蓝牙SDK
        self.bleKeysdk = [BleKeySdk shareKeySdk];
        //设置代理
        [self.bleKeysdk setDelgate:self];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_INIT_SUCCESS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_init";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
        //连接钥匙
        [self.bleKeysdk connectToKey:_currentBle secret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] sign:0];
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
        self.keyInfoB = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        for (UserKeyInfoList * keyList in self.taskBean.keylist) {
            if ([keyList.keyno isEqualToString:self.keyInfoB.key_id]) {
                self.taskBean.keyno = keyList.keyno;
                break;
            }
        }
        if (![self.keyInfoB.key_id isEqualToString:self.taskBean.keyno]) {//钥匙不匹配
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_KEY_NUMBER_NO_MATE];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            //设置开关锁模式
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate * beginDate = [formatter dateFromString:self.taskBean.begindatetime];
            NSDate * endDate = [formatter dateFromString:self.taskBean.enddatetime];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yy-MM-dd-HH-mm";
            
            BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
            basicInfo.keyValidityPeriodStart = [dateFormatter stringFromDate:beginDate];
            basicInfo.keyValidityPeriodEnd = [dateFormatter stringFromDate:endDate];
            basicInfo.keyId = [self.taskBean.keyno intValue];
            
            OnlineOpenInfo *onlineOpenInfo = [[OnlineOpenInfo alloc] init];
            onlineOpenInfo.onlineOpenStartTime = [dateFormatter stringFromDate:beginDate];
            onlineOpenInfo.onlineOpenEndTime = [dateFormatter stringFromDate:endDate];
            onlineOpenInfo.idType = 0x01;
            onlineOpenInfo.lockOrLockGroupId = [self.lockBean.lockno intValue];
            [SetKeyController setOnlineOpen:basicInfo andOnlineOpenInfo:onlineOpenInfo];
        }
    }
}
//设置在线开门钥匙
- (void)requestSetOnlineOpenResultInfo:(ResultInfo *)info {
    self.isHide = YES;
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_SETTING_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {//请开关锁
        [MBProgressHUD hideHUD];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_PLEASE_SWITH_LOCK;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_lock";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
    }
}
//获取锁数据
- (void)requestActiveReport:(ResultInfo *)info {
    NSLog(@"%@",info.detailDic);
    if (info.feedBackState == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.lockInfoB = [[RegistrationLockInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.time = [self getCurrentTime];
        infoBean.eventtype = self.lockInfoB.event_type;
        if ([self.lockInfoB.event_type isEqualToString:@"4"]) {//超出有效期
            infoBean.name = STR_OVERSTEP_TERM_VALIDITY;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfoB.event_type isEqualToString:@"5"]) {//没有权限
            infoBean.name = STR_NO_POWER;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfoB.event_type isEqualToString:@"6"]) {//超出时间范围
            infoBean.name = STR_OVERSTEP_TIME_RANGE;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfoB.event_type isEqualToString:@"8"]) {//黑名单钥匙
            infoBean.name = STR_BLACKLIST_KEY;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfoB.event_type isEqualToString:@"13"]) {//开锁成功
            infoBean.name = STR_OPEN_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        if ([self.lockInfoB.event_type isEqualToString:@"14"]) {//关锁成功
            infoBean.name = STR_CLOSE_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        if (![self.lockInfoB.event_type isEqualToString:@"1"]) {//钥匙与锁接触
            [self.listArray addObject:infoBean];
            [self.tableView reloadData];
        }
        //上传开关锁数据
        [self uploadKeyDatas:infoBean];
    }
}

#pragma mark C锁

//侧滑返回上一页
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (self.bleKeysdk) {
        [self.bleKeysdk disConnectFromKey];
    }
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
        self.keyInfoC = result.obj;
        for (UserKeyInfoList * keyList in self.taskBean.keylist) {
            if ([keyList.keyno isEqualToString:self.keyInfoC.keyId]) {
                self.taskBean.keyno = keyList.keyno;
                break;
            }
        }
        if (![self.keyInfoC.keyId isEqualToString:self.taskBean.keyno]) {//钥匙不匹配
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_KEY_NUMBER_NO_MATE];
            [self.bleKeysdk disConnectFromKey];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            //校时
            [self.bleKeysdk setDateTime:[NSDate date]];
        }
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
        if (_keyInfoC.device == 1284) { //指纹蓝牙钥匙
            //指纹授权
            NSMutableArray<NSNumber*> * fingerArray = [NSMutableArray<NSNumber*> array];
            for (FingerPrintListBean * fingerList in self.userInfo.fingerlist) {
                [fingerArray addObject:[NSNumber numberWithInt:[fingerList.fingerprintid intValue]]];
            }
            [self.bleKeysdk setFingers:[fingerArray copy]];
        }else { //蓝牙钥匙
            //设置开关锁钥匙
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"HH:mm:ss";
            //当前日期
            NSDate *nowDate = [NSDate date];
            NSString * nowString = [dateFormatter stringFromDate:nowDate];
            
            NSDate * beginDate = [formatter dateFromString:self.taskBean.begindatetime];
            NSDate * endDate = [formatter dateFromString:self.taskBean.enddatetime];
            //多时间段
            NSMutableArray<TimeSection*> *times = [[NSMutableArray<TimeSection*>  alloc]init];
            for (MyTaskTimeRangeListBean * timeList in _taskBean.timerangelist) {
                NSString * beginTime = [NSString stringWithFormat:@"%@ %@",nowString,[timeFormatter stringFromDate:[formatter dateFromString:timeList.begintime]]];
                NSString * endTime = [NSString stringWithFormat:@"%@ %@",nowString,[timeFormatter stringFromDate:[formatter dateFromString:timeList.endtime]]];
                TimeSection * timeSection = [[TimeSection alloc]initSection:[formatter dateFromString:beginTime] to:[formatter dateFromString:endTime]];
                [times addObject:timeSection];
            }
            //时间块，时间片
            NSArray<DateSection*> *dates =[NSArray arrayWithObjects:[[DateSection alloc] initSection:beginDate to:endDate times:times], nil];
            //锁号
            NSArray *lockIds = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.lockBean.lockno], nil];
            WMUserKeyInfo *userkeyInfo = [[WMUserKeyInfo alloc] initUserKeyInfo:dates lockIds:lockIds];
            [self.bleKeysdk setUserKey:userkeyInfo isOnline:NO];
        }
    }
}

//指纹授权
-(void)onSetFingers:(Result*)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_FINGERPRINT_AUTHORIZE_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        //指纹授权成功
        //        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        //        infoBean.name = STR_FINGERPRINT_AUTHORIZE_SUCCESS;
        //        infoBean.time = [self getCurrentTime];
        //        infoBean.iamgeName = @"ic_switch_fingerprint";
        //        [self.listArray addObject:infoBean];
        //        [self.tableView reloadData];
        
        //设置开关锁钥匙
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        //当前日期
        NSDate *nowDate = [NSDate date];
        NSString * nowString = [dateFormatter stringFromDate:nowDate];
        
        NSDate * beginDate = [formatter dateFromString:self.taskBean.begindatetime];
        NSDate * endDate = [formatter dateFromString:self.taskBean.enddatetime];
        //多时间段
        NSMutableArray<TimeSection*> *times = [[NSMutableArray<TimeSection*>  alloc]init];
        for (MyTaskTimeRangeListBean * timeList in _taskBean.timerangelist) {
            NSString * beginTime = [NSString stringWithFormat:@"%@ %@",nowString,[timeFormatter stringFromDate:[formatter dateFromString:timeList.begintime]]];
            NSString * endTime = [NSString stringWithFormat:@"%@ %@",nowString,[timeFormatter stringFromDate:[formatter dateFromString:timeList.endtime]]];
            TimeSection * timeSection = [[TimeSection alloc]initSection:[formatter dateFromString:beginTime] to:[formatter dateFromString:endTime]];
            [times addObject:timeSection];
        }
        //时间块，时间片
        NSArray<DateSection*> *dates =[NSArray arrayWithObjects:[[DateSection alloc] initSection:beginDate to:endDate times:times], nil];
        //锁号
        NSArray *lockIds = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.lockBean.lockno], nil];
        WMUserKeyInfo *userkeyInfo = [[WMUserKeyInfo alloc] initUserKeyInfo:dates lockIds:lockIds];
        [self.bleKeysdk setUserKey:userkeyInfo isOnline:NO];
    }
}

//设置开关锁钥匙--用户钥匙,isOnline 是否在线，在线断开连接后，钥匙不能开关锁
-(void)onSetUserKey:(Result*)result {
    self.isHide = YES;
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_SETTING_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {//请开关锁
        [MBProgressHUD hideHUD];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        if (_keyInfoC.device == 1284) { //指纹蓝牙钥匙
            infoBean.name = STR_VERIFY_FINGERPRINT_SWITH_LOCK;
        }else {
            infoBean.name = STR_PLEASE_SWITH_LOCK;
        }
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_switch_lock";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
    }
}
//获取锁数据
- (void)onReport:(Result<RecordInfo *> *)result {
    NSLog(@"%@",result.obj);
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
    }else {
        self.lockInfoC = result.obj;
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.time = [self getCurrentTime];
        infoBean.eventtype = [NSString stringWithFormat:@"%d",self.lockInfoC.flag];
        infoBean.opttype = self.lockInfoC.status; //当前处于 开 0 关 1
        
        if (self.lockInfoC.flag == 5) {//没有权限
            infoBean.name = STR_NO_POWER;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 6) {//超出时间范围
            infoBean.name = STR_OVERSTEP_TIME_RANGE;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 19) {//密码不匹配
            infoBean.name = STR_PASSWORD_MISMATCH;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 20) {//操作中断
            if (self.lockInfoC.status == 0) {//关锁失败
                infoBean.name = STR_CLOSE_LOCK_FAIL;
                infoBean.iamgeName = @"ic_switch_fail";
            }else {//开锁失败
                infoBean.name = STR_OPEN_LOCK_FAIL;
                infoBean.iamgeName = @"ic_switch_fail";
            }
        }
        if (self.lockInfoC.flag == 21) {//钥匙与锁密钥匹配失败
            infoBean.name = STR_KEY_LOCK_MATCH_FAIL;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 255) {//黑名单钥匙
            infoBean.name = STR_BLACKLIST_KEY;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 254) {//验证失败 国内外
            infoBean.name = STR_VALIDATION_FAILED;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if (self.lockInfoC.flag == 0) {//开锁成功
            infoBean.name = STR_OPEN_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        if (self.lockInfoC.flag == 1) {//关锁成功
            infoBean.name = STR_CLOSE_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
        [self uploadKeyDatas:infoBean];
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
//获取当前时间
- (NSString*)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
//上传开关锁记录
- (void)uploadKeyDatas:(MyTaskSwitchLockInfoBean *)switchBean {
    
    MyTaskUploadKeyDataReqest * request = [[MyTaskUploadKeyDataReqest alloc]init];
    request.eventtype = switchBean.eventtype;
    request.time = switchBean.time;
    request.keyno = self.taskBean.keyno;
    if ([CommonUtil getLockType]) {
        request.lockno = self.lockInfoB.lock_id;
    } else {
        request.lockno = self.lockInfoC.lockid;
    }
    request.opttype = self.taskBean.opttype;
    NSArray *parameterArr = [NSArray arrayWithObject:[request toDictionary]];
    NSString *parameterstr = [MSNetwork dictionaryToJson:parameterArr];
    [MSNetwork postWithUrl:kLockdatas body:[parameterstr dataUsingEncoding:NSUTF8StringEncoding] success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end
