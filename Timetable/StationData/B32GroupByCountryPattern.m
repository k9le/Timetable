//
//  B32GroupByCountryPattern.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 05/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32GroupByCountryPattern.h"

@implementation B32GroupByCountryPattern

- (BOOL)isObject:(id)obj1 groupLessThanObject:(id)obj2
{
    B32StationItem * item1 = (B32StationItem *) obj1;
    B32StationItem * item2 = (B32StationItem *) obj2;
    
    NSString * country1 = item1.city.countryTitle;
    NSString * country2 = item2.city.countryTitle;
    
    if(NSOrderedAscending == [country1 compare:country2 options:NSCaseInsensitiveSearch]) return YES;
    
    return NO;
}

- (NSString *) groupHeader: (id) obj
{
    B32StationItem * item = (B32StationItem *) obj;
    
    return item.city.countryTitle;
}

@end
