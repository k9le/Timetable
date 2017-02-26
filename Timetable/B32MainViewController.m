//
//  MainViewController.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32MainViewController.h"
#import "B32DatePickerViewController.h"
#import "B32MainTableView.h"
#import "B32MainView.h"
#import "B32DatePickerAnimatedTransitioning.h"

@interface B32MainViewController ()

@property (weak, nonatomic) IBOutlet B32MainTableView *mainTableView;
@property (nonatomic) B32DatePickerAnimatedTransitioning * animator;

@end

@implementation B32MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)unwindFromDatePicker:(UIStoryboardSegue *) segue
{
    NSDate * date = ((B32DatePickerViewController *)segue.sourceViewController).selectedDate;
    self.mainTableView.date = date;
}

// UIViewControllerTransitioningDelegate functions
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.animator.presenting = YES;
    self.animator.dateControlFrame = ((B32MainView *)self.view).dateControlFrame;
    
    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animator.presenting = NO;
    self.animator.dateControlFrame = ((B32MainView *)self.view).dateControlFrame;
    
    return self.animator;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.animator = [[B32DatePickerAnimatedTransitioning alloc] init];
    segue.destinationViewController.transitioningDelegate = self;
}

@end
