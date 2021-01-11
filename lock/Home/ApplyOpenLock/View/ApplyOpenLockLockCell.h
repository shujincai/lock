//
//  ApplyOpenLockLockCell.h
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyOpenLockLockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIButton *checkboxBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (nonatomic,copy) void(^checkboxBtnBlock)(UIButton * btn);

@end

NS_ASSUME_NONNULL_END
