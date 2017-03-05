//
//  B32JSONFileLoader.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32JSONFileLoader.h"
#import "B32StationsData.h"
#import "StationDataTypes.h"

#define __FROMSTATIONSKEY__ @"citiesFrom"
#define __TOSTATIONSKEY__ @"citiesTo"

@interface B32JSONFileLoader ()

- (NSURL *)JSONUrl;
- (void)loadArray:(NSString *) identifier source: (NSArray *) src;

@end


@implementation B32JSONFileLoader

- (NSURL *)JSONUrl
{
    return [[NSBundle mainBundle] URLForResource:@"allStations" withExtension:@".json"];
}

- (void)loadStationData
{
    NSURL * jsonUrl = [self JSONUrl];
    NSData * jsonData = [NSData dataWithContentsOfURL:jsonUrl];
    
    NSDictionary * jsonGeneralDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray * fromStations = jsonGeneralDict[__FROMSTATIONSKEY__];
    NSArray * toStations = jsonGeneralDict[__TOSTATIONSKEY__];
    
    [self loadArray:__FROMSTATIONSKEY__ source:fromStations];
    [self loadArray:__TOSTATIONSKEY__ source:toStations];
}

- (void)loadArray:(NSString *) identifier source: (NSArray *) src
{
    B32StationsData * stationsData = [B32StationsData shared];

    B32StationsDataSource * dstArray = ([identifier isEqualToString:__FROMSTATIONSKEY__]) ? stationsData.fromStations : stationsData.toStations;
    
    for (NSDictionary * city in src)
    {
        NSString * countryTitle = city[@"countryTitle"];
        NSNumber * longitude = city[@"point"][@"longitude"];
        NSNumber * latitude = city[@"point"][@"latitude"];
        B32PointItem * point = [B32PointItem itemWithLongitude:longitude.floatValue latitude:latitude.floatValue];
        NSString * districtTitle = city[@"districtTitle"];
        NSNumber * cityId = city[@"cityId"];
        NSString * cityTitle = city[@"cityTitle"];
        NSString * regionTitle = city[@"regionTitle"];
        
        B32CityItem * cityItem = [B32CityItem itemWithCountryTitle:countryTitle point:point districtTitle:districtTitle cityId:cityId.integerValue cityTitle:cityTitle regionTitle:regionTitle];
        
        NSArray * stations = city[@"stations"];
        
        for(NSDictionary * station in stations)
        {
            
            NSString * countryTitle = station[@"countryTitle"];
            NSNumber * longitude = station[@"point"][@"longitude"];
            NSNumber * latitude = station[@"point"][@"latitude"];
            B32PointItem * point = [B32PointItem itemWithLongitude:longitude.floatValue latitude:latitude.floatValue];
            NSString * districtTitle = station[@"districtTitle"];
            NSNumber * cityId = station[@"cityId"];
            NSString * cityTitle = station[@"cityTitle"];
            NSString * regionTitle = station[@"regionTitle"];
            
            NSNumber * stationId = station[@"stationId"];
            NSString * stationTitle = station[@"stationTitle"];
            
            B32StationItem * stationItem = [B32StationItem itemWithCountryTitle:countryTitle point:point districtTitle:districtTitle cityId:cityId.integerValue cityTitle:cityTitle regionTitle:regionTitle stationId:stationId.integerValue stationTitle:stationTitle city:cityItem];
            
            [dstArray addStation:stationItem];
        }
    }
    
}

@end
