//
//  BlackListCell.m
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import "BlackListCell.h"

@implementation BlackListCell

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
    self.userLabel.textColor = COLOR_LIST;
    self.userLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    self.timeLabel.textColor = COLOR_LIST;
    self.timeLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    [self.rightBtn setTitle:STR_RELIEVE forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [self.rightBtn setBackgroundColor:COLOR_RED];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 15;
    [self.rightBtn addTarget:self action:@selector(btnClickLoss) forControlEvents:UIControlEventTouchUpInside];
    [self.checkboxBtn addTarget:self action:@selector(checkboxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)checkboxBtnClick:(UIButton *)btn {
    self.checkboxBtnBlock(btn);
}
- (void)btnClickLoss {
    self.lossBtnBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
