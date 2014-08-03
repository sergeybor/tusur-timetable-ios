//
//  T3BaseViewController.h
//  TusurTimetable
//
//  Created by Katte on 11.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3BaseViewController : UIViewController

- (void)showPlaceholderWithError:(NSError *)error;
- (void)showAlertWithError:(NSError *)error;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
