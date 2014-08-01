//
//  T3PositionedTableCell.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3GroupItemPosition.h"

@class T3GroupItemBackgroundView;
@class T3GroupItemSelectionView;

@interface T3PositionedTableCell : UITableViewCell {
    
    IBOutlet T3GroupItemBackgroundView *_bgView;
    IBOutlet T3GroupItemSelectionView *_selectionView;
}

@property (assign, nonatomic) T3CellPosition curCellPosition;

- (void)updateWithPosition:(T3CellPosition)pos;
- (void)setBackgroundViewColor:(UIColor *)color;

@end
