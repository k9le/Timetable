//
//  StationDataTypes.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 02/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class B32CityItem;

@interface B32PointItem : NSObject

@property (nonatomic) float longitude;
@property (nonatomic) float latitude;

+ (instancetype)itemWithLongitude:(float)longitude latitude: (float)latitude;

@end

@interface B32StationItem : NSObject

@property (nonatomic) NSString * countryTitle;
@property (nonatomic) B32PointItem * point;

@property (nonatomic) NSString * districtTitle;
@property (nonatomic) NSInteger cityId;
@property (nonatomic) NSString * cityTitle;
@property (nonatomic) NSString * regionTitle;

@property (nonatomic) NSInteger stationId;
@property (nonatomic) NSString * stationTitle;

@property (nonatomic, readonly) B32CityItem * city;

+ (instancetype) itemWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle
                            stationId: (NSInteger) stationId
                         stationTitle: (NSString * ) stationTitle
                                 city: (B32CityItem * ) city;


@end

@interface B32CityItem : NSObject

@property (nonatomic) NSString * countryTitle;
@property (nonatomic) B32PointItem * point;
@property (nonatomic) NSString * districtTitle;
@property (nonatomic) NSInteger cityId;
@property (nonatomic) NSString * cityTitle;
@property (nonatomic) NSString * regionTitle;


+ (instancetype) itemWithCountryTitle: (NSString * ) countryTitle
                                point: (B32PointItem *) point
                        districtTitle: (NSString * ) districtTitle
                               cityId: (NSInteger) cityId
                            cityTitle: (NSString * ) cityTitle
                          regionTitle: (NSString * ) regionTitle;

@end
