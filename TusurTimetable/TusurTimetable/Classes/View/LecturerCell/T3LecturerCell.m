//
//  T3LecturerCell.m
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3LecturerCell.h"
#import "T3Lecturer.h"

@implementation T3LecturerCell

- (void)configureWithLecturer:(T3Lecturer *)lecturer cellPosition:(T3CellPosition)cellPosition
{
    self.nameLabel.text = lecturer.name;
    [self updateWithPosition:cellPosition];
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

@end
