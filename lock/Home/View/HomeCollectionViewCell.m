//
//  HomeCollectionViewCell.m
//  lock
//
//  Created by 李金洋 on 2020/3/24.
//  Copyright © 2020 li. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
    }
    return self;
}
-(void)createView{
    UIView * bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.frame = CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-10);
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    self.image = [UIImageView new];
    self.image.frame = CGRectMake((self.frame.size.width)/2.0-32.5, SYRealValueH(18), 65, 65);
    [bgView addSubview:self.image];
    self.TopLabel = [SZKLabel labelWithFrame:CGRectMake(0,SYRealValueH((18))+66,self.frame.size.width,20) text:@"133" textColor:UIColor.blackColor    font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter backgroundColor:UIColor.whiteColor];
    [bgView addSubview:self.TopLabel];
    //角标
     self.hub = [[RKNotificationHub alloc]initWithView:self.image];
     [self.hub moveCircleByX:-5 Y:5]; // moves the circle five pixels left and 5 down

}
@end
