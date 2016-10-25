//
//  FARequest.h
//
//  Created by Fadi on 10/8/15.
//  Copyright (c) 2015 BeeCell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "NSArray+FAArray.h"
#import "NSDate+FADate.h"
#import "NSDictionary+FADictionary.h"
#import "Reachability.h"

// Protocol definition starts here
@protocol FARequestDelegate <NSObject>
@required
- (void) requestCompleted:(id)JSONResult responseCode:(int)responseCode Tag:(int)tag;
@end

//Block
typedef void (^requestCompleted)(id JSONResult ,int responseCode , id object , BOOL hasCache);

@interface FARequest : NSObject<NSURLConnectionDelegate,UIAlertViewDelegate>
{
    // Delegate to respond back
    id <FARequestDelegate> _delegate;
    NSString* Key;
}
typedef NS_ENUM(NSInteger, FARequestType) {
    FARequestTypeGET,
    FARequestTypePOST,
    FARequestTypePUT,
    FARequestTypeDELETE,
    FARequestTypePATCH,
};
@property (nonatomic,strong) id delegate;
@property int tag;

#pragma mark - internet status

+(NetworkStatus) networkStatus;

#pragma mark - Encryption

+(void) setEncryptionKey:(NSString*)key;

#pragma mark - Use block requests
#pragma mark shortcut request

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
              RequestType:(FARequestType)Type
         requestCompleted:(requestCompleted)requestCompleted;

//Full block request With object
+(BOOL)sendRequestWithUrl:(NSURL*)url
                   object:(id)object
              RequestType:(FARequestType)Type
         requestCompleted:(requestCompleted)requestCompleted;

#pragma mark shortcut request without timeOut , Encode , images and header
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
                      requestCompleted:(requestCompleted)requestCompleted;

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
             requestCompleted:(requestCompleted)requestCompleted;

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                         Parameter:(NSString *)Param
                            object:(id)object
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;


#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
                      requestCompleted:(requestCompleted)requestCompleted;

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
             requestCompleted:(requestCompleted)requestCompleted;

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                            object:(id)object
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                      requestCompleted:(requestCompleted)requestCompleted;

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
             requestCompleted:(requestCompleted)requestCompleted;

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                            object:(id)object
                       RequestType:(FARequestType)Type
                  requestCompleted:(requestCompleted)requestCompleted;

#pragma mark full request

//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                               timeOut:(float)timeOut
                       EncodeParameter:(BOOL)Encoding
                      requestCompleted:(requestCompleted)requestCompleted;

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
                      timeOut:(float)timeOut
              EncodeParameter:(BOOL)Encoding
             requestCompleted:(requestCompleted)requestCompleted;

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
                  Headers:(NSDictionary *)Headers
                Parameter:(NSString *)Param
                    Image:(NSMutableArray <UIImage *>*)images
              RequestType:(FARequestType)Type
                  timeOut:(float)timeOut
                   object:(id)object
          EncodeParameter:(BOOL)Encoding
         requestCompleted:(requestCompleted)requestCompleted;

#pragma mark - Use delegat request

#pragma mark init

- (instancetype)initWithParent:(UIViewController *)view Tag:(int)tag;

#pragma mark requests

#pragma mark shortcut request
//Full block request
-(BOOL)sendRequestWithUrl:(NSURL*)url
              RequestType:(FARequestType)Type;

#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type;

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type;

//Full block request
-(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type;

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type;

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type;

//Full block request
-(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                       RequestType:(FARequestType)Type;

#pragma mark full request

//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                               timeOut:(float)timeOut
                       EncodeParameter:(BOOL)Encoding;

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
                      timeOut:(float)timeOut
              EncodeParameter:(BOOL)Encoding;

//Full block request
-(BOOL)sendRequestWithUrl:(NSURL*)url
                  Headers:(NSDictionary *)Headers
                Parameter:(NSString *)Param
                    Image:(NSMutableArray <UIImage *>*)images
              RequestType:(FARequestType)Type
                  timeOut:(float)timeOut
          EncodeParameter:(BOOL)Encoding;

@end
