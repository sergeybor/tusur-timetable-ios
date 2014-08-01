//
//  UIColor+CreateMethods.m
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "UIColor+CreateMethods.h"

@implementation UIColor (CreateMethods)

+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
	NSUInteger red, green, blue;
	
	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	
	return [UIColor colorWith8BitRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWith8BitRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

@end
