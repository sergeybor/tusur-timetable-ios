//
//  UITableView+CellPosition.m
//  TusurTimetable
//
//  Created by Katte on 01.08.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "UITableView+CellPosition.h"

@implementation UITableView (CellPosition)

- (T3CellPosition)positionForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //validating input
	if (indexPath == nil) {
		NSAssert(NO, @"Index path is nil.");
		return T3CellPosition_None;
	}
	
	if (indexPath.section < 0 || indexPath.section >= [self numberOfSections]) {
		NSAssert(NO, @"Invalid index path.");
		return T3CellPosition_None;
	}
	
	NSInteger rowsInSection = [self numberOfRowsInSection:indexPath.section];
	
	NSInteger rowIndex = indexPath.row;
	BOOL isLastSection = (indexPath.section + 1 == [self numberOfSections]);
	
	if (rowIndex < 0 || rowIndex >= rowsInSection) {
		NSAssert(NO, @"Invalid index path.");
		return T3CellPosition_None;
	}
    
	// obtaining cell position
    
	T3CellPosition position = T3CellPosition_None;
	if (rowsInSection == 1) {
		position = T3CellPosition_SingleCell;
	}
	else {
		if (rowIndex == rowsInSection - 1) {
			position = T3CellPosition_Bottom;
		}
		else if (rowIndex == 0) {
			position = T3CellPosition_Top;
		}
		else {
			position = T3CellPosition_Middle;
		}
	}
    
	return position;
    
}

@end
