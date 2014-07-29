//
//  T3BaseTableViewController.m
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3BaseTableViewController.h"
#import "T3PlaceholderView.h"

@interface T3BaseTableViewController ()

@end

@implementation T3BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [T3PlaceholderView hideFromView:self.view];
}

- (void)showPlaceholderWithError:(NSError *)error
{
    [T3PlaceholderView showError:error
                          inView:self.tableView
                  buttonTapBlock:nil];
    
}

- (void)showAlertWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
