//
//  WorkRecordViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/25.
//  Copyright © 2020 li. All rights reserved.
//

#import "WorkRecordViewController.h"
#import "RangeDatePickerCell.h"
#import "FSCalendarExtensions.h"
#import "WorkListViewController.h"

@interface WorkRecordViewController () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate * starDate;
@property (strong, nonatomic) NSDate * endDate;
@property (strong, nonatomic) UILabel * startLabel;
@property (strong, nonatomic) UILabel * endLabel;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation WorkRecordViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = STR_DATE_SELECT;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, UISCREEN_WIDTH, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase|FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    calendar.backgroundColor = COLOR_WHITE;
    [view addSubview:calendar];
    self.calendar = calendar;
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.appearance.headerDateFormat = STR_FORMATTER_YM;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    calendar.locale = locale;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.today = nil;
    [calendar registerClass:[RangeDatePickerCell class] forCellReuseIdentifier:@"cell"];
    
    UIView * centerLine = [[UIView alloc]init];
    centerLine.backgroundColor = COLOR_LINE;
    [view addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.top.equalTo(calendar.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(1, 50));
    }];
    //开始时间
    self.startLabel = [[UILabel alloc]init];
    self.startLabel.textColor = COLOR_BLACK;
    self.startLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.startLabel.backgroundColor = COLOR_WHITE;
    self.startLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.startLabel];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(0);
        make.right.equalTo(centerLine.mas_left).offset(0);
        make.top.equalTo(centerLine.mas_top).offset(0);
        make.height.equalTo(@50);
    }];
    //结束时间
    self.endLabel = [[UILabel alloc]init];
    self.endLabel.textColor = COLOR_BLACK;
    self.endLabel.font = BOLD_SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.endLabel.backgroundColor = COLOR_WHITE;
    self.endLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.endLabel];
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLine.mas_right).offset(0);
        make.right.equalTo(view.mas_right).offset(0);
        make.top.equalTo(centerLine.mas_top).offset(0);
        make.height.equalTo(@50);
    }];
    //查询按钮
    UIButton * queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryBtn setTitle:STR_QUERY forState:UIControlStateNormal];
    [queryBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    queryBtn.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    queryBtn.layer.masksToBounds = YES;
    queryBtn.layer.cornerRadius = 4;
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [queryBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BLUE] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage mm_imageWithColor:COLOR_BLUE] forState:UIControlStateHighlighted];
    [view addSubview:queryBtn];
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(30);
        make.right.equalTo(view.mas_right).offset(-30);
        make.top.equalTo(self.endLabel.mas_bottom).offset(70);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.calendar.accessibilityIdentifier = @"calendar";
    self.starDate = [NSDate date];
    self.endDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:7 toDate:self.starDate options:0];
    [self.calendar selectDate:self.starDate scrollToDate:NO];
    [self.calendar selectDate:self.endDate scrollToDate:NO];
    
    NSDateFormatter * seletFormatter = [[NSDateFormatter alloc] init];
    seletFormatter.dateFormat = STR_FORMATTER_YMD;
    self.startLabel.text = [seletFormatter stringFromDate:self.starDate];
    self.endLabel.text = [seletFormatter stringFromDate:self.endDate];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2019-01-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:10 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangeDatePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.starDate) {
            self.starDate = date;
        } else {
            if (self.endDate) {
                [calendar deselectDate:self.endDate];
            }
            self.endDate = date;
        }
    } else {
        if (self.endDate) {
            [calendar deselectDate:self.starDate];
            [calendar deselectDate:self.endDate];
            self.starDate = date;
            self.endDate = nil;
        } else if (!self.starDate) {
            self.starDate = date;
        } else {
            self.endDate = date;
        }
    }
    
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
    NSDateFormatter * seletFormatter = [[NSDateFormatter alloc] init];
    seletFormatter.dateFormat = STR_FORMATTER_YMD;
    NSComparisonResult result = [self.starDate compare:self.endDate];
    if (result == NSOrderedDescending) {//大于
        self.startLabel.text = [seletFormatter stringFromDate:self.endDate];
        if (self.starDate == nil) {
            self.endLabel.text = STR_SELECT_END_TIME;
        }else {
            self.endLabel.text = [seletFormatter stringFromDate:self.starDate];
        }
        
    }
    else if (result == NSOrderedAscending){//小于
        self.startLabel.text = [seletFormatter stringFromDate:self.starDate];
        if (self.endDate == nil) {
            self.endLabel.text = STR_SELECT_END_TIME;
        }else {
            self.endLabel.text = [seletFormatter stringFromDate:self.endDate];
        }
    }else {//等于
        self.startLabel.text = [seletFormatter stringFromDate:self.starDate];
        if (self.endDate == nil) {
            self.endLabel.text = STR_SELECT_END_TIME;
        }else {
            self.endLabel.text = [seletFormatter stringFromDate:self.endDate];
        }
    }
    
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangeDatePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.starDate && self.endDate) {
        BOOL isMiddle = [date compare:self.starDate] != [date compare:self.endDate];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.starDate && [self.gregorian isDate:date inSameDayAsDate:self.starDate];
    isSelected |= self.endDate && [self.gregorian isDate:date inSameDayAsDate:self.endDate];
    rangeCell.selectionLayer.hidden = !isSelected;
}
//开始查询
- (void)queryBtnClick:(UIButton *)btn {
    if (self.startLabel.text == nil) {
        [MBProgressHUD showWarning:STR_SELECT_START_TIME];
        return;
    }
    if (self.endLabel.text == STR_SELECT_END_TIME) {
        [MBProgressHUD showWarning:STR_SELECT_END_TIME];
        return;
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = STR_FORMATTER_YMD;
    NSDate * startDate = [formatter dateFromString:self.startLabel.text];
    NSDate * endDate = [formatter dateFromString:self.endLabel.text];
    
    WorkListViewController * wrok = [WorkListViewController new];
    wrok.endStr = [self.dateFormatter stringFromDate:endDate];
    wrok.startStr = [self.dateFormatter stringFromDate:startDate];
    [self.navigationController pushViewController:wrok animated:YES];
}
@end

