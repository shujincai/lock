//
//  HomeTableViewCell.m
//  lock
//
//  Created by 李金洋 on 2020/3/23.
//  Copyright © 2020 li. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

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
        self.backgroundColor = UIColor.whiteColor;

        [self configSubView];
    }
    return self;
}
-(void)configSubView{
    
    self.backgroundColor = COLOR_HOME_BG;
    
    UIView * bg = [UIView new];
    bg.backgroundColor = UIColor.whiteColor;
    bg.frame = CGRectMake(5, 10, UIScreenWidth-10, 50);
    bg.layer.masksToBounds = YES;
    bg.layer.cornerRadius = 5;
    [self addSubview:bg];
    
    
    
    UIImageView * image = [UIImageView new];
    image.frame = CGRectMake(20,12.5,25, 25);
    image.image = [UIImage imageNamed:@"ic_list_lock"];
    [bg addSubview:image];
    
    self.TopLabel = [SZKLabel labelWithFrame:CGRectMake(65,5,self.frame.size.width,20) text:@"" textColor:UIColor.blackColor    font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    
    self.bottomLabel = [SZKLabel labelWithFrame:CGRectMake(65,25,self.frame.size.width,20) text:@"" textColor:COLOR_LIST    font:SYSTEM_FONT_OF_SIZE(FONT_SIZE_H4) textAlignment:NSTextAlignmentLeft backgroundColor:UIColor.whiteColor];
    
    [bg addSubview:self.TopLabel];
    [bg addSubview:self.bottomLabel];
    
}
@end
