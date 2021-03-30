//
//  HomeViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeCollectionViewCell.h"
#import "MyTaskViewController.h"
#import "WorkRecordViewController.h"
#import "SystemViewController.h"
#import "HomeModel.h"
#import "MyTaskModel.h"
#import "WorkListModel.h"
#import "ApplyOpenLockListVC.h"
#import "OpenLockAuditListVC.h"
#import "KeyLossListVC.h"
#import "BlackListVC.h"
#import "LockReplaceListVC.h"

static NSString * cellIdentifer = @"HomeCollectionViewCell";

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) UICollectionView * rightCollectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) int data;
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,strong) SZKLabel * leftLabel;
@property (nonatomic,strong) SZKButton * taskBtn;
@property (nonatomic,strong)NSTimer * taskTimer;//任务定时
@property (nonatomic,strong)UserInfo * userInfo;
@property (nonatomic,strong)NSMutableArray * imageArray;
@property (nonatomic,strong)NSMutableArray * titleArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initLayout];
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirst == NO) {
        [self refreshData];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(enterForeground) name:NF_KEY_FOREGROUND object:nil];
    [center addObserver:self selector:@selector(enterBackground) name:NF_KEY_BACKGROUND object:nil];
    if (!_taskTimer.valid) {
        _taskTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NF_KEY_FOREGROUND object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NF_KEY_BACKGROUND object:nil];
    if (_taskTimer.valid) {
        [_taskTimer invalidate];
        _taskTimer = nil;
    }
}
//从后台进入前台 判断是否开启定时器
- (void)enterForeground {
    if (!_taskTimer.valid) {
        _taskTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    }
}
//从前台进入后台 判断是否关闭定时器
- (void)enterBackground {
    if (_taskTimer.valid) {
        [_taskTimer invalidate];
        _taskTimer = nil;
    }
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (void)initData {
    self.userInfo = [CommonUtil getObjectFromUserDefaultWith:[UserInfo class] forKey:@"userInfo"];
    [self.imageArray addObject:[UIImage imageNamed:@"ctl_my_task"]];
    [self.titleArray addObject:STR_MY_TASK];
    [self.imageArray addObject:[UIImage imageNamed:@"ctl_apply_open_lock"]];
    [self.titleArray addObject:STR_APPLY_OPEN_LOCK];
    if ([self.userInfo.ismanager isEqualToString:@"1"]) {
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_open_lock_audit"]];
        [self.titleArray addObject:STR_OPEN_LOCK_AUDIT];
    }
    [self.imageArray addObject:[UIImage imageNamed:@"ctl_work_record"]];
    [self.titleArray addObject:STR_WORK_RECORD];
    if ([self.userInfo.ismanager isEqualToString:@"1"]) {
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_registration_lock"]];
        [self.titleArray addObject:STR_REG_LOCK];
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_registration_key"]];
        [self.titleArray addObject:STR_REG_KEY];
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_key_blacklist"]];
        [self.titleArray addObject:STR_BLACKLIST];
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_key_loss"]];
        [self.titleArray addObject:STR_KEY_LOSS];
        [self.imageArray addObject:[UIImage imageNamed:@"ctl_lock_replace"]];
        [self.titleArray addObject:STR_LOCK_REPLACE];
    }
    [self.imageArray addObject:[UIImage imageNamed:@"ctl_system_parameter"]];
    [self.titleArray addObject:STR_SYSTEM_PARAMETER];
}
- (void)initLayout {
    WS(weakSelf);
    self.isFirst = YES;
    UIView * bgView = [UIView new];
    if ([self.userInfo.ismanager isEqualToString:@"1"]) {
        bgView.frame = CGRectMake(0, 0, UIScreenWidth, 130*4+155);
    }else {
        bgView.frame = CGRectMake(0, 0, UIScreenWidth, 130*2+155);
    }
    UIImageView * image = [UIImageView new];
    image.frame = CGRectMake(0, 0, UIScreenWidth, 150);
    if ([CommonUtil getLockType]) {
        image.image = [UIImage imageNamed:@"lock_background"];
    } else {
        image.image = [UIImage imageNamed:@"vanmalock_background"];
    }
    image.userInteractionEnabled = YES;
    [bgView addSubview:image];
    self.leftLabel = [SZKLabel labelWithFrame:CGRectMake(20, 130, UIScreenWidth/2-20, 15) text:kFetchMyDefault(@"appusername") textColor:UIColor.whiteColor font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.clearColor];
    [image addSubview:self.leftLabel];
    //我的任务
    self.taskBtn = [[SZKButton alloc]initWithFrame:CGRectZero title:@"0" titleColor:COLOR_WHITE titleFont:16 cornerRadius:4 backgroundColor:COLOR_GREEN backgroundImage:NULL image:[UIImage imageNamed:@"ic_lock_white"]];
    self.taskBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [image addSubview:self.taskBtn];
    [self.taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(image);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    [self.taskBtn setClicAction:^(UIButton * _Nonnull sender) {
        MyTaskViewController * myTask = [MyTaskViewController new];
        [weakSelf.navigationController pushViewController:myTask animated:YES];
    }];
    //功能区
    [bgView addSubview:self.rightCollectionView];
    //开锁记录
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
if ([CommonUtil getLockType]) {
    self.tableView.backgroundColor = COLOR_HOME_BG;
} else {
    self.tableView.backgroundColor = COLOR_BG_VIEW;
}
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.mas_equalTo(UISCREEN_WIDTH);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
    }];
    self.tableView.tableHeaderView = bgView;
    
}
-(UICollectionView *)rightCollectionView{
    
    if (!_rightCollectionView) {
        self.automaticallyAdjustsScrollViewInsets = NO;

        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.flowLayout.itemSize = CGSizeMake((UIScreenWidth-30)/3.0,130);
        if ([self.userInfo.ismanager isEqualToString:@"1"]) {
            _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5,155,UIScreenWidth-10,130*4) collectionViewLayout:self.flowLayout];
        }else {
            _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5,155,UIScreenWidth-10,130*2) collectionViewLayout:self.flowLayout];
        }
        
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
if ([CommonUtil getLockType]) {
        _rightCollectionView.backgroundColor = COLOR_HOME_BG;
} else {
        _rightCollectionView.backgroundColor = COLOR_BG_VIEW;
}
        [_rightCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifer];
    }
    return _rightCollectionView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"cell";
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[HomeTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LockRecordListBean * model = self.dataArray[indexPath.row];
    cell.TopLabel.text = model.lockname;
    cell.bottomLabel.text = model.opttime;
    return cell;
}



#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.userInfo.ismanager isEqualToString:@"1"]) {
        return  4;
    }else {
        return 2;
    }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.userInfo.ismanager isEqualToString:@"1"]) {
        if (section == 3) {
            return 1;
        }else {
            return 3;
        }
    }else {
        if (section == 1) {
            return 1;
        }else {
            return 3;
        }
    }
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.image.image = _imageArray[indexPath.section*3+indexPath.item];
    cell.TopLabel.text = _titleArray[indexPath.section*3+indexPath.item];
    if ((indexPath.section*3+indexPath.item) == 0) {
        cell.hub.count = self.data;
    }else {
        cell.hub.count = 0;
    }
     //角标数字
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * titleType = [self.titleArray objectAtIndex:indexPath.section*3+indexPath.item];
    
    if ([titleType isEqualToString:STR_MY_TASK]) {//我的任务
        MyTaskViewController * myTask = [MyTaskViewController new];
        [self.navigationController pushViewController:myTask animated:YES];
    }
    if ([titleType isEqualToString:STR_WORK_RECORD]){//工作记录
        WorkRecordViewController * workRecord = [WorkRecordViewController new];
        [self.navigationController pushViewController:workRecord animated:YES];
    }
    if ([titleType isEqualToString:STR_REG_LOCK]){//注册锁
        RegistrationKeyViewController* regLock = [RegistrationKeyViewController new];
        regLock.type = @"1";
        [self.navigationController pushViewController:regLock animated:YES];
    }
    if ([titleType isEqualToString:STR_REG_KEY]){//注册钥匙
        RegistrationKeyViewController* regKey = [RegistrationKeyViewController new];
        regKey.type = @"0";
        [self.navigationController pushViewController:regKey animated:YES];
    }
    if ([titleType isEqualToString:STR_SYSTEM_PARAMETER]){//系统参数
        SystemViewController* systemVC = [SystemViewController new];
        [self.navigationController pushViewController:systemVC animated:YES];
    }
    if ([titleType isEqualToString:STR_APPLY_OPEN_LOCK]){//申请开锁
        ApplyOpenLockListVC* applyOpenLockVC = [ApplyOpenLockListVC new];
        [self.navigationController pushViewController:applyOpenLockVC animated:YES];
    }
    if ([titleType isEqualToString:STR_OPEN_LOCK_AUDIT]){//开锁审核
        OpenLockAuditListVC* openLockAuditVC = [OpenLockAuditListVC new];
        [self.navigationController pushViewController:openLockAuditVC animated:YES];
    }
    if ([titleType isEqualToString:STR_KEY_LOSS]) { // 钥匙挂失
        KeyLossListVC* keyLossVC = [KeyLossListVC new];
        [self.navigationController pushViewController:keyLossVC animated:YES];
    }
    if ([titleType isEqualToString:STR_BLACKLIST]) { // 黑名单
        BlackListVC* blacklistVC = [BlackListVC new];
        [self.navigationController pushViewController:blacklistVC animated:YES];
    }
    if ([titleType isEqualToString:STR_LOCK_REPLACE]) { // 锁替换
        LockReplaceListVC* lockVReplaceC = [LockReplaceListVC new];
        [self.navigationController pushViewController:lockVReplaceC animated:YES];
    }
}
#pragma mark 查询开关锁记录
-(void)getData{
    [MBProgressHUD showActivityMessage:STR_LOADING];
    LockRecordListRequest * request = [[LockRecordListRequest alloc]init];
    request.begintime =@"2019-02-24";
    request.endtime = [CommonUtil getCurrentTimes];
    request.page = 1;
    request.pagesize = 5;
    [MSHTTPRequest GET:kLockdatas parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        LockRecordListResponse * response = [[LockRecordListResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [self.dataArray addObjectsFromArray:response.data.content];
            [self.tableView reloadData];
            [self getCount];
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:response.msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
#pragma mark 我的任务数量
-(void)getCount{
    MyTaskNumberRequest * request = [[MyTaskNumberRequest alloc]init];
    [MSHTTPRequest GET:kCount parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        self.isFirst = NO;
        MyTaskNumberResponse * response = [[MyTaskNumberResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            self.data = response.data;
            [self.taskBtn setTitle:[NSString stringWithFormat:@"%d",self.data] forState:UIControlStateNormal];
            [self.rightCollectionView reloadData];
        }else {
            [MBProgressHUD showError:response.msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
            
}
//每间隔10秒刷新一次 任务数和工作记录
- (void)refreshData {
    LockRecordListRequest * request = [[LockRecordListRequest alloc]init];
    request.begintime =@"2019-02-24";
    request.endtime = [CommonUtil getCurrentTimes];
    request.page = 1;
    request.pagesize = 5;
    [MSHTTPRequest GET:kLockdatas parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        LockRecordListResponse * response = [[LockRecordListResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:response.data.content];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {

    }];
    MyTaskNumberRequest * taskRequest = [[MyTaskNumberRequest alloc]init];
    [MSHTTPRequest GET:kCount parameters:[taskRequest toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        NSError * error = nil;
        MyTaskNumberResponse * response = [[MyTaskNumberResponse alloc]initWithDictionary:responseObject error:&error];
        if ([response.resultCode intValue] == 0) {
            self.data = response.data;
            [self.taskBtn setTitle:[NSString stringWithFormat:@"%d",self.data] forState:UIControlStateNormal];
            [self.rightCollectionView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}
- (UIView *)listView {
    return self.view;
}

@end
