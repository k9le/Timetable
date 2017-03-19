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
#import "B32FromToTableViewCell.h"
#import "B32StationsViewController.h"
#import "B32StationsData.h"
#import "B32CoreDataStore.h"
#import "B32StationMO+CoreDataClass.h"
#import "B32StationsViewController.h"

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

-(IBAction)unwindFromStationChooserCancel:(UIStoryboardSegue *) segue
{
    
}

-(IBAction)unwindFromStationChooserChosen:(UIStoryboardSegue *) segue
{
    B32StationsViewController * sourceVC = segue.sourceViewController;
    
    BOOL showFrom = sourceVC.showFrom;
    
    NSFetchRequest * fetchRequest = [B32StationMO fetchRequestForFromStations:showFrom numberOfStationsToFetch:1];
    
    NSManagedObjectContext * context = [[B32CoreDataStore shared] managedObjectContext];
    NSArray * stations = [context executeFetchRequest:fetchRequest error:nil];
    if(stations.count > 0)
    {
        B32StationMO * stationMO = [stations objectAtIndex:0];
        B32StationItem * stationItem = stationMO.station;
        
        if(showFrom)
        {
            self.mainTableView.fromStation = stationItem;
        } else {
            self.mainTableView.toStation = stationItem;
        }
        [self.mainTableView reloadData];
    }
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
    if([segue.identifier isEqualToString:@"DateSegue"])
    {
        if(nil == self.animator) self.animator = [[B32DatePickerAnimatedTransitioning alloc] init];
        
        segue.destinationViewController.transitioningDelegate = self;
    }
    
    if([segue.identifier isEqualToString:@"StationSegue"])
    {
        B32FromToTableViewCell * cell = (B32FromToTableViewCell *) sender;
        if(B32FromToTableViewCellTypeTo == cell.type)
        {
            B32StationsViewController * stationsVC = (B32StationsViewController *)((UINavigationController * )segue.destinationViewController).topViewController;
            stationsVC.stationsDataSource = [[B32StationsData shared] toStations];
        } else {
            B32StationsViewController * stationsVC = (B32StationsViewController *)((UINavigationController * )segue.destinationViewController).topViewController;
            stationsVC.stationsDataSource = [[B32StationsData shared] fromStations];
        }
    }
}

@end
