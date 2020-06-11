//
//  SettingViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/25.
//  Copyright © 2020 li. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property(nonatomic,strong)NSString * erweima;
@property(nonatomic,strong) RJTextField * account;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = STR_SET_ADDRESS;
    WS(weakSelf);
    
    SZKButton * erweima = [[SZKButton alloc]initWithFrame:CGRectZero title:@"" titleColor:UIColor.clearColor titleFont:0 cornerRadius:0 backgroundColor:UIColor.clearColor backgroundImage:[UIImage imageNamed:@"ctl_qr_code"]image:nil];
    
    [erweima setClicAction:^(UIButton * _Nonnull sender) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                weakSelf.account.textField.text = result;
                [weakSelf showInfo:result];
            }
        }];
        [weakSelf.navigationController pushViewController:scanVc animated:YES];
        
    }];
    [self.view addSubview:erweima];
    [erweima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT+20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.account = [[RJTextField alloc]init];
    self.account.placeholder = STR_ADDRESS_PLACEHOLER;
    self.account.textField.text = kFetchMyDefault(@"address");
    [self.view addSubview:self.account];
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT+20);
        make.right.equalTo(erweima.mas_left).offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    
    SZKButton * BCBtn = [[SZKButton alloc]initWithFrame:CGRectZero title:STR_SAVE titleColor:UIColor.whiteColor titleFont:18 cornerRadius:4 backgroundColor:COLOR_BLUE backgroundImage:NULL image:NULL];
    BCBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:BCBtn];
    [BCBtn setClicAction:^(UIButton * _Nonnull sender) {
        
        weakSelf.sendValueBlock(weakSelf.account.textField.text);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [BCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(self.account.mas_bottom).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
}
- (void)showInfo:(NSString*)str {
    //    [self showInfo:str andTitle:@"提示:"];
}
- (void)showInfo:(NSString*)str andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
        action;
    });
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
