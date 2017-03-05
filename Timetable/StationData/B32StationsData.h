//
//  B32StationsData.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "B32StationsDataSource.h"
#import "B32DataLoaderIFace.h"

@interface B32StationsData : NSObject

@property (atomic, readonly) B32StationsDataSource * fromStations;
@property (atomic, readonly) B32StationsDataSource * toStations;

@property (atomic, readonly) BOOL loaded;
@property (atomic) void (^completion)(void);

- (void) loadWithLoader:(id<B32DataLoaderIFace>)loader;

+ (instancetype) shared;

@end
