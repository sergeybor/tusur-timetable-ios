//
//  T3WebJSONResponse.h
//  TusurTimetable
//

#import <Foundation/Foundation.h>

@interface T3WebJSONResponse : NSObject

@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) id JSON;

- (id)initWithURLResponse:(NSHTTPURLResponse *)response JSON:(id)jsonData;
- (id)initWithURLResponse:(NSHTTPURLResponse *)response JSON:(id)jsonData error:(NSError *)error;

@end
