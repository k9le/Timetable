//
//  B32SearchCache.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "B32SearchRequest.h"

@interface B32SearchCache : NSObject

- (instancetype) init;

- (void) addNewRequest:(B32SearchRequest *) request results:(NSArray *)results;
- (NSArray * ) checkIfCached: (B32SearchRequest *) request;

@end
