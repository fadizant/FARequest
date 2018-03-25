//
//  FARequest.m
//
//  Created by Fadi on 10/8/15.
//  Copyright (c) 2015 Fadi. All rights reserved.
//

#import "FARequest.h"
#import "NSURLSession+FARequestSession.h"
@import MobileCoreServices; 

@implementation FARequest
#pragma mark - internet status
static FAReachability *reachability;

+(NetworkStatus) networkStatus
{
    if (!reachability) {
        reachability = [FAReachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    return [reachability currentReachabilityStatus];
}

#pragma mark - Configuration
static FARequestConfiguration *configuration;
+(FARequestConfiguration *)defaultConfiguration{
    if (!configuration)
        configuration = [[FARequestConfiguration alloc]initWithRequestType:FARequestTypeGET];
    
    return configuration;
}
+(void)setDefaultConfiguration:(FARequestConfiguration *)value{
    configuration = value;
}

#pragma mark - Status Handler
static NSMutableDictionary<NSNumber*,NSString*> *statusHandler;
+(NSMutableDictionary<NSNumber*,NSString*> *)statusHandler{
    if (!statusHandler)
        statusHandler = [NSMutableDictionary new];
    return statusHandler;
}
+(NSString*)notificationNameFromKey:(NSNumber*)key{
    return [statusHandler objectForKey:key] ? [statusHandler objectForKey:key] : @"";
}
+(void)setStatusHandler:(NSMutableDictionary<NSNumber*,NSString*> *)value{
    statusHandler = value;
}

#pragma mark - Use block requests
+(BOOL)sendWithRequestObject:(FARequestObject *)requestObject
            RequestCompleted:(requestCompleted)requestCompleted
{
    return [self sendWithRequestObject:requestObject
                RequestProgress:nil
               RequestCompleted:requestCompleted];
}

+(BOOL)sendWithRequestObject:(FARequestObject *)requestObject
             RequestProgress:(requestProgress)requestProgress
            RequestCompleted:(requestCompleted)requestCompleted
{
    NSString * parameter = requestObject.parameter;
    
    if (!requestObject.url){
        NSError *error = [NSError errorWithDomain:@"NSURL" code:-1 userInfo:@{@"Error":@"URL is null"}];
        requestCompleted([[FAResponse alloc]initWithResult:nil
                                                    Object:requestObject.configuration.object
                                               IsFromCache:NO
                                                       URL:requestObject.url
                                              ResponseCode:-1
                                            ResponseHeader:[NSDictionary new]
                                                     Error:error]);
        return YES;
    }
    
    //read from cache
    //__block BOOL hasCache = NO;
    __block NSData * cacheResponse;
    if (requestObject.configuration.useCashe) {
        // Use GCD's background queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            // Generate the file path
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *request = [FARequestHelper getHashWithString:[NSString stringWithFormat:@"%@%@%@",[requestObject.url absoluteString],parameter,requestObject.configuration.header ? [FARequestHelper GetJSON:requestObject.configuration.header] : @""]];
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
                if ([FARequestHelper encryptionKey] && ![[FARequestHelper encryptionKey] isEqualToString:@""]) {
                    cacheResponse = [FARequestHelper DecryptAES:[FARequestHelper encryptionKey] value:cacheResponse];
                    //                [cacheResponse decryptWithKey:EncryptionKey];
                }
                if (cacheResponse) {
                    //parsing the JSON response
                    id jsonObject = [NSJSONSerialization
                                     JSONObjectWithData:cacheResponse
                                     options:NSJSONReadingAllowFragments
                                     error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        requestCompleted([[FAResponse alloc]initWithResult:jsonObject
                                                                    Object:requestObject.configuration.object
                                                               IsFromCache:YES
                                                                       URL:requestObject.url
                                                              ResponseCode:200
                                                            ResponseHeader:[NSDictionary new]
                                                                     Error:nil]);
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
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestObject.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:requestObject.configuration.timeOut];
    //sets the receiver’s HTTP request method
    switch (requestObject.configuration.requestType) {
        case FARequestTypeGET:
            [urlRequest setHTTPMethod:@"GET"];
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            break;
        case FARequestTypePOST:
        {
            [urlRequest setHTTPMethod:@"POST"];
            NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            if ([NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error] == nil || [parameter isEqualToString:@""])
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
        {
            [urlRequest setHTTPMethod:@"PUT"];
            NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            if ([NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error] == nil || [parameter isEqualToString:@""])
            {
                // not JSON
                [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }
            else
                [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
            break;
        default:
            break;
    }
    
    //Authorization
    if (requestObject.configuration.authorization) {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", requestObject.configuration.authorization.user, requestObject.configuration.authorization.password];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    //set headers
    if(requestObject.configuration.header)
        for (NSString *header in requestObject.configuration.header.allKeys) {
            [urlRequest addValue:[requestObject.configuration.header objectForKey:header] forHTTPHeaderField:header];
        }
    
    //param fix spaces (No need for JSON format)
    if (![[urlRequest valueForHTTPHeaderField:@"Content-Type"] isEqualToString:@"application/json"])
        parameter = [parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //init body
    id body;
    
    //check if there is images to send or not
    if (requestObject.mediaFiles && requestObject.mediaFiles.count) {
        
        // set content type
        NSString *boundary = [self generateBoundaryString];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urlRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // Build the request body
        body = [self multiPartWithParameter:parameter Boundary:boundary Files:requestObject.mediaFiles];

        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:body];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%i", (int)[body length]] forHTTPHeaderField:@"Content-Length"];

    } else {
    
        //Encode
        if(requestObject.configuration.encoding)
            parameter = [FARequestHelper URLEncodeStringFromString:parameter];
        
        //create string for parameters that we need to send in the HTTP POST body
        body =  [NSString stringWithFormat:@"%@", parameter];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        
        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    NSURLSession *session = [NSURLSession sharedSession];
    
    if (requestObject.configuration.header) {
        // Setup the session
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = requestObject.configuration.header;
        
        // Create the session
        // We can use the delegate to track upload progress
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:FARequest.self delegateQueue:nil];
    }
    
    if (requestObject.mediaFiles && requestObject.mediaFiles.count) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:FARequest.self delegateQueue:nil];
        session.completed = requestCompleted;
        session.progress = requestProgress;
        session.requestObject = requestObject;
        NSURLSessionDataTask *task = [session uploadTaskWithRequest:urlRequest fromData:body];
        [task resume];
    }
    else{
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          [self responseWithRequest:urlRequest
                                                               Data:data
                                                           Response:response
                                                              Error:error
                                                              Cache:cacheResponse
                                                      RequestObject:requestObject
                                                   RequestCompleted:requestCompleted
                                                          Parameter:parameter];
                                      }];
        
        [task resume];
    }

    return YES;
}

#pragma mark response
+(void)responseWithRequest:(NSMutableURLRequest*)urlRequest
                      Data:(NSData *)data
                  Response:(NSURLResponse *)response
                     Error:(NSError *)error
                     Cache:(NSData *) cacheResponse
             RequestObject:(FARequestObject *)requestObject
          RequestCompleted:(requestCompleted)requestCompleted
                 Parameter:(NSString *) parameter
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    //         NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
    dispatch_async(dispatch_get_main_queue(), ^{
        //hide loading progress bar
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // init
        NSError *errorParsing = nil;
        FAResponse * responseObject = [FAResponse new];
        
        // check if there is data
        if (data) {
            //parsing the JSON response
            id jsonObject = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingAllowFragments
                             error:&errorParsing];
            //check if there is cache
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (cacheResponse) {
                NSString *cacheResponseString = [[NSString alloc] initWithData:cacheResponse encoding:NSUTF8StringEncoding];
                if ([responseString isEqualToString:cacheResponseString]) {
                    // return function to do not send same data
                    return ;
                }
                else
                {
                    //if cache date not same of response one
                    [FARequestHelper cachThisRequest:[NSString stringWithFormat:@"%@%@%@",[requestObject.url absoluteString],parameter,requestObject.configuration.header ? [FARequestHelper GetJSON:requestObject.configuration.header] : @""] Data:responseString];
                }
            }
            else if (requestObject.configuration.requestType == FARequestTypeGET)
            {
                // cache data for GET request only
                [FARequestHelper cachThisRequest:[NSString stringWithFormat:@"%@%@%@",[requestObject.url absoluteString],parameter,requestObject.configuration.header ? [FARequestHelper GetJSON:requestObject.configuration.header] : @""] Data:responseString];
            }
            
            // send if cache data not equal with new data
            if (jsonObject) { // is JSON format
                responseObject = [[FAResponse alloc]initWithResult:jsonObject
                                                            Object:requestObject.configuration.object
                                                       IsFromCache:NO
                                                               URL:requestObject.url
                                                      ResponseCode:(int)[httpResponse statusCode]
                                                    ResponseHeader:[httpResponse allHeaderFields]
                                                             Error:error];
                requestCompleted(responseObject);
                
            } else { // return string if not JSON format
                responseObject = [[FAResponse alloc]initWithResult:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
                                                            Object:requestObject.configuration.object
                                                       IsFromCache:NO
                                                               URL:requestObject.url
                                                      ResponseCode:(int)[httpResponse statusCode]
                                                    ResponseHeader:[httpResponse allHeaderFields]
                                                             Error:error];
                requestCompleted(responseObject);
            }
        }
        else // if response data is nil
        {
            responseObject = [[FAResponse alloc]initWithResult:nil
                                                        Object:requestObject.configuration.object
                                                   IsFromCache:NO
                                                           URL:requestObject.url
                                                  ResponseCode:(int)[httpResponse statusCode]
                                                ResponseHeader:[httpResponse allHeaderFields]
                                                         Error:error];
            requestCompleted(responseObject);
        }
        
        //send Notification center
        if (requestObject.notificationKey) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:requestObject.notificationKey
             object:self
             userInfo:@{FARequestNotificationRequest:requestObject,
                        FARequestNotificationResponse:responseObject,
                        FARequestNotificationRequestCompleted:requestCompleted}];
        }
        
        //Status handler
        NSString *statusKey = [statusHandler objectForKey:[NSNumber numberWithInt:(int)[httpResponse statusCode]]];
        if (statusKey) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:statusKey
             object:self
             userInfo:@{FARequestNotificationRequest:requestObject,
                        FARequestNotificationResponse:responseObject,
                        FARequestNotificationRequestCompleted:requestCompleted}];
        }
        
    });
}

#pragma mark multiPart
+(NSMutableData *)multiPartWithParameter:(NSString*)parameter Boundary:(NSString*)boundary Files:(NSArray<FARequestMediaFile*>*)files{
    NSMutableData* data = [NSMutableData new];
    
    // add params (all params are strings)
    NSArray *params = [parameter componentsSeparatedByString:@"&"];
    for (NSString* item in params) {
        NSArray *keyValue = [item componentsSeparatedByString:@"="];
        if (keyValue.count >= 2) {
            // Body part for "key" parameter. This is a string.
            [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", keyValue[0]] dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[[NSString stringWithFormat:@"%@\r\n", keyValue[1]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // add images data
    for (FARequestMediaFile *file in files) {
        NSString *filename  = file.filename;
        NSData   *filedata  = file.file ? file.file : (file.image? UIImageJPEGRepresentation(file.image,1) : nil);
        if (!filedata && (!file.filePath || [file.filePath isEqualToString:@""]))
            continue; // skip file if not exist
        
        NSString *mimetype  = file.image?  FARequestMediaTypeJPEG : (file.mimetype ? file.mimetype : filedata ? [self mimeTypeForData:filedata] : @"");
        if (file.filePath) {
            filename  = [file.filePath lastPathComponent];
            filedata  = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.filePath]];
            mimetype  = [self mimeTypeForPath:file.filePath];
        }
        
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", file.name, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:filedata];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

+ (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

+ (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return FARequestMediaTypeJPEG;
            break;
        case 0x89:
            return FARequestMediaTypePNG;
            break;
        case 0x47:
            return FARequestMediaTypeGIF;
            break;
        case 0x42:
            return FARequestMediaTypeBMP;
            break;
        case 0x49:
        case 0x4D:
            return FARequestMediaTypeTIFF;
            break;
        case 0x25:
            return FARequestMediaTypePDF;
            break;
        case 0xD0:
            return FARequestMediaTypeVND;
            break;
        case 0x80:
            return FARequestMediaTypeMP4;
        case 0x46:
            return FARequestMediaTypePLAIN;
            break;
        default:
            return FARequestMediaTypeOCTET_STREAM;
    }
    return nil;
}

#pragma mark upload progress
+ (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // update in main thread
        float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
        if (session.progress) {
            session.progress(progress);
        }
    });
}

+ (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self responseWithRequest:dataTask.originalRequest
                         Data:data
                     Response:dataTask.response
                        Error:nil
                        Cache:nil
                RequestObject:session.requestObject
             RequestCompleted:session.completed
                    Parameter:session.requestObject.parameter];
}

+ (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)dataTask didCompleteWithError:(NSError *)error {
    
    if (error) {
        [self responseWithRequest:dataTask.originalRequest
                             Data:nil
                         Response:dataTask.response
                            Error:error
                            Cache:nil
                    RequestObject:session.requestObject
                 RequestCompleted:session.completed
                        Parameter:session.requestObject.parameter];
    }

}

#pragma mark - get request (Download)

+(BOOL)getWithRequestObject:(FARequestObject *)requestObject
           RequestCompleted:(requestCompleted)requestCompleted{
    return [self getWithRequestObject:requestObject
                      RequestProgress:nil
                     RequestCompleted:requestCompleted];
}

+(BOOL)getWithRequestObject:(FARequestObject *)requestObject
            RequestProgress:(requestProgress)requestProgress
           RequestCompleted:(requestCompleted)requestCompleted{
    
    if (!requestObject.url){
        NSError *error = [NSError errorWithDomain:@"NSURL" code:-1 userInfo:@{@"Error":@"URL is null"}];
        requestCompleted([[FAResponse alloc]initWithResult:nil
                                                    Object:requestObject.configuration.object
                                               IsFromCache:NO
                                                       URL:requestObject.url
                                              ResponseCode:-1
                                            ResponseHeader:[NSDictionary new]
                                                     Error:error]);
        return YES;
    }
    
    // check if file exist if no need to override
    if (!requestObject.overWrite){
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //create dir if not exist
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths firstObject];
        path = [path stringByAppendingPathComponent:requestObject.saveInFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            [fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:NO
                                    attributes:nil
                                         error:&error];
        
        
        if ([fileManager fileExistsAtPath:[requestObject filePath]]) {
            if (requestProgress) {
                requestProgress(1.0);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update in main thread
                requestCompleted([[FAResponse alloc] initWithResult:[requestObject filePath]
                                                             Object:nil
                                                        IsFromCache:NO
                                                                URL:requestObject.url
                                                       ResponseCode:FAResponseStatusOK
                                                     ResponseHeader:nil
                                                              Error:nil]);
            });

            return YES;
        }
    }
    
    //check internet connection before request
    if ([FARequest networkStatus] == NotReachable) {
        return NO;
    }
    
    //show loading progress bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 50;
    
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:FARequest.self
                                            delegateQueue:nil];
    
    session.completed = requestCompleted;
    session.progress = requestProgress;
    session.requestObject = requestObject;
    
    //self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.downloadSource]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestObject.url];
    [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    
    // Start the task.
    [downloadTask resume];
    return YES;
}

#pragma mark - NSURLSession Delegate method implementation

+(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //create dir if not exist
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [path stringByAppendingPathComponent:session.requestObject.saveInFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    
    
    if ([fileManager fileExistsAtPath:[session.requestObject filePath]]) {
        [fileManager removeItemAtURL:[session.requestObject fileURL] error:nil];
    }
    
    
    //get fime size
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[location path] error:&error];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    if (fileSize <= 1) { // faild
        dispatch_async(dispatch_get_main_queue(), ^{
            // update in main thread
            //hide loading progress bar
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            session.completed([[FAResponse alloc] initWithResult:downloadTask.response
                                                          Object:nil
                                                     IsFromCache:NO
                                                             URL:location
                                                    ResponseCode:FAResponseStatusInternal_Server_Error
                                                  ResponseHeader:nil
                                                           Error:[NSError errorWithDomain:@"can't save file" code:NSURLErrorCannotWriteToFile userInfo:nil]]);
        });

        return;
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:[session.requestObject fileURL]
                                        error:&error];
    
    if (success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update in main thread
            //hide loading progress bar
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            session.completed([[FAResponse alloc] initWithResult:[session.requestObject filePath]
                                                          Object:nil
                                                     IsFromCache:NO
                                                             URL:location
                                                    ResponseCode:FAResponseStatusOK
                                                  ResponseHeader:nil
                                                           Error:nil]);
        });

        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}

+(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update in main thread
            if (session.progress) {
                session.progress(downloadProgress);
            }
        });
    }
    
}
@end

//to keep download file in background while app minimized

//-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//
//    // Check if all download tasks have been finished.
//    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
//
//        if ([downloadTasks count] == 0) {
//            if (appDelegate.backgroundTransferCompletionHandler != nil) {
//                // Copy locally the completion handler.
//                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
//
//                // Make nil the backgroundTransferCompletionHandler.
//                appDelegate.backgroundTransferCompletionHandler = nil;
//
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    // Call the completion handler to tell the system that there are no other background transfers.
//                    completionHandler();
//
//                    // Show a local notification when all downloads are over.
//                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                    localNotification.alertBody = [NSString stringWithFormat:@"%@ %@",self.fileTitle, @"has been downloaded!"] ;
//                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//                }];
//            }
//        }
//    }];
//}


//add this lines to AppDelegate
//FADownloader
//-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
//
//    self.backgroundTransferCompletionHandler = completionHandler;
//
//}
//header file
//@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();
