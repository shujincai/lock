//
//  BlackListRelieveVC.m
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import "BlackListRelieveVC.h"
#import "SwitchLockListCell.h"
#import "RegistrationKeyModel.h"
#import "BlackListModel.h"
#import "MyTaskModel.h"

@interface BlackListRelieveVC ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfoB; //B钥匙信息
@property (nonatomic,strong)KeyInfo * keyInfoC; //C钥匙信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)BOOL isHide; //根据加载时间判断是否隐藏加载框

@end

@implementation BlackListRelieveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_REMOVE_LOSS;
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
    //连接钥匙
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
        if (![self.keyInfoB.key_id isEqualToString:self.blacklistBean.keyno]) {//钥匙不匹配
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_KEY_NUMBER_NO_MATE];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            self.isHide = YES;
            [MBProgressHUD hideHUD];
            MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
            infoBean.name = STR_PLEASE_REMOVE_LOSS;
            infoBean.time = [self getCurrentTime];
            infoBean.iamgeName = @"ic_relieve_key";
            [self.listArray addObject:infoBean];
            [self.tableView reloadData];
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
//连接钥匙
- (void)onConnectToKey:(Result *)result {
    if (result.ret == NO || result.code < 0) {
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
        if (![self.keyInfoC.keyId isEqualToString:self.blacklistBean.keyno]) {//钥匙不匹配
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
        // 清除黑名单钥匙
        [self.bleKeysdk clearBlocklistFlag];
    }
}
- (void)onClearBlocklistFlag:(Result *)result {
    if (result.ret == NO) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CREATE_WHITE_KEY_FAIL];
        return;
    }else {
        self.isHide = YES;
        [MBProgressHUD hideHUD];
        MyTaskSwitchLockInfoBean * infoBean = [[MyTaskSwitchLockInfoBean alloc]init];
        infoBean.name = STR_PLEASE_REMOVE_LOSS;
        infoBean.time = [self getCurrentTime];
        infoBean.iamgeName = @"ic_relieve_key";
        [self.listArray addObject:infoBean];
        [self.tableView reloadData];
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
        [relieveBtn setTitle:STR_RELIEVE forState:UIControlStateNormal];
        [relieveBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        relieveBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
        relieveBtn.layer.masksToBounds = YES;
        relieveBtn.layer.cornerRadius = 4;
        [relieveBtn addTarget:self action:@selector(relieveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_RED] forState:UIControlStateNormal];
        [relieveBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_RED] forState:UIControlStateHighlighted];
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
//解除挂失

- (void)relieveBtnClick:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_BE_CAREFUL message:STR_REMOVE_LOSS_TIPS preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveRelieveLoss];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
// 解除挂失
-(void)saveRelieveLoss {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest DELETE:[NSString stringWithFormat:kBlackListLoss,_blacklistBean.keyno] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:response.msg];
            return ;
        }else {
            // 设置为空白钥匙
            if ([CommonUtil getLockType]) {
                BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                basicInfo.keyId = [self.keyInfoB.key_id intValue];
                BlankKeyInfo *blankKeyInfo = [[BlankKeyInfo alloc] init];
                [SetKeyController setBlankKey:basicInfo andBlankKeyInfo:blankKeyInfo];
            } else {
                [self.bleKeysdk setBlankKey];
            }
            
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
// 解除挂失后，设置为空白钥匙，返回
- (void)requestSetBlankKeyResultInfo:(ResultInfo *)info {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:STR_REMOVE_LOSS_SUCCESS];
    [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_KEY_RELIEVE_SUCCESS object:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (void)onSetBlankKey:(Result *)result {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:STR_REMOVE_LOSS_SUCCESS];
    [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_KEY_RELIEVE_SUCCESS object:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
