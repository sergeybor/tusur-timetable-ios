//
//  TimeTable.h
//  TusurTimetable
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lecture;

@interface TimeTable : NSManagedObject

@property (nonatomic, retain) NSNumber * dayOfWeek;
@property (nonatomic, retain) NSString * lectureHall;
@property (nonatomic, retain) NSNumber * weekEven;
@property (nonatomic, retain) Lecture *lecture;
@property (nonatomic, retain) NSManagedObject *timeslot;

@end
