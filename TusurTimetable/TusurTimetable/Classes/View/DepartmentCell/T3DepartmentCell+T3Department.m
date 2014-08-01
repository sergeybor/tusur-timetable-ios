//
//  T3DepartmentCell+T3Department.m
//  TusurTimetable
//
//  Created by Katte on 13.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3DepartmentCell+T3Department.h"
#import "T3Department.h"

static NSDictionary *departmentToLogo = nil;

@implementation T3DepartmentCell (T3Department)

- (void)configureForDepartment:(T3Department *)department
{
    self.departmentIcon.image = [self iconToDepartment:department];
}

- (UIImage *)iconToDepartment:(T3Department *)department
{
    UIImage *result = nil;
    
    if (departmentToLogo == nil) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"DepartmentsLogo" ofType:@"plist"];
        departmentToLogo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    NSString *logoName = [departmentToLogo valueForKey:department.name];
    if (logoName)
        result = [UIImage imageNamed:logoName];
    
    return result;
}

@end
