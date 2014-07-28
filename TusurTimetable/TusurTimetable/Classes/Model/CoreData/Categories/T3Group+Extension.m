//
//  T3Group+Extension.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Group+Extension.h"
#import "T3TimeTable+Extension.h"
#import "T3Favourites+Extension.h"

@implementation T3Group (Extension)

+ (void)deleteTimetableForGroupWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    T3Group *group = [T3Group findFirstByAttribute:@"name" withValue:name inContext:context];
    if (group) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.group == %@", group];
        [T3TimeTable deleteAllMatchingPredicate:predicate inContext:context];
    }
}

- (BOOL)isFavourite
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID == %@ AND self.objectType == %@", self.serverID, @(T3FavouriteGroup)];
    T3Favourites *favourite = [T3Favourites findFirstWithPredicate:predicate];
    
    return !(favourite == nil);
    
}

@end
