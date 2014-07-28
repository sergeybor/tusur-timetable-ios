//
//  T3SystemInfo.h
//  TusurTimetable
//
//  Created by Katte on 29.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface T3SystemInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * itemType;
@property (nonatomic, retain) NSDate * itemTimestamp;
@property (nonatomic, retain) NSNumber * itemID;

@end
