//
//  Timeslot.h
//  TusurTimetable
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TimeTable;

@interface Timeslot : NSManagedObject

@property (nonatomic, retain) NSDate * timeFrom;
@property (nonatomic, retain) NSDate * timeTo;
@property (nonatomic, retain) NSSet *timeTable;
@end

@interface Timeslot (CoreDataGeneratedAccessors)

- (void)addTimeTableObject:(TimeTable *)value;
- (void)removeTimeTableObject:(TimeTable *)value;
- (void)addTimeTable:(NSSet *)values;
- (void)removeTimeTable:(NSSet *)values;

@end
