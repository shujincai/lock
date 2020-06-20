//
//  SystemViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/27.
//  Copyright © 2020 li. All rights reserved.
//

#import "SystemViewController.h"
#import "SystemParameterCell.h"
#import "LogInViewController.h"
#import "ChangePasswordVC.h"

@interface SystemViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_SYSTEM_PARAMETER;
    [self createTableView];
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG_VIEW;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_AREA_HEIGHT);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, UIScreenWidth, 150);
    self.tableView.tableFooterView = headerView;
    
    SZKButton * buton = [[SZKButton alloc]initWithFrame:CGRectMake(20, 40, UIScreenWidth-40, 40) title:STR_QUIT titleColor:UIColor.whiteColor titleFont:18 cornerRadius:5 backgroundColor:COLOR_BLUE backgroundImage:nil image:nil];
    buton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [headerView addSubview:buton];
    [buton setClicAction:^(UIButton * _Nonnull sender) {//退出
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:STR_BE_CAREFUL message:STR_DEFINE_QUIT preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:STR_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:STR_DEFINE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exitAccount];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier =  @"SystemParameterCell";
    
    SystemParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SystemParameterCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {//设备号码
        cell.headerImageV.image = [UIImage imageNamed:@"ic_set_device"];
        cell.titleLabel.text = STR_DEVICE_NUMBER;
        cell.detailLabel.text = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }else  if (indexPath.row == 1) {//服务器地址
        cell.headerImageV.image = [UIImage imageNamed:@"ic_set_address"];
        cell.titleLabel.text = STR_SERVER_ADDRESS;
        cell.detailLabel.text = kFetchMyDefault(@"address");
    }else  if (indexPath.row == 2) {//版本号
        cell.headerImageV.image = [UIImage imageNamed:@"ic_set_version"];
        cell.titleLabel.text = STR_VERSION_NUMBER;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        cell.detailLabel.text = [NSString stringWithFormat:@"V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }else  if (indexPath.row == 3) {//修改密码
        cell.headerImageV.image = [UIImage imageNamed:@"ic_set_password"];
        cell.titleLabel.text = STR_CHANGE_PASSWORD;
        cell.detailLabel.text = STR_CLICK_CHANGE;
        cell.goImageV.image = [UIImage imageNamed:@"ctl_go"];
        [cell setEnable:YES];
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {//修改密码
        ChangePasswordVC * changePasswordVC = [[ChangePasswordVC alloc]init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }
}
//退出账号
- (void)exitAccount {
    [MBProgressHUD showActivityMessage:STR_LOADING];
    RequestBean * request = [[RequestBean alloc]init];
    [MSHTTPRequest requestWithMethod:MSRequestMethodDELETE url:kLogin parameters:[request toDictionary] cachePolicy:MSCachePolicyOnlyNetNoCache success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        NSError * error = nil;
        ResponseBean * response = [[ResponseBean alloc]initWithDictionary:responseObject error:&error];
        if (error) {
            [MBProgressHUD showError:STR_PARSE_FAILURE];
            return ;
        }
        if ([response.resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:STR_QUIT_SUCCESS];
            [CommonUtil removeObjectFromUserDefaultWith:@"token"];
            [CommonUtil removeObjectFromUserDefaultWith:@"userInfo"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LogInViewController * loginViewController=[[LogInViewController alloc] init];
                BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:loginViewController];
                self.view.window.rootViewController=nav;
            });
        }else {
            [MBProgressHUD showError:response.msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:STR_TIMEOUT];
    }];
}
@end
