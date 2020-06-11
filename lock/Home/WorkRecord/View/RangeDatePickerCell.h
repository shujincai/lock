//
//  RangeDatePickerCell.h
//  lock
//
//  Created by 金万码 on 2020/6/6.
//  Copyright © 2020 li. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

NS_ASSUME_NONNULL_BEGIN

@interface RangeDatePickerCell : FSCalendarCell

@property (weak, nonatomic) CALayer *selectionLayer;//开始 结束 样式
@property (weak, nonatomic) CALayer *middleLayer;//中间样式

@end

NS_ASSUME_NONNULL_END
