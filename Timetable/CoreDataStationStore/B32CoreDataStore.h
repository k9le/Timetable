//
//  B32CoreDataStore.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 18/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface B32CoreDataStore : NSObject

@property (readonly, strong) NSPersistentContainer * persistentContainer;
@property (readonly) NSManagedObjectContext * managedObjectContext;

- (void)saveContext;

+ (instancetype) shared;

@end
