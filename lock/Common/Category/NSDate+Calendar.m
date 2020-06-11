//
//  NSDate+Calendar.m
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "NSDate+Calendar.h"

@implementation NSDate (Calendar)

- (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    return calendar;
}

-(NSUInteger)PTBaseNumberOfDaysInCurrentMonth{
    return [[self calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}
- (NSDate *)PTBaseFirstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[self calendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}
-(int)PTBaseWeekly{
    return (int)[[self calendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



-(int)getYear{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.year;
}
-(int)getMonth{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.month;
}
-(int)getDay{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.day;
}
-(int)getHour{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.hour;
}
-(int)getMinute{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.minute;
}
-(int)getSecond{
    NSCalendar *calendar = [self calendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.second;
}
@end
