//
//  B32SearchRequest.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B32SearchRequest : NSObject

- (instancetype) initWithString:(NSString *) string;
- (BOOL) isSubrequestOf: (B32SearchRequest*) otherRequest;

@property (nonatomic, readonly) NSArray * substrings;

@end
