//
//  MyTaskListCell.m
//  lock
//
//  Created by admin on 2020/5/27.
//  Copyright © 2020 li. All rights reserved.
//

#import "MyTaskListCell.h"

@implementation MyTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCell];
}
- (void)initCell {
    self.backgroundColor = COLOR_BG_VIEW;
    self.bgView.backgroundColor = COLOR_WHITE;
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    self.headerImageV.image = [UIImage imageNamed:@"lock_128"];
    self.nameLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.nameLabel.textColor = COLOR_BLACK;
    self.dateLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.dateLabel.textColor = COLOR_LIST;
    self.timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.timeLabel.textColor = COLOR_LIST;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
