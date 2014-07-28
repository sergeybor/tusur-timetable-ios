//
//  T3Lecturer.h
//  TusurTimetable
//
//  Created by Katte on 29.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class T3TimeTable;

@interface T3Lecturer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSSet *timetable;
@end

@interface T3Lecturer (CoreDataGeneratedAccessors)

- (void)addTimetableObject:(T3TimeTable *)value;
- (void)removeTimetableObject:(T3TimeTable *)value;
- (void)addTimetable:(NSSet *)values;
- (void)removeTimetable:(NSSet *)values;

@end
