//
//  LockReplaceListVC.m
//  lock
//
//  Created by 金万码 on 2021/2/7.
//  Copyright © 2021 li. All rights reserved.
//

#import "LockReplaceListVC.h"
#import "LockReplaceListCell.h"
#import "KeyLossModel.h"
#import "LockReplaceModel.h"

@interface LockReplaceListVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation LockReplaceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_LOCK_REPLACE;
    self.pageNumber = 1;
    self.isFirst = YES;
    [self createTableView];
    [self getLockdatas];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLockList) name:NF_KEY_LOCK_REPLACE_SUCCESS object:nil];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
// 更新锁列表
- (void)updateLockList {
    self.pageNumber = 1;
    [self getLockdatas];
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
    static NSString * reuseIdentifier =  @"LockReplaceListCell";
    LockReplaceListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LockReplaceListCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LockReplaceListBean * lockList = [_listArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@：%@",STR_KEY_NAME,lockList.lockname];
    cell.deptLabel.text = [NSString stringWithFormat:@"%@：%@",STR_DEPT,lockList.dept.deptname];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@：%@",STR_UPDATE_TIME,lockList.updatetime];
    cell.leftImageV.image = [UIImage imageNamed:@"lock_128"];
    cell.replaceBtnBlock = ^{
        RegistrationKeyViewController * regLock = [RegistrationKeyViewController new];
        regLock.type = @"7";
        regLock.replaceLockBean = lockList;
        [self.navigationController pushViewController:regLock animated:YES];
    };
    if ([lockList.lockstatus isEqualToString:@"0"]) { // 未安装
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",STR_STATUS,STR_NO_INSTALL]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_GREEN range:NSMakeRange(STR_STATUS.length+1, STR_NO_INSTALL.length)];
        cell.statusLabel.attributedText = attributedString;
    }
    if ([lockList.lockstatus isEqualToString:@"1"]) { // 已安装
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",STR_STATUS,STR_ALREADY_INSTALL]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_BLUE range:NSMakeRange(STR_STATUS.length+1, STR_ALREADY_INSTALL.length)];
        cell.statusLabel.attributedText = attributedString;
    }
    if ([lockList.lockstatus isEqualToString:@"2"]) { // 损坏
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",STR_STATUS,STR_DAMAGE]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_RED range:NSMakeRange(STR_STATUS.length+1, STR_DAMAGE.length)];
        cell.statusLabel.attributedText = attributedString;
    }
    if ([lockList.lockstatus isEqualToString:@"3"]) { // 维修
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",STR_STATUS,STR_REPAIR]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_TASK_HEADER_BG range:NSMakeRange(STR_STATUS.length+1, STR_REPAIR.length)];
        cell.statusLabel.attributedText = attributedString;
    }
    return cell;
}

#pragma mark 获取锁列表

-(void)getLockdatas{
    if (self.isFirst == YES) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
    }
    LockReplaceListRequest * request = [[LockReplaceListRequest alloc]init];
    request.page = self.pageNumber;
    request.pagesize = 10;
    [MSHTTPRequest GET:kRegLock parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        if (self.pageNumber == 1) {
            [self.listArray removeAllObjects];
        }
        if (self.isFirst == YES) {
            [MBProgressHUD hideHUD];
        }
        NSError * error = nil;
        LockReplaceListResponse * response = [[LockReplaceListResponse alloc]initWithDictionary:responseObject error:&error];
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
