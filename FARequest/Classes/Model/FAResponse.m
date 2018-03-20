//
//  FAResponse.m
//
//  Created by Fadi Abuzant on 3/13/18.
//

#import "FAResponse.h"

@implementation FAResponse

- (instancetype)initWithResult:(id)JSONResult
                        Object:(id)object
                   IsFromCache:(BOOL)isFromCache
                           URL:(NSURL*)url
                  ResponseCode:(int)responseCode
                ResponseHeader:(NSDictionary*)responseHeader
                         Error:(NSError*)error
{
    self = [super init];
    if (self) {
        _JSONResult = JSONResult;
        _object = object;
        _isFromCache = isFromCache;
        _url = url;
        _responseCode = responseCode;
        _responseHeader = responseHeader;
        _error = error;
    }
    return self;
}

@end
