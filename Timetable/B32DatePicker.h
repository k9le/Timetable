//
//  DatePicker.h
//  CustomDatePicker
//
//  Created by Vasiliy Fedotov on 27/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, B32FirstWeekDay) {
    B32FirstWeekDaySunday,
    B32FirstWeekDayMonday
};

@class B32DatePicker;

@protocol B32DatePickerDelegate <NSObject>

@required

- (void) pickerView: (B32DatePicker * ) picker dateWasSelected: (NSDateComponents *) dateComponents;

@optional

- (void) pickerView: (B32DatePicker * ) picker displayedMonthWasChangedTo: (NSDateComponents *) dateComponents;

@end


typedef void (^B32DatePickerCompletionBlock)(B32DatePicker * picker);
typedef void (^B32DatePickerChangeMonthBlock)(B32DatePicker * picker, NSDateComponents * newDate);

IB_DESIGNABLE

@interface B32DatePicker : UIControl

@property (nonatomic) NSDateComponents * monthAndYearToShow;
@property (nonatomic) NSCalendar * calendar;
@property (nonatomic) B32FirstWeekDay firstWeekday;

@property (nonatomic) IBInspectable UIColor * weekdayHeaderColor;
@property (nonatomic) IBInspectable UIFont * weekdayHeaderFont;
@property (nonatomic) IBInspectable UIColor * weekdayHeaderFontColor;
@property (nonatomic) IBInspectable UIColor * linesBetweenRowsColor;
@property (nonatomic) IBInspectable UIFont * thisMonthDaysFont;
@property (nonatomic) IBInspectable UIColor * thisMonthDaysFontColor;
@property (nonatomic) IBInspectable UIFont * anotherMonthDaysFont;
@property (nonatomic) IBInspectable UIColor * anotherMonthDaysFontColor;
@property (nonatomic) IBInspectable BOOL showLinesBetweenRows;

@property (nonatomic, readonly) NSDateComponents * selectedDate;

@property (nonatomic, weak) id<B32DatePickerDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame;
- (instancetype) initWithCoder:(NSCoder *)aDecoder;

- (IBAction)previousMonth;
- (IBAction)nextMonth;

@end
