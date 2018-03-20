//
//  FARequestConfiguration.m
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import "FARequestConfiguration.h"

@implementation FARequestConfiguration

- (instancetype)initWithRequestType:(FARequestType)requestType
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = nil;
        _object = nil;
        _useCashe = false;
        _encoding = false;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = nil;
        _useCashe = false;
        _encoding = false;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = object;
        _useCashe = false;
        _encoding = false;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = object;
        _useCashe = useCashe;
        _encoding = false;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = object;
        _useCashe = useCashe;
        _encoding = encoding;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding
                            TimeOut:(float)timeOut
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = object;
        _useCashe = useCashe;
        _encoding = encoding;
        _timeOut = 120;
        _authorization = nil;
    }
    return self;
}

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding
                            TimeOut:(float)timeOut
                      Authorization:(FARequestAuthorization*)authorization
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _header = header;
        _object = object;
        _useCashe = useCashe;
        _encoding = encoding;
        _timeOut = 120;
        _authorization = authorization;
    }
    return self;
}

-(FARequestConfiguration*)clone{
    return [[FARequestConfiguration alloc] initWithRequestType:self.requestType
                                                        Header:self.header
                                                        Object:self.object
                                                      UseCashe:self.useCashe
                                                      Encoding:self.encoding
                                                       TimeOut:self.timeOut
                                                 Authorization:self.authorization];
}
@end
