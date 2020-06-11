//
//  SystemParameterCell.h
//  lock
//
//  Created by 金万码 on 2020/6/10.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemParameterCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UIImageView *goImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
