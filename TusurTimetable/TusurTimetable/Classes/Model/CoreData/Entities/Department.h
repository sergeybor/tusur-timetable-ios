//
//  Department.h
//  TusurTimetable
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Department : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSSet *groups;
@end

@interface Department (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(NSManagedObject *)value;
- (void)removeGroupsObject:(NSManagedObject *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
