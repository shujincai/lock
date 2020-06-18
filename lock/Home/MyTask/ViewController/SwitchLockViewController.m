//
//  SwitchLockViewController.m
//  lock
//
//  Created by 金万码 on 2020/6/9.
//  Copyright © 2020 li. All rights reserved.
//

#import "SwitchLockViewController.h"
#import "MyTaskListCell.h"
#import "RegistrationKeyModel.h"
#import "RegistrationLockModel.h"
#import "MyTaskModel.h"

@interface SwitchLockViewController ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfo;
@property (nonatomic,strong)RegistrationLockInfoBean * lockInfo;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)UITextField * keyTF;

@end

@implementation SwitchLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_SWITH_LOCK;
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [MBProgressHUD showActivityMessage:STR_CONNECTING];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [self createTableView];
    [SetKeyController setDelegate:self];
    [SetKeyController initSDK];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)returnClick {
    [SetKeyController disConnectBle];
    [self.navigationController popViewControllerAnimated:YES];
}
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
        [SetKeyController connectBlueTooth:_currentBle withSyscode:@[@0x36, @0x36, @0x36, @0x36] withRegcode:@[@0x31, @0x31, @0x31, @0x31] withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:NO];
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
        if (![self.keyInfo.key_id isEqualToString:self.taskBean.keyno]) {//钥匙不匹配
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_KEY_NUMBER_NO_MATE];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate * beginDate = [formatter dateFromString:self.taskBean.begintime];
            NSDate * endDate = [formatter dateFromString:self.taskBean.endtime];
            
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
        self.lockInfo = [[RegistrationLockInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.time = [self getCurrentTime];
        infoBean.eventtype = self.lockInfo.event_type;
        if ([self.lockInfo.event_type isEqualToString:@"4"]) {//超出有效期
            infoBean.name = STR_OVERSTEP_TERM_VALIDITY;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfo.event_type isEqualToString:@"5"]) {//没有权限
            infoBean.name = STR_NO_POWER;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfo.event_type isEqualToString:@"6"]) {//超出时间范围
            infoBean.name = STR_OVERSTEP_TIME_RANGE;
            infoBean.iamgeName = @"ic_switch_fail";
        }
        if ([self.lockInfo.event_type isEqualToString:@"13"]) {
            infoBean.name = STR_OPEN_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        if ([self.lockInfo.event_type isEqualToString:@"14"]) {
            infoBean.name = STR_CLOSE_LOCK_SUCCESS;
            infoBean.iamgeName = @"ic_switch_success";
        }
        if (![self.lockInfo.event_type isEqualToString:@"1"]) {
            [self.listArray addObject:infoBean];
            [self.tableView reloadData];
        }
        [self uploadKeyDatas:infoBean];
    }
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
    static NSString * reuseIdentifier =  @"MyTaskListCell";
    MyTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyTaskListCell" owner:self options:nil] lastObject];
        
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
    request.lockno = self.lockBean.lockno;
    request.opttype = self.taskBean.opttype;
    NSArray *parameterArr = [NSArray arrayWithObject:[request toDictionary]];
    NSString *parameterstr = [MSNetwork dictionaryToJson:parameterArr];
    [MSNetwork postWithUrl:kLockdatas body:[parameterstr dataUsingEncoding:NSUTF8StringEncoding] success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end
