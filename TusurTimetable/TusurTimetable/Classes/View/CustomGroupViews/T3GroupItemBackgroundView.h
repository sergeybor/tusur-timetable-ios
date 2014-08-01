//
//  T3GroupItemBackgroundView.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3GroupItemView.h"

@interface T3GroupItemBackgroundView : T3GroupItemView

/**
 Separator view will be placed at the bottom of the view.
 By default it is UIView with height = 1, width = self.frame.size.width - 0, background color = white, alpha = 1.
 */
@property (strong, nonatomic) UIView *separatorView;

/**
 Default = YES
 */
@property (assign, nonatomic) BOOL showsSeparator;

- (void)setupWithViewColor:(UIColor *)selColor cornerRadiuses:(CGSize)radiuses;
- (void)changeCellPosition:(T3CellPosition)curCellPos;

@end
