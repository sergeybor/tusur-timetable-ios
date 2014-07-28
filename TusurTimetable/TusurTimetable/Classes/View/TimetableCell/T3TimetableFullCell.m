//
//  T3TimetableFullCell.m
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimetableFullCell.h"
#import "T3Timetable+Extension.h"

@implementation T3TimetableFullCell

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
    self.weekDayLabel.text = [timetable stringWeekDay];
    self.parityLabel.text = [timetable stringPartily];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%i", [timetable.lessonNumber integerValue]];
    self.timeLabel.text = [timetable stringLessonTime];
    
    self.shortNameLabel.text = timetable.shortName;
    self.kindLabel.text = timetable.kind;
    
    self.nameLabel.text = timetable.fullName;
    
    self.roomLabel.text = timetable.lectureHall;
    
    self.teacherLabel.text = timetable.teacher;
    
    self.noteLabel.text = timetable.note;
}

+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable
{
    return NO;
}

+ (CGFloat)heightForItem:(T3TimeTable *)timetable
{
    if ([timetable.note length] > 0) {
        return 188.0 + [T3TimetableFullCell heightForNote:timetable.note];
    } else {
        return 188.0;
    }
}

+ (CGFloat)heightForNote:(NSString *)note
{
    CGSize textSize = CGSizeZero;
    UIFont *font = [UIFont systemFontOfSize:17.0];
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
