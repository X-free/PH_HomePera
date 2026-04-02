//
//  DatePickerView.m
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import "DatePickerView.h"

@interface DatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dashLineView;
@property (nonatomic, copy) DatePickerCompletion completion;

@property (nonatomic, strong) NSArray<NSString *> *days;
@property (nonatomic, strong) NSArray<NSString *> *months;
@property (nonatomic, strong) NSArray<NSString *> *years;

@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame dateString:(NSString *)dateString completion:(DatePickerCompletion)completion {
    self = [super initWithFrame:frame];
    if (self) {
        _completion = completion;
        [self setupData];
        [self setupUI];
        [self setInitialDateWithString:dateString];
    }
    return self;
}

#pragma mark - 数据初始化

- (void)setupData {
    // 初始化月份数据
    NSMutableArray *months = [NSMutableArray array];
    for (NSInteger i = 1; i <= 12; i++) {
        [months addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
    self.months = [months copy];
    
    // 200年范围（当前年份前后各100年）
    NSMutableArray *years = [NSMutableArray array];
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger startYear = currentYear - 100;
    NSInteger endYear = currentYear + 100;
    
    for (NSInteger i = startYear; i <= endYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    self.years = [years copy];
    
    // 初始化天数数据（基于当前月份和年份）
    [self updateDaysForCurrentMonthAndYear];
}

// 根据当前选择的月份和年份更新天数数组
- (void)updateDaysForCurrentMonthAndYear {
    // 1. 获取当前选择的月份和年份
       NSInteger selectedMonth = [self.pickerView selectedRowInComponent:1] + 1;
       NSInteger selectedYear = [self.years[[self.pickerView selectedRowInComponent:2]] integerValue];
       
       // 2. 计算该月实际天数（确保正确处理闰年）
       NSInteger daysInMonth = [self daysInMonth:selectedMonth year:selectedYear];
       
       // 3. 更新天数数据源
       NSMutableArray *days = [NSMutableArray array];
       for (NSInteger i = 1; i <= daysInMonth; i++) {
           [days addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
       }
       self.days = [days copy];
       
       // 4. 先刷新组件数据
       [self.pickerView reloadComponent:0];
       
       // 5. 获取当前选择的天数（基于旧数据）
       NSInteger selectedDay = [self.pickerView selectedRowInComponent:0] + 1;
       
       // 6. 调整选择行（必须在reload之后）
       if (selectedDay > daysInMonth) {
           // 使用dispatch_async确保在界面更新后执行选择
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.pickerView selectRow:daysInMonth - 1 inComponent:0 animated:YES];
           });
       }
       
//       NSLog(@"月份: %ld, 年份: %ld → 实际天数: %ld, 调整后天数: %ld",
//             selectedMonth, selectedYear, daysInMonth, MIN(selectedDay, daysInMonth));
}

// 计算指定月份和年份的天数
- (NSInteger)daysInMonth:(NSInteger)month year:(NSInteger)year {
    if (month == 2) {
        // 检查闰年
        if ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0)) {
            return 29; // 闰年2月
        } else {
            return 28; // 平年2月
        }
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        return 30;
    } else {
        return 31;
    }
}


- (void)setInitialDateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [formatter dateFromString:dateString];
    
    if (!date) {
        [formatter setDateFormat:@"dd-MM-yyyy"];
        date = [formatter dateFromString:dateString];
    }
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    
    NSInteger day = components.day;
    NSInteger month = components.month;
    NSInteger year = components.year;
    
    // 设置初始选中项
    NSInteger dayIndex = [self.days indexOfObject:[NSString stringWithFormat:@"%02ld", (long)day]];
    NSInteger monthIndex = [self.months indexOfObject:[NSString stringWithFormat:@"%02ld", (long)month]];
    
    // 查找年份位置（因为年份范围大，需要确保年份在范围内）
    NSInteger yearIndex = 0;
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger minYear = currentYear - 100;
    NSInteger maxYear = currentYear + 100;
    
    if (year < minYear) {
        year = minYear;
    } else if (year > maxYear) {
        year = maxYear;
    }
    
    yearIndex = year - minYear;
    
    if (dayIndex != NSNotFound) {
        [self.pickerView selectRow:dayIndex inComponent:0 animated:NO];
    }
    if (monthIndex != NSNotFound) {
        [self.pickerView selectRow:monthIndex inComponent:1 animated:NO];
    }
    [self.pickerView selectRow:yearIndex inComponent:2 animated:NO];
    
    // 设置初始选中项后，更新天数
        [self updateDaysForCurrentMonthAndYear];
    
    // 初始回调
    if (self.completion) {
        self.completion([NSString stringWithFormat:@"%02ld-%02ld-%ld", (long)day, (long)month, (long)year]);
    }
    
}

#pragma mark - UI 初始化

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    
    // 容器视图
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_containerView];
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.bounds.size.width, 20)];
    _titleLabel.text =  @"Day        \t\tMonth        \t\tYear";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor darkGrayColor];
    [_containerView addSubview:_titleLabel];
    
    // 虚线
    _dashLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 45, self.bounds.size.width - 40, 1)];
    [self addDashLineToView:_dashLineView];
    [_containerView addSubview:_dashLineView];
    
    // 选择器
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height - 50)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_containerView addSubview:_pickerView];
}

- (void)addDashLineToView:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineDashPattern = @[@3, @2]; // 虚线模式: 3点实线，2点空白
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, view.frame.size.width, 0);
    shapeLayer.path = path;
    CGPathRelease(path);
    
    [view.layer addSublayer:shapeLayer];
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return self.days.count;
    if (component == 1) return self.months.count;
    return self.years.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) return self.days[row];
    if (component == 1) return self.months[row];
    return self.years[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
    }
    
    if (component == 0) label.text = self.days[row];
    else if (component == 1) label.text = self.months[row];
    else label.text = self.years[row];
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.bounds.size.width - 40) / 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 当月份或年份变化时，更新天数
    if (component == 1 || component == 2) {
        [self updateDaysForCurrentMonthAndYear];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取当前选择的日期
        NSInteger day = [[self.days objectAtIndex:[pickerView selectedRowInComponent:0]] integerValue];
        NSInteger month = [[self.months objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
        NSInteger year = [[self.years objectAtIndex:[pickerView selectedRowInComponent:2]] integerValue];
        
        if (self.completion) {
            self.completion([NSString stringWithFormat:@"%02ld-%02ld-%ld", (long)day, (long)month, (long)year]);
        }
    });
    
   
}

#pragma mark - 显示/隐藏

- (void)showInView:(UIView *)view {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
