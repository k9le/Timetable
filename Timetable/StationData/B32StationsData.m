//
//  B32StationsData.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationsData.h"
#import "B32GroupByCountryCityPattern.h"

@interface B32StationsData ()

- (instancetype)init;

@property (atomic, readwrite) BOOL loaded;

@end

@implementation B32StationsData

- (instancetype)init
{
    self = [super init];
    
    if(nil != self)
    {
        _fromStations = [[B32StationsDataSource alloc] init];
        _toStations = [[B32StationsDataSource alloc] init];
        
        _loaded = NO;
    }
    
    return self;
}

- (void) loadWithLoader:(id<B32DataLoaderIFace>)loader
{
    // Delay for demonstration
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{

    [loader loadStationData];
    
    B32GroupByCountryCityPattern * pattern = [[B32GroupByCountryCityPattern alloc] init];
    
    [self.fromStations groupWithPattern:pattern completion:nil];
    [self.toStations groupWithPattern:pattern completion:nil];


    self.loaded = YES;

    if(nil != self.completion)
    {
        self.completion();
        self.completion = nil;
    }
        
    });
}

+ (instancetype) shared
{
    static dispatch_once_t pred;
    static B32StationsData * sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}



@end
