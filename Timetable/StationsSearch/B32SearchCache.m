//
//  B32SearchCache.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32SearchCache.h"

@interface B32SearchCache ()
{
    NSInteger _maxNumberOfCachedRequests;
}
@property (nonatomic) NSMutableArray * searchRequests;
@property (nonatomic) NSMutableArray * searchResults;

@end

@implementation B32SearchCache

- (instancetype) init
{
    self = [super init];

    if(nil != self)
    {
        _maxNumberOfCachedRequests = 10;
        
        _searchRequests = [NSMutableArray arrayWithCapacity:_maxNumberOfCachedRequests];
        _searchResults = [NSMutableArray arrayWithCapacity:_maxNumberOfCachedRequests];
    }
    
    return self;
}

- (void) addNewRequest:(B32SearchRequest *) request results:(NSArray *)results;
{
    NSUInteger sizeOfCachedRepository = self.searchRequests.count;
    
    if(sizeOfCachedRepository == _maxNumberOfCachedRequests)
    {
        [self.searchRequests removeLastObject];
        [self.searchResults removeLastObject];
    }
    
    [self.searchRequests insertObject:request atIndex:0];
    [self.searchResults insertObject:results atIndex:0];
}

- (NSArray * ) checkIfCached: (B32SearchRequest *) request
{
    NSUInteger sizeOfCachedRepository = self.searchRequests.count;

    for(NSUInteger i = 0; i < sizeOfCachedRepository; ++i)
    {
        B32SearchRequest * cachedRequest = self.searchRequests[i];
        if([request isSubrequestOf:cachedRequest])
        {
            return self.searchResults[i];
        }
    }
    
    return nil;
}



@end
