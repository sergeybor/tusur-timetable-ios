//
//  T3BaseViewController.m
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3BaseViewController.h"
#import "T3PlaceholderView.h"

@interface T3BaseViewController ()

@end

@implementation T3BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [T3PlaceholderView hideFromView:self.view];
}

- (void)showPlaceholderWithError:(NSError *)error
{
    if (self.isViewLoaded && self.view.window) {
        [T3PlaceholderView showError:error
                              inView:self.view
                      buttonTapBlock:nil];
    }
    
}

- (void)showAlertWithError:(NSError *)error
{
    if (self.isViewLoaded && self.view.window) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Ок"
                                              otherButtonTitles:nil];
    
        [alert show];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    if (self.isViewLoaded && self.view.window) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ок"
                                              otherButtonTitles:nil];
    
        [alert show];
    }
}

@end
