//
//  LockReplaceListCell.m
//  lock
//
//  Created by 金万码 on 2021/2/7.
//  Copyright © 2021 li. All rights reserved.
//

#import "LockReplaceListCell.h"

@implementation LockReplaceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initCell];
}
- (void)initCell {
    self.bottomLine.backgroundColor = COLOR_LINE;
    self.nameLabel.textColor = COLOR_BLACK;
    self.nameLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.deptLabel.textColor = COLOR_LIST;
    self.deptLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    self.statusLabel.textColor = COLOR_LIST;
    self.statusLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    self.timeLabel.textColor = COLOR_LIST;
    self.timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    [self.rightBtn setTitle:STR_REPLACE forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [self.rightBtn setBackgroundColor:COLOR_YELLOW];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 15;
    [self.rightBtn addTarget:self action:@selector(btnClickReplace) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClickReplace{
    self.replaceBtnBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
