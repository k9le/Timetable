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

- (BOOL)doesItemSatisfyRequest:(B32SearchRequest *)request
{
    NSArray * substrings = [request substrings];
    
    for(NSString * substring in substrings)
    {
        if(
           [_countryTitle localizedCaseInsensitiveContainsString:substring] ||
           [_districtTitle localizedCaseInsensitiveContainsString:substring] ||
           [_cityTitle localizedCaseInsensitiveContainsString:substring] ||
           [_regionTitle localizedCaseInsensitiveContainsString:substring] ||
           [_stationTitle localizedCaseInsensitiveContainsString:substring] ||
           [self.city.countryTitle localizedCaseInsensitiveContainsString:substring] ||
           [self.city.districtTitle localizedCaseInsensitiveContainsString:substring] ||
           [self.city.cityTitle localizedCaseInsensitiveContainsString:substring] ||
           [self.city.regionTitle localizedCaseInsensitiveContainsString:substring]
           ) {;} else {
            return NO;
        }
    }
    
    return YES;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(nil != self)
    {
        _countryTitle = [aDecoder decodeObjectForKey:@"countryTitle"];
        float longitude = [aDecoder decodeFloatForKey:@"longitude"];
        float latitude = [aDecoder decodeFloatForKey:@"latitude"];
        _point = [B32PointItem itemWithLongitude:longitude latitude:latitude];
        
        _districtTitle = [aDecoder decodeObjectForKey:@"districtTitle"];
        _cityId = [aDecoder decodeIntegerForKey:@"cityId"];
        _cityTitle = [aDecoder decodeObjectForKey:@"cityTitle"];
        _regionTitle = [aDecoder decodeObjectForKey:@"regionTitle"];
        
        _stationId = [aDecoder decodeIntegerForKey:@"stationId"];
        _stationTitle = [aDecoder decodeObjectForKey:@"stationTitle"];
        
        _city = [aDecoder decodeObjectForKey:@"city"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_countryTitle forKey:@"countryTitle"];
    [aCoder encodeFloat:self.point.longitude forKey:@"longitude"];
    [aCoder encodeFloat:self.point.latitude forKey:@"latitude"];

    [aCoder encodeObject:_districtTitle forKey:@"districtTitle"];
    [aCoder encodeInteger:_cityId forKey:@"cityId"];
    [aCoder encodeObject:_cityTitle forKey:@"cityTitle"];
    [aCoder encodeObject:_regionTitle forKey:@"regionTitle"];
    
    [aCoder encodeInteger:_stationId forKey:@"stationId"];
    [aCoder encodeObject:_stationTitle forKey:@"stationTitle"];
    
    [aCoder encodeObject:_city forKey:@"city"];
}

@end


@interface B32CityItem ()

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

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(nil != self)
    {
        _countryTitle = [aDecoder decodeObjectForKey:@"countryTitle"];
        float longitude = [aDecoder decodeFloatForKey:@"longitude"];
        float latitude = [aDecoder decodeFloatForKey:@"latitude"];
        _point = [B32PointItem itemWithLongitude:longitude latitude:latitude];
        
        _districtTitle = [aDecoder decodeObjectForKey:@"districtTitle"];
        _cityId = [aDecoder decodeIntegerForKey:@"cityId"];
        _cityTitle = [aDecoder decodeObjectForKey:@"cityTitle"];
        _regionTitle = [aDecoder decodeObjectForKey:@"regionTitle"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_countryTitle forKey:@"countryTitle"];
    [aCoder encodeFloat:self.point.longitude forKey:@"longitude"];
    [aCoder encodeFloat:self.point.latitude forKey:@"latitude"];
    
    [aCoder encodeObject:_districtTitle forKey:@"districtTitle"];
    [aCoder encodeInteger:_cityId forKey:@"cityId"];
    [aCoder encodeObject:_cityTitle forKey:@"cityTitle"];
    [aCoder encodeObject:_regionTitle forKey:@"regionTitle"];
}

@end
