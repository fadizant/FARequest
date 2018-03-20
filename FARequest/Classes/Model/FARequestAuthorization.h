//
//  FARequestAuthorization.h
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import <Foundation/Foundation.h>

@interface FARequestAuthorization : NSObject

#pragma mark - Property
@property (nonatomic,retain) NSString *user;
@property (nonatomic,retain) NSString *password;

#pragma mark - Method
- (instancetype)init;
- (instancetype)initWithUser:(NSString*)user Password:(NSString*)password;
@end
