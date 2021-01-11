//
//  DatePickerView.h
//  Vanmalock
//
//  Created by 金万码 on 2020/12/31.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DatePickerViewMode) {
    
    DatePickerViewDateYearMonthDayHourMinuteSecondMode = 0,//年月日,时分秒
    DatePickerViewDateYearMonthDayHourMinuteMode,//年月日,时分
    DatePickerViewDateYearMonthDayHourMode,//年月日,时
    DatePickerViewDateYearMonthDayMode,//年月日
    DatePickerViewDateYearMonthMode,//年月
    DatePickerViewDateYearMode,//年
    DatePickerViewDateYearMonthDayYearMonthDayMode,//年月日,年月日
    DatePickerViewDateHourMinuteSecondMode,//时分秒
};

NS_ASSUME_NONNULL_BEGIN

@protocol DatePickerViewDelegate <NSObject>
@optional

-(void)didClickFinishDateTimePickerView:(NSString*)date;

@end

@interface DatePickerView : UIView

@property(nonatomic, strong)id<DatePickerViewDelegate>delegate;
/**
 选择模式
 */
@property (nonatomic, assign)DatePickerViewMode pickerViewMode;
/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate*currentDate;
/**
 * 设置结束时间
 */
@property(nonatomic, strong)NSDate*finishDate;
/**
 * 显示
 */
- (void)showDateTimePickerView;
/**
 * 掩藏
 */
- (void)hideDateTimePickerView;
@end

NS_ASSUME_NONNULL_END
