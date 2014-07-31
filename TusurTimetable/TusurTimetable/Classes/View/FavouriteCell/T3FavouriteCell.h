//
//  T3FavouriteCell.h
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3PositionedTableCell.h"

@interface T3FavouriteCell : T3PositionedTableCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

+ (T3FavouriteCell *)favouriteCell;
- (void)configureWithItem:(NSManagedObject *)item cellPosition:(T3CellPosition)cellPosition;
+ (CGFloat)cellHeight;

@end
