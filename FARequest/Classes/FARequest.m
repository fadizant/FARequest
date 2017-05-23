//
//  FARequest.m
//  SlideBar
//
//  Created by Fadi on 10/8/15.
//  Copyright (c) 2015 BeeCell. All rights reserved.
//

#import "FARequest.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation FARequest
#pragma mark - internet status
static Reachability *reachability;

+(NetworkStatus) networkStatus
{
    if (!reachability) {
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    return [reachability currentReachabilityStatus];
}

#pragma mark - Authorization
static NSString *username;
static NSString *password;

+(void)setUsername:(NSString*)value{username=value;}
+(NSString*)username{return username;}

+(void)setPassword:(NSString*)value{password=value;}
+(NSString*)password{return password;}

#pragma mark - Use block requests

#pragma mark shortcut request

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
         requestCompleted:(requestCompleted)requestCompleted
{
    
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:FARequestTypeGET
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:YES
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendRequestWithUrl:(NSURL*)url
                   object:(id)object
         requestCompleted:(requestCompleted)requestCompleted
{
    
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:FARequestTypeGET
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:YES
                   requestCompleted:requestCompleted];
}

#pragma mark shortcut request with type

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
              RequestType:(FARequestType)Type
         requestCompleted:(requestCompleted)requestCompleted
{
    
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:YES
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendRequestWithUrl:(NSURL*)url
                   object:(id)object
              RequestType:(FARequestType)Type
         requestCompleted:(requestCompleted)requestCompleted{
    
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:YES
                   requestCompleted:requestCompleted];
}

#pragma mark shortcut request with cache

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
              RequestType:(FARequestType)Type
                 useCache:(BOOL)useCashe
         requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendRequestWithUrl:(NSURL*)url
                   object:(id)object
              RequestType:(FARequestType)Type
                 useCache:(BOOL)useCashe
         requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

#pragma mark shortcut request without timeOut , Encode , images and header
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
                      requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:nil
                                   KeysAndValues:Data
                                           Image:nil
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO
                                        useCache:NO
                                requestCompleted:requestCompleted];
}

//Keys and Values block request with cache
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
                              useCache:(BOOL)useCashe
                      requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:nil
                                   KeysAndValues:Data
                                           Image:nil
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO
                                        useCache:useCashe
                                requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
             requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendJSONRequestWithUrl:url
                                Headers:nil
                                   JSON:JSON
                                  Image:nil
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO
                               useCache:NO
                       requestCompleted:requestCompleted];
}

//JSON block request with cache
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
                     useCache:(BOOL)useCashe
             requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendJSONRequestWithUrl:url
                                Headers:nil
                                   JSON:JSON
                                  Image:nil
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO
                               useCache:useCashe
                       requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:Param
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                         Parameter:(NSString *)Param
                            object:(id)object
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:Param
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}


#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
                              useCache:(BOOL)useCashe
                      requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:Headers
                                   KeysAndValues:Data
                                           Image:nil
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO
                                        useCache:useCashe
                                requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
                     useCache:(BOOL)useCashe
             requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendJSONRequestWithUrl:url
                                Headers:Headers
                                   JSON:JSON
                                  Image:nil
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO
                               useCache:useCashe
                       requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                            object:(id)object
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:nil
                        RequestType:Type
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                              useCache:(BOOL)useCashe
                      requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:Headers
                                   KeysAndValues:Data
                                           Image:images
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO
                                        useCache:useCashe
                                requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
                     useCache:(BOOL)useCashe
             requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendJSONRequestWithUrl:url
                                Headers:Headers
                                   JSON:JSON
                                  Image:images
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO
                               useCache:useCashe
                       requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:images
                        RequestType:Type
                            timeOut:120
                             object:nil
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//Full block request With object
+(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                            object:(id)object
                       RequestType:(FARequestType)Type
                          useCache:(BOOL)useCashe
                  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:images
                        RequestType:Type
                            timeOut:120
                             object:object
                    EncodeParameter:NO
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

#pragma mark full request

//Keys and Values block request
+(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                               timeOut:(float)timeOut
                       EncodeParameter:(BOOL)Encoding
                              useCache:(BOOL)useCashe
                      requestCompleted:(requestCompleted)requestCompleted
{
    NSString *Parameter = @"";
    if (Data) {
        for (NSString* key in Data.allKeys) {
            Parameter = [Parameter stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[Data objectForKey:key]]];
        }
        Parameter = Parameter ? [Parameter substringToIndex:Parameter.length-1] : @"";
    }
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Parameter
                              Image:images
                        RequestType:Type
                            timeOut:timeOut
                             object:nil
                    EncodeParameter:Encoding
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
                      timeOut:(float)timeOut
              EncodeParameter:(BOOL)Encoding
                     useCache:(BOOL)useCashe
             requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:[self GetJSON:JSON]
                              Image:images
                        RequestType:Type
                            timeOut:timeOut
                             object:nil
                    EncodeParameter:Encoding
                           useCache:useCashe
                   requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendRequestWithUrl:(NSURL*)url
                  Headers:(NSDictionary *)Headers
                Parameter:(NSString *)Param
                    Image:(NSMutableArray <UIImage *>*)images
              RequestType:(FARequestType)Type
                  timeOut:(float)timeOut
                   object:(id)object
          EncodeParameter:(BOOL)Encoding
                 useCache:(BOOL)useCashe
         requestCompleted:(requestCompleted)requestCompleted
{
    //read from cache
    //__block BOOL hasCache = NO;
    __block NSData * cacheResponse;
    if (useCashe) {
    // Use GCD's background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *request = [self getHashWithString:[NSString stringWithFormat:@"%@%@%@",[url absoluteString],Param,Headers ? [self GetJSON:Headers] : @""]];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"FACache/%@",request]];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]]) {
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error != nil) {
                NSLog(@"error creating directory: %@", error);
                //..
            }
        }
        if([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
            //            hasCache = YES;
            cacheResponse = [NSData dataWithContentsOfFile:dataPath]; //[[NSFileManager defaultManager] contentsAtPath:dataPath];
            if (EncryptionKey && ![EncryptionKey isEqualToString:@""]) {
                cacheResponse = [self DecryptAES:EncryptionKey value:cacheResponse];
                //                [cacheResponse decryptWithKey:EncryptionKey];
            }
            if (cacheResponse) {
                //parsing the JSON response
                id jsonObject = [NSJSONSerialization
                                 JSONObjectWithData:cacheResponse
                                 options:NSJSONReadingAllowFragments
                                 error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    requestCompleted(jsonObject,200 ,object,YES);
                });
            }
        }
    });
        
    }
    
    //check internet connection before request
    if ([FARequest networkStatus] == NotReachable) {
        return NO;
    }
    
    //show loading progress bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOut];
    //sets the receiver’s HTTP request method
    switch (Type) {
        case FARequestTypeGET:
            [urlRequest setHTTPMethod:@"GET"];
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case FARequestTypePOST:
        {
            [urlRequest setHTTPMethod:@"POST"];
            NSData *data = [Param dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            if ([NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error] == nil || [Param isEqualToString:@""])
            {
                // not JSON
                [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }
            else
                [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
            break;
        case FARequestTypePATCH:
            [urlRequest setHTTPMethod:@"PATCH"];
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case FARequestTypeDELETE:
            [urlRequest setHTTPMethod:@"DELETE"];
            break;
        case FARequestTypePUT:
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        default:
            break;
    }
    
    //Authorization
    if (username && ![username isEqualToString:@""]) {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    //set headers
    if(Headers)
        for (NSString *header in Headers.allKeys) {
            [urlRequest addValue:[Headers objectForKey:header] forHTTPHeaderField:header];
        }
    
    //param fix spaces
    Param = [Param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //init body
    id body;
    
    //check if there is images to send or not
    if (images) {
        // Build the request body
        NSString *boundary = @"SportuondoFormBoundary";
        NSMutableData *body = [NSMutableData data];
        
        //fill params
        NSArray *params = [Param componentsSeparatedByString:@"&"];
        for (NSString* item in params) {
            NSArray *keyValue = [item componentsSeparatedByString:@"="];
            if (keyValue.count >= 2) {
                // Body part for "key" parameter. This is a string.
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", keyValue[0]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", keyValue[1]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        //fill images
        for (UIImage *image in images) {
            // Body part for the attachament. This is an image.
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",
                                   object ? object : @"image",
                                   object ? object : @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //        // Init the URLRequest
        //        NSString *boundary = @"---------------------------14737809831466499882746641449";
        //        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        //        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        //
        //        body = [NSMutableData data];
        //
        //        //chaeck if there is param
        //        if (Param && ![Param isEqualToString:@""]) {
        //            //Encode
        //            if(Encoding)
        //                Param = [self URLEncodeStringFromString:Param];
        //
        //            if (![Param hasSuffix:@"&"]) {
        //                Param = [Param stringByAppendingString:@"&"];
        //            }
        //
        //            [body appendData:[Param dataUsingEncoding:NSUTF8StringEncoding]];
        //        }
        //
        //
        //        for (UIImage *image in images) {
        //            NSData *imageData = UIImageJPEGRepresentation(image, 1);
        //
        //            NSString *filename = @"filename";
        //            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; file=\"%@.jpg\"\r\n", filename]] dataUsingEncoding:NSUTF8StringEncoding]];
        //            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //            [body appendData:[NSData dataWithData:imageData]];
        //            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //        }
        //        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //        //set lenght
        //        [urlRequest addValue:[NSString stringWithFormat:@"%i", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        //
        //        //sets the request body of the receiver to the specified data.
        //        [urlRequest setHTTPBody:body];
    } else {
        
        //Encode
        if(Encoding)
            Param = [self URLEncodeStringFromString:Param];
        
        //create string for parameters that we need to send in the HTTP POST body
        body =  [NSString stringWithFormat:@"%@", Param];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        
        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    if (Headers) {
        // Setup the session
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = Headers;
        
        // Create the session
        // We can use the delegate to track upload progress
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:FARequest.self delegateQueue:nil];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      //         NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          NSError *errorParsing = nil;
                                          if (data) {
                                              //parsing the JSON response
                                              id jsonObject = [NSJSONSerialization
                                                               JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                               error:&errorParsing];
                                              //check if there is cache
                                              BOOL sendBlock=YES;
                                              NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              if (cacheResponse) {
                                                  NSString *cacheResponseString = [[NSString alloc] initWithData:cacheResponse encoding:NSUTF8StringEncoding];
                                                  if ([responseString isEqualToString:cacheResponseString]) {
                                                      sendBlock=NO;
                                                  }
                                                  else
                                                  {
                                                      //if cache date not same of response one 
                                                      [self cachThisRequest:[NSString stringWithFormat:@"%@%@%@",[url absoluteString],Param,Headers ? [self GetJSON:Headers] : @""] Data:responseString];
                                                  }
                                              }
                                              else if (Type == FARequestTypeGET)
                                              {
                                                  // cache data for GET request only
                                                  [self cachThisRequest:[NSString stringWithFormat:@"%@%@%@",[url absoluteString],Param,Headers ? [self GetJSON:Headers] : @""] Data:responseString];
                                              }
                                              
                                              if(sendBlock)
                                              {
                                                  if (jsonObject) {
                                                      requestCompleted(jsonObject,(int)[httpResponse statusCode] ,object , NO);
                                                      
                                                      //send Notification center
                                                      if (object) {
                                                          [[NSNotificationCenter defaultCenter]
                                                           postNotificationName:@"FARequestCompleted"
                                                           object:self
                                                           userInfo:@{@"result":jsonObject,
                                                                      @"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                                      @"object":object,
                                                                      @"hasCach":[NSNumber numberWithBool:NO]}];
                                                      } else {
                                                          [[NSNotificationCenter defaultCenter]
                                                           postNotificationName:@"FARequestCompleted"
                                                           object:self
                                                           userInfo:@{@"result":jsonObject,
                                                                      @"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                                      @"hasCach":[NSNumber numberWithBool:NO]}];
                                                      }
                                                      
                                                      
                                                      
                                                  } else {
                                                      requestCompleted([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],(int)[httpResponse statusCode] , object , NO);
                                                      
                                                      //send Notification center
                                                      if (object) {
                                                          [[NSNotificationCenter defaultCenter]
                                                           postNotificationName:@"FARequestCompleted"
                                                           object:self
                                                           userInfo:@{@"result":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                                                                      @"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                                      @"object":object,
                                                                      @"hasCach":[NSNumber numberWithBool:NO]}];
                                                      } else {
                                                          [[NSNotificationCenter defaultCenter]
                                                           postNotificationName:@"FARequestCompleted"
                                                           object:self
                                                           userInfo:@{@"result":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                                                                      @"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                                      @"hasCach":[NSNumber numberWithBool:NO]}];
                                                      }
                                                  }
                                              }
                                          }
                                          else
                                          {
                                              requestCompleted(nil,(int)[httpResponse statusCode] , object , NO);
                                              
                                              //send Notification center
                                              if (object) {
                                                  [[NSNotificationCenter defaultCenter]
                                                   postNotificationName:@"FARequestCompleted"
                                                   object:self
                                                   userInfo:@{@"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                              @"object":object,
                                                              @"hasCach":[NSNumber numberWithBool:NO]}];
                                              } else {
                                                  [[NSNotificationCenter defaultCenter]
                                                   postNotificationName:@"FARequestCompleted"
                                                   object:self
                                                   userInfo:@{@"responseCode":[NSNumber numberWithInteger:[httpResponse statusCode]],
                                                              @"hasCach":[NSNumber numberWithBool:NO]}];
                                              }
                                              
                                          }
                                          //hide loading progress bar
                                          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                          
                                      });
                                  }];
    
    [task resume];
    return YES;
}

#pragma mark - Use delegat request

#pragma mark init

- (instancetype)initWithParent:(UIViewController *)view Tag:(int)tag
{
    self = [super init];
    if (self) {
        self.delegate = view;
        self.tag = tag;
    }
    return self;
}

#pragma mark requests
#pragma mark shortcut request
//Full block request
-(BOOL)sendRequestWithUrl:(NSURL*)url
              RequestType:(FARequestType)Type
{
    return [self sendRequestWithUrl:url
                            Headers:nil
                          Parameter:@""
                              Image:nil
                        RequestType:Type
                            timeOut:120
                    EncodeParameter:NO];
}

#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                           RequestType:(FARequestType)Type
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:Headers
                                   KeysAndValues:Data
                                           Image:nil
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO];
}

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                  RequestType:(FARequestType)Type
{
    return [self sendJSONRequestWithUrl:url
                                Headers:Headers
                                   JSON:JSON
                                  Image:nil
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO];
}

//Full block request
-(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                       RequestType:(FARequestType)Type
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:nil
                        RequestType:Type
                            timeOut:120
                    EncodeParameter:NO];
}

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
{
    return [self sendKeysAndValuesRequestWithUrl:url
                                         Headers:Headers
                                   KeysAndValues:Data
                                           Image:images
                                     RequestType:Type
                                         timeOut:120
                                 EncodeParameter:NO];
}

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
{
    return [self sendJSONRequestWithUrl:url
                                Headers:Headers
                                   JSON:JSON
                                  Image:images
                            RequestType:Type
                                timeOut:120
                        EncodeParameter:NO];
}

//Full block request
-(BOOL)sendParameterRequestWithUrl:(NSURL*)url
                           Headers:(NSDictionary *)Headers
                         Parameter:(NSString *)Param
                             Image:(NSMutableArray <UIImage *>*)images
                       RequestType:(FARequestType)Type
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Param
                              Image:images
                        RequestType:Type
                            timeOut:120
                    EncodeParameter:NO];
}

#pragma mark full request

//Keys and Values block request
-(BOOL)sendKeysAndValuesRequestWithUrl:(NSURL*)url
                               Headers:(NSDictionary *)Headers
                         KeysAndValues:(NSMutableDictionary *)Data
                                 Image:(NSMutableArray <UIImage *>*)images
                           RequestType:(FARequestType)Type
                               timeOut:(float)timeOut
                       EncodeParameter:(BOOL)Encoding
{
    NSString *Parameter ;
    for (NSString* key in Data.allKeys) {
        Parameter = [NSString stringWithFormat:@"%@=%@&",key,[Data objectForKey:key]];
    }
    Parameter = Parameter ? [Parameter substringToIndex:Parameter.length-1] : @"";
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:Parameter
                              Image:images
                        RequestType:Type
                            timeOut:timeOut
                    EncodeParameter:Encoding];
}

//JSON block request
-(BOOL)sendJSONRequestWithUrl:(NSURL*)url
                      Headers:(NSDictionary *)Headers
                         JSON:(NSDictionary *)JSON
                        Image:(NSMutableArray <UIImage *>*)images
                  RequestType:(FARequestType)Type
                      timeOut:(float)timeOut
              EncodeParameter:(BOOL)Encoding
{
    return [self sendRequestWithUrl:url
                            Headers:Headers
                          Parameter:[FARequest GetJSON:JSON]
                              Image:images
                        RequestType:Type
                            timeOut:timeOut
                    EncodeParameter:Encoding];
}

//Full block request
-(BOOL)sendRequestWithUrl:(NSURL*)url
                  Headers:(NSDictionary *)Headers
                Parameter:(NSString *)Param
                    Image:(NSMutableArray <UIImage *>*)images
              RequestType:(FARequestType)Type
                  timeOut:(float)timeOut
          EncodeParameter:(BOOL)Encoding
{
    //check internet connection before request
    if (![FARequest isNetworkAvailable]) {
        return NO;
    }
    
    //show loading progress bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOut];
    //sets the receiver’s HTTP request method
    switch (Type) {
        case FARequestTypeGET:
            [urlRequest setHTTPMethod:@"GET"];
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case FARequestTypePOST:
        {
            [urlRequest setHTTPMethod:@"POST"];
            NSData *data = [Param dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            if ([NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error] == nil || [Param isEqualToString:@""])
            {
                // not JSON
                [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }
            else
                [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
            break;
        case FARequestTypePATCH:
            [urlRequest setHTTPMethod:@"PATCH"];
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case FARequestTypeDELETE:
            [urlRequest setHTTPMethod:@"DELETE"];
            break;
        case FARequestTypePUT:
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        default:
            break;
    }
    
    //set headers
    if(Headers)
        for (NSString *header in Headers.allKeys) {
            [urlRequest addValue:[Headers objectForKey:header] forHTTPHeaderField:header];
        }
    
    //param fix spaces
    Param = [Param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //init body
    id body;
    
    //check if there is images to send or not
    if (images) {
        // Init the URLRequest
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        body = [NSMutableData data];
        
        //chaeck if there is param
        if (Param && ![Param isEqualToString:@""]) {
            //Encode
            if(Encoding)
                Param = [FARequest URLEncodeStringFromString:Param];
            
            if (![Param hasSuffix:@"&"]) {
                Param = [Param stringByAppendingString:@"&"];
            }
            
            [body appendData:[Param dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        for (UIImage *image in images) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            NSString *filename = @"filename";
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; file=\"%@.jpg\"\r\n", filename]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:body];
    } else {
        
        //Encode
        if(Encoding)
            Param = [FARequest URLEncodeStringFromString:Param];
        
        //create string for parameters that we need to send in the HTTP POST body
        body =  [NSString stringWithFormat:@"%@", Param];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        
        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //allocate a new operation queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //Loads the data for a URL request and executes a handler block on an
    //operation queue when the request completes or fails.
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
         //         NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
         if ((data && [data length] != 0) || error == nil){
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self getResponse:data responseCode:(int)[httpResponse statusCode] URL:url];
             });
         }
         else if (error != nil){
             NSLog(@"error = %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self getResponse:nil responseCode:(int)[httpResponse statusCode] URL:url];
             });
         }
         else
         {
             NSLog(@"error = %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self getResponse:nil responseCode:(int)[httpResponse statusCode] URL:url];
             });
         }
     }];
    
    return YES;
}


#pragma mark Response
-(void)getResponse:(NSData *)Data responseCode:(int)responseCode URL:(NSURL*)url
{
    //Show Respons Result in Log
    NSError *error = nil;
    
    if (Data) {
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:Data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            //push delegate
            [self.delegate requestCompleted:jsonObject responseCode:responseCode Tag:(int)self.tag];
        }
        else
        {
            [self.delegate requestCompleted:nil responseCode:responseCode Tag:(int)self.tag];
        }
    }
    else
        [self.delegate requestCompleted:nil responseCode:responseCode Tag:(int)self.tag];
    
    
    //hide loading progress bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - helper

#pragma mark JSON

+(NSString*)GetJSON:(id)object
{
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

#pragma mark Encode

+ (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[]");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

#pragma mark check internet connection

+(BOOL)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

#pragma mark - caching
+(BOOL)isCached:(NSURL*)url Headers:(NSDictionary*)Headers
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *request = [self getHashWithString:[NSString stringWithFormat:@"%@%@",[url absoluteString],Headers ? [self GetJSON:Headers] : @""]];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"FACache/%@",request]];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]]) {
        NSError * error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            NSLog(@"error creating directory: %@", error);
            //..
        }
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
}

+(void)cachThisRequest:(NSString*)request Data:(NSString*)data
{
    // Use GCD's background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"FACache/%@",[self getHashWithString:request]]];
        
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]]) {
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/FACache",documentsDirectory]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error != nil) {
                NSLog(@"error creating directory: %@", error);
                //..
            }
        }
        
        // Save it into file system
        if (EncryptionKey && ![EncryptionKey isEqualToString:@""])
        {
            NSData* encryption = [self encryptWithKey:EncryptionKey value:data ];
            [encryption writeToFile:dataPath atomically:YES];
        }
        else
        {
            [data writeToFile:dataPath atomically:YES];
        }
    });
}
+(NSString *)getHashWithString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    
    return s;
}
#pragma mark - encryption
static NSString *EncryptionKey;
+(void) setEncryptionKey:(NSString*)key{EncryptionKey = key;}

+ (NSData*) encryptWithKey: (NSString *) key value:(NSString*)value
{
    NSData *encrypted = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [encrypted length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [encrypted bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSData*)DecryptAES: (NSString*)key value:(NSData*)value
{
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [value length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [value bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
    
}

@end
