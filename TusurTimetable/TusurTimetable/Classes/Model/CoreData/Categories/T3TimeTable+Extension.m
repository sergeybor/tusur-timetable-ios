//
//  T3TimeTable+Extension.m
//  TusurTimetable
//
//  Created by Katte on 24.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3TimeTable+Extension.h"
#import "T3Group.h"
#import "T3Lecturer.h"

@implementation T3TimeTable (Extension)

+ (NSString *)weekDayToNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"Понедельник";
        case 2:
            return @"Вторник";
        case 3:
            return @"Среда";
        case 4:
            return @"Четверг";
        case 5:
            return @"Пятница";
        case 6:
            return @"Суббота";
        case 7:
            return @"Воскресенье";

        default:
            return nil;
    }
}

+ (NSString *)stringToDayNumber:(NSInteger)number isOddWeek:(BOOL)isOddWeek
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    NSUInteger weekdayNow = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
    
    BOOL isOddWeekNow = [T3TimeTable isTodayOddWeek];
    
    NSString *day = [T3TimeTable weekDayToNumber:number];
    if ((number == weekdayNow) && (isOddWeek == isOddWeekNow)) {
        day = [NSString stringWithFormat:@"%@ (сегодня)", day];
    }
    
    return day;
}

+ (BOOL)isTodayOddWeek
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit|NSCalendarUnitWeekOfYear|NSDayCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];

    NSInteger weekOfYear = [comp weekOfYear];
    NSInteger year = [comp year];
    
    NSDateComponents *compDeterminant = [[NSDateComponents alloc] init];
    
    if (year == 2014) {
        [compDeterminant setCalendar:cal];
        [compDeterminant setDay:1];
        [compDeterminant setMonth:9];
        [compDeterminant setYear:2014];
    } else {
        [compDeterminant setCalendar:cal];
        [compDeterminant setDay:1];
        [compDeterminant setMonth:1];
        [compDeterminant setYear:2015];
    }
    
    NSDate *dateDeterminant = [cal dateFromComponents:compDeterminant];
    NSDateComponents *compOdd = [cal components:NSCalendarUnitWeekOfYear fromDate:dateDeterminant];
    NSInteger weekOfYearOdd = [compOdd weekOfYear];
    
    if ((weekOfYearOdd - weekOfYear) % 2 == 0) {
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)isEmpty
{
    return [self.lectureHall length] == 0 &&
           [self.shortName length] == 0 &&
           [self.fullName length] == 0 &&
           [self.teacher length] == 0;
}

- (NSString *)stringWeekDay
{
    return [T3TimeTable weekDayToNumber:[self.dayOfWeek integerValue]];
}

- (NSString *)stringPartily
{
    return [self.isOdd boolValue] ? @"нечет" : @"чет";
}

- (NSString *)stringLessonTime
{
    return [T3TimeTable lessonTimeToLessonNumber:[self.lessonNumber integerValue]];
}

+ (NSString *)lessonTimeToLessonNumber:(NSInteger)lesson
{
    switch (lesson) {
        case 1:
            return @"8:50-10:25";
        case 2:
            return @"10:40-12:15";
        case 3:
            return @"13:15-14:50";
        case 4:
            return @"15:00-16:35";
        case 5:
            return @"16:45-18:20";
        case 6:
            return @"18:30-20:05";
        case 7:
            return @"20:15-21:50";
            
        default:
            return nil;
    }
}

+ (void)markUnnecessaryTimetableItemsAsInvisibleForOwner:(NSManagedObject *)owner inContext:(NSManagedObjectContext *)context
{
    NSArray *evenArray = @[@(YES), @(NO)];
    
    for (NSNumber *isEvenWeek in evenArray) {
        for (NSInteger i = 1; i < 8; i++) {
            NSPredicate *predicate = nil;
            
            if ([owner isKindOfClass:[T3Group class]]) {
                predicate = [NSPredicate predicateWithFormat:@"self.group == %@ AND self.isOdd == %@ AND self.dayOfWeek == %@", owner, isEvenWeek, @(i)];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"self.lecturer == %@ AND self.isOdd == %@ AND self.dayOfWeek == %@",  owner, isEvenWeek, @(i)];
            }
            
            NSArray *items = [T3TimeTable findAllSortedBy:@"lessonNumber" ascending:YES withPredicate:predicate inContext:context];
            [self process:items];
        }
    }
    
    
}

+ (void)process:(NSArray *)items
{
    T3TimeTable *timetable = [items firstObject];
    
    //trim from begin
    BOOL previousItemEmpty = YES;
    for (T3TimeTable *timetable in items) {
        
        if ([timetable isEmpty]) {
            timetable.hide = previousItemEmpty ? @(YES) : @(NO);
        } else {
            previousItemEmpty = NO;
            timetable.hide = @(NO);
        }
        
    }
    
    //trim from end
    timetable = [items lastObject];
    
    for (NSInteger i = [items count]-1; i >= 0; i--) {
        
        timetable = [items objectAtIndex:i];
        
        if ([timetable isEmpty]) {
            timetable.hide = @(YES);
        } else {
            break;
        }
    }
    
}

- (NSString *)stringForKind
{
    if ([self.kind isEqualToString:@"laboratory"]) {
        return @"Лабораторная работа";
    }
    if ([self.kind isEqualToString:@"lecture"]) {
        return @"Лекция";
    }
    if ([self.kind isEqualToString:@"practice"]) {
        return @"Практика";
    }
    if ([self.kind isEqualToString:@"research"]) {
        return @"Курсовая работа";
    }
    if ([self.kind isEqualToString:@"design"]) {
        return @"Курсовое проектирование";
    }
    if ([self.kind isEqualToString:@"test"]) {
        return @"Зачет";
    }
    if ([self.kind isEqualToString:@"exam"]) {
        return @"Экзамен";
    }
    return nil;
    
}

- (NSString *)stringForShortKind
{
    if ([self.kind isEqualToString:@"laboratory"]) {
        return @"л.р.";
    }
    if ([self.kind isEqualToString:@"lecture"]) {
        return @"лек.";
    }
    if ([self.kind isEqualToString:@"practice"]) {
        return @"пр.";
    }
    if ([self.kind isEqualToString:@"research"]) {
        return @"к.р.";
    }
    if ([self.kind isEqualToString:@"design"]) {
        return @"к.п.";
    }
    if ([self.kind isEqualToString:@"test"]) {
        return @"зач.";
    }
    if ([self.kind isEqualToString:@"exam"]) {
        return @"экз.";
    }
    return nil;
}

@end
