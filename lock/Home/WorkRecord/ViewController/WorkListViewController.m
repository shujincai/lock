//
//  WorkListViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import "WorkListViewController.h"
#import "WorkListTableViewCell.h"
#import "WorkListModel.h"

@interface WorkListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation WorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_OPEN_CLOSE_LOCK_RECORD;
    self.pageNumber = 1;
    self.isFirst = YES;
    [self createTableView];
    [self getLockdatas];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
    WS(weakSelf);
    //设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [self getLockdatas];
    }];
    
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getLockdatas];
    }];
    self.tableView.mj_footer.hidden = YES;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_abnormal_no_notice"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2),
                                 NSForegroundColorAttributeName: COLOR_BLACK};
    return [[NSAttributedString alloc] initWithString:STR_NO_DATA attributes:attributes];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 5;//设置尾视图高度为0.01
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"cell";
    WorkListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[WorkListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    LockRecordListBean * model = _listArray[indexPath.row];
    cell.topLabel.text = model.lockname;
    
    if ([model.eventtype isEqualToString:@"1"]) {//关锁成功
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_CLOSE_LOCK_SUCCESS];
    }else if ([model.eventtype isEqualToString:@"0"]) {//开锁成功
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_OPEN_LOCK_SUCCESS];
    }else  if (model.eventtype.integerValue == 2){//设置成功
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_SETTING_SUCCESS];
    }else  if (model.eventtype.integerValue == 3){//设置失败
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_SETTING_FAIL];
    }else  if (model.eventtype.integerValue == 4){//超出有效期
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_OVERSTEP_TERM_VALIDITY];
    }else  if (model.eventtype.integerValue == 5){//没有权限
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_NO_POWER];
    }else  if (model.eventtype.integerValue == 6){//超出时间范围
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_OVERSTEP_TIME_RANGE];
    }else  if (model.eventtype.integerValue == 8){//黑名单钥匙
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_BLACKLIST_KEY];
    }else  if (model.eventtype.integerValue == 13){//蓝牙钥匙开锁成功
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_BLUETOOTH_OPEN_LOCK_SUCCESS];
    }else  if (model.eventtype.integerValue == 14){//蓝牙钥匙关锁成功
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_BLUETOOTH_CLOSE_LOCK_SUCCESS];
    }else  if (model.eventtype.integerValue == 19){//密码不匹配
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_PASSWORD_MISMATCH];
    }else  if (model.eventtype.integerValue == 20){//操作中断
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_OPERAT_DISTURBANCE];
    }else  if (model.eventtype.integerValue == 21){//钥匙与锁密钥匹配失败
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_BLUETOOTH_CLOSE_LOCK_SUCCESS];
    }else  if (model.eventtype.integerValue == 255){//黑名单钥匙
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_BLACKLIST_KEY];
    }else  if (model.eventtype.integerValue == 254){//验证失败 国内外
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@      %@",model.opttime,STR_VALIDATION_FAILED];
    }else {
        cell.bottomLabel.text =   [NSString stringWithFormat:@"%@",model.opttime];
    }
    cell.middleLabel.text = model.keyname;
    return cell;
}

#pragma mark获取开关锁记录

-(void)getLockdatas{
    if (self.isFirst == YES) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
    }
    LockRecordListRequest * request = [[LockRecordListRequest alloc]init];
    request.begintime = self.startStr;
    request.endtime = self.endStr;
    request.page = self.pageNumber;
    request.pagesize = 10;
    [MSHTTPRequest GET:kLockdatas parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        if (self.pageNumber == 1) {
            [self.listArray removeAllObjects];
        }
        if (self.isFirst == YES) {
            [MBProgressHUD hideHUD];
        }
        NSError * error = nil;
        LockRecordListResponse * response = [[LockRecordListResponse alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showMessage:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] != 0) {
            [MBProgressHUD showError:response.msg];
            return ;
        }else {
            self.isFirst = NO;
            if (response.data.content.count > 0) {
                self.tableView.mj_footer.hidden = NO;
            }else {
                self.tableView.mj_footer.hidden = YES;
            }
            if (self.pageNumber == 1) {
                self.pageNumber++;
                [self.tableView.mj_header endRefreshing];
                if (response.data.totalcount <= self.listArray.count+10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
            }else {
                if (response.data.totalcount <= self.listArray.count+10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                    self.pageNumber++;
                }
            }
            [self.listArray addObjectsFromArray:response.data.content];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.isFirst == YES) {
            [MBProgressHUD hideHUD];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
    
}


@end
