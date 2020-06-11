//
//  BaseTableViewCell.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell{
    UIColor *normalColor;
    BOOL clickEnable;
}

-(void)setEnable:(BOOL)enable;
-(void)setNormalColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
