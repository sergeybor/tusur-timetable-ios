//
//  Lecturer.h
//  TusurTimetable
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Lecturer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *lectures;
@end

@interface Lecturer (CoreDataGeneratedAccessors)

- (void)addLecturesObject:(NSManagedObject *)value;
- (void)removeLecturesObject:(NSManagedObject *)value;
- (void)addLectures:(NSSet *)values;
- (void)removeLectures:(NSSet *)values;

@end
