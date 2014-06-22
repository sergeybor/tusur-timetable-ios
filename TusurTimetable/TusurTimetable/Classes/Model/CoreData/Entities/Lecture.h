//
//  Lecture.h
//  TusurTimetable

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lecturer;

@interface Lecture : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) Lecturer *lecturer;
@property (nonatomic, retain) NSSet *timetable;
@end

@interface Lecture (CoreDataGeneratedAccessors)

- (void)addTimetableObject:(NSManagedObject *)value;
- (void)removeTimetableObject:(NSManagedObject *)value;
- (void)addTimetable:(NSSet *)values;
- (void)removeTimetable:(NSSet *)values;

@end
