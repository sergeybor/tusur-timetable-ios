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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IT3TimetableCell

- (void)configureWithTimetable:(T3TimeTable *)timetable
{
    self.numberLabel.text = [NSString stringWithFormat:@"%i", [timetable.lessonNumber integerValue]];
    self.timeLabel.text = [timetable stringLessonTime];
    self.kindLabel.text = [NSString stringWithFormat:@"%i", [timetable.hide boolValue] ];
    self.roomLabel.text = timetable.lectureHall;
    self.teacherLabel.text = timetable.teacher;
    self.shortNameLabel.text = timetable.shortName;
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
