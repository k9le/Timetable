//
//  B32DatePickerViewController.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 21/02/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B32DatePicker.h"

@interface B32DatePickerViewController : UIViewController <B32DatePickerDelegate>

@property (nonatomic, readonly) NSDate * selectedDate;

@end
