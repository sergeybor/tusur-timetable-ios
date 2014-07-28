//
//  T3LecturerCell.h
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class T3Lecturer;

@interface T3LecturerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)configureWithLecturer:(T3Lecturer *)lecturer;

@end
