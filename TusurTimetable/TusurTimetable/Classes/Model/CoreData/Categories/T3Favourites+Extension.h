//
//  T3Favourites+Extension.h
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Favourites.h"

typedef enum {
    T3FavouriteGroup    = 1001,
    T3FavouriteLecturer = 1002
} T3FavouriteObjectType;

@class T3Group, T3Lecturer;

@interface T3Favourites (Extension)

+ (void)addGroup:(T3Group *)group;
+ (void)removeGroup:(T3Group *)group;

+ (void)addLecturer:(T3Lecturer *)lecturer;
+ (void)removeLecturer:(T3Lecturer *)lecturer;

+ (NSArray *)getGroups;
+ (NSArray *)getLecturers;

@end
