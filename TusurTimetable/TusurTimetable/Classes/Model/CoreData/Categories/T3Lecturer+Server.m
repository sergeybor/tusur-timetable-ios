//
//  T3Lecturer+Server.m
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Lecturer+Server.h"
#import "T3UpdateManager.h"

@implementation T3Lecturer (Server)

+ (void)updateLecturersFromServerWithCompletion:(void (^)(NSError *error))completion
{
    [[T3UpdateManager defaultUpdateManager] loadLecturers:completion];
}

+ (T3Lecturer *)createLecturerFromServerObject:(NSDictionary *)serverDict
                                     inContext:(NSManagedObjectContext *)context
{
    NSNumber *lecturerID = serverDict[@"id"];
    T3Lecturer *lecturer = [T3Lecturer findFirstByAttribute:@"serverID" withValue:lecturerID inContext:context];
    if (lecturer == nil) {
        lecturer = [T3Lecturer createInContext:context];
        lecturer.serverID = lecturerID;
    }
    
    [lecturer updateLecturerFromServerObject:serverDict];
    
    return lecturer;

}

+ (void)cancelLoadFromServer
{
    [[T3UpdateManager defaultUpdateManager] cancelLoadLecturers];
}

- (void)updateLecturerFromServerObject:(NSDictionary *)serverDict
{
//    self.serverID = serverDict[@"id"];
    self.name = serverDict[@"name"];
}

@end
