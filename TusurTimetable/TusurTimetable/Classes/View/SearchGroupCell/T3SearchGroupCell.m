//
//  T3SearchGroupCell.m
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3SearchGroupCell.h"
#import "T3Group.h"

@implementation T3SearchGroupCell

- (void)configureWithGroup:(T3Group *)group
{
    self.nameLabel.text = group.name;
}

@end
