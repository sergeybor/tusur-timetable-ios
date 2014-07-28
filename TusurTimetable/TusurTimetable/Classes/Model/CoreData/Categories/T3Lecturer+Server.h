//
//  T3Lecturer+Server.h
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Lecturer.h"

@interface T3Lecturer (Server)

+ (void)updateLecturersFromServerWithCompletion:(void (^)(NSError *error))completion;
+ (T3Lecturer *)createLecturerFromServerObject:(NSDictionary *)serverDict
                                     inContext:(NSManagedObjectContext *)context;
+ (void)cancelLoadFromServer;

@end
