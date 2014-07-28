//
//  T3Group+Extension.h
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Group.h"

@interface T3Group (Extension)

+ (void)deleteTimetableForGroupWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
- (void)markUnnecessaryTimetableItemsAsInvisibleInContext:(NSManagedObjectContext *)context;

- (BOOL)isFavourite;

@end
