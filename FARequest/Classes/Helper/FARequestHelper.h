//
//  FARequestHelper.h
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import <Foundation/Foundation.h>

@interface FARequestHelper : NSObject


#pragma mark - JSON

+(NSString*)GetJSON:(id)object;

#pragma mark - Encode

+ (NSString *)URLEncodeStringFromString:(NSString *)string;

#pragma mark - check internet connection

+(BOOL)isNetworkAvailable;

#pragma mark - caching
+(BOOL)isCached:(NSURL*)url Headers:(NSDictionary*)Headers;

+(void)cachThisRequest:(NSString*)request Data:(NSString*)data;

+(NSString *)getHashWithString:(NSString *)str ;

#pragma mark - encryption
+(NSString*) encryptionKey;

+(void) setEncryptionKey:(NSString*)key;

+ (NSData*) encryptWithKey: (NSString *) key value:(NSString*)value;

+ (NSData*)DecryptAES: (NSString*)key value:(NSData*)value;

@end
