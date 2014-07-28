//
//  T3TimeTable+Extension.h
//  TusurTimetable
//
//  Created by Katte on 24.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimeTable.h"

@interface T3TimeTable (Extension)

+ (NSString *)stringToDayNumber:(NSInteger)number isOddWeek:(BOOL)isOddWeek;

- (NSString *)stringWeekDay;
- (NSString *)stringPartily;
- (NSString *)stringLessonTime;

- (BOOL)isEmpty;

+ (void)markUnnecessaryTimetableItemsAsInvisibleForOwner:(NSManagedObject *)owner inContext:(NSManagedObjectContext *)context;

@end
