//
//  IT3TimetableCell.h
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>

@class T3TimeTable;

@protocol IT3TimetableCell <NSObject>

- (void)configureWithTimetable:(T3TimeTable *)timetable;
+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable;
+ (CGFloat)heightForItem:(T3TimeTable *)timetable;

@end
