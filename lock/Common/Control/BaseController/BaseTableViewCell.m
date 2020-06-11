//
//  BaseTableViewCell.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    normalColor = COLOR_WHITE;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(!clickEnable){
        self.backgroundColor = normalColor;
        return;
    }
    
    if(highlighted){
        self.backgroundColor = COLOR_ROW_HIGHLIGHT;
    }else{
        self.backgroundColor = normalColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(!clickEnable){
        self.backgroundColor = normalColor;
        return;
    }
    
    if(selected){
        self.backgroundColor = COLOR_ROW_HIGHLIGHT;
        [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1];
    }else{
        self.backgroundColor = normalColor;
    }
}

-(void)setEnable:(BOOL)enable{
    clickEnable = enable;
}

- (void) deselect{
    [self setSelected:NO];
}

-(void)setNormalColor:(UIColor*)color{
    normalColor = color;
}

@end
