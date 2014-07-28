//
//  T3Placeholder.h
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const T3PlaceholderMessage;
extern NSString * const T3PlaceholderDescription;
extern NSString * const T3PlaceholderButtonTitle;
extern NSString * const T3PlaceholderButtonIcon;

typedef void(^T3PlaceholderButtonTapBlock)(id sender);

@interface T3PlaceholderView : UIView

@property (nonatomic, copy) T3PlaceholderButtonTapBlock buttonTapBlock;

- (void)setupWithParams:(NSDictionary *)params;

+ (T3PlaceholderView *)placeholderWithParams:(NSDictionary *)params;
+ (T3PlaceholderView *)placeholderWithParams:(NSDictionary *)params
                               buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock;

+ (void)showError:(NSError *)error
           inView:(UIView *)hostView
   buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock;


+ (void)showInView:(UIView *)hostView
        withParams:(NSDictionary *)params
    buttonTapBlock:(T3PlaceholderButtonTapBlock)buttonTapBlock;

+ (void)showInView:(UIView *)hostView withParams:(NSDictionary *)params;
+ (void)hideFromView:(UIView *)hostView;

@end
