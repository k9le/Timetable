//
//  B32GroupableIFace.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#ifndef B32GroupableIFace_h
#define B32GroupableIFace_h

@protocol B32GroupableIFace <NSObject>

@required

- (BOOL) isObject:(id)obj1 groupLessThanObject:(id)obj2;

- (NSString *) groupHeader: (id) obj;

@end


#endif /* B32GroupableIFace_h */
