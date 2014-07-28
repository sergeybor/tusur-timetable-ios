//
//  T3DepartmentCell+T3Department.m
//  TusurTimetable
//
//  Created by Katte on 13.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3DepartmentCell+T3Department.h"
#import "T3Department.h"

@implementation T3DepartmentCell (T3Department)

- (void)configureForDepartment:(T3Department *)department
{
    self.departmentNameLabel.text = department.name;
}


@end
