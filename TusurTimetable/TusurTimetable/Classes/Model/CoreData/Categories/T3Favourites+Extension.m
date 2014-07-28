//
//  T3Favourites+Extension.m
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Favourites+Extension.h"
#import "T3Group+Extension.h"
#import "T3Lecturer+Extension.h"

@implementation T3Favourites (Extension)

+ (void)addGroup:(T3Group *)group
{
    [T3Favourites addObjectWithID:group.serverID objectType:T3FavouriteGroup fileUrl:group.dirName inContext:group.managedObjectContext];
}

+ (void)removeGroup:(T3Group *)group
{
    [T3Favourites removeObjectWithID:group.serverID objectType:T3FavouriteGroup inContext:group.managedObjectContext];
}

+ (void)addLecturer:(T3Lecturer *)lecturer
{
    // TODO : add fileUrl
    [T3Favourites addObjectWithID:lecturer.serverID objectType:T3FavouriteLecturer fileUrl:nil inContext:lecturer.managedObjectContext];
}

+ (void)removeLecturer:(T3Lecturer *)lecturer
{
    [T3Favourites removeObjectWithID:lecturer.serverID objectType:T3FavouriteLecturer inContext:lecturer.managedObjectContext];
}


+ (void)addObjectWithID:(NSNumber *)serverID objectType:(NSInteger)objectType fileUrl:(NSString *)fileUrl inContext:(NSManagedObjectContext *)context
{
    T3Favourites *favourites = [T3Favourites createInContext:context];
    favourites.serverID = serverID;
    favourites.objectType = @(objectType);
    favourites.fileUrl = fileUrl;
}

+ (void)removeObjectWithID:(NSNumber *)serverID objectType:(NSInteger)objectType inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID == %@ AND self.objectType == %@", serverID, @(objectType)];
    [T3Favourites deleteAllMatchingPredicate:predicate inContext:context];
    
}

+ (NSArray *)getGroups
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *groupsIds = [T3Favourites findByAttribute:@"objectType" withValue:@(T3FavouriteGroup)];
    
    if ([groupsIds count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID IN %@", [self getArrayIdsFromFavouriteItems:groupsIds]];
        NSArray *groups = [T3Group findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        [result addObjectsFromArray:groups];
    }
    
    return result;
}

+ (NSArray *)getLecturers
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *lecturersIds = [T3Favourites findByAttribute:@"objectType" withValue:@(T3FavouriteLecturer)];
    
    if ([lecturersIds count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID IN %@", [self getArrayIdsFromFavouriteItems:lecturersIds]];
        NSArray *lecturers = [T3Lecturer findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        [result addObjectsFromArray:lecturers];
    }
    
    return result;
}

+ (NSArray *)getArrayIdsFromFavouriteItems:(NSArray *)favouriteItems
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[favouriteItems count]];
    for (T3Favourites *item in favouriteItems) {
        [result addObject:item.serverID];
    }
    return result;
}

@end
