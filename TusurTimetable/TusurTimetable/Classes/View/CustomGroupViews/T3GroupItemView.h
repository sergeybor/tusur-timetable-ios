//
//  T3GroupItemView.h
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "T3GroupItemPosition.h"

@interface T3GroupItemView : UIView

@property (assign, nonatomic) CGSize cornerRadiuses;
@property (strong, nonatomic) UIColor *viewColor;
@property (weak, nonatomic) CAShapeLayer *viewLayer;

- (void)setupWithViewColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses;
- (void)changeCellPosition:(T3CellPosition)curCellPos;
- (void)setViewColor:(UIColor *)color;

@end
