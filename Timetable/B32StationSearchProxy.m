//
//  B32StationSearchProxy.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 07/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationSearchProxy.h"
#import "B32SearchRequest.h"
#import "B32SearchCache.h"

#define __USECACHE__ YES

@interface B32StationSearchProxy ()

@property (nonatomic) NSOperationQueue * asyncQueue;

@property (nonatomic, readonly) B32StationsDataSource * dataSource;
@property (nonatomic) B32SearchCache * cache;

@property (atomic) NSArray * lastResult;
@property (atomic) B32SearchRequest * lastRequest;

- (void) reinitialize;

- (void) searchRequest:(B32SearchRequest *)request inCached:(NSArray *)cached;


@end

@implementation B32StationSearchProxy

- (instancetype) initWithDataSource:(B32StationsDataSource *)dataSource
{
    self = [super init];
    
    if(nil != self)
    {
        _dataSource = dataSource;
        
        [self reinitialize];
    }
    
    return self;
    
}
- (void) reinitialize
{
    _asyncQueue = [[NSOperationQueue alloc] init];
    _asyncQueue.qualityOfService = NSQualityOfServiceUserInteractive;
    _asyncQueue.maxConcurrentOperationCount = 1; // serial queue
    
    if(__USECACHE__) _cache = [[B32SearchCache alloc] init];
}

- (void) searchText: (NSString *)request completion: (void (^)(void))completion
{
    
    [self.asyncQueue addOperationWithBlock:^{

        B32SearchRequest * newRequest = [[B32SearchRequest alloc] initWithString:request];
        
        if(__USECACHE__)
        {
            NSArray * cachedResult = [self.cache checkIfCached:newRequest];
            [self searchRequest:newRequest inCached:cachedResult];
        } else {
            [self searchRequest:newRequest inCached:nil];
        }
        
        if(nil != completion) completion();
    }];
}

- (void) searchRequest:(B32SearchRequest *)request inCached:(NSArray *)cached
{
    NSMutableArray * searched = [[NSMutableArray alloc] init];

    if(nil == cached)
    {
        // SEARCH IN ALL
        NSInteger count = [self.dataSource stationCount];
        for(NSInteger i = 0; i < count; ++i)
        {
            B32StationItem * stationItem = [self.dataSource getStationAtIndex:i];
            if([stationItem doesItemSatisfyRequest:request])
            {
                [searched addObject:@(i)];
            }
        }
        
    } else {
        NSInteger count = [cached count];
        for(NSInteger i = 0; i < count; ++i)
        {
            NSInteger index = [((NSNumber *) cached[i]) integerValue];
            
            B32StationItem * stationItem = [self.dataSource getStationAtIndex:index];
            if([stationItem doesItemSatisfyRequest:request])
            {
                [searched addObject:@(index)];
            }
        }
        
    }
    
    if(__USECACHE__) {
        if ((nil != cached && 0 == cached.count) && 0 == searched.count)
        {
            // if 0 results in this search,  AND 0 results in cached search - don't add subrequest in cache (no sense)
        } else {
            [self.cache addNewRequest:request results:searched];
        }
    }
    
    self.lastResult = searched;
    self.lastRequest = request;
}

- (void) reset
{
    [self reinitialize];
}

- (NSInteger)numberOfSearchedItems
{
    return (nil == self.lastResult) ? 0 : self.lastResult.count;
}

- (B32StationItem * ) getSearchedStationAtIndex:(NSInteger)index
{
    NSInteger indexInDataSource = [((NSNumber *) self.lastResult[index]) integerValue];
    return [self.dataSource getStationAtIndex:indexInDataSource];
}


@end
