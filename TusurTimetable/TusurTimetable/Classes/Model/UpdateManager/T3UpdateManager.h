//
//  T3UpdateManager.h
//  TusurTimetable
//
//  Created by Katte on 03.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoadCompleteBlock)(NSError *error);

@class T3Group;

@interface T3UpdateManager : NSObject

+ (T3UpdateManager *)defaultUpdateManager;

- (void)loadGroups:(LoadCompleteBlock)complite;
- (void)loadLecturers:(LoadCompleteBlock)complite;
- (void)loadTimetableForGroup:(T3Group *)group complite:(LoadCompleteBlock)complite;

- (void)updateFavouriteWithComplite:(LoadCompleteBlock)complite;

- (void)cancelLoadGroups;
- (void)cancelLoadLecturers;
- (void)cancelLoadTimetableForOwner:(NSManagedObject *)owner;

- (BOOL)isNetworkReachable;

@end
