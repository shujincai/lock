//
//  SearchBluetoothView.h
//  blueDemo
//
//  Created by mac on 2020/6/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchBluetoothView : UIView

-(void)start;

-(void)hide;

@property (nonatomic,copy) void(^searchBluetoothBlock)(BOOL type);//false开始 true结束

@end

NS_ASSUME_NONNULL_END
