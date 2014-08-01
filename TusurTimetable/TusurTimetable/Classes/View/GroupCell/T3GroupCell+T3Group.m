//
//  T3GroupCell+T3Group.m
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3GroupCell+T3Group.h"
#import "T3Group.h"

@implementation T3GroupCell (T3Group)

- (void)configureForGroup:(T3Group *)group cellPosition:(T3CellPosition)cellPosition
{
    self.groupNameLabel.text = group.name;
    
    [self updateWithPosition:cellPosition];
}

@end
