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

@interface RegistrationKeyViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,SetKeyControllerDelegate>

@property (strong, nonatomic) NSMutableArray *bleArray; //搜索到蓝牙
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
    [SetKeyController initBlueToothManager];
    [SetKeyController setDelegate:self];
}
- (void)returnClick {
    [self.navigationController popViewControllerAnimated:YES];
    //停止蓝牙搜索
    [self.searchBluetoothView hide];
    [SetKeyController stopScan];
}
//当侧滑返回 停止蓝牙搜索
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (parent == nil) {
        [self.searchBluetoothView hide];
        [SetKeyController stopScan];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开始蓝牙搜索
    [self.searchBluetoothView start];
    [SetKeyController startScan];
    if (![SetKeyController sharedManager].delegate){
        [SetKeyController setDelegate:self];
    }
}

- (NSMutableArray *)bleArray {
    if (_bleArray == nil) {
        _bleArray = [NSMutableArray array];
    }
    return _bleArray;
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
    };
}
//初始化蓝牙
- (void)requestInitBleManagerResultInfo:(ResultInfo *)info {
    
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
    CBPeripheral * peripheral = [_bleArray objectAtIndex:indexPath.row];
    cell.topLabel.text =  peripheral.name;
    if (peripheral.state == CBPeripheralStateDisconnected) {//未连接
        cell.bottomLabel.text = STR_NO_CONNECT;
    }
    if (peripheral.state == CBPeripheralStateConnecting) {//连接中
        cell.bottomLabel.text = STR_CONNECTING;
    }
    if (peripheral.state == CBPeripheralStateConnected) {//已连接
        cell.bottomLabel.text = STR_CONNECTED;
    }
    if (peripheral.state == CBPeripheralStateDisconnecting) {//断开中
        cell.bottomLabel.text = STR_DISCONNECTING;
    }
    NSString *str = [[(CBPeripheral *)self.bleArray[[indexPath row]] name] substringToIndex:4];//str3 = "this"
    if ([str isEqualToString:@"B030"] || [str isEqualToString:@"rayonicskey"]) {
        cell.leftImage.image = [UIImage imageNamed:@"ic_list_key"];
    }else{
        cell.leftImage.image = [UIImage imageNamed:@"ic_list_bluetooth"];
        
    }
//    if (_taskBean) {
//        for (UserKeyInfoList * keyList in _taskBean.keylist) {
//            if ([keyList.bleflag isEqualToString:peripheral.name]) {
//                cell.rightImage.image = [UIImage imageNamed:@"ic_lock_open"];
//                break;
//            }
//        }
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (void)scanedPeripheral:(CBPeripheral *)peripheral{
    if ([peripheral.name rangeOfString:@"B030"].location != NSNotFound||[peripheral.name rangeOfString:@"rayonicskey"].location != NSNotFound) {
        if (![_bleArray containsObject:peripheral]){
            [_bleArray addObject:peripheral];
        }
        [self.tableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    CBPeripheral * currentBle = [_bleArray objectAtIndex:indexPath.row];
    [self.searchBluetoothView hide];
    [SetKeyController stopScan];
    if ([self.type isEqualToString:@"0"]) {//注册钥匙
        ConnectKeyViewController * connectKey = [[ConnectKeyViewController alloc]init];
        connectKey.currentBle = currentBle;
        [self.navigationController pushViewController: connectKey animated:YES];
    }
    if ([self.type isEqualToString:@"1"]) {//注册锁
        RegistrationLockVC * lockVC = [[RegistrationLockVC alloc]init];
        lockVC.currentBle = currentBle;
        [self.navigationController pushViewController: lockVC animated:YES];
    }
    if ([self.type isEqualToString:@"2"]) {//我的任务 开关锁
//        for (UserKeyInfoList * keyList in _taskBean.keylist) {
//            if ([keyList.bleflag isEqualToString:currentBle.name]) {
//                self.taskBean.keyno = keyList.keyno;
//                self.taskBean.keyid = keyList.keyid;
//                break;
//            }
//        }
        SwitchLockViewController * switchLockVC = [[SwitchLockViewController alloc]init];
        switchLockVC.currentBle = currentBle;
        switchLockVC.taskBean = self.taskBean;
        switchLockVC.lockBean = self.lockBean;
        [self.navigationController pushViewController: switchLockVC animated:YES];
    }
}

@end
