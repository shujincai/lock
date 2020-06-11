//
//  BaseTableViewController.h
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SetKeyControllerDelegate>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,assign)CGFloat           insetX;//各种屏幕距离屏幕的x值
@property(nonatomic, assign) NSInteger                     page;/**< <##> */
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
