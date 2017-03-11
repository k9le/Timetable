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
#import "B32StationSearchProxy.h"

@interface B32StationsViewController ()
{
    float _durationOfLoadingViewAnimation;
    float _durationOfSearchBarAnimation;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, readonly) NSString * searchRequest;

@property (nonatomic) BOOL recentIsEmpty;
- (void) prepareRecent;
- (BOOL) showRecent;

- (void) regroup;

- (void) showLoadingViewWithAnimation:(BOOL)animation;
- (void) hideLoadingViewWithAnimation:(BOOL)animation;

- (void) reloadSearchBar;
- (void) showSearchBarWithAnimation:(BOOL)animated;
- (void) hideSearchBarWithAnimation:(BOOL)animated;
- (BOOL) isSearchBarVisible;

- (void) setSearchRightBarButtonItem;
- (void) setGroupRightBarButtonItem;
- (void) setRightBarButtonItemEnabled:(BOOL)enabled;

@property (nonatomic) id<B32GroupableIFace> groupPattern;

@property (nonatomic) B32StationSearchProxy * dataSourceSearchProxy;


@end

@implementation B32StationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    self.searchBar.delegate = self;
    
    _durationOfLoadingViewAnimation = 0.20f;
    _durationOfSearchBarAnimation = 0.3f;
    
    [self reloadSearchBar];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.groupPattern = self.stationsDataSource.groupPattern;
    
    [self prepareRecent];
    if(self.recentIsEmpty) {
        [self rightBarButtonItemTapped:nil];
    }
}

#pragma mark - Tableview delegate & dataSource funcs

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self showRecent])
    {
        return 1;
        
    } else {
    
        BOOL loaded = [B32StationsData shared].loaded;
        if(loaded)
        {
            if(nil == self.searchRequest)
            {
                NSInteger groupCount = [self.stationsDataSource groupCount];
                return groupCount;
            } else {
                return 1;
            }
        } else {
            return 0;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self showRecent])
    {
        return @"Недавно выбранные";
    } else {
    
        if(0 == section && nil != self.searchRequest)
        {
            
            return nil;
        } else {
            B32StationItem * station = [self.stationsDataSource getStationInGroup:section index:0];
            
            return [self.groupPattern groupHeader:station];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self showRecent])
    {
        return 0;
    } else {
    
        if(0 == section && nil != self.searchRequest)
        {
            return [self.dataSourceSearchProxy numberOfSearchedItems];
        } else {
            NSInteger rowsCount = [self.stationsDataSource getStationsCountInGroup:section];
            return rowsCount;
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    B32StationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    B32StationItem * station;
    if ([self showRecent])
    {
        
    } else {
        if(nil != self.searchRequest)
        {
            station = [self.dataSourceSearchProxy getSearchedStationAtIndex:row];
        } else {
            station = [self.stationsDataSource getStationInGroup:section index:row];
        }
    }
    
    cell.titleLabel.text = station.stationTitle;
    if(0 == [station.regionTitle length])
    {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@", station.city.cityTitle, station.city.countryTitle];
    } else {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@, %@", station.city.cityTitle, station.city.regionTitle, station.city.countryTitle];
    }
    
    return cell;
}

#pragma mark - Right bar button item

- (void) setSearchRightBarButtonItem
{
    self.rightBarButtonItem.image = [UIImage imageNamed:@"Search"];
}

- (void) setGroupRightBarButtonItem
{
    self.rightBarButtonItem.image = [UIImage imageNamed:@"Regroup"];
}

- (void) setRightBarButtonItemEnabled:(BOOL)enabled
{
    self.rightBarButtonItem.enabled = enabled;
}


- (IBAction)rightBarButtonItemTapped:(UIBarButtonItem *)sender {

    if ([self isSearchBarVisible])
    {
        [self.searchBar resignFirstResponder];

        [self regroup];
        
    } else {
        
        [self setGroupRightBarButtonItem];
        [self showSearchBarWithAnimation:YES];
        
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
        } else {
            [self.tableView reloadData];
        }
    }
}

- (IBAction)leftBarButtonItemTapped:(UIBarButtonItem *)sender {
    [self.searchBar resignFirstResponder];
    
    [self performSegueWithIdentifier:@"unwindFromStationsToMain" sender:nil];
}

- (void) regroup
{
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

#pragma mark - Loading View

- (void) showLoadingViewWithAnimation:(BOOL)animation
{
    [self.loadingView.superview bringSubviewToFront:self.loadingView];
    [self.view bringSubviewToFront:self.searchBar];
    
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
            [self.tableView.superview bringSubviewToFront:self.tableView];
            self.loadingView.center = previousCenter;
        }];
    } else {
        [self.tableView.superview bringSubviewToFront:self.tableView];
    }
    
}

#pragma mark - SearchBar management

- (NSString *) searchRequest
{
    NSString * request = self.searchBar.text;
    if(nil == request || 0 == request.length)
    {
        return nil;
    }

    return request;
}

- (void) reloadSearchBar
{
    [self hideSearchBarWithAnimation:NO];
    [self setSearchRightBarButtonItem];
    [self setRightBarButtonItemEnabled:YES];
}

- (void) hideSearchBarWithAnimation:(BOOL)animated
{
    CGFloat constant = self.searchBarTopConstraint.constant;
    CGFloat searchBarHeight = self.searchBar.frame.size.height;

    if(0.f == constant) ; else return;

    self.searchBarTopConstraint.constant -= searchBarHeight;

    if(animated)
    {
        [UIView animateWithDuration:_durationOfSearchBarAnimation delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void) showSearchBarWithAnimation:(BOOL)animated
{
    CGFloat constant = self.searchBarTopConstraint.constant;
    
    if(0.f != constant) ; else return;

    self.searchBarTopConstraint.constant = 0.f;
    
    if(animated)
    {
        [UIView animateWithDuration:_durationOfSearchBarAnimation delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(nil == searchText || 0 == searchText.length)
    {
        // enable group bar button item
        [self setRightBarButtonItemEnabled:YES];
        
        [self.dataSourceSearchProxy reset];
        [self.tableView reloadData];
        return;
    }
    
    // if text is not empty, disable group bar button item
    [self setRightBarButtonItemEnabled:NO];
    
    [self.dataSourceSearchProxy searchText:searchText completion:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (BOOL) isSearchBarVisible
{
    CGFloat constant = self.searchBarTopConstraint.constant;
    return (0.f == constant);
}

#pragma mark - Recent management

- (void) prepareRecent
{
    self.recentIsEmpty = YES;
}

- (BOOL) showRecent
{
    return !self.recentIsEmpty && ![self isSearchBarVisible];
}

#pragma mark - Getters, setters
- (void) setStationsDataSource:(B32StationsDataSource *)stationsDataSource
{
    _stationsDataSource = stationsDataSource;

    self.dataSourceSearchProxy = [[B32StationSearchProxy alloc] initWithDataSource:stationsDataSource];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unwindFromStationsToMain"])
    {
        [self reloadSearchBar];
    }
}

@end
