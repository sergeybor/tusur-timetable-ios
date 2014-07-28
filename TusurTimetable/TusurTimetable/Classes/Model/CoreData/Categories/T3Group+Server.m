//
//  T3Group+Server.m
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Group+Server.h"
#import "T3UpdateManager.h"

@implementation T3Group (Server)

- (void)updateTimetableFromServerWithCompletion:(void (^)(NSError *error))completion
{
    [[T3UpdateManager defaultUpdateManager] loadTimetableForGroup:self complite:completion];
}

+ (T3Group *)createOrUpdateGroupFromServerObject:(NSDictionary *)serverDict
                                       inContext:(NSManagedObjectContext *)context
{
    NSNumber *groupID = serverDict[@"id"];
    T3Group *group = [T3Group findFirstByAttribute:@"serverID" withValue:groupID inContext:context];
    if (group == nil) {
        group = [T3Group createInContext:context];
        group.serverID = groupID;
    }
    
    [group updateGroupFromServerObject:serverDict];
    
    return group;
}

- (void)updateGroupFromServerObject:(NSDictionary *)serverDict
{
//    self.serverID = serverDict[@"id"];
    self.dirName = serverDict[@"dir_name"];
    self.name = serverDict[@"name"];
    self.facultyName = serverDict[@"faculty"];
    self.year = serverDict[@"year"];
}
- (void)cancelLoadFromServer
{
    [[T3UpdateManager defaultUpdateManager] cancelLoadTimetableForOwner:self];
}

@end
