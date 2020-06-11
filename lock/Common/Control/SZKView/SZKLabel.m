//
//  SZKLabel.m
//  lock
//
//  Created by 李金洋 on 2020/3/23.
//  Copyright © 2020 li. All rights reserved.
//

#import "SZKLabel.h"

@implementation SZKLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)labelWithFrame:(CGRect)frame
                         text:(NSString *)text
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                textAlignment:(NSTextAlignment)textAlignment
              backgroundColor:(UIColor *)bgColor
{
    SZKLabel *szkLabel=[[SZKLabel alloc]initWithFrame:frame];
    szkLabel.text=text;
    szkLabel.textColor=textColor;
    szkLabel.font=font;
    szkLabel.textAlignment=textAlignment;
    szkLabel.backgroundColor=bgColor;
    return szkLabel;
}
@end
