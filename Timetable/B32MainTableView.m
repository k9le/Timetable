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

@implementation B32MainTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
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
    
    if (0 == row) {
        
        [cell setFromToLabelText: @"Откуда"];
        [cell setFromToValueLabelText: @"123"];
        
    } else if (1 == row) {

        [cell setFromToLabelText: @"Куда"];
        [cell setFromToValueLabelText: @"123"];
        
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
