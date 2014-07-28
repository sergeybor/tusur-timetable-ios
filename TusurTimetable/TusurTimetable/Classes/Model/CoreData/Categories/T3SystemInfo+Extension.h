//
//  T3SystemInfo+Extension.h
//  TusurTimetable
//
//  Created by Katte on 18.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3SystemInfo.h"

@class T3Group;

@interface T3SystemInfo (Extension)

+ (NSDate *)groupsTimestamp;
+ (NSDate *)lecturersTimestamp;
+ (NSDate *)timetableTimestampForOwner:(NSManagedObject *)owner;

+ (void)updateGroupsTimestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context;
+ (void)updateLecturersTimestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context;
+ (void)updateTimetableForOwner:(NSManagedObject *)owner timestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context;

@end
