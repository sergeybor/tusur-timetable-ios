//
//  T3TimeTable+Server.h
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimeTable.h"

@class T3Group;

@interface T3TimeTable (Server)

+ (T3TimeTable *)createTimetableFromServerObject:(NSDictionary *)serverDict
                                       inContext:(NSManagedObjectContext *)context;

@end
