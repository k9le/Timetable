//
//  B32StationsViewController.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationsViewController.h"
#import "B32StationsData.h"
#import "StationDataTypes.h"
#import "B32StationTableViewCell.h"
#import "B32GroupByCityCountryPattern.h"
#import "B32GroupByCountryCityPattern.h"
#import "B32GroupByCountryPattern.h"

@interface B32StationsViewController ()
{
    float _durationOfLoadingViewAnimation;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

- (void) showLoadingViewWithAnimation:(BOOL)animation;
- (void) hideLoadingViewWithAnimation:(BOOL)animation;

@property (nonatomic) id<B32GroupableIFace> groupPattern;

@end

@implementation B32StationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view bringSubviewToFront:self.tableView];
    
    self.groupPattern = [B32GroupByCountryCityPattern new];
    self.loadingView.alpha = 0.9f;
    
    _durationOfLoadingViewAnimation = 0.20f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.groupPattern = self.stationsDataSource.groupPattern;
    
    void (^asyncCompletionBlock)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self hideLoadingViewWithAnimation:YES];
        });
    };
    
    if(![B32StationsData shared].loaded)
    {
        [self showLoadingViewWithAnimation:NO];

        [[B32StationsData shared] setCompletion: asyncCompletionBlock];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL loaded = [B32StationsData shared].loaded;
    NSInteger groupCount = [self.stationsDataSource groupCount];
    return loaded ? groupCount : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    B32StationItem * station = [self.stationsDataSource getStationInGroup:section index:0];
    
    return [self.groupPattern groupHeader:station];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsCount = [self.stationsDataSource getStationsCountInGroup:section];
    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    B32StationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    B32StationItem * station = [self.stationsDataSource getStationInGroup:section index:row];
    
    cell.titleLabel.text = station.stationTitle;
    if(0 == [station.regionTitle length])
    {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@", station.city.cityTitle, station.city.countryTitle];
    } else {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@, %@", station.city.cityTitle, station.city.regionTitle, station.city.countryTitle];
    }
    
    return cell;
}

- (IBAction)regroupButtonTapped:(UIBarButtonItem *)sender {
    
    void (^executeRegroup)(id<B32GroupableIFace> groupable) = ^(id<B32GroupableIFace> groupable){
        BOOL animation = YES;
        
        __block NSDate * firstMoment = [NSDate date];
        
        [self showLoadingViewWithAnimation:animation];
        
        [self.stationsDataSource groupWithPattern:groupable completion:^{

            void (^executeRedraw)(void) = ^{
                [self.tableView reloadData];
                [self hideLoadingViewWithAnimation:animation];
            };
            
            NSTimeInterval minDelay = 3.0;
            NSDate *secondMoment = [NSDate date];
            NSTimeInterval interval = [secondMoment timeIntervalSinceDate:firstMoment];
            NSTimeInterval difference = minDelay - interval - (animation ? 2 * _durationOfLoadingViewAnimation : 0);
            
            if(difference <= 0.0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    executeRedraw();
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(difference * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    executeRedraw();
                });
            }
        }];
    };
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Сортировать список по:"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* countryAction = [UIAlertAction actionWithTitle:@"Стране" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.groupPattern = [B32GroupByCountryPattern new];
                                                              executeRegroup(self.groupPattern);
                                                          }];
    UIAlertAction* countryCityAction = [UIAlertAction actionWithTitle:@"Стране, городу" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.groupPattern = [B32GroupByCountryCityPattern new];
                                                              executeRegroup(self.groupPattern);
                                                          }];
    
    UIAlertAction* cityCountryAction = [UIAlertAction actionWithTitle:@"Городу, стране" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               self.groupPattern = [B32GroupByCityCountryPattern new];
                                                               executeRegroup(self.groupPattern);
                                                           }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * action) {}];
    
    
    
    [alert addAction:countryAction];
    [alert addAction:countryCityAction];
    [alert addAction:cityCountryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void) showLoadingViewWithAnimation:(BOOL)animation
{
    [self.view bringSubviewToFront:self.loadingView];
    
    if(animation)
    {
        CGPoint previousCenter = self.loadingView.center;

        self.loadingView.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y - self.loadingView.frame.size.height * 2);
        
        [UIView animateWithDuration:_durationOfLoadingViewAnimation delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.loadingView.center = previousCenter;
        } completion:nil];
    }
}

- (void) hideLoadingViewWithAnimation:(BOOL)animation
{
    if(animation)
    {
    
        CGPoint newCenter = CGPointMake(self.loadingView.center.x, self.loadingView.center.y + self.loadingView.frame.size.height * 2);
        CGPoint previousCenter = self.loadingView.center;
        
        [UIView animateWithDuration:_durationOfLoadingViewAnimation delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.loadingView.center = newCenter;
        } completion:^(BOOL ok){
            [self.view bringSubviewToFront:self.tableView];
            self.loadingView.center = previousCenter;
        }];
    } else {
        [self.view bringSubviewToFront:self.tableView];
    }
    
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
