//
//  T3TimetableCell.m
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimetableCell.h"
#import "T3TimeTable.h"
#import "T3GroupItemView.h"

static NSDictionary *timetableKindToColor = nil;

@implementation T3TimetableCell

- (void)configureWithTimetable:(T3TimeTable *)timetable cellPosition:(T3CellPosition)cellPosition
{

}

+ (BOOL)shouldExpandForItem:(T3TimeTable *)timetable
{
    return NO;
}

+ (CGFloat)heightForItem:(T3TimeTable *)timetable
{
    return 44.0;
}

- (void)setupBGColorToKind:(T3TimeTable *)timetable
{
    UIColor *color = [T3TimetableCell colorToKind:timetable];
    [self setBackgroundViewColor:color];
}

+ (UIColor *)colorToKind:(T3TimeTable *)timetable
{
    UIColor *color = [UIColor whiteColor];
    
    if (timetableKindToColor == nil) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TimetableColors" ofType:@"plist"];
        timetableKindToColor = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    NSString *kindColorString = [timetableKindToColor valueForKey:timetable.kind];
    NSArray *array = [kindColorString componentsSeparatedByString:@"."];
    
    if ([array count] == 3) {
        CGFloat red = [[array objectAtIndex:0] integerValue];
        CGFloat green = [[array objectAtIndex:1] integerValue];
        CGFloat blue = [[array objectAtIndex:2] integerValue];
        
        color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    }
    
    return color;
}

@end
