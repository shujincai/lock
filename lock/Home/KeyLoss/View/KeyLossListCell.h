//
//  KeyLossListCell.h
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyLossListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,copy) void(^lossBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
