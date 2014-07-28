//
//  T3Department+Server.h
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Department.h"

@interface T3Department (Server)

+ (void)updateDepartmentsFromServerWithCompletion:(void (^)(NSError *error))completion;
+ (void)createOrUpdateDepartmentsInContext:(NSManagedObjectContext *)context;
+ (void)cancelLoadFromServer;

@end
