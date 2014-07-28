//
//  T3UpdateManager.m
//  TusurTimetable
//
//  Created by Katte on 03.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3UpdateManager.h"
#import "T3DownloadManager.h"
#import "T3UpdateItem.h"

#import "T3Group+Server.h"
#import "T3Department+Server.h"
#import "T3Lecturer+Server.h"
#import "T3TimeTable.h"

#import "T3SystemInfo+Extension.h"
#import "T3Group+Extension.h"
#import "T3TimeTable+Server.h"
#import "T3TimeTable+Extension.h"
#import "T3Favourites+Extension.h"

#import "Reachability.h"

NSString *const groupsUrl = @"http://anisov.tomsk.ru/timetable/groups.json"; //@"http://s3-eu-west-1.amazonaws.com/risik/images/3ffe8b54-1280-11e4-8ba7-50e54957825b/groups.json";
NSString *const teachersUrl = @"http://anisov.tomsk.ru/timetable/teachers.json";


@interface T3UpdateManager ()

@property (assign, nonatomic) NSUInteger currentSessionID;
@property (nonatomic, strong) NSMutableDictionary *tasks;

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) Reachability *hostReachability;

@end

@implementation T3UpdateManager

+ (T3UpdateManager *)defaultUpdateManager
{
    static T3UpdateManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance configure];
    });
    
    return instance;
}

- (void)configure
{
    [self configureSession];
    [self configureTimer];
    
    self.tasks = [NSMutableDictionary dictionary];
}

- (void)configureTimer
{
    NSTimeInterval secondsPerDay = 60 * 60 * 24;
    
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    
    self.updateTimer = [[NSTimer alloc] initWithFireDate:d
                                                interval:secondsPerDay
                                                  target:self
                                                selector:@selector(onUpdateTimerTick:)
                                                userInfo:nil
                                                 repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:self.updateTimer forMode: NSDefaultRunLoopMode];
}

- (void)configureReachability
{
    NSString *remoteHostName = @"anisov.tomsk.ru";
    
	self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)configureSession
{
    __weak T3UpdateManager *wself = self;
    
    _currentSessionID = [[T3DownloadManager defaultManager]
                         makeSessionWithProgressBlock:^(NSUInteger taskID, int64_t bytesWritten,
                                                        int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
                             
                             
                         } errorBlock:^(NSUInteger taskID, NSError *error){
                             
                             NSLog(@"download error : %@", [error localizedDescription]);
                             T3UpdateItem *item = [wself.tasks objectForKey:@(taskID)];
                             
                             if (item.compliteBlock) {
                                 item.compliteBlock(error);
                                 [wself.tasks removeObjectForKey:@(taskID)];
                             }
                             
                         } completeBolck:^(NSUInteger taskID, BOOL isFinish, NSString *filePath){
                             
                             if (isFinish) {
                                 // check task id
                                 [wself checkLoadedTask:taskID filePath:filePath];
                                
                                 NSLog(@"file path is %@", filePath);
                             }
                             // parse json
                             
                         }];

}

- (void)loadGroups:(LoadCompleteBlock)complite
{
    NSInteger taskId = [[T3DownloadManager defaultManager] startDownloadWithURL:groupsUrl sessionID:_currentSessionID];
    
    T3UpdateItem *item = [[T3UpdateItem alloc] initWithType:T3UpdateItemDepartmentsAndGroups
                                                     taskID:taskId
                                                   objectID:nil
                                                   complite:complite];
    [self.tasks setObject:item forKey:@(taskId)];
}

- (void)loadLecturers:(LoadCompleteBlock)complite
{
    NSInteger taskId = [[T3DownloadManager defaultManager] startDownloadWithURL:teachersUrl sessionID:_currentSessionID];
    
    T3UpdateItem *item = [[T3UpdateItem alloc] initWithType:T3UpdateItemLecturers
                                                     taskID:taskId
                                                   objectID:nil
                                                   complite:complite];
    [self.tasks setObject:item forKey:@(taskId)];
}

- (void)loadTimetableForGroup:(T3Group *)group complite:(LoadCompleteBlock)complite
{
    [self loadTimetableForGroupId:group.serverID fileUrl:group.dirName complite:complite];
}

- (void)loadTimetableForGroupId:(NSNumber *)groupID fileUrl:(NSString *)fileUrl complite:(LoadCompleteBlock)complite
{
    NSInteger taskId = [[T3DownloadManager defaultManager] startDownloadWithURL:fileUrl sessionID:_currentSessionID];
    
    T3UpdateItem *item = [[T3UpdateItem alloc] initWithType:T3UpdateItemGroupTimetable
                                                     taskID:taskId
                                                   objectID:groupID
                                                   complite:complite];
    [self.tasks setObject:item forKey:@(taskId)];
}

- (void)updateShedule
{
    [self loadGroups];
}

- (void)loadGroups
{
    [self loadTaskWithUrlString:groupsUrl];
}

- (void)loadLecturers
{
    [self loadTaskWithUrlString:teachersUrl];
}

- (NSUInteger)loadTaskWithUrlString:(NSString *)URLString
{
    NSUInteger taskID = [[T3DownloadManager defaultManager] startDownloadWithURL:URLString sessionID:_currentSessionID];
    return taskID;
}

- (void)cancelLoadGroups
{
    NSArray *array = [self findItemsWithItemType:T3UpdateItemDepartmentsAndGroups];
    if ([array count] > 0) {
        T3UpdateItem *item = [array firstObject];
        [[T3DownloadManager defaultManager] stopDownloadWithIdentifier:item.taskID];
    }
}

- (void)cancelLoadLecturers
{
    NSArray *array = [self findItemsWithItemType:T3UpdateItemLecturers];
    if ([array count] > 0) {
        T3UpdateItem *item = [array firstObject];
        [[T3DownloadManager defaultManager] stopDownloadWithIdentifier:item.taskID];
    }
}

- (void)cancelLoadTimetableForOwner:(NSManagedObject *)owner
{
    NSNumber *serverID = nil;
    if ([owner isKindOfClass:[T3Group class]]) {
        serverID = ((T3Group *)owner).serverID;
    } else if ([owner isKindOfClass:[T3Lecturer class]]) {
        serverID = ((T3Lecturer *)owner).serverID;
    }
    
    T3UpdateItem *item = [self findItemWithUpdatedObjectServerID:serverID];
    if (item)
        [[T3DownloadManager defaultManager] stopDownloadWithIdentifier:item.taskID];
}

#pragma mark - parse response

- (void)checkLoadedTask:(NSUInteger)taskID filePath:(NSString *)filePath
{
    __weak T3UpdateManager *wself = self;
    
    T3UpdateItem *item = [wself.tasks objectForKey:@(taskID)];
    void (^compliteBlock)(void) = ^(){
        if (item.compliteBlock) {
            item.compliteBlock(nil);
            [wself.tasks removeObjectForKey:@(taskID)];
        }
    };
    
    
    switch (item.type) {
        case T3UpdateItemDepartmentsAndGroups: {
            [self parseGroupsFromFile:filePath completion:compliteBlock];
            break;
        }
        case T3UpdateItemLecturers: {
            [self parseTeachersFromFile:filePath completion:compliteBlock];
            break;
        }
        case T3UpdateItemGroupTimetable:
        case T3UpdateItemLecturerTimetable:{
            NSManagedObject *owner = [item objectForItem];
            [self parseTimetableFromFile:filePath timetableOwner:owner completion:compliteBlock];
        }
        default:
            break;
    }
}

- (void)parseGroupsFromFile:(NSString *)filePath completion:(void (^)(void))completion
{
    UIApplication * application = [UIApplication sharedApplication];
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask:background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            //### background task starts
            NSManagedObjectContext *threadContext =
            [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            threadContext.parentContext = [NSManagedObjectContext defaultContext];
            //threadContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator defaultStoreCoordinator];
            
            id contextObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:NSManagedObjectContextDidSaveNotification
                                  object:threadContext
                                  queue:nil
                                  usingBlock:^(NSNotification* note)
                                  {
                                      NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
                                      [moc performBlock:^(){
                                          [moc mergeChangesFromContextDidSaveNotification:note];
                                          [moc saveToPersistentStoreAndWait];
                                      }];
                                  }];
            
            NSDictionary *dict = [self getJSONFromFile:filePath];
            
            int64_t timestamp = [dict[@"timestamp"] longLongValue];
            [T3SystemInfo updateGroupsTimestamp:timestamp inContext:threadContext];
            
            NSArray *groupsArray = dict[@"groups"];
            
            [T3Group truncateAllInContext:threadContext];
            
            if ([groupsArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in groupsArray) {
                    [T3Group createOrUpdateGroupFromServerObject:dict inContext:threadContext];
                }
            }
            
            [T3Department truncateAllInContext:threadContext];
            [T3Department createOrUpdateDepartmentsInContext:threadContext];
            
            [threadContext saveToPersistentStoreAndWait];
            [[NSNotificationCenter defaultCenter] removeObserver:contextObserver];
            //#### background task ends
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }
    
}

- (void)parseTeachersFromFile:(NSString *)filePath completion:(void (^)(void))completion
{
    UIApplication * application = [UIApplication sharedApplication];
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask:background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            //### background task starts
            NSManagedObjectContext *threadContext =
            [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            threadContext.parentContext = [NSManagedObjectContext defaultContext];
            //threadContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator defaultStoreCoordinator];
            
            id contextObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:NSManagedObjectContextDidSaveNotification
                                  object:threadContext
                                  queue:nil
                                  usingBlock:^(NSNotification* note)
                                  {
                                      NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
                                      [moc performBlock:^(){
                                          [moc mergeChangesFromContextDidSaveNotification:note];
                                          [moc saveToPersistentStoreAndWait];
                                      }];
                                  }];
            
            NSDictionary *dict = [self getJSONFromFile:filePath];
            
            int64_t timestamp = [dict[@"timestamp"] longLongValue];
            [T3SystemInfo updateLecturersTimestamp:timestamp inContext:threadContext];
            
            NSArray *groupsArray = dict[@"teachers"];
            
            [T3Lecturer truncateAllInContext:threadContext];
            
            if ([groupsArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in groupsArray) {
                    [T3Lecturer createLecturerFromServerObject:dict inContext:threadContext];
                }
            }
            
            [threadContext saveToPersistentStoreAndWait];
            [[NSNotificationCenter defaultCenter] removeObserver:contextObserver];
            //#### background task ends
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }
    
}


- (void)parseTimetableFromFile:(NSString *)filePath timetableOwner:(NSManagedObject *)owner completion:(void (^)(void))completion
{
    if (owner == nil) {
        if (completion)
            completion();
    }
        
    UIApplication * application = [UIApplication sharedApplication];
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask:background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            //### background task starts
            NSManagedObjectContext *threadContext =
            [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            threadContext.parentContext = [NSManagedObjectContext defaultContext];
            //threadContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator defaultStoreCoordinator];
            
            id contextObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:NSManagedObjectContextDidSaveNotification
                                  object:threadContext
                                  queue:nil
                                  usingBlock:^(NSNotification* note)
                                  {
                                      NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
                                      [moc performBlock:^(){
                                          [moc mergeChangesFromContextDidSaveNotification:note];
                                          [moc saveToPersistentStoreAndWait];
                                      }];
                                  }];
            
            NSDictionary *dict = [self getJSONFromFile:filePath];
            
            int64_t timestamp = [dict[@"timestamp"] longLongValue];
            [T3SystemInfo updateTimetableForOwner:owner timestamp:timestamp inContext:threadContext];
            
            NSManagedObject *contextOwner = [owner inContext:threadContext];
        
            if ([owner isKindOfClass:[T3Group class]]) {
                for (T3TimeTable *timetable in ((T3Group *)contextOwner).timetable) {
                    [timetable deleteInContext:threadContext];
                }
            
            } else if ([owner isKindOfClass:[T3Lecturer class]]) {
                for (T3TimeTable *timetable in ((T3Lecturer *)contextOwner).timetable) {
                    [timetable deleteInContext:threadContext];
                }
            
            }
            
            [threadContext saveToPersistentStoreAndWait];
            
            NSArray *lessonsArray = dict[@"lessons"];
            
            if ([lessonsArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in lessonsArray) {
                    
                    T3TimeTable *timetable = [T3TimeTable createTimetableFromServerObject:dict
                                                                                inContext:threadContext];

                    if ([owner isKindOfClass:[T3Group class]]) {
                        timetable.group = (T3Group *)contextOwner;
                        if (timetable)
                            [(T3Group *)contextOwner addTimetableObject:timetable];
                        
                    } else if ([owner isKindOfClass:[T3Lecturer class]]) {
                        timetable.lecturer = (T3Lecturer *)contextOwner;
                        if (timetable)
                            [(T3Lecturer *)contextOwner addTimetableObject:timetable];
                    }
                }
            }
            
            [T3TimeTable markUnnecessaryTimetableItemsAsInvisibleForOwner:owner inContext:threadContext];
            
            [threadContext saveToPersistentStoreAndWait];
            
            [[NSNotificationCenter defaultCenter] removeObserver:contextObserver];
            //#### background task ends
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }

}

- (NSDictionary *)getJSONFromFile:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath] == YES) {
        
        NSData *data = [fileManager contentsAtPath:filePath];
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([json isKindOfClass:[NSDictionary class]]){
            return (NSDictionary *)json;
        }
        return nil;
        
    } else {
        return nil;
    }

}
#pragma mark - search in tasks collection

- (NSArray *)findItemsWithItemType:(T3UpdateItemType)type
{
    NSSet *set = [self.tasks keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop){
        if (((T3UpdateItem *)obj).type == type) {
            return YES;
        } else {
            return NO;
        }
    }];
    NSArray *result = [self.tasks objectsForKeys:[set allObjects] notFoundMarker:[NSNull null]];
    return result;
}

- (T3UpdateItem *)findItemWithUpdatedObjectServerID:(NSNumber *)objectID
{
    NSSet *set = [self.tasks keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop){
        if ([((T3UpdateItem *)obj).updatedObjectServerID integerValue] == [objectID integerValue]) {
            return YES;
        } else {
            return NO;
        }
    }];
    NSArray *result = [self.tasks objectsForKeys:[set allObjects] notFoundMarker:[NSNull null]];
    return [result firstObject];
}

- (NSManagedObject *)objectForItem:(T3UpdateItem *)item
{
    if (item.type == T3UpdateItemGroupTimetable) {
        
    } else if (item.type == T3UpdateItemLecturerTimetable) {
        
    }
    
    return nil;
}

#pragma mark - favourites update

-(void)onUpdateTimerTick:(NSTimer *)timer
{
    [self startUpdateFavouritesInTime:YES];
}

- (void)startUpdateFavouritesInTime:(BOOL)inTime
{
    NSArray *allFavourites = nil;
    
    if (inTime) {
        allFavourites = [T3Favourites findAll];
        
        for (T3Favourites *favourite in allFavourites) {
            favourite.isNeedUpdate = @(YES);
        }
        if ([allFavourites count] > 0)
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        
    } else {
        allFavourites = [T3Favourites findByAttribute:@"isNeedUpdate" withValue:@(YES)];
    }

    
    if ([allFavourites count] == 0)
        return;
    
    
    if ([self.hostReachability currentReachabilityStatus] == NotReachable)
        return;
    
    for (T3Favourites *favourite in allFavourites) {
        
        if ([favourite.objectType integerValue] == T3FavouriteGroup) {
            [self loadTimetableForGroupId:favourite.serverID fileUrl:favourite.fileUrl complite:^(NSError *error) {
                
                if (!error) {
                    favourite.isNeedUpdate = @(NO);
                    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
                } else {
                    // TODO : do something
                }
                
            }];
        }
    }
}

#pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)note
{
	if ([self.hostReachability currentReachabilityStatus] != NotReachable) {
        [self startUpdateFavouritesInTime:NO];
    }
        
}

@end
