//
//  T3AppDelegate.h
//  TusurTimetable


#import <UIKit/UIKit.h>

@interface T3AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) void(^backgroundTransferCompletionHandler)();

@end
