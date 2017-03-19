//
//  B32StationMO+CoreDataClass.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 18/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationMO+CoreDataClass.h"
#import "B32CoreDataStore.h"

@interface B32StationMO ()


@end


@implementation B32StationMO

- (instancetype) initWithStation:(B32StationItem *)station
{
    NSManagedObjectContext * context = [[B32CoreDataStore shared] managedObjectContext];
    NSEntityDescription * descr = [NSEntityDescription entityForName:@"StationMO" inManagedObjectContext:context];
    
    self = [super initWithEntity:descr insertIntoManagedObjectContext:context];
    if (nil != self)
    {
        self.stationData = [[self class] encodeStation:station];
        self.creationDate = [NSDate date];
    }
    
    return self;
}

+ (NSData *) encodeStation: (B32StationItem *)station
{
    return [NSKeyedArchiver archivedDataWithRootObject:station];
}

+ (B32StationItem *) decodeStation: (NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (B32StationItem *)station
{
    return [[self class] decodeStation:self.stationData];
}

- (void)setStation:(B32StationItem *)station
{
    self.stationData = [[self class] encodeStation:station];
}

- (void) refreshDate
{
    self.creationDate = [NSDate date];
}

@end
