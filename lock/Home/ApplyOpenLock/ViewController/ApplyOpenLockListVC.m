//
//  ApplyOpenLockListVC.m
//  lock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import "ApplyOpenLockListVC.h"
#import "MyTaskListCell.h"
#import "MyTaskModel.h"
#import "ApplyOpenLockDetailVC.h"

@interface ApplyOpenLockListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,strong)NSMutableArray * deleteArray;

@end

@implementation ApplyOpenLockListVC

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
- (NSMutableArray *)deleteArray {
    if (_deleteArray == nil) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
- (void)initData {
    [self setTitle:STR_APPLY_OPEN_LOCK];
    self.pageNumber = 1;
    self.isFirst = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateApplyTaskDatas) name:NF_KEY_APPLY_OPEN_LOCK_SUCCESS object:nil];
    [self getApplyTaskDatas];
}
// 更新
- (void)updateApplyTaskDatas {
    self.pageNumber = 1;
    [self.deleteArray removeAllObjects];
    [self getApplyTaskDatas];
}
- (void)initLayout {
    // 创建任务按钮
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"ctl_add_task"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(0, 0, 36, 36);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * addBarItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    // 删除任务按钮
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"ctl_delete_task"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(0, 0, 36, 36);
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * deleteBarItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItems = @[addBarItem,deleteBarItem];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
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
        [self.deleteArray removeAllObjects];
        [self getApplyTaskDatas];
    }];
    
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getApplyTaskDatas];
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
    return 55;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyTaskListBean * listBean = [_listArray objectAtIndex:section];
    return listBean.unlocklist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;//设置尾视图高度为0.01
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyTaskListBean * taskList = [_listArray objectAtIndex:section];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * beginDate = [formatter dateFromString:taskList.begindate];
    NSDate * endDate = [formatter dateFromString:taskList.enddate];
    NSDate * beginTime = [formatter dateFromString:taskList.begintime];
    NSDate * endTime = [formatter dateFromString:taskList.endtime];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    
    UIView * view = [UIView new];
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = COLOR_TASK_HEADER_BG;
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    bgView.tag = [taskList.taskid intValue] + 3000;
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.top.equalTo(view.mas_top).offset(5);
        make.right.equalTo(view.mas_right).offset(-10);
        make.height.mas_equalTo(80);
    }];
    UIButton * checkboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.deleteArray containsObject:taskList.taskid]) {
        [checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
    }else {
        [checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
    }
    [checkboxBtn addTarget:self action:@selector(checkboxBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    checkboxBtn.tag = [taskList.taskid intValue];
    [bgView addSubview:checkboxBtn];
    [checkboxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.centerY.equalTo(bgView.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    UILabel * statusLabel = [[UILabel alloc]init];
    if ([taskList.approved isEqualToString:@"0"]) {
        statusLabel.text = STR_PENDING_APPROVAL;
        statusLabel.textColor = COLOR_YELLOW;
    }else {
        statusLabel.text = STR_REJECTED;
        statusLabel.textColor = COLOR_RED;
    }
    statusLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H1);
    [bgView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(checkboxBtn.mas_left).offset(-10);
        make.centerY.equalTo(bgView.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    NSMutableArray * nameArray = [NSMutableArray new];
    for (UserKeyInfoList * keyInfo in taskList.keylist) {
        [nameArray addObject:keyInfo.keyname];
    }
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = [nameArray componentsJoinedByString:@","];
    nameLabel.textColor = COLOR_WHITE;
    nameLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H1);
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(bgView.mas_top).offset(5);
        make.right.equalTo(statusLabel.mas_left).offset(-10);
        make.height.mas_equalTo(25);
    }];
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel.text = [NSString stringWithFormat:@"%@~%@",[dateFormatter stringFromDate:beginDate],[dateFormatter stringFromDate:endDate]];
    dateLabel.textColor = COLOR_WHITE;
    dateLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    [bgView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.right.equalTo(statusLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = [NSString stringWithFormat:@"%@~%@",[timeFormatter stringFromDate:beginTime],[timeFormatter stringFromDate:endTime]];
    timeLabel.textColor = COLOR_WHITE;
    timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(dateLabel.mas_bottom).offset(0);
        make.right.equalTo(statusLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(changeOpenlockTask:)];
    longPress.minimumPressDuration = 1;
    [bgView addGestureRecognizer:longPress];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"MyTaskListCell";
    MyTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyTaskListCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyTaskListBean * taskList = [_listArray objectAtIndex:indexPath.section];
    UnlockListBean * listBean = [taskList.unlocklist objectAtIndex:indexPath.row];
    cell.nameLabel.text = listBean.deptname;
    cell.timeLabel.text = listBean.lockno;
    return cell;
}
// 修改审核任务
- (void)changeOpenlockTask:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSInteger taskid = longPress.view.tag-3000;
        for (MyTaskListBean * taskList in self.listArray) {
            if ([taskList.taskid isEqualToString:[NSString stringWithFormat:@"%ld",taskid]]) {
                ApplyOpenLockDetailVC * applyDetailVC = [[ApplyOpenLockDetailVC alloc]init];
                applyDetailVC.taskBean = taskList;
                [self.navigationController pushViewController:applyDetailVC animated:YES];
                break;;
            }
        }
    }
    
}
// 创建审核任务
- (void)addBtnClick {
    RegistrationKeyViewController * bluetoothVC = [[RegistrationKeyViewController alloc]init];
    bluetoothVC.type = @"3";
    [self.navigationController pushViewController:bluetoothVC animated:YES];
}
// 删除任务
- (void)deleteBtnClick {
    if (_deleteArray.count <= 0) {
        [MBProgressHUD showMessage:STR_PLEASE_SELECT_DELETE_OPEN_LOCK];
        return ;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_BE_CAREFUL message:STR_SURE_DELETE_OPEN_LOCK preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
        RequestBean * request = [[RequestBean alloc]init];
        [MSHTTPRequest DELETE:[NSString stringWithFormat:kTaskValid,[self.deleteArray componentsJoinedByString:@","]] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
            [MBProgressHUD hideHUD];
            NSError * error = nil;
            MyTaskValidResponse * response = [[MyTaskValidResponse alloc]initWithDictionary:responseObject error:&error];
            if (error) {
                [MBProgressHUD showMessage:STR_PARSE_FAILURE];
                return ;
            }
            if ([response.resultCode intValue] != 0) {
                [MBProgressHUD showError:response.msg];
                return ;
            }else {
                [MBProgressHUD showMessage:STR_DELETE_SUCCESS];
                NSMutableArray * deleteTaskArr = [NSMutableArray new];
                for (MyTaskListBean * listBean in self.listArray) {
                    if ([self.deleteArray containsObject:listBean.taskid]) {
                        [deleteTaskArr addObject:listBean];
                    }
                }
                for (MyTaskListBean * deleteBean in deleteTaskArr) {
                    [self.listArray removeObject:deleteBean];
                }
                if (self.listArray.count > 0) {
                    self.tableView.mj_footer.hidden = NO;
                }else {
                    self.tableView.mj_footer.hidden = YES;
                }
                [self.deleteArray removeAllObjects];
                [self.tableView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:STR_TIMEOUT];
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
// 任务复选框
- (void)checkboxBtnBtnClick:(UIButton *)btn {
    if ([self.deleteArray containsObject:[NSString stringWithFormat:@"%ld",btn.tag]]) {
        [btn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
        [self.deleteArray removeObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    }else {
        [btn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
        [self.deleteArray addObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
}

#pragma mark 获取状态为0或2的任务

-(void)getApplyTaskDatas{
    if (self.isFirst == YES) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
    }
    MyTaskListRequest * request = [[MyTaskListRequest alloc]init];
    request.page = self.pageNumber;
    request.pagesize = 10;
    request.approved = @"0,2";
    [MSHTTPRequest GET:kTaskList parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        if (self.pageNumber == 1) {
            [self.listArray removeAllObjects];
        }
        if (self.isFirst == YES) {
            [MBProgressHUD hideHUD];
        }
        NSError * error = nil;
        MyTaskListResponse * response = [[MyTaskListResponse alloc]initWithDictionary:responseObject error:&error];
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
            //判断时间段选择距离当前时间最近的，且未发生的
            NSDate * date = [NSDate date];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDate * nowDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
            NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"HH:mm:ss";
            NSDate * nowTime = [timeFormatter dateFromString:[timeFormatter stringFromDate:date]];
            
            for (MyTaskListBean * taskList in response.data.content) {
                NSDate * benginDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[formatter dateFromString:taskList.begindate]]];
                NSDate * finishDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[formatter dateFromString:taskList.enddate]]];
                // 判断当前日期是否超出日期范围
                if (([nowDate compare:benginDate] == NSOrderedSame||[nowDate compare:benginDate] == NSOrderedDescending)&&([nowDate compare:finishDate] == NSOrderedSame||[nowDate compare:finishDate] == NSOrderedAscending)) {
                    benginDate = nowDate;
                    finishDate = nowDate;
                }
                NSString * startTime = @"";
                NSString * endTime = @"";
                NSInteger currentInterval= 0;
                for (MyTaskTimeRangeListBean * timeList in taskList.timerangelist) {
                    NSDate * startDate = [timeFormatter dateFromString:[timeFormatter stringFromDate:[formatter dateFromString:timeList.begintime]]];
                    NSDate * endDate = [timeFormatter dateFromString:[timeFormatter stringFromDate:[formatter dateFromString:timeList.endtime]]];
                    //当前时间是否在时间段内。
                    if (([nowTime compare:startDate] == NSOrderedSame||[nowTime compare:startDate] == NSOrderedDescending)&&([nowTime compare:endDate] == NSOrderedSame||[nowTime compare:endDate] == NSOrderedAscending)) {
                        startTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:benginDate],[timeFormatter stringFromDate:startDate]];
                        endTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:finishDate],[timeFormatter stringFromDate:endDate]];
                        break;
                    } else {
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        //两时间间隔秒数
                        NSDateComponents * comp = [calendar components:NSCalendarUnitSecond fromDate:nowTime toDate:startDate options:NSCalendarWrapComponents];
                        if (comp.second < 0) {//开始时间在当前时间之前
                            if (currentInterval == 0) {
                                startTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:benginDate],[timeFormatter stringFromDate:startDate]];
                                endTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:finishDate],[timeFormatter stringFromDate:endDate]];
                            }
                        }else {
                            //判断距离当前时间最近的开始时间
                            if (comp.second <= currentInterval || currentInterval == 0) {
                                currentInterval = comp.second;
                                startTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:benginDate],[timeFormatter stringFromDate:startDate]];
                                endTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:finishDate],[timeFormatter stringFromDate:endDate]];
                            }
                        }
                    }
                }
                taskList.begindatetime = startTime;
                taskList.begintime = startTime;
                taskList.enddatetime = endTime;
                taskList.endtime = endTime;
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
