//
//  T3LecturerCell.h
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3PositionedTableCell.h"

@class T3Lecturer;

@interface T3LecturerCell : T3PositionedTableCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)configureWithLecturer:(T3Lecturer *)lecturer cellPosition:(T3CellPosition)cellPosition;
+ (CGFloat)cellHeight;

@end
