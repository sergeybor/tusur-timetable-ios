//
//  UITableView+CellPosition.h
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T3GroupItemPosition.h"

@interface UITableView (CellPosition)

- (T3CellPosition)positionForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
