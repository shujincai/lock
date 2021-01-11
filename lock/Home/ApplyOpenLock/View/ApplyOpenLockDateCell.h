//
//  ApplyOpenLockDateCell.h
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyOpenLockDateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

NS_ASSUME_NONNULL_END
