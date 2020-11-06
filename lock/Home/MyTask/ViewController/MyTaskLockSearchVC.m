//
//  MyTaskLockSearchVC.m
//  lock
//
//  Created by 金万码 on 2020/11/5.
//  Copyright © 2020 li. All rights reserved.
//

#import "MyTaskLockSearchVC.h"
#import "MyTaskModel.h"
#import "SwitchLockListCell.h"
#import "RegistrationKeyViewController.h"

@interface MyTaskLockSearchVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UITextField  * searchTF;
@property (nonatomic,strong)NSMutableArray * listArray;

@end

@implementation MyTaskLockSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)initData {
    [self setTitle:@"锁列表"];
    [self.listArray addObjectsFromArray:_taskBean.unlocklist];
    [self initLayout];
    [self createTableView];
}
- (void)initLayout {
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 60, UISCREEN_WIDTH-80, 44);
    searchBar.layer.cornerRadius = 17;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"请输入锁名称";
    searchBar.translucent = YES;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    //改变占位符的字体大小颜色
    searchBar.searchTextField.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    searchBar.searchTextField.backgroundColor = COLOR_BG_VIEW;
    searchBar.searchTextField.textColor = COLOR_BLACK;
    _searchTF = searchBar.searchTextField;
    self.navigationItem.titleView = searchBar;
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
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2),
                                 NSForegroundColorAttributeName: COLOR_BLACK};
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:attributes];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseIdentifier =  @"SwitchLockListCell";
    SwitchLockListCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SwitchLockListCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UnlockListBean * listBean = [_listArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = listBean.lockname;
    cell.timeLabel.text = listBean.lockno;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return 0.00001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UnlockListBean * listBean = [_listArray objectAtIndex:indexPath.row];
    RegistrationKeyViewController* regLock = [RegistrationKeyViewController new];
    regLock.type = @"2";
    regLock.taskBean = _taskBean;
    regLock.lockBean = listBean;
    [self.navigationController pushViewController:regLock animated:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchTF resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_searchTF.text.length > 0) {
        NSMutableArray * array = [NSMutableArray new];
        for (UnlockListBean * lockBean in _taskBean.unlocklist) {
            if ([lockBean.lockname rangeOfString:_searchTF.text].location != NSNotFound) {
                [array addObject:lockBean];
            }
        }
        if (array.count > 0) {
            [_listArray replaceObjectsInRange:NSMakeRange(0, _listArray.count) withObjectsFromArray:array];
        }
        [self.tableView reloadData];
    }else {
        [_listArray replaceObjectsInRange:NSMakeRange(0, _listArray.count) withObjectsFromArray:_taskBean.unlocklist];
        [self.tableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchTF resignFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
