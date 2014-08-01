//
//  T3TimetableCell.h
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3PositionedTableCell.h"

@class T3TimeTable;

@interface T3TimetableCell : T3PositionedTableCell

- (void)configureWithTimetable:(T3TimeTable *)timetable cellPosition:(T3CellPosition)cellPosition;
+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable;
+ (CGFloat)heightForItem:(T3TimeTable *)timetable;

- (void)setupBGColorToKind:(T3TimeTable *)timetable;

@end
