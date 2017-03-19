//
//  B32MainTableView.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32MainTableView.h"
#import "B32FromToTableViewCell.h"
#import "B32DateTableViewCell.h"
#import "B32CoreDataStore.h"
#import "B32StationMO+CoreDataClass.h"


@implementation B32MainTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
        
        NSManagedObjectContext * context = [[B32CoreDataStore shared] managedObjectContext];
        
        NSFetchRequest * fetchRequest = [B32StationMO fetchRequestForFromStations:YES numberOfStationsToFetch:1];
        
        NSArray * stations = [context executeFetchRequest:fetchRequest error:nil];
        if(stations.count > 0)
        {
            B32StationMO * stationMO = [stations objectAtIndex:0];
            B32StationItem * stationItem = stationMO.station;
            self.fromStation = stationItem;
        }
        
        fetchRequest = [B32StationMO fetchRequestForFromStations:NO numberOfStationsToFetch:1];
        
        stations = [context executeFetchRequest:fetchRequest error:nil];
        if(stations.count > 0)
        {
            B32StationMO * stationMO = [stations objectAtIndex:0];
            B32StationItem * stationItem = stationMO.station;
            self.toStation = stationItem;
        }

    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];

    B32FromToTableViewCell * cell = [self dequeueReusableCellWithIdentifier:@"FromToCell"];
    
    typedef void (^SetCellDefaultBlock)(void);
    typedef void (^SetCellStationBlock)(B32StationItem * station);
    
    SetCellDefaultBlock setDefaultBlock = ^{
        cell.valueLabel.textColor = [UIColor grayColor];
        [cell setFromToValueLabelText: @"Выберите станцию"];
    };
    
    SetCellStationBlock setStationBlock = ^(B32StationItem * station){
        cell.valueLabel.textColor = [UIColor blackColor];
        
        NSString * string = [NSString stringWithFormat:@"%@, %@, %@", station.stationTitle, station.city.cityTitle, station.city.countryTitle];
        [cell setFromToValueLabelText:string];
    };
    
    
    if (0 == row) {
        
        [cell setFromToLabelText: @"Откуда"];
        [cell setType:B32FromToTableViewCellTypeFrom];
        if(nil == self.fromStation)
        {
            setDefaultBlock();
        } else {
            setStationBlock(self.fromStation);
        }
        
    } else if (1 == row) {

        [cell setFromToLabelText: @"Куда"];
        [cell setType:B32FromToTableViewCellTypeTo];
        if(nil == self.toStation)
        {
            setDefaultBlock();
        } else {
            setStationBlock(self.toStation);
        }
        
    } else if (2 == row) {
        B32DateTableViewCell * dateCell = [self dequeueReusableCellWithIdentifier:@"DateCell"];
        
        if(nil != self.date)
        {
            dateCell.actualDate = self.date;
        }

        return dateCell;
    }
    
    return cell;
    
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    NSIndexPath * indexPathForReload = [NSIndexPath indexPathForRow:2 inSection:0];
    [self reloadRowsAtIndexPaths:@[indexPathForReload] withRowAnimation:UITableViewRowAnimationNone];
}


@end
