//
//  T3TimetableCell.h
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3TimetableCell.h"

@interface T3TimetableShortCell : T3TimetableCell

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *kindLabel;
@property (nonatomic, weak) IBOutlet UILabel *roomLabel;
@property (nonatomic, weak) IBOutlet UILabel *teacherLabel;
@property (nonatomic, weak) IBOutlet UILabel *shortNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *exclamationMarkImageView;

@end
