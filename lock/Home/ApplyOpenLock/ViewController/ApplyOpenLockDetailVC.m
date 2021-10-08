//
//  ApplyOpenLockDetailVC.m
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import "ApplyOpenLockDetailVC.h"
#import "ApplyOpenLockDateCell.h"
#import "ApplyOpenLockModel.h"
#import "ApplyOpenLockLockCell.h"
#import "DatePickerView.h"
#import "RegistrationKeyModel.h"
#import "MyTaskModel.h"
#import "RegistrationKeyModel.h"
#import "ApplyOpenLockSubjectCell.h"

@interface ApplyOpenLockDetailVC ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)RegistrationKeyInfoBean * keyInfoB; //B钥匙信息
@property (nonatomic,strong)KeyInfo * keyInfoC; //C钥匙信息
@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)NSMutableArray * checkboxArray;
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,strong)NSString * dateType; // 1日期选择 2时间选择
@property (nonatomic,strong)NSString * beginDate;
@property (nonatomic,strong)NSString * finishDate;
@property (nonatomic,strong)NSString * beginTime;
@property (nonatomic,strong)NSString * finishTime;
@property (nonatomic,assign)BOOL isHide;
@property (nonatomic,strong)UITextField * subjectTF;

@end

@implementation ApplyOpenLockDetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)checkboxArray {
    if (_checkboxArray == nil) {
        _checkboxArray = [NSMutableArray array];
    }
    return _checkboxArray;
}
- (void)returnClick {
    if ([CommonUtil getLockType]) {
        [SetKeyController disConnectBle];
    } else {
        [self.bleKeysdk disConnectFromKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData {
    [self setTitle:STR_NEW_APPLY_UNLOCK];
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    if (self.taskBean) {
        [MBProgressHUD showActivityMessage:STR_CONNECTING];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * beginDate = [formatter dateFromString:_taskBean.begindate];
        NSDate * endDate = [formatter dateFromString:_taskBean.enddate];
        NSDate * beginTime = [formatter dateFromString:_taskBean.begintime];
        NSDate * endTime = [formatter dateFromString:_taskBean.endtime];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        self.beginDate = [dateFormatter stringFromDate:beginDate];
        self.finishDate = [dateFormatter stringFromDate:endDate];
        self.beginTime = [timeFormatter stringFromDate:beginTime];
        self.finishTime = [timeFormatter stringFromDate:endTime];
        for (UnlockListBean * lockList in _taskBean.unlocklist) {
            [self.checkboxArray addObject:lockList.lockno];
        }
        if ([CommonUtil getLockType]) {
            self.keyInfoB = [[RegistrationKeyInfoBean alloc]init];
            for (UserKeyInfoList * keyList in _taskBean.keylist) {
                self.keyInfoB.key_id = keyList.keyno;
            }
        } else {
            self.keyInfoC = [[KeyInfo alloc]init];
            for (UserKeyInfoList * keyList in _taskBean.keylist) {
                self.keyInfoC.keyId = keyList.keyno;
            }
        }
        [self getLockTreeData];
    }else {
        NSDate * currentDate = [NSDate date];
        self.beginDate = [NSString stringWithFormat:@"%d-%.2d-%.2d",[currentDate getYear],[currentDate getMonth],[currentDate getDay]];
        self.finishDate = [NSString stringWithFormat:@"%d-%.2d-%.2d",[currentDate getYear],[currentDate getMonth],[currentDate getDay]];
        self.beginTime = @"00:00:00";
        self.finishTime = @"23:59:59";
        self.isHide = NO;
        [MBProgressHUD showActivityMessage:STR_CONNECTING];
        if ([CommonUtil getLockType]) {
            [SetKeyController setDelegate:self];
            [SetKeyController initSDK];
        } else {
            self.bleKeysdk = [BleKeySdk shareKeySdk];
            [self.bleKeysdk setDelgate:self];
            [self.bleKeysdk connectToKey:_currentBle secret:[CommonUtil getCLockDesDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] sign:[CommonUtil getAppleLanguages] ? 0: 1];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isHide == NO) {
                [MBProgressHUD hideHUD];
            }
        });
    }
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
        [SetKeyController connectBlueTooth:_currentBle withSyscode:[CommonUtil desDecodeWithCode:self.userInfo.syscode withPassword:self.userInfo.apppwd] withRegcode:[CommonUtil desDecodeWithCode:self.userInfo.regcode withPassword:self.userInfo.apppwd] withLanguageType:[CommonUtil getAppleLanguages] ? RASCRBleSDKLanguageTypeChinese : RASCRBleSDKLanguageTypeEnglish needResetKey:NO];
    }
    
}
//连接
- (void)requestConnectResultInfo:(ResultInfo *)info {
    if (info.feedBackState == NO) {//连接失败
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
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [SetKeyController disConnectBle];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        self.keyInfoB = [[RegistrationKeyInfoBean alloc]initWithDictionary:info.detailDic error:nil];
        self.isHide = YES;
        [self getKeyInfoDetail:self.keyInfoB.key_id];
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
    if (result.ret == NO || result.code < 0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_CONNECT_KEY_FAIL];
        [self.bleKeysdk disConnectFromKey];
        [self.navigationController popViewControllerAnimated:YES];
        return;
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
        self.isHide = YES;
        [self getLockTreeData];
    }
}

#pragma mark 公共方法

// 获取钥匙详情

- (void)getKeyInfoDetail:(NSString *)keyId {
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest GET:[NSString stringWithFormat:kKeyDetail,keyId] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        KeyInfoDetailResponse * response = [[KeyInfoDetailResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            if (response.data) {
                if ([response.data.keystatus isEqualToString:@"2"]) { // 损坏
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:STR_KEY_DAMAGED];
                    if ([CommonUtil getLockType]) {
                        [SetKeyController disConnectBle];
                    } else {
                        [self.bleKeysdk disConnectFromKey];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([response.data.keystatus isEqualToString:@"3"]){ // 丢失
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:STR_KEY_LOSE];
                    if ([CommonUtil getLockType]) {
                        [SetKeyController disConnectBle];
                    } else {
                        [self.bleKeysdk disConnectFromKey];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([response.data.keystatus isEqualToString:@"1"]){ // 领出
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:STR_KEY_TASK_OUT];
                    if ([CommonUtil getLockType]) {
                        [SetKeyController disConnectBle];
                    } else {
                        [self.bleKeysdk disConnectFromKey];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    if ([CommonUtil getLockType]) {
                        [self getLockTreeData];
                    } else {
                        //校时
                        [self.bleKeysdk setDateTime:[NSDate date]];
                    }
                    
                }
            } else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
                if ([CommonUtil getLockType]) {
                    [SetKeyController disConnectBle];
                } else {
                    [self.bleKeysdk disConnectFromKey];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [MBProgressHUD hideHUD];
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


// 根据区域id获取锁-区域列表
- (void)getLockTreeData {
    ApplyOpenLockTreeRequest * request = [[ApplyOpenLockTreeRequest alloc]init];
    request.deptids = self.userInfo.dept.deptid;
    [MSHTTPRequest GET:kLockTree parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ApplyOpenLockTreeResponse * response = [[ApplyOpenLockTreeResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD showError:response.msg];
            return ;
        }else {
            [self.listArray addObjectsFromArray:response.data.content];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
- (void)initLayout {
    // 创建任务
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"ctl_upload_task"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(0, 0, 36, 36);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * addBarItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[addBarItem];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
        return  60;
    }else {
        return 50;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count+3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//钥匙主题
        static NSString * reuseIdentifier =  @"ApplyOpenLockSubjectCell";
        ApplyOpenLockSubjectCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[ApplyOpenLockSubjectCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.topLabel.text = STR_TASK_SUBJECT;
        cell.textField.placeholder = STR_TASK_SUBJECT_TIPS;
        cell.textField.text = self.taskBean.subject;
        _subjectTF = cell.textField;
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        static NSString * reuseIdentifier =  @"ApplyOpenLockDateCell";
        ApplyOpenLockDateCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplyOpenLockDateCell" owner:self options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            cell.titleLabel.text = STR_DATE;
            cell.timeLabel.text = [NSString stringWithFormat:@"%@～%@",self.beginDate,self.finishDate];
            [cell.rightBtn setImage:[UIImage imageNamed:@"ctl_date_task"] forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"ctl_date_task"] forState:UIControlStateHighlighted];
            [cell.rightBtn addTarget:self action:@selector(rightBtnDateClick) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row == 2) {
            cell.titleLabel.text = STR_TIME;
            cell.timeLabel.text = [NSString stringWithFormat:@"%@～%@",self.beginTime,self.finishTime];
            [cell.rightBtn setImage:[UIImage imageNamed:@"ctl_time_task"] forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"ctl_time_task"] forState:UIControlStateHighlighted];
            [cell.rightBtn addTarget:self action:@selector(rightBtnTimeClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else {
        ApplyOpenLockTreeBean * lockBean = [_listArray objectAtIndex:indexPath.row-3];
        static NSString * reuseIdentifier =  @"ApplyOpenLockLockCell";
        ApplyOpenLockLockCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplyOpenLockLockCell" owner:self options:nil] lastObject];
            
        }
        if ([self.checkboxArray containsObject:lockBean.value]) {
            [cell.checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
        }else {
            [cell.checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
        }
        cell.checkboxBtnBlock = ^(UIButton * _Nonnull btn) {
            if ([self.checkboxArray containsObject:lockBean.value]) {
                [btn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
                [self.checkboxArray removeObject:lockBean.value];
            }else {
                [btn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
                [self.checkboxArray addObject:lockBean.value];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = lockBean.label;
        return cell;
    }
    
}
// 增加申请的任务
- (void)addBtnClick {
    if (_checkboxArray.count <= 0) {
        [MBProgressHUD showMessage:STR_PLEASE_SELECT_OPEN_LOCK];
        return ;
    }
    if (self.taskBean) { // 修改
        [MBProgressHUD showActivityMessage:STR_LOADING];
        ApplyOpenLockTaskRequest * request = [[ApplyOpenLockTaskRequest alloc]init];
        request.daterange = [NSArray arrayWithObjects:self.beginDate,self.finishDate, nil];
        if ([CommonUtil getLockType]) {
            request.keynos = [NSArray arrayWithObjects:self.keyInfoB.key_id, nil];
        } else {
            request.keynos = [NSArray arrayWithObjects:self.keyInfoC.keyId, nil];
        }
        request.locknos = self.checkboxArray;
        request.timerangelist = [NSArray arrayWithObjects:[NSArray arrayWithObjects:self.beginTime,self.finishTime, nil], nil];
        request.subject = _subjectTF.text;
        [MSHTTPRequest PUT:[NSString stringWithFormat:kTaskValid,_taskBean.taskid] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            [MBProgressHUD hideHUD];
            NSError * error = nil;
            ApplyOpenLockTreeResponse * response = [[ApplyOpenLockTreeResponse alloc]initWithDictionary:responseObject error:&error];
            if (error) {
                [MBProgressHUD showMessage:STR_PARSE_FAILURE];
                return ;
            }
            if ([response.resultCode intValue] != 0) {
                if ([response.resultCode intValue] == 15007) {//任务已存在
                    [MBProgressHUD showError:STR_TASK_ALREADY_EXIST];
                } else if ([response.resultCode intValue] == 15001) {//钥匙不存在
                    [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
                }else {
                    [MBProgressHUD showError:response.msg];
                }
                return ;
            }else {
                [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_APPLY_OPEN_LOCK_SUCCESS object:nil];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_TIMEOUT];
        }];
        
    }else { // 新建
        [MBProgressHUD showActivityMessage:STR_LOADING];
        ApplyOpenLockTaskRequest * request = [[ApplyOpenLockTaskRequest alloc]init];
        request.daterange = [NSArray arrayWithObjects:self.beginDate,self.finishDate, nil];
        if ([CommonUtil getLockType]) {
            request.keynos = [NSArray arrayWithObjects:self.keyInfoB.key_id, nil];
        } else {
            request.keynos = [NSArray arrayWithObjects:self.keyInfoC.keyId, nil];
        }
        request.locknos = self.checkboxArray;
        request.timerangelist = [NSArray arrayWithObjects:[NSArray arrayWithObjects:self.beginTime,self.finishTime, nil], nil];
        request.subject = _subjectTF.text;
        [MSHTTPRequest POST:kTaskList parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            [MBProgressHUD hideHUD];
            NSError * error = nil;
            ApplyOpenLockTreeResponse * response = [[ApplyOpenLockTreeResponse alloc]initWithDictionary:responseObject error:&error];
            if (error) {
                [MBProgressHUD showMessage:STR_PARSE_FAILURE];
                return ;
            }
            if ([response.resultCode intValue] != 0) {
                if ([response.resultCode intValue] == 15007) {//任务已存在
                    [MBProgressHUD showError:STR_TASK_ALREADY_EXIST];
                } else if ([response.resultCode intValue] == 15001) {//钥匙不存在
                    [MBProgressHUD showError:STR_KEY_INFO_NO_EXISTENT];
                }else {
                    [MBProgressHUD showError:response.msg];
                }
                return ;
            }else {
                if ([CommonUtil getLockType]) {
                    [SetKeyController disConnectBle];
                } else {
                    [self.bleKeysdk disConnectFromKey];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_APPLY_OPEN_LOCK_SUCCESS object:nil];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_TIMEOUT];
        }];
    }
}

- (void)rightBtnDateClick {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.dateType = @"1";
    DatePickerView * dateView = [[DatePickerView alloc]init];
    dateView.delegate = self;
    dateView.pickerViewMode = DatePickerViewDateYearMonthDayYearMonthDayMode;
    dateView.currentDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",self.beginDate,self.beginTime]];
    dateView.finishDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",self.finishDate,self.finishTime]];
    [dateView showDateTimePickerView];
}
- (void)rightBtnTimeClick {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.dateType = @"2";
    DatePickerView * dateView = [[DatePickerView alloc]init];
    dateView.delegate = self;
    dateView.pickerViewMode = DatePickerViewDateHourMinuteSecondMode;
    dateView.currentDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",self.beginDate,self.beginTime]];
    dateView.finishDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",self.finishDate,self.finishTime]];
    [dateView showDateTimePickerView];
}
// 日期选择完成
-(void)didClickFinishDateTimePickerView:(NSString*)date {
    // 选择的日期
    if ([self.dateType isEqualToString:@"1"]) {
        NSArray * dateArray = [date componentsSeparatedByString:@"～"];
        self.beginDate = [dateArray objectAtIndex:0];
        self.finishDate = [dateArray objectAtIndex:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else {
        NSArray * dateArray = [date componentsSeparatedByString:@"～"];
        self.beginTime = [dateArray objectAtIndex:0];
        self.finishTime = [dateArray objectAtIndex:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
