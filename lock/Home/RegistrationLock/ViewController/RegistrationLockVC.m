
//
//  RegistrationLockVC.m
//  blueDemo
//
//  Created by mac on 2020/6/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "RegistrationLockVC.h"
#import "ConnectKeyTableViewCell.h"
#import "RegistrationLockTFCell.h"
#import "RegistrationKeyModel.h"
#import "RegistrationLockModel.h"

@interface RegistrationLockVC ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfo;
@property (nonatomic,strong)RegistrationLockInfoBean * lockInfo;
@property (nonatomic,strong)UITextField * keyTF;
@property (nonatomic,strong)UITextField * lockNameTF;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)BOOL isHide;
@property (nonatomic,assign)BOOL isLockHide;
@property (nonatomic,strong)NSString * setLockId;
@end

@implementation RegistrationLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_REG_LOCK;
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    self.isHide = NO;
    self.isLockHide = NO;
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [MBProgressHUD showActivityMessage:STR_LOADING];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isHide == NO) {
            [MBProgressHUD hideHUD];
        }
    });
    [self createTableView];
    [SetKeyController setDelegate:self];
    [SetKeyController initSDK];
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
        NSCalendar * gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDate * beginDate = [NSDate date];
        NSDate * endDate = [gregorian dateByAddingUnit:NSCalendarUnitDay value:7 toDate:beginDate options:0];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yy-MM-dd-HH-mm";
        
        BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
        basicInfo.keyValidityPeriodStart = [dateFormatter stringFromDate:beginDate];
        basicInfo.keyValidityPeriodEnd = [dateFormatter stringFromDate:endDate];
        basicInfo.keyId = [self.keyInfo.key_id intValue];
        
        OnlineOpenInfo *onlineOpenInfo = [[OnlineOpenInfo alloc] init];
        onlineOpenInfo.onlineOpenStartTime = [dateFormatter stringFromDate:beginDate];
        onlineOpenInfo.onlineOpenEndTime = [dateFormatter stringFromDate:endDate];
        [SetKeyController setOnlineOpen:basicInfo andOnlineOpenInfo:onlineOpenInfo];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showActivityMessage:STR_PLEASE_CONNECT_LOCK_READ];
    }
}
//获取锁数据
- (void)requestActiveReport:(ResultInfo *)info {
    self.isHide = YES;
    [MBProgressHUD hideHUD];
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CONNECT_LOCK_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.lockInfo = [[RegistrationLockInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        if ([self.lockInfo.event_type isEqualToString:@"2"]) {
            self.isLockHide = YES;
            self.lockInfo.lock_id = self.setLockId;
            self.setLockId = nil;
        }
        [self.tableView reloadData];
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
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * reuseIdentifier =  @"RegistrationLockTFCell";
        RegistrationLockTFCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[RegistrationLockTFCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.topLabel.text = STR_KEY_NAME;
        _lockNameTF = cell.textField;
        return cell;
    }else {
        static NSString * reuseIdentifier =  @"cell";
        ConnectKeyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[ ConnectKeyTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_lockInfo) {
            cell.topLabel.text = [NSString stringWithFormat:@"%@：%@",STR_LOCK_ID,_lockInfo.lock_id];
        }else {
            cell.topLabel.text = cell.topLabel.text = [NSString stringWithFormat:@"%@：",STR_LOCK_ID];
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
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * bgView = [[UIView alloc]init];
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setTitle:STR_REGISTER forState:UIControlStateNormal];
    [regBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    regBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = 4;
    [regBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_GREEN] forState:UIControlStateHighlighted];
    [bgView addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.bottom.equalTo(bgView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    return bgView;
}
//注册锁
- (void)registerBtnClick:(UIButton *)btn {
    if (kStringIsEmpty(self.lockNameTF.text)) {
        [MBProgressHUD showMessage:STR_LOCK_NAME_TIPS];
        return;
    }
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RegistrationLockRegRequest * request = [[RegistrationLockRegRequest alloc]init];
    request.lockid = _lockInfo.lock_id;
    request.lockname = _lockNameTF.text;
    request.lockno = _lockInfo.lock_id;
    [MSHTTPRequest POST:kRegLock parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@(%@)",STR_SUBMIT_DATA_FAIL,response.resultCode]];
            return ;
        }else {
            [MBProgressHUD showMessage:STR_RE_LOCK_SUCCESS];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
    
}

//修改锁ID
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (self.setLockId.length > 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改锁ID" message:self.setLockId preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showActivityMessage:STR_LOADING];
                BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                basicInfo.keyId = [self.keyInfo.key_id integerValue];
                
                SettingKeyInfo *setKeyInfo = [[SettingKeyInfo alloc] init];
                setKeyInfo.lockId = [self.setLockId integerValue];
                [SetKeyController setSettingKey:basicInfo andSettingKeyInfo:setKeyInfo];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
         [MBProgressHUD showActivityMessage:STR_LOADING];
         RequestBean * request = [[RequestBean alloc]init];
         [MSHTTPRequest GET:kLockId parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
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
                 self.setLockId = response.data.lockno;
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改锁ID" message:response.data.lockno preferredStyle:UIAlertControllerStyleAlert];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                 }]];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [MBProgressHUD showActivityMessage:STR_LOADING];
                     BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
                     basicInfo.keyValidityPeriodStart = @"00-01-01-00-00";
                     basicInfo.keyValidityPeriodEnd = @"99-12-31-23-59";
                     basicInfo.keyId = [self.keyInfo.key_id integerValue];
                     
                     SettingKeyInfo *setKeyInfo = [[SettingKeyInfo alloc] init];
                     setKeyInfo.lockId = [response.data.lockno integerValue];
                     [SetKeyController setSettingKey:basicInfo andSettingKeyInfo:setKeyInfo];
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
- (void)requestSetSettingKeyResultInfo:(ResultInfo *)info{
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:@"修改锁ID失败"];
    }else {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showActivityMessage:STR_PLEASE_CONNECT_LOCK_READ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isLockHide == NO) {
                [MBProgressHUD hideHUD];
            }
        });
    }
    
}
@end
