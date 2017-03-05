//
//  B32StationsDataSource.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 03/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationsDataSource.h"

@interface B32StationsDataSource ()

@property (nonatomic) NSMutableArray * stations;
@property (nonatomic) NSMutableArray * stationGroups;
@property (nonatomic, readwrite) id<B32GroupableIFace> groupPattern;

@end

@implementation B32StationsDataSource

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        _stations = [[NSMutableArray alloc] init];
        
        _stationGroups = nil;
        _groupPattern = nil;
    }

    return self;
}

- (void) addStation:(B32StationItem *) newItem
{
    [self.stations addObject:newItem];
}

- (NSInteger)stationCount
{
    return self.stations.count;
}

- (B32StationItem *) getStationAtIndex:(NSInteger)index
{
    return [self.stations objectAtIndex:index];
}

- (void) groupWithPattern:(id<B32GroupableIFace>)pattern completion: (void (^)(void)) completion
{
    self.stationGroups = nil;
    
    [self.stations sortUsingComparator:^(id obj1, id obj2) {
        if([pattern isObject:obj1 groupLessThanObject:obj2])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if([pattern isObject:obj2 groupLessThanObject:obj1])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    typedef BOOL (^EqualByGroup)(B32StationItem *, B32StationItem *);
    
    EqualByGroup equalByGroup = ^(B32StationItem * item1, B32StationItem * item2) {
        if(![pattern isObject:item1 groupLessThanObject:item2] && ![pattern isObject:item2 groupLessThanObject:item1])
        {
            return YES;
        }
        
        return NO;
    };
    
    NSMutableArray * stationGroups_ = [[NSMutableArray alloc] init];
    for(NSInteger i = 0, im = self.stations.count; i < im; )
    {
        
        [stationGroups_ addObject:@(i)];
        
        B32StationItem * iItem = [self.stations objectAtIndex:i];
        
        NSInteger j = i + 1;
        for(; j < im; ++j)
        {
            B32StationItem * jItem = [self.stations objectAtIndex:j];
            
            if(!equalByGroup(iItem, jItem)) break;
        }
        
        i = j;
    }
    
    self.stationGroups = stationGroups_;
    self.groupPattern = pattern;
    
    if(nil != completion) completion();
}

- (BOOL) groupped
{
    return (nil != self.stationGroups);
}

- (NSInteger) groupCount
{
    BOOL groupped = self.groupped;
    return groupped ? self.stationGroups.count : 1;
}

- (NSInteger) getStationsCountInGroup: (NSInteger)groupIndex
{
    BOOL groupped = self.groupped;
    
    if (groupped)
    {
        NSInteger groupCount = self.groupCount;
        if (groupIndex == groupCount - 1)
        {
            NSNumber * prev = self.stationGroups[groupIndex];
            
            return self.stations.count - [prev integerValue];
        } else {
            NSNumber * next = self.stationGroups[groupIndex + 1];
            NSNumber * prev = self.stationGroups[groupIndex];
            
            return [next integerValue] - [prev integerValue];
        }
    } else {
        return self.stations.count;
    }
}

- (B32StationItem *) getStationInGroup: (NSInteger)groupIndex index:(NSInteger)index
{
    BOOL groupped = self.groupped;
    
    if (groupped)
    {
        NSNumber * prev = self.stationGroups[groupIndex];
        NSInteger firstStationIndex = [prev integerValue];

        return self.stations[firstStationIndex + index];
    } else {
        return self.stations[index];
    }
    
}

- (NSArray *) getStationsInGroup: (NSInteger)groupIndex
{
    BOOL groupped = self.groupped;
    
    if (groupped)
    {
        NSNumber * prev = self.stationGroups[groupIndex];
        NSRange range = NSMakeRange([prev integerValue], [self getStationsCountInGroup:groupIndex]);
        return [self.stations subarrayWithRange:range];
    } else {
        return self.stations;
    }
    
}

@end
