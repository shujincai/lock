//
//  ApplyOpenLockLockCell.m
//  Vanmalock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import "ApplyOpenLockLockCell.h"

@implementation ApplyOpenLockLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCell];
}
- (void)initCell {
    self.nameLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H1);
    self.nameLabel.textColor = COLOR_BLACK;
    self.bottomLine.backgroundColor = COLOR_LINE;
    self.leftImageV.image = [UIImage imageNamed:@"ic_list_lock"];
    [self.checkboxBtn addTarget:self action:@selector(checkboxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)checkboxBtnClick:(UIButton *)btn {
    self.checkboxBtnBlock(btn);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
