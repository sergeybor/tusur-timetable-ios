//
//  T3TimetableFullCell.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimetableFullCell.h"
#import "T3Timetable+Extension.h"
#import "UIView+Resizing.h"

const CGFloat T3TFLHeight = 145.0;

@implementation T3TimetableFullCell

#pragma mark - T3TimetableCell

- (void)configureWithTimetable:(T3TimeTable *)timetable cellPosition:(T3CellPosition)cellPosition
{
    self.weekDayLabel.text = [timetable stringWeekDay];
    self.parityLabel.text = [timetable stringPartily];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%i.", [timetable.lessonNumber integerValue]];
    self.timeLabel.text = [timetable stringLessonTime];
    
    self.shortNameLabel.text = timetable.shortName;
    self.kindLabel.text = [timetable stringForKind];
    
    self.nameLabel.text = timetable.fullName;
    
    self.roomLabel.text = timetable.lectureHall;
    
    self.teacherLabel.text = timetable.teacher;
    
    self.noteLabel.text = timetable.note;
    
    [self setupBackgroundWithTimetable:timetable];
    [self setupBGColorToKind:timetable];
    [self updateWithPosition:cellPosition];
}

- (void)setupBackgroundWithTimetable:(T3TimeTable *)timetable
{
    CGFloat height = [T3TimetableFullCell heightForItem:timetable];
    [self.contentView setHeight:height];
}

+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable
{
    return NO;
}

+ (CGFloat)heightForItem:(T3TimeTable *)timetable
{
    if ([timetable.note length] > 0) {
        CGFloat height = T3TFLHeight + [T3TimetableFullCell heightForNote:timetable.note] + 15.0;
        return height;
    } else {
        return T3TFLHeight;
    }
}

+ (CGFloat)heightForNote:(NSString *)note
{
    CGSize textSize = CGSizeZero;
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constrainedSize = CGSizeMake(288.0, NSIntegerMax);
    
    if ([note respondsToSelector:
         @selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary * attributes = @{NSFontAttributeName : font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        int options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
        
        textSize = [note boundingRectWithSize:constrainedSize
                                                          options:options
                                                       attributes:attributes
                                                          context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [note sizeWithFont:font
                                        constrainedToSize:constrainedSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }

    return textSize.height;
}

@end
