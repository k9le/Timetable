//
//  B32StationSearchProxy.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 07/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "B32StationsDataSource.h"

@interface B32StationSearchProxy : NSObject

- (instancetype) initWithDataSource:(B32StationsDataSource *)dataSource;

@property (nonatomic, readonly) NSInteger numberOfSearchedItems;
- (B32StationItem * ) getSearchedStationAtIndex:(NSInteger)index;

- (void) searchText: (NSString *)request completion: (void (^)(void))completion;

- (void) reset;

@end
