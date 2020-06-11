//
//  NSDate+Calendar.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Calendar)

/**
 *获取当前月的天数
 */
- (NSUInteger)PTBaseNumberOfDaysInCurrentMonth;
/**
 *获取本月第一天
 */
- (NSDate *)PTBaseFirstDayOfCurrentMonth;
//下面这些方法用于获取各种整形的数据
/**
 *确定某天是周几
 */
-(int)PTBaseWeekly;
/**
 *年月日 时分秒
 */
-(int)getYear;
-(int)getMonth;
-(int)getDay;
-(int)getHour;
-(int)getMinute;
-(int)getSecond;

@end

NS_ASSUME_NONNULL_END
