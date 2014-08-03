//
//  T3SearchGroupCell.h
//  TusurTimetable
//
//  Created by Katte on 27.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3PositionedTableCell.h"

@class T3Group;

@interface T3SearchGroupCell : T3PositionedTableCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)configureWithGroup:(T3Group *)group cellPosition:(T3CellPosition)cellPosition;

@end
