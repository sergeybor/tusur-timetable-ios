//
//  T3GroupsTableViewController.h
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3BaseTableViewControllerWithFetchedResultController.h"

@class T3Department;

@interface T3GroupsTableViewController : T3BaseTableViewControllerWithFetchedResultController

@property (nonatomic, strong) T3Department *department;

@end
