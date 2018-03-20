//
//  FARequestAuthorization.m
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import "FARequestAuthorization.h"

@implementation FARequestAuthorization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = @"";
        _password = @"";
    }
    return self;
}

- (instancetype)initWithUser:(NSString*)user Password:(NSString*)password
{
    self = [super init];
    if (self) {
        _user = user;
        _password = password;
    }
    return self;
}

@end
