//
//  RegistrationKeyTableViewCell.m
//  lock
//
//  Created by 李金洋 on 2020/4/3.
//  Copyright © 2020 li. All rights reserved.
//

#import "RegistrationKeyTableViewCell.h"

@implementation RegistrationKeyTableViewCell

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
    [self addSubview:bgView];
    
    self.leftImage = [UIImageView new];
    self.leftImage.frame = CGRectMake(10, 10,30, 30);
    [bgView addSubview:self.leftImage];
    
    self.topLabel = [SZKLabel labelWithFrame:CGRectMake(50, 5, 300, 20) text:@"" textColor:UIColor.blackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    [bgView addSubview:self.topLabel];
    
    self.bottomLabel = [SZKLabel labelWithFrame:CGRectMake(50, 25, 300, 20) text:@"" textColor:UIColor.blackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
       [bgView addSubview:self.bottomLabel];
    
}

@end
