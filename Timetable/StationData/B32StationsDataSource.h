//
//  B32StationsDataSource.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 03/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationDataTypes.h"
#import "B32GroupableIFace.h"

@interface B32StationsDataSource : NSObject

- (instancetype) init;

- (void) addStation:(B32StationItem *) newItem;
@property (nonatomic, readonly) NSInteger stationCount;
- (B32StationItem *) getStationAtIndex:(NSInteger)index;


- (void) groupWithPattern:(id<B32GroupableIFace>)pattern completion: (void (^)(void)) completion;
@property (nonatomic, readonly) BOOL groupped;
@property (nonatomic, readonly) NSInteger groupCount;
@property (nonatomic, readonly) id<B32GroupableIFace> groupPattern;

- (NSInteger) getStationsCountInGroup: (NSInteger)groupIndex;
- (B32StationItem *) getStationInGroup: (NSInteger)groupIndex index:(NSInteger)index;
- (NSArray *) getStationsInGroup: (NSInteger)groupIndex;

@end
