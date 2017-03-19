//
//  B32StationMO+CoreDataClass.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 18/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StationDataTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface B32StationMO : NSManagedObject

- (instancetype) initWithStation:(B32StationItem *)station;

@property B32StationItem * station;

- (void) refreshDate;

+ (NSData *) encodeStation: (B32StationItem *)station;
+ (B32StationItem *) decodeStation: (NSData *)data;

@end

NS_ASSUME_NONNULL_END

#import "B32StationMO+CoreDataProperties.h"
