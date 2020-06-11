//
//  WorkListTableViewCell.m
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import "WorkListTableViewCell.h"

@implementation WorkListTableViewCell

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
    bgView.frame = CGRectMake(10, 0, UIScreenWidth-20, 80);
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    
    self.topLabel = [SZKLabel labelWithFrame:CGRectMake(10, 0,bgView.frame.size.width-20, 26) text:@"" textColor:COLOR_BLACK font:[UIFont fontWithName:@"Helvetica-Bold" size:16] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    
     self.middleLabel = [SZKLabel labelWithFrame:CGRectMake(10, 27,bgView.frame.size.width-20, 26) text:@"" textColor:COLOR_LIST font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    
    self.bottomLabel = [SZKLabel labelWithFrame:CGRectMake(10,55,bgView.frame.size.width-20, 26) text:@"" textColor:COLOR_LIST font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    
    [bgView addSubview:self.topLabel];
    [bgView addSubview:self.middleLabel];
    [bgView addSubview:self.bottomLabel];
}
@end
