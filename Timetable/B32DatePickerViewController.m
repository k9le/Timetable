//
//  B32DatePickerViewController.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 21/02/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32DatePickerViewController.h"

@interface B32DatePickerViewController ()

@property (weak, nonatomic) IBOutlet B32DatePicker *datePicker;
@property (nonatomic, readwrite) NSDate * selectedDate;

@end

@implementation B32DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.datePicker.delegate = self;
    
    // FIRST EXECUTION
    [self pickerView:self.datePicker displayedMonthWasChangedTo:self.datePicker.monthAndYearToShow];
}

// B32DatePickerDelegate functions
- (void)pickerView:(B32DatePicker *)picker dateWasSelected:(NSDateComponents *)dateComponents
{
    self.selectedDate = [self.datePicker.calendar dateFromComponents:dateComponents];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"IDFunwindFromDatePicker" sender:nil];
    });
}

- (void)pickerView:(B32DatePicker *)picker displayedMonthWasChangedTo:(NSDateComponents *)dateComponents
{
    NSDateFormatter * dfForMonth = [[NSDateFormatter alloc] init];
    [dfForMonth setLocale: [NSLocale currentLocale]];
    NSArray * monthSymbols = [dfForMonth monthSymbols];
    NSString * month = monthSymbols[dateComponents.month - 1];
    NSString * year = [@(dateComponents.year) stringValue];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", [month capitalizedString], year];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
