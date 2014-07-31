//
//  T3GroupItemBackgroundView.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3GroupItemPosition.h"

@interface T3GroupItemBackgroundView : UIView

@property (strong, nonatomic) UIImage *topItemBgImage;
@property (strong, nonatomic) UIImage *middleItemBgImage;
@property (strong, nonatomic) UIImage *bottomItemBgImage;
@property (strong, nonatomic) UIImage *fullItemBgImage;

/**
 Separator view will be placed at the bottom of the view.
 By default it is UIView with height = 1, width = self.frame.size.width - 2, background color = 0xdfe9ed, alpha = 1.
 */
@property (strong, nonatomic) UIView *separatorView;

/**
 Default = YES
 */
@property (assign, nonatomic) BOOL showsSeparator;


- (void)changePosition:(T3CellPosition)position;

@end
