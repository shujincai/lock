//
//  ConnectKeyTableViewCell.m
//  lock
//
//  Created by 李金洋 on 2020/4/7.
//  Copyright © 2020 li. All rights reserved.
//

#import "ConnectKeyTableViewCell.h"

@implementation ConnectKeyTableViewCell

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
     bgView.frame = CGRectMake(10, 0, UIScreenWidth-20, 40);
     bgView.backgroundColor = [UIColor whiteColor];
     bgView.layer.masksToBounds = YES;
     bgView.layer.cornerRadius = 5;
     [self addSubview:bgView];
    
     self.topLabel = [SZKLabel labelWithFrame:CGRectMake(10,0, 300, 40) text:@"" textColor:UIColor.blackColor font:[UIFont fontWithName:@"Helvetica-Bold" size:16] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
     [bgView addSubview:self.topLabel];
}
@end
