//
//  T3TimetableViewController.h
//  TusurTimetable
//
//  Created by Katte on 23.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3BaseTableViewControllerWithFetchedResultController.h"

@class T3Group, T3Lecturer;

@interface T3TimetableViewController : T3BaseTableViewControllerWithFetchedResultController

@property (nonatomic, strong) T3Group *group;
@property (nonatomic, strong) T3Lecturer *lecturer;

@end
