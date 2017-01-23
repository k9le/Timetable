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

        return [self dequeueReusableCellWithIdentifier:@"DateCell"];
    }
    
    return cell;
    
}


@end
