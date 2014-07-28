//
//  T3TimeTable.h
//  TusurTimetable
//
//  Created by Katte on 29.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class T3Group, T3Lecturer;

@interface T3TimeTable : NSManagedObject

@property (nonatomic, retain) NSNumber * dayOfWeek;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * hide;
@property (nonatomic, retain) NSNumber * isOdd;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * lectureHall;
@property (nonatomic, retain) NSNumber * lessonNumber;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) T3Group *group;
@property (nonatomic, retain) T3Lecturer *lecturer;

@end
