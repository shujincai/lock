//
//  DatePickerView.m
//  Vanmalock
//
//  Created by 金万码 on 2020/12/31.
//  Copyright © 2020 li. All rights reserved.
//

#import "DatePickerView.h"

#import "DatePickerView.h"

@interface DatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate> {
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    
    NSInteger dayFinishRange;
    NSInteger selectedFinishYear;
    NSInteger selectedFinishMonth;
    NSInteger selectedFinishDay;
    NSInteger selectedFinishHour;
    NSInteger selectedFinishMinute;
    NSInteger selectedFinishSecond;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
}

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSString *string;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UILabel * titleLabel;
@end

@implementation DatePickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (void)initLayout {
    self.backgroundColor = COLOR_COVER;
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = COLOR_WHITE;
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(200);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(250);
    }];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.bottomView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(210);
    }];
    
    //左边的取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = COLOR_WHITE;
    cancelButton.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    [cancelButton setTitleColor:COLOR_GROY forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 1.0;
    cancelButton.layer.borderColor = [COLOR_LINE CGColor];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 2;
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(10);
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    //右边的确定按钮
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.backgroundColor = COLOR_BLUE;
    chooseButton.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    [chooseButton setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    chooseButton.layer.masksToBounds = YES;
    chooseButton.layer.cornerRadius = 2;
    [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chooseButton];
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = COLOR_BLACK;
    self.titleLabel.font = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.left.equalTo(cancelButton.mas_right).offset(10);
        make.right.equalTo(chooseButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];

    NSDate * date = [NSDate date];
    NSInteger year = [date getYear];
    startYear=year-100;
    yearRange=200;
}
//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:currentDate== nil ? [NSDate date] : currentDate];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    selectedSecond =second;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
        
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        
        
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:year-startYear inComponent:3 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:4 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:3];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:4];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:5];
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        [self.pickerView selectRow:second inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
        [self pickerView:self.pickerView didSelectRow:second inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
    }
    [self.pickerView reloadAllComponents];
}
//默认时间的处理
-(void)setFinishDate:(NSDate *)finishDate
{
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:finishDate== nil ? [NSDate date] : finishDate];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedFinishYear=year;
    selectedFinishMonth=month;
    selectedFinishDay=day;
    selectedFinishHour=hour;
    selectedFinishMinute=minute;
    selectedFinishSecond =second;
    
    dayFinishRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        [self.pickerView selectRow:year-startYear inComponent:3 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:4 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:3];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:4];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:5];
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 选择对应月份的天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        return 5;
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        return 6;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        return 4;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        return 3;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        return 2;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        return 1;
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        return 6;
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        return 6;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            case 5:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return yearRange;
            }
                break;
            case 4:
            {
                return 12;
            }
                break;
                
            case 5:
            {
                return dayFinishRange;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
            case 2:
            {
                return 60;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            case 5:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:15.0];
    label.textAlignment=NSTextAlignmentCenter;
    
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 4:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 5:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
            case 3:
            {
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        
        return (UISCREEN_WIDTH-40)/5.0;
        
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        return (UISCREEN_WIDTH-40)/6.0;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        return (UISCREEN_WIDTH-40)/4.0;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        return (UISCREEN_WIDTH-40)/3.0;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        return (UISCREEN_WIDTH-40)/2.0;
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        return (UISCREEN_WIDTH-40)/1.0;
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        return (UISCREEN_WIDTH-40)/6.0;
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        return (UISCREEN_WIDTH-40)/6.0;
    }
    
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
            case 5:
            {
                selectedSecond=row;
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute,selectedSecond];
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld",selectedYear,selectedMonth,selectedDay,selectedHour];
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthDayMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMonthMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    }
    else if (self.pickerViewMode == DatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld",selectedYear];
    }else if (self.pickerViewMode == DatePickerViewDateYearMonthDayYearMonthDayMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                if (selectedYear > selectedFinishYear) {
                    selectedFinishYear = selectedYear;
                    selectedFinishMonth = selectedMonth;
                    selectedFinishDay = selectedDay;
                    [self.pickerView selectRow:selectedFinishYear-startYear inComponent:3 animated:NO];
                    [self.pickerView selectRow:selectedFinishMonth-1 inComponent:4 animated:NO];
                    [self.pickerView selectRow:selectedFinishDay-1 inComponent:5 animated:NO];
                    
                    [self pickerView:self.pickerView didSelectRow:selectedFinishYear-startYear inComponent:3];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishMonth-1 inComponent:4];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishDay-1 inComponent:5];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                if (selectedMonth > selectedFinishMonth) {
                    selectedFinishMonth = selectedMonth;
                    selectedFinishDay = selectedDay;
                    [self.pickerView selectRow:selectedFinishMonth-1 inComponent:4 animated:NO];
                    [self.pickerView selectRow:selectedFinishDay-1 inComponent:5 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishMonth-1 inComponent:4];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishDay-1 inComponent:5];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
                if (selectedDay > selectedFinishDay) {
                    selectedFinishDay = selectedDay;
                    [self.pickerView selectRow:selectedFinishDay-1 inComponent:5 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishDay-1 inComponent:5];
                }
                [self.pickerView reloadComponent:5];
            }
                break;
            case 3:
            {
                selectedFinishYear=startYear + row;
                dayFinishRange=[self isAllDay:selectedFinishYear andMonth:selectedFinishMonth];
                if (selectedYear > selectedFinishYear) {
                     selectedYear = selectedFinishYear;
                     selectedMonth = selectedFinishMonth;
                     selectedDay = selectedFinishDay;
                    [self.pickerView selectRow:selectedYear-startYear inComponent:0 animated:NO];
                    [self.pickerView selectRow:selectedMonth-1 inComponent:1 animated:NO];
                    [self.pickerView selectRow:selectedDay-1 inComponent:2 animated:NO];
                    
                    [self pickerView:self.pickerView didSelectRow:selectedYear-startYear inComponent:0];
                    [self pickerView:self.pickerView didSelectRow:selectedMonth-1 inComponent:1];
                    [self pickerView:self.pickerView didSelectRow:selectedDay-1 inComponent:2];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 4:
            {
                selectedFinishMonth=row+1;
                dayFinishRange=[self isAllDay:selectedFinishYear andMonth:selectedFinishMonth];
                if (selectedMonth > selectedFinishMonth) {
                    selectedMonth = selectedFinishMonth;
                    selectedDay = selectedFinishDay;
                    [self.pickerView selectRow:selectedMonth-1 inComponent:1 animated:NO];
                    [self.pickerView selectRow:selectedDay-1 inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedMonth-1 inComponent:1];
                    [self pickerView:self.pickerView didSelectRow:selectedDay-1 inComponent:2];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 5:
            {
                selectedFinishDay=row+1;
                if (selectedDay > selectedFinishDay) {
                    selectedDay = selectedFinishDay;
                    [self.pickerView selectRow:selectedDay-1 inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedDay-1 inComponent:2];
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld～%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay,selectedFinishYear,selectedFinishMonth,selectedFinishDay];
        [self.titleLabel setText:_string];
    }else if (self.pickerViewMode == DatePickerViewDateHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                selectedHour = row;
                if (selectedHour > selectedFinishHour) {
                    selectedFinishHour = selectedHour;
                    selectedFinishMinute = selectedMinute;
                    selectedFinishSecond = selectedSecond;
                    [self.pickerView selectRow:selectedFinishHour inComponent:3 animated:NO];
                    [self.pickerView selectRow:selectedFinishMinute inComponent:4 animated:NO];
                    [self.pickerView selectRow:selectedFinishSecond inComponent:5 animated:NO];
                    
                    [self pickerView:self.pickerView didSelectRow:selectedFinishHour inComponent:3];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishMinute inComponent:4];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishSecond inComponent:5];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 1:
            {
                selectedMinute=row;
                if (selectedMinute > selectedFinishMinute) {
                    selectedFinishMinute = selectedMinute;
                    selectedFinishSecond = selectedSecond;
                    [self.pickerView selectRow:selectedFinishMinute inComponent:4 animated:NO];
                    [self.pickerView selectRow:selectedFinishSecond inComponent:5 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishMinute inComponent:4];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishSecond inComponent:5];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 2:
            {
                selectedSecond = row;
                if (selectedSecond > selectedFinishSecond) {
                    selectedFinishSecond = selectedSecond;
                    [self.pickerView selectRow:selectedFinishSecond inComponent:5 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedFinishSecond inComponent:5];
                }
                [self.pickerView reloadComponent:5];
            }
                break;
            case 3:
            {
                selectedFinishHour = row;
                if (selectedHour > selectedFinishHour) {
                    selectedHour = selectedFinishHour;
                     selectedMinute = selectedFinishMinute;
                     selectedSecond = selectedFinishSecond;
                    [self.pickerView selectRow:selectedHour inComponent:0 animated:NO];
                    [self.pickerView selectRow:selectedMinute inComponent:1 animated:NO];
                    [self.pickerView selectRow:selectedSecond inComponent:2 animated:NO];
                    
                    [self pickerView:self.pickerView didSelectRow:selectedHour inComponent:0];
                    [self pickerView:self.pickerView didSelectRow:selectedMinute inComponent:1];
                    [self pickerView:self.pickerView didSelectRow:selectedSecond inComponent:2];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 4:
            {
                selectedFinishMinute = row;
                if (selectedMinute > selectedFinishMinute) {
                    selectedMinute = selectedFinishMinute;
                    selectedSecond = selectedFinishSecond;
                    [self.pickerView selectRow:selectedMinute inComponent:1 animated:NO];
                    [self.pickerView selectRow:selectedSecond inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedMinute inComponent:1];
                    [self pickerView:self.pickerView didSelectRow:selectedSecond inComponent:2];
                }
                [self.pickerView reloadAllComponents];
            }
                break;
            case 5:
            {
                selectedFinishSecond = row;
                if (selectedSecond > selectedFinishSecond) {
                    selectedSecond = selectedFinishSecond;
                    [self.pickerView selectRow:selectedSecond inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:selectedSecond inComponent:2];
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld～%.2ld:%.2ld:%.2ld",selectedHour,selectedMinute,selectedSecond,selectedFinishHour,selectedFinishMinute,selectedFinishSecond];
        [self.titleLabel setText:_string];
    }
}
#pragma mark -- show and hidden
- (void)showDateTimePickerView{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    self.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideDateTimePickerView{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
#pragma mark - private
//取消的隐藏
- (void)cancelButtonClick
{
    [self hideDateTimePickerView];
    
}

//确认的隐藏
-(void)configButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
        [self.delegate didClickFinishDateTimePickerView:_string];
    }
    [self hideDateTimePickerView];
}
@end
