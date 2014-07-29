//
//  T3DownloadManager.m
//  TusurTimetable
//
//  Created by Katte on 02.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import "T3DownloadManager.h"
#import "T3AppDelegate.h"

#import "EGOCache.h"

#define DEFAULT_DESTINATION NSTemporaryDirectory()

#define MAKE_KEY(s) [[[s stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]

@interface T3DownloadManager ()

@property (strong, nonatomic) NSMutableArray *sessionList;
@property (strong, nonatomic) NSURLSessionConfiguration *configuration;
@property (strong, nonatomic) NSMutableArray *sessionTaskList;

@property (strong, nonatomic) ProgressBlock progressBlock;
@property (strong, nonatomic) ErrorBlock errorBlock;
@property (strong, nonatomic) CompleteBlock completeBlock;

@property (nonatomic, strong) NSURL *docDirectoryURL;

@end


@implementation T3DownloadManager

+ (T3DownloadManager *)defaultManager
{
    static T3DownloadManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance configure];
    });
    
    return instance;
}

- (void)configure
{
    self.configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.MBKWON.MBSessionDownload - BackgroundSession"];
    
    self.sessionList = [NSMutableArray new];
    self.sessionTaskList = [NSMutableArray new];
    self.destinationList = [NSMutableDictionary new];
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
}

-(NSUInteger)makeSessionWithProgressBlock:(ProgressBlock)progressBlock
                               errorBlock:(ErrorBlock)errorBlock
                            completeBolck:(CompleteBlock)completeBlock
{
    _progressBlock = progressBlock;
    _errorBlock = errorBlock;
    _completeBlock = completeBlock;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:nil];
    
    [_sessionList addObject:session];
    return [_sessionList indexOfObject:session];
}


-(NSUInteger)startDownloadWithURL:(NSString *)downloadURLString sessionID:(NSUInteger)sessionID
{
    return [self startDownloadWithURL:downloadURLString destination:DEFAULT_DESTINATION sessionID:sessionID];
}

-(NSUInteger)startDownloadWithURL:(NSString *)downloadURLString destination:(NSString *)destination sessionID:(NSUInteger)sessionID
{
    NSString *key = MAKE_KEY(downloadURLString);
    NSData *resumeData = [[EGOCache globalCache] dataForKey:key];
    NSURLSessionDownloadTask *downloadTask;
    
    if (resumeData != nil) {
        
        [[EGOCache globalCache] removeCacheForKey:key];
        downloadTask = [[_sessionList objectAtIndex:sessionID] downloadTaskWithResumeData:resumeData];
        
    } else {
        
        NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
        downloadTask = [[_sessionList objectAtIndex:sessionID] downloadTaskWithRequest:request];
    }
    
    NSString *destinationKey = [NSString stringWithFormat:@"%lu", (unsigned long)downloadTask.taskIdentifier];
    [_destinationList setObject:destination forKey:destinationKey];
    [_sessionTaskList addObject:downloadTask];
    [downloadTask resume];
    
    return [downloadTask taskIdentifier];
}


#pragma mark - pause download
-(void)pauseDownloadWithIdentifier:(NSUInteger)taskID
{
    NSURLSessionDownloadTask *pausedTask;
    
    for (NSURLSessionDownloadTask *task in _sessionTaskList) {
        if (task.taskIdentifier == taskID) {
            pausedTask = task;
            break;
        }
    }
    
    if (pausedTask != nil) {
        [pausedTask cancelByProducingResumeData:^(NSData *resumeData){
            if (resumeData != nil) {
                
                NSString *key = MAKE_KEY(pausedTask.originalRequest.URL.absoluteString);
                [[EGOCache globalCache] setData:resumeData forKey:key withTimeoutInterval:A_WEEK];
            }
        }];
        [_sessionTaskList removeObject:pausedTask];
    }
}

-(void)pauseAllTasks
{
    for (NSURLSessionDownloadTask *pausedTask in _sessionTaskList) {
        
        if (pausedTask != nil) {
            [pausedTask cancelByProducingResumeData:^(NSData *resumeData){
                if (resumeData != nil) {
                    
                    NSString *key = MAKE_KEY(pausedTask.originalRequest.URL.absoluteString);
                    [[EGOCache globalCache] setData:resumeData forKey:key withTimeoutInterval:A_WEEK];
                }
            }];
        }
    }
    
    [_sessionTaskList removeAllObjects];
}


#pragma mark - stop download
-(void)stopDownloadWithIdentifier:(NSUInteger)taskID
{
    for (NSURLSessionDownloadTask *stopTask in _sessionTaskList) {
        if (stopTask.taskIdentifier == taskID) {
            [stopTask cancel];
            [_sessionTaskList removeObject:stopTask];
            break;
        }
    }
}

-(void)stopAllTasks
{
    for (NSURLSessionDownloadTask *stopTask in _sessionTaskList) {
        
        if (stopTask != nil) {
            [stopTask cancel];
        }
    }
    
    [_sessionTaskList removeAllObjects];
}

#pragma mark - delegate for download task <NSURLSessionDownloadDelegate>
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double) totalBytesWritten/(double) totalBytesExpectedToWrite;
    
    NSLog(@"Download Task : %@  progress : %lf", downloadTask, progress);
    
    if (_progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressBlock([downloadTask taskIdentifier], bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success) {
        
        if (_completeBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _completeBlock([downloadTask taskIdentifier], success, [destinationURL path]);
            });
        }
        
    } else {
        
        NSLog(@"Error during the copy : %@", [error localizedDescription]);
        if (_errorBlock) {
            _errorBlock([downloadTask taskIdentifier], error);
        }
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}


#pragma mark - delegate for session task <NSURLSessionTaskDelegate, NSURLSessionDelegate>
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error == nil) {
        NSLog(@"Task ; %@  complete successfully", task);
    } else {
        NSLog(@"Task : %@  complete with error : %@", task, [error localizedDescription]);
        if (_errorBlock) {
            _errorBlock([task taskIdentifier], error);
        }
    }

    [_sessionTaskList removeObject:task];
//    _downloadTask = nil;
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    T3AppDelegate *appdelegate = (T3AppDelegate *) [[UIApplication sharedApplication] delegate];

    if (appdelegate.backgroundTransferCompletionHandler) {
        void (^completionHandler)() = appdelegate.backgroundTransferCompletionHandler;
        appdelegate.backgroundTransferCompletionHandler = nil;
        completionHandler();
    }

    NSLog(@"Alltask are finished");
}

@end
