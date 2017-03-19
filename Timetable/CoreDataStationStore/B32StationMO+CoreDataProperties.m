//
//  B32StationMO+CoreDataProperties.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 18/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationMO+CoreDataProperties.h"

@implementation B32StationMO (CoreDataProperties)

+ (NSFetchRequest<B32StationMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StationMO"];
}

+ (NSFetchRequest<B32StationMO *> *)fetchRequestForFromStations:(BOOL)fromOrTo numberOfStationsToFetch:(NSInteger)number
{
    NSFetchRequest * fetchRequest = [self fetchRequest];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:(fromOrTo ? @"from == YES" : @"from == NO")];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchLimit = number;
    
    return fetchRequest;
}


@dynamic creationDate;
@dynamic stationData;
@dynamic from;

@end
