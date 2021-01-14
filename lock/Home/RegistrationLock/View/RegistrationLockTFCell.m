//
//  RegistrationLockTFCell.m
//  blueDemo
//
//  Created by mac on 2020/6/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "RegistrationLockTFCell.h"

@implementation RegistrationLockTFCell

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
    bgView.frame = CGRectMake(10, 0, UIScreenWidth-20, 50);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:bgView];
    
    self.topLabel = [SZKLabel labelWithFrame:CGRectMake(10,0, 50, 50) text:@"" textColor:UIColor.blackColor font:[UIFont fontWithName:@"Helvetica-Bold" size:16] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    [bgView addSubview:self.topLabel];
    
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = COLOR_RED;
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.bottom.equalTo(bgView.mas_bottom).offset(-5);
        make.height.mas_equalTo(1.5);
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
        make.right.equalTo(bgView.mas_right).offset(0);
        make.bottom.equalTo(bottomLine.mas_top).offset(0);
        make.height.mas_equalTo(40);
    }];
}
@end
