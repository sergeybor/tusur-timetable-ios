//
//  T3DownloadManager.h
//  TusurTimetable
//
//  Created by Katte on 02.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FirstBlock)(NSUInteger taskID);
typedef void (^ProgressBlock)(NSUInteger taskID, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^ErrorBlock)(NSUInteger taskID, NSError *error);
typedef void (^CompleteBlock)(NSUInteger taskID, BOOL isFinish, NSString *fielPath);

@interface T3DownloadManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSMutableDictionary *destinationList;


+(T3DownloadManager *)defaultManager;
-(NSUInteger)makeSessionWithProgressBlock:(ProgressBlock)progressBlock
                               errorBlock:(ErrorBlock)errorBlock
                            completeBolck:(CompleteBlock)completeBlock;


-(NSUInteger)startDownloadWithURL:(NSString *)downloadURLString sessionID:(NSUInteger)sessionID;
-(NSUInteger)startDownloadWithURL:(NSString *)downloadURLString destination:(NSString *)destination sessionID:(NSUInteger)sessionID;


-(void)pauseDownloadWithIdentifier:(NSUInteger)taskID;
-(void)pauseAllTasks;


-(void)stopDownloadWithIdentifier:(NSUInteger)taskID;
-(void)stopAllTasks;

- (void)print;

@end
