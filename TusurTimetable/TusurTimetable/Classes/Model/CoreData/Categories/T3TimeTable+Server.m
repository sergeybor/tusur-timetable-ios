//
//  T3TimeTable+Server.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimeTable+Server.h"

@implementation T3TimeTable (Server)

+ (T3TimeTable *)createTimetableFromServerObject:(NSDictionary *)serverDict
                                       inContext:(NSManagedObjectContext *)context
{
    T3TimeTable *timetable = [T3TimeTable createInContext:context];
    [timetable updateTimetableFromServerObject:serverDict];
    
    return timetable;

}

- (void)updateTimetableFromServerObject:(NSDictionary *)serverDict
{
    self.dayOfWeek = serverDict[@"day"];
    self.lectureHall = serverDict[@"room"];
    self.isOdd = serverDict[@"is_odd"];
    self.lessonNumber = serverDict[@"lesson_number"];
    self.shortName = serverDict[@"short_name"];
    self.fullName = serverDict[@"full_name"];
    self.kind = serverDict[@"kind"];
    self.teacher = serverDict[@"teacher"];
    self.note = serverDict[@"note"];
}


@end
