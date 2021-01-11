//
//  ApplyOpenLockDateCell.m
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import "ApplyOpenLockDateCell.h"

@implementation ApplyOpenLockDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCell];
}
- (void)initCell {
    self.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H1);
    self.titleLabel.textColor = COLOR_BLACK;
    self.timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.timeLabel.textColor = COLOR_LINE;
    self.bottomLine.backgroundColor = COLOR_LINE;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
