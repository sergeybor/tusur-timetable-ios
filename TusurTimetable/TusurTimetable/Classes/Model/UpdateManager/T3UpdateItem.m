//
//  T3UpdateItem.m
//  TusurTimetable
//
//  Created by Katte on 28.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3UpdateItem.h"
#import "T3Group.h"
#import "T3Lecturer.h"

@implementation T3UpdateItem

- (id)initWithType:(T3UpdateItemType)type
            taskID:(NSInteger)taskID
          objectID:(NSNumber *)objectID
          complite:(LoadItemCompleteBlock)complite
{
    self = [super init];
    if (self) {
        self.type = type;
        self.taskID = taskID;
        self.updatedObjectServerID = objectID;
        self.compliteBlock = complite;
    }
    return self;
}

- (NSManagedObject *)objectForItem
{
    if (self.type == T3UpdateItemGroupTimetable) {
        return [T3Group findFirstByAttribute:@"serverID" withValue:self.updatedObjectServerID];
    } else if (self.type == T3UpdateItemLecturerTimetable) {
        return [T3Lecturer findFirstByAttribute:@"serverID" withValue:self.updatedObjectServerID];
    }
    
    return nil;
}

@end
