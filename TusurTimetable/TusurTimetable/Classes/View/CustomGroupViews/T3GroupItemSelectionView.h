//
//  T3GroupItemSelectionView.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "T3GroupItemPosition.h"

@interface T3GroupItemSelectionView : UIView

@property (assign, nonatomic) CGSize cornerRadiuses;
@property (strong, nonatomic) UIColor *selectionColor;
@property (weak, nonatomic) CAShapeLayer *selectionLayer;

- (void)setupWithSelectionColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses;

- (void)changeSelectedState:(BOOL)isSelected animated:(BOOL)animated;
- (void)changeCellPosition:(T3CellPosition)curCellPos;

@end
