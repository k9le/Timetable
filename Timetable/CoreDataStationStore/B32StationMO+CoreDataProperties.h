//
//  B32StationMO+CoreDataProperties.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 18/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface B32StationMO (CoreDataProperties)

+ (NSFetchRequest<B32StationMO *> *)fetchRequest;
+ (NSFetchRequest<B32StationMO *> *)fetchRequestForFromStations:(BOOL)fromOrTo numberOfStationsToFetch:(NSInteger)number;

@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSData *stationData;
@property (nonatomic) BOOL from;

@end

NS_ASSUME_NONNULL_END
