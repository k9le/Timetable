//
//  B32GroupByCityCountry.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32GroupByCityCountryPattern.h"

@implementation B32GroupByCityCountryPattern

- (BOOL)isObject:(id)obj1 groupLessThanObject:(id)obj2
{
    B32StationItem * item1 = (B32StationItem *) obj1;
    B32StationItem * item2 = (B32StationItem *) obj2;
    
    
    NSString * city1 = item1.city.cityTitle;
    NSString * city2 = item2.city.cityTitle;
    if([city1 isEqualToString:city2])
    {
        
        NSString * country1 = item1.city.countryTitle;
        NSString * country2 = item2.city.countryTitle;

        return (NSOrderedAscending == [country1 compare:country2 options:NSCaseInsensitiveSearch]) ? YES : NO;
    }
    
    if(NSOrderedAscending == [city1 compare:city2 options:NSCaseInsensitiveSearch]) return YES;
    
    return NO;
}

- (NSString *) groupHeader: (id) obj
{
    B32StationItem * item = (B32StationItem *) obj;
    
    return [NSString stringWithFormat:@"%@, %@", item.city.cityTitle, item.city.countryTitle];
}

@end
