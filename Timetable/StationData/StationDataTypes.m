//
//  StationDataTypes.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 02/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "StationDataTypes.h"

@interface B32PointItem ()

- (instancetype)initWithLongitude:(float)longitude latitude: (float)latitude;

@end

@implementation B32PointItem

- (instancetype)initWithLongitude:(float)longitude latitude: (float)latitude
{
    self = [super init];
    
    if (nil != self)
    {
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
}

+ (instancetype)itemWithLongitude:(float)longitude latitude: (float)latitude
{
    return [[B32PointItem alloc] initWithLongitude:longitude latitude:latitude];
}

@end

@interface B32StationItem ()

- (instancetype) initWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
                            stationId: (NSInteger) stationId
                         stationTitle: (NSString * ) stationTitle
                                 city: (B32CityItem * ) city;



@end

@implementation B32StationItem


- (instancetype) initWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
                            stationId: (NSInteger) stationId
                         stationTitle: (NSString * ) stationTitle
                                 city: (B32CityItem * ) city
{
    self = [super init];
    
    if (nil != self)
    {
        _countryTitle = countryTitle;
        _point = point;
        _districtTitle = districtTitle;
        _cityId = cityId;
        _cityTitle = cityTitle;
        _regionTitle = regionTitle;
        _stationId = stationId;
        _stationTitle = stationTitle;
        
        _city = city;
    }
    
    return self;
}

+ (instancetype) itemWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
                            stationId: (NSInteger) stationId
                         stationTitle: (NSString * ) stationTitle
                                 city: (B32CityItem * ) city
{
    return [[B32StationItem alloc] initWithCountryTitle:countryTitle point:point districtTitle:districtTitle cityId:cityId cityTitle:cityTitle regionTitle:regionTitle stationId:stationId stationTitle:stationTitle city:city];
}

@end


@interface B32CityItem ()

@property (nonatomic, readwrite) NSPointerArray * stations;

- (instancetype) initWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle;


@end

@implementation B32CityItem

- (instancetype) initWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
{
    self = [super init];
    
    if (nil != self)
    {
        _countryTitle = countryTitle;
        _point = point;
        _districtTitle = districtTitle;
        _cityId = cityId;
        _cityTitle = cityTitle;
        _regionTitle = regionTitle;
    }
    
    return self;
}

+ (instancetype) itemWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
{
    return [[B32CityItem alloc] initWithCountryTitle:countryTitle point:point districtTitle:districtTitle cityId:cityId cityTitle:cityTitle regionTitle:regionTitle];
}

@end
