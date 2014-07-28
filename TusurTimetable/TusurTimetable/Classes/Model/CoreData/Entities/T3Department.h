//
//  T3Department.h
//  TusurTimetable
//
//  Created by Katte on 29.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class T3Group;

@interface T3Department : NSManagedObject

@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *groups;
@end

@interface T3Department (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(T3Group *)value;
- (void)removeGroupsObject:(T3Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
