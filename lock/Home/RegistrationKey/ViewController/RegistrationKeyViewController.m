//
//  RegistrationKeyViewController.m
//  lock
//
//  Created by 李金洋 on 2020/4/3.
//  Copyright © 2020 li. All rights reserved.
//

#import "RegistrationKeyViewController.h"
#import "RegistrationKeyTableViewCell.h"
#import "ConnectKeyViewController.h"
#import "RegistrationLockVC.h"
#import "SearchBluetoothView.h"
#import "SwitchLockViewController.h"
#import "MyTaskModel.h"
#import "ApplyOpenLockDetailVC.h"
#import "BlackListRelieveVC.h"
#import "BlackListCreateVC.h"
#import "WriteListCreateVC.h"
#import "LockReplaceDetailVC.h"
#import "RegistrationKeyModel.h"
#import "SwitchLockDateViewController.h"

@interface RegistrationKeyViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,SetKeyControllerDelegate,KeyDelegate>

@property (nonatomic,strong)BleKeySdk * bleKeysdk;
@property (strong, nonatomic) NSMutableArray *bleArray; //搜索到蓝牙
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)SearchBluetoothView * searchBluetoothView;
@property ( nonatomic) BOOL _isScan;

@end

@implementation RegistrationKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_SEARCH_BLUETOOTH;
    [self gennerateNavigationItemReturnBtn:@selector(returnClick)];
    [self createTableView];
    [self KeyBtn];
    //初始化
    if ([CommonUtil getLockType]) {
        [SetKeyController initBlueToothManager];
        [SetKeyController setDelegate:self];
    } else {
        self.bleKeysdk = [BleKeySdk shareKeySdk];
        [self.bleKeysdk setDelgate:self];
        [self.bleKeysdk initSdk];
    }
    
}
- (void)returnClick {
    [self.navigationController popViewControllerAnimated:YES];
    //停止蓝牙搜索
    [self.searchBluetoothView hide];
    if ([CommonUtil getLockType]) {
        [SetKeyController stopScan];
    } else {
        [self.bleKeysdk stopScan];
    }
    
}
//当侧滑返回 停止蓝牙搜索
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (parent == nil) {
        [self.searchBluetoothView hide];
        if ([CommonUtil getLockType]) {
            [SetKeyController stopScan];
        } else {
            [self.bleKeysdk stopScan];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开始蓝牙搜索
    [self.searchBluetoothView start];
    if ([CommonUtil getLockType]) {
        [SetKeyController startScan];
        if (![SetKeyController sharedManager].delegate){
            [SetKeyController setDelegate:self];
        }
    } else {
        [self.bleKeysdk startScan:10*1000];
        [self.bleKeysdk setDelgate:self];
    }
    
}

- (NSMutableArray *)bleArray {
    if (_bleArray == nil) {
        _bleArray = [NSMutableArray array];
    }
    return _bleArray;
}
- (NSMutableArray *)keyArray {
    if (_keyArray == nil) {
        _keyArray = [NSMutableArray array];
    }
    return _keyArray;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_abnormal_no_notice"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2),
                                 NSForegroundColorAttributeName: COLOR_BLACK};
    return [[NSAttributedString alloc] initWithString:STR_NO_BLUETOOTH attributes:attributes];
}
-(void)KeyBtn{
    WS(weakSelf);
    self.searchBluetoothView = [[SearchBluetoothView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH-80, UISCREEN_HEIGHT-TABBAR_AREA_HEIGHT-80, 80, 80)];
    [self.view addSubview:self.searchBluetoothView];
    self.searchBluetoothView.searchBluetoothBlock = ^(BOOL type) {
        if ([CommonUtil getLockType]) {
            if (type == false) {//开始扫描
                [weakSelf.bleArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [SetKeyController startScan];
                if (![SetKeyController sharedManager].delegate){
                    [SetKeyController setDelegate:weakSelf];
                }
            }else {
                [SetKeyController stopScan];
            }
        } else {
            if (type == false) {//开始扫描
                [weakSelf.bleArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf.bleKeysdk startScan:1000*10];
            }else {
                [weakSelf.bleKeysdk stopScan];
            }
        }
        
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"cell";
    RegistrationKeyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[RegistrationKeyTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if ([CommonUtil getLockType]) {
        RASCRBleSDKPeripheralModel *peripheralModel = _bleArray[indexPath.row];
        NSString * peripheralName = peripheralModel.peripheralName;
        cell.topLabel.text =  peripheralName;
        if (peripheralModel.peripheral.state == CBPeripheralStateDisconnected) {//未连接
            cell.bottomLabel.text = STR_NO_CONNECT;
        }
        if (peripheralModel.peripheral.state == CBPeripheralStateConnecting) {//连接中
            cell.bottomLabel.text = STR_CONNECTING;
        }
        if (peripheralModel.peripheral.state == CBPeripheralStateConnected) {//已连接
            cell.bottomLabel.text = STR_CONNECTED;
        }
        if (peripheralModel.peripheral.state == CBPeripheralStateDisconnecting) {//断开中
            cell.bottomLabel.text = STR_DISCONNECTING;
        }
        NSString *str = [peripheralName substringToIndex:4];//str3 = "this"
        if ([str isEqualToString:@"B030"] || [str isEqualToString:@"rayonicskey"]) {
            cell.leftImage.image = [UIImage imageNamed:@"ic_list_key"];
        }else{
            cell.leftImage.image = [UIImage imageNamed:@"ic_list_bluetooth"];
            
        }
        if (_taskBean) {
            for (UserKeyInfoList * keyList in _taskBean.keylist) {
                if ([keyList.bleflag isEqualToString:[CommonUtil getBluetoothKeyMac:peripheralName]]) {
                    cell.rightImage.image = [UIImage imageNamed:@"ic_lock_open"];
                    break;
                }
            }
        }
    } else {
        BluetoothKeyBean * keyBean = [_keyArray objectAtIndex:indexPath.row];
        cell.topLabel.text = [keyBean.keyId substringFromIndex:4];
        cell.bottomLabel.text = keyBean.mac;
        cell.leftImage.image = [UIImage imageNamed:@"ic_list_key"];
        if (_taskBean) {
            for (UserKeyInfoList * keyList in _taskBean.keylist) {
                if (keyList.bleflag.length > 0) {
                    if ([keyBean.keyId rangeOfString:keyList.bleflag].location != NSNotFound) {
                        cell.rightImage.image = [UIImage imageNamed:@"ic_lock_open"];
                        break;
                    }
                }
            }
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
//扫描蓝牙

#pragma mark B锁
- (void)scannedPeripheralModel:(RASCRBleSDKPeripheralModel *)peripheralModel {
    RASCRBleSDKKeyHardwareType keyHardWareType = [RASCRBleSDKPublicUtil keyHardwareTypeFromPeripheralName:peripheralModel.peripheralName];
    if (keyHardWareType != RASCRBleSDKKeyHardwareTypeUnknow && ![RASCRBleSDKPublicUtil peripheralModelArray:_bleArray containsPeripheral:peripheralModel.peripheral]) {
        [_bleArray addObject:peripheralModel];
        _bleArray = [RASCRBleSDKPublicUtil sortedPeripheralModelArrayFromArray:_bleArray];
        [self.tableView reloadData];
    }
}

#pragma mark C锁

-(void)onScanedPeripheral:(CBPeripheral *)peripheral keyIdData:(NSDictionary *)keyIdData RSSI:(NSNumber *)RSSI {
    if (![_bleArray containsObject:peripheral]){
        [_bleArray addObject:peripheral];
        [self.keyArray addObject:[[BluetoothKeyBean alloc]initWithDictionary:keyIdData error:nil]];
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    CBPeripheral * currentBle;
    if ([CommonUtil getLockType]) {
        RASCRBleSDKPeripheralModel * peripheralModel = _bleArray[indexPath.row];
        currentBle = peripheralModel.peripheral;
    } else {
        currentBle = [_bleArray objectAtIndex:indexPath.row];
    }
    if ([CommonUtil getLockType]) {
        [self.searchBluetoothView hide];
        [SetKeyController stopScan];
        if ([self.type isEqualToString:@"0"]) {//注册钥匙
            ConnectKeyViewController * connectKey = [[ConnectKeyViewController alloc]init];
            connectKey.currentBle = currentBle;
            [self.navigationController pushViewController: connectKey animated:YES];
        }
    } else {
        BluetoothKeyBean * dict = [_keyArray objectAtIndex:indexPath.row];
        [self.searchBluetoothView hide];
        [self.bleKeysdk stopScan];
        if ([self.type isEqualToString:@"0"]) {//注册钥匙
            ConnectKeyViewController * connectKey = [[ConnectKeyViewController alloc]init];
            connectKey.currentBle = currentBle;
            connectKey.keyDictionary = dict;
            [self.navigationController pushViewController: connectKey animated:YES];
        }
    }
    
    if ([self.type isEqualToString:@"1"]) {//注册锁
        RegistrationLockVC * lockVC = [[RegistrationLockVC alloc]init];
        lockVC.currentBle = currentBle;
        [self.navigationController pushViewController: lockVC animated:YES];
    }
    if ([self.type isEqualToString:@"2"]) {//我的任务 开关锁
        SwitchLockViewController * switchLockVC = [[SwitchLockViewController alloc]init];
        switchLockVC.currentBle = currentBle;
        switchLockVC.taskBean = self.taskBean;
        switchLockVC.lockBean = self.lockBean;
        [self.navigationController pushViewController: switchLockVC animated:YES];
    }
    if ([self.type isEqualToString:@"3"]) {//申请开锁
        ApplyOpenLockDetailVC * applyDetailVC = [[ApplyOpenLockDetailVC alloc]init];
        applyDetailVC.currentBle = currentBle;
        [self.navigationController pushViewController:applyDetailVC animated:YES];
    }
    if ([self.type isEqualToString:@"4"]) {//解除挂失
        BlackListRelieveVC * relieveVC = [[BlackListRelieveVC alloc]init];
        relieveVC.currentBle = currentBle;
        relieveVC.blacklistBean = _blacklistBean;
        [self.navigationController pushViewController:relieveVC animated:YES];
    }
    if ([self.type isEqualToString:@"5"]) {//创建黑钥匙
        BlackListCreateVC * blackCreateVC = [[BlackListCreateVC alloc]init];
        blackCreateVC.currentBle = currentBle;
        blackCreateVC.blacklistArray = _blacklistArray;
        [self.navigationController pushViewController:blackCreateVC animated:YES];
    }
    if ([self.type isEqualToString:@"6"]) {//创建白钥匙
        WriteListCreateVC * writeCreateVC = [[WriteListCreateVC alloc]init];
        writeCreateVC.currentBle = currentBle;
        [self.navigationController pushViewController:writeCreateVC animated:YES];
    }
    if ([self.type isEqualToString:@"7"]) {//替换锁
        LockReplaceDetailVC * lockReplaceVC = [[LockReplaceDetailVC alloc]init];
        lockReplaceVC.currentBle = currentBle;
        lockReplaceVC.replaceLockBean = _replaceLockBean;
        [self.navigationController pushViewController:lockReplaceVC animated:YES];
    }
    if ([self.type isEqualToString:@"8"]) {//粮库 开关锁
        SwitchLockDateViewController * switchLockVC = [[SwitchLockDateViewController alloc]init];
        switchLockVC.currentBle = currentBle;
        switchLockVC.taskBean = self.taskDateBean;
        [self.navigationController pushViewController: switchLockVC animated:YES];
    }
}

@end
