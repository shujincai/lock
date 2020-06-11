//
//  SystemParameterCell.m
//  lock
//
//  Created by 金万码 on 2020/6/10.
//  Copyright © 2020 li. All rights reserved.
//

#import "SystemParameterCell.h"

@implementation SystemParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCell];
}
- (void)initCell {
    self.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.titleLabel.textColor = UIColor.blackColor;
    self.detailLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    self.detailLabel.textColor = COLOR_LIST;
    self.bottomLine.backgroundColor = COLOR_LINE;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
