//
//  T3UpdateItem.h
//  TusurTimetable
//
//  Created by Katte on 28.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    T3UpdateItemGroupTimetable      = 1001,
    T3UpdateItemLecturerTimetable   = 1002,
    T3UpdateItemDepartmentsAndGroups = 1003,
    T3UpdateItemLecturers            = 1004
} T3UpdateItemType;

typedef void (^LoadItemCompleteBlock)(NSError *error);

@interface T3UpdateItem : NSObject

@property (nonatomic, assign) T3UpdateItemType type;
@property (nonatomic, assign) NSInteger taskID;
@property (nonatomic, strong) NSNumber *updatedObjectServerID;
@property (nonatomic, copy) LoadItemCompleteBlock compliteBlock;

- (id)initWithType:(T3UpdateItemType)type
            taskID:(NSInteger)taskID
          objectID:(NSNumber *)objectID
          complite:(LoadItemCompleteBlock)complite;

- (NSManagedObject *)objectForItem;

@end
