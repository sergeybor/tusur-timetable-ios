//
//  T3Group+Server.h
//  TusurTimetable
//
//  Created by Katte on 25.06.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3Group.h"

@interface T3Group (Server)

- (void)updateTimetableFromServerWithCompletion:(void (^)(NSError *error))completion;
+ (T3Group *)createOrUpdateGroupFromServerObject:(NSDictionary *)serverDict
                                         inContext:(NSManagedObjectContext *)context;

- (void)cancelLoadFromServer;

@end
