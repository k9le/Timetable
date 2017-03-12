//
//  DatePicker.m
//  CustomDatePicker
//
//  Created by Vasiliy Fedotov on 27/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32DatePicker.h"

#define RADIUSOFCIRCLE(__chosenLabelFrame) (MIN(__chosenLabelFrame.size.width,  __chosenLabelFrame.size.height)/2.f) * (2.f/3.f)

@interface B32DatePicker ()
{
    CALayer * _selectedDateCircleLayer;
    CALayer * _todayDateCircleLayer;
}
@property (nonatomic, readonly) NSUInteger numDaysInWeek;
@property (nonatomic, readonly) NSUInteger numRowsInCalendarMonth;

@property (nonatomic) NSMutableArray * weekdayLabels;
@property (nonatomic) NSMutableArray * dayLabels;

@property (nonatomic, copy) NSArray * daysToDisplay;

@property (nonatomic) UITapGestureRecognizer * gestureRecognizer;

@property (nonatomic, readonly) NSDateComponents * todayDate;
@property (nonatomic, readwrite) NSDateComponents * selectedDate;

- (void)initialize;
- (void)setDefaultValues;
- (void)createUIElements;
- (void)prepareDaysForDisplay;

- (void)drawRect:(CGRect)rect;

- (void)checkDateComponents;
- (void)setPreviousMonth:(NSDateComponents * ) components;
- (void)setNextMonth:(NSDateComponents * ) components;
- (NSDate *)getDateFromComponents: (NSDateComponents *) components;
- (NSUInteger)numberOfDaysInMonth: (NSDateComponents *) components;

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (CALayer * )drawDateCircleForLabel: (UILabel *)label withColor: (UIColor *) color animated:(BOOL) animated;
- (CALayer *)redrawCircleForLayer: (CALayer *)layer date:(NSDateComponents *)date color: (UIColor *)color animated: (BOOL) animated;
- (void)drawSelectedDateCircleAnimated: (BOOL) animated;
- (void)drawTodayDateCircle;
- (void)redrawDateCircles;

@end


@implementation B32DatePicker

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(nil != self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(nil != self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedDate"];
}

- (void)initialize
{
    _numDaysInWeek = 7;
    _numRowsInCalendarMonth = 6;
    
    [self setDefaultValues];
    [self createUIElements];
    
    [self addObserver:self forKeyPath:@"selectedDate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) createUIElements
{
    NSInteger capacity = _numDaysInWeek * _numRowsInCalendarMonth;
    _dayLabels = [[NSMutableArray alloc] initWithCapacity:capacity];
    for(NSInteger i = 0; i < capacity; ++i)
    {
        UILabel * label  = [[UILabel alloc] init];
        [_dayLabels addObject:label];
        [self addSubview:label];
        
    }
    
    _weekdayLabels = [[NSMutableArray alloc] initWithCapacity:_numDaysInWeek];
    for(NSInteger i = 0; i < _numDaysInWeek; ++i)
    {
        UILabel * label  = [[UILabel alloc] init];
        [_weekdayLabels addObject:label];
        [self addSubview:label];
    }
    
    _gestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [_gestureRecognizer addTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:_gestureRecognizer];
}


- (void) setDefaultValues
{
    _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    _monthAndYearToShow = [_calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    _firstWeekday = B32FirstWeekDayMonday;
    _weekdayHeaderColor = [UIColor yellowColor];
    _weekdayHeaderFont = [UIFont systemFontOfSize:12.f];
    _weekdayHeaderFontColor = [UIColor blackColor];
    _linesBetweenRowsColor = [UIColor blackColor];
    _thisMonthDaysFont = [UIFont systemFontOfSize:15.f];
    _thisMonthDaysFontColor = [UIColor blackColor];
    _anotherMonthDaysFont = [UIFont systemFontOfSize:15.f];
    _anotherMonthDaysFontColor = [UIColor grayColor];
    _showLinesBetweenRows = YES;
    
    NSDate * today = [NSDate date];
    NSCalendarUnit units = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    _todayDate = [self.calendar components:units fromDate:today];

    _selectedDateCircleLayer = nil;
    _todayDateCircleLayer = nil;

//    _monthAndYearToShow = [_calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate dateWithTimeIntervalSinceNow:4 * 2592000]];
}

- (void)drawRect:(CGRect)rect
{
    [self checkDateComponents];
    
    [self prepareDaysForDisplay];
    
    // DRAWING
    float widthOfLineBetweenRows = 0.5f;
    float weekdayPaneHeightRatio = 0.5;
    
    float rowHeight =( rect.size.height / ([self numRowsInCalendarMonth] + weekdayPaneHeightRatio));
    float dayLabelHeight = rowHeight - widthOfLineBetweenRows;
    
    // draw weekdays pane
    float weekdayPaneHeight = (rect.size.height - rowHeight * [self numRowsInCalendarMonth]);
    UIBezierPath * weekdayPanePath = [UIBezierPath bezierPathWithRect: CGRectMake(0,0, rect.size.width, weekdayPaneHeight)];
    [self.weekdayHeaderColor setFill];
    [weekdayPanePath fill];

    // draw weekday labels
    NSDateFormatter * dfForWeekdays = [[NSDateFormatter alloc] init];
    [dfForWeekdays setLocale: [NSLocale currentLocale]];
    NSArray * shortWeekdaySymbols = [dfForWeekdays shortWeekdaySymbols];
    
    float oneDayWidth = (rect.size.width / [self numDaysInWeek]);
    
    for(NSInteger d = 0; d < [self numDaysInWeek]; ++d)
    {
        UILabel * weekdayLabel = self.weekdayLabels[d];
        
        weekdayLabel.frame = CGRectMake(d * oneDayWidth, 0, oneDayWidth, weekdayPaneHeight);
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = self.weekdayHeaderFont;
        weekdayLabel.textColor = self.weekdayHeaderFontColor;
        
        if(B32FirstWeekDayMonday == self.firstWeekday) {
            NSInteger weekdayIdx = (([self numDaysInWeek] - 1 == d) ? 0 : d + 1);
            [weekdayLabel setText:shortWeekdaySymbols[weekdayIdx]];
        } else {
            [weekdayLabel setText:shortWeekdaySymbols[d]];
        }
    }
    
    // DRAWING DAY LABELS
    UIFont * currentFont = [self anotherMonthDaysFont];
    UIColor * currentTextColor = [self anotherMonthDaysFontColor];
    BOOL drawLine = NO;
    
    NSDateComponents * month = [self.monthAndYearToShow copy];
    [self setPreviousMonth:month];
    for(NSInteger row = 0, elem = 0, label = 0; row < [self numRowsInCalendarMonth]; ++row)
    {
        for(NSInteger day = 0; day < [self numDaysInWeek]; ++day)
        {
            id element = _daysToDisplay[elem++];
            if ([NSNull null] == element) {
                // change font & color
                currentFont = (currentFont == [self anotherMonthDaysFont] ? [self thisMonthDaysFont] : [self anotherMonthDaysFont]);
                currentTextColor = (currentTextColor == [self anotherMonthDaysFontColor] ? [self thisMonthDaysFontColor] : [self anotherMonthDaysFontColor]);
                drawLine = !drawLine;
                day -- ;
                [self setNextMonth:month];
                
                continue;
            }
            
            NSNumber * dayNumber = element;
            
            UILabel * dayLabel = self.dayLabels[label++];
            dayLabel.frame = CGRectMake(day * oneDayWidth, weekdayPaneHeight + row * rowHeight, oneDayWidth, dayLabelHeight);
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.font = currentFont;
            dayLabel.text = [NSString stringWithFormat:@"%zd", [dayNumber integerValue]];
            dayLabel.textColor = currentTextColor;
            
            // DRAW LINE, IF ACTUAL MONTH DAY
            if (self.showLinesBetweenRows && drawLine) {
                [self.linesBetweenRowsColor setFill];
                float rowBottomHeight = weekdayPaneHeight + row * rowHeight + dayLabelHeight;
                UIBezierPath * line = [UIBezierPath bezierPathWithRect:CGRectMake(day * oneDayWidth, rowBottomHeight, oneDayWidth , widthOfLineBetweenRows)];
                [line fill];
            }
        }
    }
    
    [self redrawDateCircles];
    
}



    
- (void)checkDateComponents
{
    
    if (self.monthAndYearToShow == nil)
    {
        NSDate * today = [NSDate date];
        NSCalendarUnit units = NSCalendarUnitMonth|NSCalendarUnitYear;
        
        self.monthAndYearToShow = [self.calendar components:units fromDate:today];
    }
}

- (NSUInteger) numberOfDaysInMonth: (NSDateComponents *) components
{
    NSDate * date = [self getDateFromComponents:components];
    
    if (nil == date) {
        @throw [NSException exceptionWithName:@"EmptyDateException" reason:@"Can't get data from components using this calendar" userInfo:nil];
    }
    
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}



- (NSDate *)getDateFromComponents:(NSDateComponents *) components
{
    return [self.calendar dateFromComponents:components];
}

- (void)setPreviousMonth:(NSDateComponents * ) components
{
    if (1 == components.month) {
        // january
        components.month = 12;
        components.year -- ;
    } else {
        components.month -- ;
    }
}

- (void)setNextMonth:(NSDateComponents * ) components
{
    if (12 == components.month) {
        // december
        components.month = 1;
        components.year ++ ;
    } else {
        components.month ++ ;
    }
}

- (void)prepareDaysForDisplay
{
    // GET NUMBER OF DAYS IN THIS, PREVIOUS AND NEXT MONTHS
    NSDateComponents * prev = [self.monthAndYearToShow copy];
    [self setPreviousMonth:prev];
    
    NSDateComponents * next = [self.monthAndYearToShow copy];
    [self setNextMonth:next];
    
    NSInteger numDaysInThisMonth = [self numberOfDaysInMonth:self.monthAndYearToShow];
    NSInteger numDaysInPrevMonth = [self numberOfDaysInMonth:prev];
//    NSInteger numDaysInNextMonth = [self numberOfDaysInMonth:next];
    
    // GET FIRST WEEKDAY, DEPENDING OF USER SETTING
    NSDateComponents * firstDay = [self.monthAndYearToShow copy];
    [firstDay setDay:1];
    NSDate * firstDayDate = [self getDateFromComponents:firstDay];
    NSInteger firstDayWeekday = [self.calendar component:NSCalendarUnitWeekday fromDate:firstDayDate];
    
    
    NSInteger numOfThisMonthDaysOnFirstRow = 1;
    if(B32FirstWeekDayMonday == self.firstWeekday) {
        if(1 == firstDayWeekday) { // if 1day == sunday
            numOfThisMonthDaysOnFirstRow = 1;
        } else {
            numOfThisMonthDaysOnFirstRow = ([self numDaysInWeek] - firstDayWeekday) + 2;
        }
    } else {
        // B32FirstWeekDaySunday == self.firstWeekday
        numOfThisMonthDaysOnFirstRow = ([self numDaysInWeek] - firstDayWeekday) + 1;
    }
    
    NSInteger numOfDaysThisMonthOnAnotherRows = numDaysInThisMonth - numOfThisMonthDaysOnFirstRow;
    NSInteger numThisMonthRows = 1 + (NSInteger)(numOfDaysThisMonthOnAnotherRows / [self numDaysInWeek]) + (numOfDaysThisMonthOnAnotherRows % [self numDaysInWeek] == 0 ? 0 : 1);
    
    // CENTER ACTUAL MONTH ON DISPLAY
    NSInteger numOfRowsPrevMonthUpperThisMonth = (NSInteger)(([self numRowsInCalendarMonth] - numThisMonthRows) / 2);
    NSInteger numOfRowsNextMonthUnderThisMonth = [self numRowsInCalendarMonth] - numThisMonthRows - numOfRowsPrevMonthUpperThisMonth;
    
    NSInteger numOfPrevMonthDaysToDisplay = numOfRowsPrevMonthUpperThisMonth * [self numDaysInWeek] + ( [self numDaysInWeek] - numOfThisMonthDaysOnFirstRow);
    NSInteger firstDayPrevMonth = numDaysInPrevMonth - numOfPrevMonthDaysToDisplay + 1;
    
    NSInteger numOfNextMonthDaysToDisplay = numOfRowsNextMonthUnderThisMonth * [self numDaysInWeek] + ( [self numDaysInWeek] - (numOfDaysThisMonthOnAnotherRows % [self numDaysInWeek]));
    
    NSInteger capacity = (numOfPrevMonthDaysToDisplay + numDaysInThisMonth + numOfNextMonthDaysToDisplay + 2); // 2 for two NSNulls
    NSMutableArray * daysToDisplay_ = [NSMutableArray arrayWithCapacity:capacity];
    
    for(NSInteger i = 0; i<numOfPrevMonthDaysToDisplay; ++i) [daysToDisplay_ addObject:[NSNumber numberWithInteger:(firstDayPrevMonth + i)]];
    [daysToDisplay_ addObject:[NSNull null]];
    for(NSInteger i = 0; i<numDaysInThisMonth; ++i) [daysToDisplay_ addObject:[NSNumber numberWithInteger:(i + 1)]];
    [daysToDisplay_ addObject:[NSNull null]];
    for(NSInteger i = 0; i<numOfNextMonthDaysToDisplay; ++i) [daysToDisplay_ addObject:[NSNumber numberWithInteger:(i + 1)]];
    
    [self setDaysToDisplay: daysToDisplay_];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (UIGestureRecognizerStateEnded != gestureRecognizer.state) return;

    CGPoint point = [gestureRecognizer locationInView:self];
    for(NSInteger i = 0, imax = self.dayLabels.count, val = 0, monthIdx = -1; i<imax; ++i, ++val)
    {
        if ([NSNull null] == self.daysToDisplay[val]) { val++; monthIdx++; }
        
        UILabel * label = self.dayLabels[i];
        if(CGRectContainsPoint(label.frame, point))
        {
            NSDateComponents * chosenDate = [self.monthAndYearToShow copy];
            if(-1 == monthIdx) {
                [self setPreviousMonth:chosenDate];
            } else if (1 == monthIdx) {
                [self setNextMonth:chosenDate];
            }
            chosenDate.day = [self.daysToDisplay[val] integerValue];
            
            [self setSelectedDate:chosenDate];
            
            break;
        }
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedDate"]) {
        [self drawSelectedDateCircleAnimated:YES];
        
        [self.delegate pickerView:self dateWasSelected:self.selectedDate];
    }
}

- (void)drawSelectedDateCircleAnimated: (BOOL) animated
{
    _selectedDateCircleLayer = [self redrawCircleForLayer:_selectedDateCircleLayer date:self.selectedDate color:[UIColor blueColor] animated:animated];
}

- (void)drawTodayDateCircle
{
    _todayDateCircleLayer = [self redrawCircleForLayer:_todayDateCircleLayer date:self.todayDate color:[UIColor redColor] animated:NO];
}

- (void)redrawDateCircles
{
    [self drawTodayDateCircle];
    [self drawSelectedDateCircleAnimated:NO];
}

- (CALayer *)redrawCircleForLayer: (CALayer *)layer date:(NSDateComponents *)date color: (UIColor *)color animated: (BOOL) animated
{
    // DELETE OLD LAYER, IF ANY
    if(nil != layer)
    {
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    NSDateComponents * dc = [self.monthAndYearToShow copy];
    [self setPreviousMonth:dc];
    
    UILabel * chosenLabel = nil;
    for(NSInteger i = 0, imax = self.daysToDisplay.count, val = 0; i<imax; ++i)
    {
        if ([NSNull null] == self.daysToDisplay[i]) { [self setNextMonth:dc]; val++; continue; }
        
        dc.day = [self.daysToDisplay[i] integerValue];
        
        if([dc isEqual:date])
        {
            chosenLabel = self.dayLabels[i - val];
        }
    }
    
    if(nil == chosenLabel) return nil;
    
    // DRAW CHOSEN CIRLCE
    CALayer * circleLayer = [self drawDateCircleForLabel:chosenLabel withColor:color animated:animated];
    
    [self.layer insertSublayer:circleLayer below:chosenLabel.layer];
    
    return circleLayer;
}

- (CALayer * )drawDateCircleForLabel: (UILabel *)label withColor: (UIColor *) color animated:(BOOL) animated
{
    CGRect boundsOfChosenLabel = label.bounds;
    CGRect frameOfChosenLabel = label.frame;
    
    CGFloat radius = RADIUSOFCIRCLE(boundsOfChosenLabel);
    CGRect circleRect = CGRectInset(boundsOfChosenLabel,
                                    boundsOfChosenLabel.size.width/2.f - radius,
                                    boundsOfChosenLabel.size.height/2.f - radius);
    
    CGFloat smallRadius = radius * (0.1f);
    CGRect smallCircleRect = CGRectInset(circleRect,
                                         radius - smallRadius,
                                         radius - smallRadius);
    
    UIBezierPath * smallCirclePath = [UIBezierPath bezierPathWithOvalInRect:smallCircleRect];
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    CAShapeLayer * circleLayer = [CAShapeLayer layer];
    circleLayer.frame = frameOfChosenLabel;
    circleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    circleLayer.path = [circlePath CGPath];
    circleLayer.opacity = 1.f;
    circleLayer.fillColor = [color CGColor];
    
    if (animated) {
        CABasicAnimation * circleOpacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        circleOpacityAnim.duration = 0.2f;
        circleOpacityAnim.fromValue = @(0.f);
        circleOpacityAnim.toValue = @(0.5f);
        circleOpacityAnim.repeatCount = 1;
        
        CABasicAnimation * circlePathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
        circlePathAnim.duration = 0.2f;
        circlePathAnim.fromValue = (id)[smallCirclePath CGPath];
        circlePathAnim.toValue = (id)[circlePath CGPath];
        circlePathAnim.repeatCount = 1;
        
        [circleLayer addAnimation:circleOpacityAnim forKey:@"circleOpacity"];
        [circleLayer addAnimation:circlePathAnim forKey:@"circlePath"];
    }
    
    return circleLayer;
}

- (void)previousMonth
{
    [self setPreviousMonth:self.monthAndYearToShow];
    [self setNeedsDisplay];
    
    if([self.delegate respondsToSelector:@selector(pickerView:displayedMonthWasChangedTo:)])
    {
        [self.delegate pickerView:self displayedMonthWasChangedTo:self.monthAndYearToShow];
    }
}

- (void)nextMonth
{
    [self setNextMonth:self.monthAndYearToShow];
    [self setNeedsDisplay];

    if([self.delegate respondsToSelector:@selector(pickerView:displayedMonthWasChangedTo:)])
    {
        [self.delegate pickerView:self displayedMonthWasChangedTo:self.monthAndYearToShow];
    }
}

@end
