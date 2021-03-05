//
//  BlackListVC.m
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import "BlackListVC.h"
#import "BlackListCell.h"
#import "BlackListModel.h"

@interface BlackListVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,strong)NSMutableArray * checkboxArray;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation BlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = STR_BLACKLIST;
    self.pageNumber = 1;
    self.isFirst = YES;
    [self initLayout];
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBlackList) name:NF_KEY_KEY_RELIEVE_SUCCESS object:nil];
    [self getBlackListdatas];
}
// 更新黑名单
- (void)updateBlackList {
    self.pageNumber = 1;
    [self.checkboxArray removeAllObjects];
    [self getBlackListdatas];
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
- (void)initLayout {
    // 创建黑白钥匙按钮
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"ctl_add_task"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(0, 0, 36, 36);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * addBarItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[addBarItem];
}
// 创建黑白钥匙
- (void)addBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_BE_CAREFUL message:[NSString stringWithFormat:@"%@ \n%@",STR_BLACK_KEY_TIPS,STR_WHITE_KEY_TIPS] preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_BLACK_KEY style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//创建黑钥匙
        if (self.checkboxArray.count <= 0) {
            [MBProgressHUD showMessage:STR_SELECT_LOSS_KEY];
            return;;
        }
        RegistrationKeyViewController * regLock = [RegistrationKeyViewController new];
        regLock.type = @"5";
        regLock.blacklistArray = self.checkboxArray;
        [self.navigationController pushViewController:regLock animated:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:STR_WHITE_KEY style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//创建白钥匙
        RegistrationKeyViewController * regLock = [RegistrationKeyViewController new];
        regLock.type = @"6";
        [self.navigationController pushViewController:regLock animated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
        [self getBlackListdatas];
    }];
    
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getBlackListdatas];
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
    static NSString * reuseIdentifier =  @"BlackListCell";
    BlackListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BlackListCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BlackListBean * blackList = [_listArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@：%@",STR_KEY_NAME,blackList.keyname];
    cell.deptLabel.text = [NSString stringWithFormat:@"%@：%@",STR_DEPT,blackList.deptname];
    cell.userLabel.text = [NSString stringWithFormat:@"%@：%@",STR_OPERATION_USER,blackList.username];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@：%@",STR_BLACKOUT_TIME,blackList.createtime];
    cell.lossBtnBlock = ^{ //解除
        RegistrationKeyViewController * regLock = [RegistrationKeyViewController new];
        regLock.type = @"4";
        regLock.blacklistBean = blackList;
        [self.navigationController pushViewController:regLock animated:YES];
    };
    if ([self.checkboxArray containsObject:blackList.keyno]) {
        [cell.checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
    }else {
        [cell.checkboxBtn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
    }
    cell.checkboxBtnBlock = ^(UIButton * _Nonnull btn) {
        if ([self.checkboxArray containsObject:blackList.keyno]) {
            [btn setImage:[UIImage imageNamed:@"ctl_checkbox_normal"] forState:UIControlStateNormal];
            [self.checkboxArray removeObject:blackList.keyno];
        }else {
            [btn setImage:[UIImage imageNamed:@"ctl_checkbox_select"] forState:UIControlStateNormal];
            [self.checkboxArray addObject:blackList.keyno];
        }
    };
    return cell;
}

#pragma mark 获取黑名单列表

-(void)getBlackListdatas{
    if (self.isFirst == YES) {
        [MBProgressHUD showActivityMessage:STR_LOADING];
    }
    BlackListRequest * request = [[BlackListRequest alloc]init];
    request.page = self.pageNumber;
    request.pagesize = 10;
    request.keytype = 3;
    [MSHTTPRequest GET:kBlackList parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        if (self.pageNumber == 1) {
            [self.listArray removeAllObjects];
        }
        if (self.isFirst == YES) {
            [MBProgressHUD hideHUD];
        }
        NSError * error = nil;
        BlackListResponse * response = [[BlackListResponse alloc]initWithDictionary:responseObject error:&error];
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
