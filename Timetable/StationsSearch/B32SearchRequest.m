//
//  B32SearchRequest.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32SearchRequest.h"

@interface B32SearchRequest ()

@property (nonatomic) NSMutableArray * searchStrings;

@end

@implementation B32SearchRequest

- (instancetype) initWithString:(NSString *) string
{
    self = [super init];
    
    if(nil != self)
    {
        _searchStrings = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@" "]];
        
        NSPredicate * notNulLength = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            
            NSString * evaluatedString = (NSString * )evaluatedObject;
            
            return  (nil == evaluatedString || 0 == evaluatedString.length) ? NO : YES ;
            
        }];
        [_searchStrings filterUsingPredicate:notNulLength];
    }
    
    return self;
}

- (BOOL) isSubrequestOf: (B32SearchRequest*) otherRequest
{
    for(NSString * otherString in otherRequest.searchStrings)
    {
        BOOL contains = NO;
        for(NSString * thisString in self.searchStrings)
        {
            if([thisString localizedCaseInsensitiveContainsString:otherString])
            {
                contains = YES;
                break;
            }
        }
        
        if(NO == contains) return NO;
    }
    
    return YES;
}

- (NSArray *)substrings
{
    return self.searchStrings;
}

@end

