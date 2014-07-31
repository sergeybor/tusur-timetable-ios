//
//  T3DepartmentCell+T3Department.h
//  TusurTimetable
//
//  Created by Katte on 13.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3DepartmentCell.h"
#import "T3PositionedTableCell.h"

@class T3Department;

@interface T3DepartmentCell (T3Department)

- (void)configureForDepartment:(T3Department *)department cellPosition:(T3CellPosition)cellPosition;

@end
