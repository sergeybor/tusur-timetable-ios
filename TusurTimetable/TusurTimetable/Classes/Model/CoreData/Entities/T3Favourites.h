//
//  T3Favourites.h
//  TusurTimetable
//
//  Created by Katte on 29.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface T3Favourites : NSManagedObject

@property (nonatomic, retain) NSNumber * objectType;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSNumber * isNeedUpdate;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * fileUrl;

@end
