//
//  ApplyOpenLockSubjectCell.m
//  lock
//
//  Created by 金万码 on 2021/9/16.
//  Copyright © 2021 li. All rights reserved.
//

#import "ApplyOpenLockSubjectCell.h"

@implementation ApplyOpenLockSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configSubView];
    }
    return self;
}
-(void)configSubView{
    self.backgroundColor = COLOR_BG_VIEW;
    
    UIView * bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, UIScreenWidth, 60);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    self.topLabel = [SZKLabel labelWithFrame:CGRectMake(20,0, 50, 60) text:@"" textColor:UIColor.blackColor font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    [bgView addSubview:self.topLabel];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = COLOR_LINE;
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.right.equalTo(bgView.mas_right).offset(0);
        make.bottom.equalTo(bgView.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.textField = [UITextField new];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textColor = COLOR_BLACK;
    self.textField.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.placeholder = STR_LOCK_NAME_TIPS;
    [bgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.bottom.equalTo(bottomLine.mas_top).offset(0);
        make.height.mas_equalTo(60);
    }];
}
@end
