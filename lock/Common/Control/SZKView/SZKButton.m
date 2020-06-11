//
//  SZKButton.m
//  lock
//
//  Created by 李金洋 on 2020/3/23.
//  Copyright © 2020 li. All rights reserved.
//

#import "SZKButton.h"
@interface SZKButton()


@end
@implementation SZKButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)titlecolor
                   titleFont:(CGFloat)fontsize
                cornerRadius:(CGFloat)radius
             backgroundColor:(UIColor *)backcolor
             backgroundImage:(UIImage *)backgroundimage
                       image:(UIImage *)image
{
    if (self == [super init]) {
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontsize]];
        self.layer.cornerRadius = radius;
        self.clipsToBounds = YES;
        self.backgroundColor = backcolor;
         self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setBackgroundImage:backgroundimage forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setClicAction:(STButtonTouchAction)clicAction
{
    if (clicAction) {
        _clicAction = clicAction;
    }
}
- (void)clicAction:(UIButton*)sender
{
    if (self.clicAction) {
        self.clicAction(sender);
    }
}
@end
