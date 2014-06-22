//
//  T3WebJSONResponse.m
//  TusurTimetable
//

#import "T3WebJSONResponse.h"

@implementation T3WebJSONResponse

- (id)initWithURLResponse:(NSHTTPURLResponse *)response JSON:(id)jsonData
{
    return [self initWithURLResponse:response JSON:jsonData error:nil];
}

- (id)initWithURLResponse:(NSHTTPURLResponse *)response JSON:(id)jsonData error:(NSError *)error
{
    self = [super init];
    if (self) {
        _JSON = jsonData;
        _statusCode = response.statusCode;
        _error = error;
        
        if (self.error == nil) {
            [self proccessJSON];
        }
    }
    
    return self;
}

- (void)proccessJSON
{
// TODO : parse
}

@end
