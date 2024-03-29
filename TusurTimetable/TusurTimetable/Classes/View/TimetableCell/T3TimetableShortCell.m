//
//  T3TimetableCell.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimetableShortCell.h"
#import "T3TimeTable+Extension.h"

@implementation T3TimetableShortCell

#pragma mark - T3TimetableCell

- (void)configureWithTimetable:(T3TimeTable *)timetable cellPosition:(T3CellPosition)cellPosition
{
    self.numberLabel.text = [NSString stringWithFormat:@"%i.", [timetable.lessonNumber integerValue]];
    self.timeLabel.text = [timetable stringLessonTime];
    self.exclamationMarkImageView.hidden = ([timetable.note length] == 0);
    self.roomLabel.text = timetable.lectureHall;
    self.teacherLabel.text = timetable.teacher;
    self.shortNameLabel.text = [NSString stringWithFormat:@"%@ %@", timetable.shortName, [timetable stringForShortKind]];
    
    [self setupBGColorToKind:timetable];
    [self updateWithPosition:cellPosition];
}

+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable
{
    if ([timetable isEmpty])
        return NO;
    else
        return YES;
}

+ (CGFloat)heightForItem:(T3TimeTable *)timetable
{
    if ([timetable isEmpty])
        return 44.0;
    else
        return 68.0;

}

@end
