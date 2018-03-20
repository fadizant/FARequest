//
//  FARequest.h
//
//  Created by Fadi on 10/8/15.
//  Copyright (c) 2015 Fadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FAReachability.h"
#import "FADownloader.h"
#import "FAResponse.h"
#import "FARequestObject.h"
#import "FARequestAuthorization.h"
#import "FARequestConfiguration.h"
#import "FARequestHelper.h"
#import "FAQueueRequest.h"
#import "FARequestMediaFile.h"

#pragma mark - FARequestNotification
#define FARequestNotification                       @"FARequestCompleted"
#define FARequestNotificationRequest                @"request"
#define FARequestNotificationResponse               @"response"
#define FARequestNotificationRequestCompleted       @"requestCompleted"


#pragma mark - send request
typedef void (^requestCompleted)(FAResponse *response);
typedef void (^requestProgress)(float progress);

@interface FARequest : NSObject<NSURLConnectionDelegate,UIAlertViewDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>


#pragma mark - internet status
+(NetworkStatus) networkStatus;

#pragma mark - Configuration
+(FARequestConfiguration *)defaultConfiguration;
+(void)setDefaultConfiguration:(FARequestConfiguration *)value;

#pragma mark - Status Handler
+(NSMutableDictionary<NSNumber*,NSString*> *)statusHandler;
+(NSString*)notificationNameFromKey:(NSNumber*)key;
+(void)setStatusHandler:(NSMutableDictionary<NSNumber*,NSString*> *)value;

#pragma mark - send request

+(BOOL)sendWithRequestObject:(FARequestObject *)requestObject
            RequestCompleted:(requestCompleted)requestCompleted;

+(BOOL)sendWithRequestObject:(FARequestObject *)requestObject
             RequestProgress:(requestProgress)requestProgress
            RequestCompleted:(requestCompleted)requestCompleted;

#pragma mark - get request (Download)

+(BOOL)getWithRequestObject:(FARequestObject *)requestObject
            RequestCompleted:(requestCompleted)requestCompleted;

+(BOOL)getWithRequestObject:(FARequestObject *)requestObject
             RequestProgress:(requestProgress)requestProgress
            RequestCompleted:(requestCompleted)requestCompleted;
@end


