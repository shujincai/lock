//
//  MyTaskViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/25.
//  Copyright © 2020 li. All rights reserved.
//

#import "MyTaskViewController.h"
#import "MyTaskListCell.h"
#import "MyTaskModel.h"
#import "RegistrationKeyViewController.h"

@interface MyTaskViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_WORK_TASK;
    self.pageNumber = 1;
    self.isFirst = YES;
    [self createTableView];
    [self getTaskDatas];
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
        [self getTaskDatas];
    }];
    
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getTaskDatas];
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
    return 70;
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
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.top.equalTo(view.mas_top).offset(5);
        make.right.equalTo(view.mas_right).offset(-10);
        make.height.mas_equalTo(65);
    }];
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = taskList.keyname;
    nameLabel.textColor = COLOR_WHITE;
    nameLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(bgView.mas_top).offset(0);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.height.mas_equalTo(25);
    }];
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel.text = [NSString stringWithFormat:@"%@~%@",[dateFormatter stringFromDate:beginDate],[dateFormatter stringFromDate:endDate]];
    dateLabel.textColor = COLOR_WHITE;
    dateLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    [bgView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = [NSString stringWithFormat:@"%@~%@",[timeFormatter stringFromDate:beginTime],[timeFormatter stringFromDate:endTime]];
    timeLabel.textColor = COLOR_WHITE;
    timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(dateLabel.mas_bottom).offset(0);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.bottom.equalTo(bgView.mas_bottom).offset(0);
    }];
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
    cell.nameLabel.text = listBean.lockname;
    cell.timeLabel.text = listBean.lockno;
    return cell;
}

//获取任务列表

-(void)getTaskDatas{
    if (self.isFirst == YES) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
    }
    MyTaskListRequest * request = [[MyTaskListRequest alloc]init];
    request.page = self.pageNumber;
    request.pagesize = 10;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTaskListBean * taskList = [_listArray objectAtIndex:indexPath.section];
    UnlockListBean * listBean = [taskList.unlocklist objectAtIndex:indexPath.row];
    [self getTaskValid:listBean withTaskList:taskList];
}

//任务ID判断任务是否有效
- (void)getTaskValid:(UnlockListBean *)infoBean withTaskList:(MyTaskListBean *)taskList {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest GET:[NSString stringWithFormat:kTaskValid,infoBean.keydataid] parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
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
            if (response.data == NO) {
                [MBProgressHUD showError:STR_MY_TASK_INVALID];
            }else {
                RegistrationKeyViewController* regLock = [RegistrationKeyViewController new];
                regLock.type = @"2";
                regLock.taskBean = taskList;
                regLock.lockBean = infoBean;
                [self.navigationController pushViewController:regLock animated:YES];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end
