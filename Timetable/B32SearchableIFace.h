//
//  B32SearchableIFace.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 10/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32SearchRequest.h"

#ifndef B32SearchableIFace_h
#define B32SearchableIFace_h

@protocol B32SearchableIFace <NSObject>

@required
- (BOOL) doesItemSatisfyRequest:(B32SearchRequest *)request;

@end

#endif /* B32SearchableIFace_h */
