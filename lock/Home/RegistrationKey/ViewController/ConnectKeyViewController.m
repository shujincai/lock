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

@interface ConnectKeyViewController ()<UITableViewDataSource,UITableViewDelegate,SetKeyControllerDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfo;
@property (nonatomic,strong)UITextField * keyTF;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,assign)NSInteger registerNumber;

@end

@implementation ConnectKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_REG_KEY;
    self.registerNumber = 0;
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [MBProgressHUD showActivityMessage:STR_CONNECTING];
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
//                    [SetKeyController connectBlueTooth:self.currentBle withSyscode:DEFINE_SYSCODE withRegcode:DEFINE_REGCODE withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:YES];
                    [SetKeyController connectBlueTooth:self.currentBle withSyscode:@[@36,@36,@36,@36] withRegcode:@[@31,@31,@31,@31] withLanguageType:RASCRBleSDKLanguageTypeChinese needResetKey:NO];
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
//设置注册密钥
- (void)requestSetRegisterKeyResultInfo:(ResultInfo *)info {

}
//获取钥匙数据
- (void)requestReadKeyInfoResultInfo:(ResultInfo *)info {
    [MBProgressHUD hideHUD];
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.keyInfo = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        if (self.registerNumber > 0) {
            NSCalendar * gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDate * beginDate = [NSDate date];
            NSDate * endDate = [gregorian dateByAddingUnit:NSCalendarUnitDay value:7 toDate:beginDate options:0];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yy-MM-dd-HH-mm";
           
            BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
            basicInfo.keyValidityPeriodStart = [dateFormatter stringFromDate:beginDate];
            basicInfo.keyValidityPeriodEnd = [dateFormatter stringFromDate:endDate];
            basicInfo.keyId = [self.keyInfo.key_id intValue];
//            basicInfo.keyType = RASCRBleSDKKeyTypeSetting;
            basicInfo.regCode = [CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd];
            basicInfo.sysCode = [CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd];
            RegisterKeyInfo *registerKeyInfo = [[RegisterKeyInfo alloc] init];
            registerKeyInfo.lockCylinderCode = [CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd];
            registerKeyInfo.newlockCylinderCode = [CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd];
            [SetKeyController setRegisterKey:basicInfo andRegisterKeyInfo:registerKeyInfo];
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"cell";
      ConnectKeyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
       if (!cell) {
           cell = [[ ConnectKeyTableViewCell alloc]
                   initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
       }
    if(indexPath.row == 0){
        cell.topLabel.text = [NSString stringWithFormat:@"%@：%@",STR_KEY_NAME,_currentBle.name];
        
    }else if (indexPath.row == 1){
        if (_keyInfo) {
            cell.topLabel.text = [NSString stringWithFormat:@"MAC：%@",_keyInfo.mac_address];
        }else {
            cell.topLabel.text = @"MAC：";
        }

    }else if (indexPath.row == 2){
        if (_keyInfo) {
            cell.topLabel.text = [NSString stringWithFormat:@"%@ID：%@",STR_KEY,_keyInfo.key_id];
        }else {
            cell.topLabel.text = [NSString stringWithFormat:@"%@ID：",STR_KEY];
        }

    }else if (indexPath.row == 3){
        if (_keyInfo) {
            cell.topLabel.text = [NSString stringWithFormat:@"%@：%@",STR_KEY_NUMBER,_keyInfo.read_key_serial_number];
        }else {
            cell.topLabel.text = [NSString stringWithFormat:@"%@：",STR_KEY_NUMBER];
        }

    }else if (indexPath.row == 4){
        if (_keyInfo) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            cell.topLabel.text = [NSString stringWithFormat:@"%@%@：%@",STR_KEY,STR_TIME,currentTimeString];
        }else {
            cell.topLabel.text = [NSString stringWithFormat:@"%@%@：",STR_KEY,STR_TIME];
        }
    }
    
    return cell;
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
//注册钥匙
- (void)registerBtnClick:(UIButton *)btn {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RegistrationKeyRegRequest * keyRequest = [[RegistrationKeyRegRequest alloc]init];
    keyRequest.factoryno = _keyInfo.read_key_serial_number;
    keyRequest.keyid = _keyInfo.key_id;
    keyRequest.keymode = @"0";
    keyRequest.keyname = _currentBle.name;
    keyRequest.keyno = _keyInfo.key_id;
    keyRequest.keystatus = @"0";
    keyRequest.keytype = _keyInfo.key_type;
    [MSHTTPRequest POST:kRegKey parameters:[keyRequest toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
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
            [MBProgressHUD showMessage:STR_REG_KEY_SUCCESS];
            [SetKeyController disConnectBle];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
    
}
//修改钥匙ID
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改钥匙ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入钥匙ID（1～60000）";
            self.keyTF = textField;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.keyTF.text.length <= 0) {
                [MBProgressHUD showMessage:@"钥匙ID不能为空"];
                return;
            }
            BasicInfo *basicInfo = [[BasicInfo alloc] initBasicInfo];
            basicInfo.keyValidityPeriodStart = self.keyInfo.key_validity_period_start;
            basicInfo.keyValidityPeriodEnd = self.keyInfo.key_validity_period_end;
            basicInfo.keyId = [self.keyTF.text intValue];
            
            UserKeyInfo *userKeyInfo = [[UserKeyInfo alloc] init];
            [SetKeyController setUserKey:basicInfo andUserKeyInfo:userKeyInfo];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)requestSetUserKeyResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {
        [MBProgressHUD showError:@"修改钥匙失败"];
    }else {
        self.keyInfo = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        [self.tableView reloadData];
    }
}
@end
