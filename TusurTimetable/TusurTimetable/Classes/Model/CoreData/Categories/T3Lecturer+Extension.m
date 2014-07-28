//
//  T3Lecturer+Extension.m
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Lecturer+Extension.h"
#import "T3Favourites+Extension.h"

@implementation T3Lecturer (Extension)

- (BOOL)isFavourite
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.serverID == %@ AND self.objectType == %@", self.serverID, @(T3FavouriteLecturer)];
    T3Favourites *favourite = [T3Favourites findFirstWithPredicate:predicate];
    
    return favourite != nil;
    
}

@end
