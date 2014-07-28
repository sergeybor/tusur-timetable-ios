//
//  T3GroupCell+T3Group.h
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupCell.h"

@class T3Group;

@interface T3GroupCell (T3Group)

- (void)configureForGroup:(T3Group *)group;

@end
