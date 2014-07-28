//
//  T3SystemInfo+Extension.m
//  TusurTimetable
//
//  Created by Katte on 18.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3SystemInfo+Extension.h"
#import "T3Group.h"
#import "T3Lecturer.h"

typedef enum {
    T3SystemInfoGroupTimetable      = 1001,
    T3SystemInfoLecturerTimetable   = 1002,
    T3SystemInfoDepartmentsAndGroups = 1003,
    T3SystemInfoLecturers            = 1004
} T3SystemInfoType;

@implementation T3SystemInfo (Extension)

+ (NSDate *)groupsTimestamp
{
    T3SystemInfo *info = [T3SystemInfo findFirstByAttribute:@"itemType" withValue:@(T3SystemInfoDepartmentsAndGroups)];
    return info.itemTimestamp;
}

+ (NSDate *)lecturersTimestamp
{
    T3SystemInfo *info = [T3SystemInfo findFirstByAttribute:@"itemType" withValue:@(T3SystemInfoLecturers)];
    return info.itemTimestamp;
}

+ (NSDate *)timetableTimestampForOwner:(NSManagedObject *)owner
{
    NSNumber *ownerId = nil;
    T3SystemInfoType type;
    
    if ([owner isKindOfClass:[T3Group class]]) {
        ownerId = ((T3Group *)owner).serverID;
        type = T3SystemInfoGroupTimetable;
        
    } else if ([owner isKindOfClass:[T3Lecturer class]]) {
        ownerId = ((T3Lecturer *)owner).serverID;
        type = T3SystemInfoLecturerTimetable;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.itemType == %@ AND self.itemID == %@", @(type), ownerId];
    T3SystemInfo *info = [T3SystemInfo findFirstWithPredicate:predicate];
    
    return info.itemTimestamp;
}

+ (void)updateGroupsTimestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context
{
    T3SystemInfo *info = [T3SystemInfo findFirstByAttribute:@"itemType" withValue:@(T3SystemInfoDepartmentsAndGroups)];
    if (info == nil) {
        info = [T3SystemInfo createInContext:context];
        info.itemType = @(T3SystemInfoDepartmentsAndGroups);
    }
    info.itemTimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
}

+ (void)updateLecturersTimestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context
{
    T3SystemInfo *info = [T3SystemInfo findFirstByAttribute:@"itemType" withValue:@(T3SystemInfoLecturers)];
    if (info == nil) {
        info = [T3SystemInfo createInContext:context];
        info.itemType = @(T3SystemInfoLecturers);
    }
    info.itemTimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];

}

+ (void)updateTimetableForOwner:(NSManagedObject *)owner timestamp:(int64_t)timestamp inContext:(NSManagedObjectContext *)context
{
    NSNumber *ownerId = nil;
    T3SystemInfoType type;
    
    if ([owner isKindOfClass:[T3Group class]]) {
        ownerId = ((T3Group *)owner).serverID;
        type = T3SystemInfoGroupTimetable;
        
    } else if ([owner isKindOfClass:[T3Lecturer class]]) {
        ownerId = ((T3Lecturer *)owner).serverID;
        type = T3SystemInfoLecturerTimetable;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.itemType == %@ AND self.itemID == %@", @(type), ownerId];
    T3SystemInfo *info = [T3SystemInfo findFirstWithPredicate:predicate];

    if (info == nil) {
        info = [T3SystemInfo createInContext:context];
        info.itemID = ownerId;
        info.itemType = @(type);
    }
    
    info.itemTimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
}

@end
