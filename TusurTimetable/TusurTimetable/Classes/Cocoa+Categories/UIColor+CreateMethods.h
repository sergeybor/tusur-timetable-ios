//
//  UIColor+CreateMethods.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CreateMethods)

/*
 Creates UIColor from hex representation.
 @param hex RGB in hex (ex. 0xffef14)
 @param alpha alpha value - should be from 0.0 to 1.0
 */
+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;

/*
 Creates UIColor from 8bit RGB values.
 @param hex 8bit color value  (ex. 255)
 @param alpha alpha value - should be from 0.0 to 1.0
 */
+ (UIColor *)colorWith8BitRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;

@end
