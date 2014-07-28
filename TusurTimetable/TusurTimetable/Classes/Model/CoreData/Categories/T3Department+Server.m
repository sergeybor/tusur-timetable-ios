//
//  T3Department+Server.m
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Department+Server.h"

#import "T3Group+Server.h"

#import "T3UpdateManager.h"

@implementation T3Department (Server)

+ (void)updateDepartmentsFromServerWithCompletion:(void (^)(NSError *error))completion
{
    [[T3UpdateManager defaultUpdateManager] loadGroups:completion];
}

+ (void)cancelLoadFromServer
{
    [[T3UpdateManager defaultUpdateManager] cancelLoadGroups];
}

+ (void)createOrUpdateDepartmentsInContext:(NSManagedObjectContext *)context
{
    NSArray *groups = [T3Group findAllInContext:context];
    for (T3Group *group in groups) {
        T3Department *dep = [T3Department findFirstByAttribute:@"name" withValue:group.facultyName inContext:context];
        if (dep == nil) {
            dep = [T3Department createInContext:context];
            dep.name = group.facultyName;
        }
        [dep addGroupsObject:group];
        group.department = dep;
    }
}

@end
