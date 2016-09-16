//
//  FARequest.m
//  SlideBar
//
//  Created by Fadi on 10/8/15.
//  Copyright (c) 2015 BeeCell. All rights reserved.
//

#import "FARequest.h"

@implementation FARequest

#pragma mark - Use block requests

#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
     KeysAndValues:(NSMutableDictionary *)Data
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequest:url
                     Headers:Headers
               KeysAndValues:Data
                       Image:nil
                 RequestType:Type
                     timeOut:120
             EncodeParameter:NO
            requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    [self sendRequest:url
              Headers:Headers
                 JSON:JSON
                Image:nil
          RequestType:Type
              timeOut:120
      EncodeParameter:NO
     requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
         Parameter:(NSString *)Param
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    [self sendRequest:url
              Headers:Headers
            Parameter:Param
                Image:nil
          RequestType:Type
              timeOut:120
      EncodeParameter:NO
     requestCompleted:requestCompleted];
}

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
     KeysAndValues:(NSMutableDictionary *)Data
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequest:url
                     Headers:Headers
               KeysAndValues:Data
                       Image:images
                 RequestType:Type
                     timeOut:120
             EncodeParameter:NO
            requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    [self sendRequest:url
              Headers:Headers
                 JSON:JSON
                Image:images
          RequestType:Type
              timeOut:120
      EncodeParameter:NO
     requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
         Parameter:(NSString *)Param
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
  requestCompleted:(requestCompleted)requestCompleted
{
    [self sendRequest:url
              Headers:Headers
            Parameter:Param
                Image:images
          RequestType:Type
              timeOut:120
      EncodeParameter:NO
     requestCompleted:requestCompleted];
}

#pragma mark full request

//Keys and Values block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
     KeysAndValues:(NSMutableDictionary *)Data
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
           timeOut:(float)timeOut
   EncodeParameter:(BOOL)Encoding
  requestCompleted:(requestCompleted)requestCompleted
{
    NSString *Parameter ;
    for (NSString* key in Data.allKeys) {
        Parameter = [NSString stringWithFormat:@"%@=%@&",key,[Data objectForKey:key]];
    }
    Parameter = Parameter ? [Parameter substringToIndex:Parameter.length-1] : @"";
    return [self sendRequest:url
                     Headers:Headers
                   Parameter:Parameter
                       Image:images
                 RequestType:Type
                     timeOut:timeOut
             EncodeParameter:Encoding
            requestCompleted:requestCompleted];
}

//JSON block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
           timeOut:(float)timeOut
   EncodeParameter:(BOOL)Encoding
  requestCompleted:(requestCompleted)requestCompleted
{
    return [self sendRequest:url
                     Headers:Headers
                   Parameter:[self GetJSON:JSON]
                       Image:images
                 RequestType:Type
                     timeOut:timeOut
             EncodeParameter:Encoding
            requestCompleted:requestCompleted];
}

//Full block request
+(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
         Parameter:(NSString *)Param
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
           timeOut:(float)timeOut
   EncodeParameter:(BOOL)Encoding
  requestCompleted:(requestCompleted)requestCompleted
{
    //check internet connection before request
    if (![self isNetworkAvailable]) {
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
                Param = [self URLEncodeStringFromString:Param];
            
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
        [body appendData:[[NSString stringWithFormat:@"\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set lenght
        [urlRequest addValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        //sets the request body of the receiver to the specified data.
        [urlRequest setHTTPBody:body];
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
         NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSError *errorParsing = nil;
             if (data) {
                 //parsing the JSON response
                 id jsonObject = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingAllowFragments
                                  error:&errorParsing];
                 if (jsonObject) {
                     requestCompleted(jsonObject,(int)[httpResponse statusCode]);
                 } else {
                     requestCompleted([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],(int)[httpResponse statusCode]);
                 }
             }
             else
                 requestCompleted(nil,(int)[httpResponse statusCode]);
             //hide loading progress bar
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
         });
     }];
    
    
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

#pragma mark shortcut request without timeOut , Encode and images
//Keys and Values block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
     KeysAndValues:(NSMutableDictionary *)Data
       RequestType:(FARequestType)Type
{
    return [self sendRequest:url
                     Headers:Headers
               KeysAndValues:Data
                       Image:nil
                 RequestType:Type
                     timeOut:120
             EncodeParameter:NO];
}

//JSON block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
       RequestType:(FARequestType)Type
{
    [self sendRequest:url
              Headers:Headers
                 JSON:JSON
                Image:nil
          RequestType:Type
              timeOut:120
      EncodeParameter:NO];
}

//Full block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
         Parameter:(NSString *)Param
       RequestType:(FARequestType)Type
{
    [self sendRequest:url
              Headers:Headers
            Parameter:Param
                Image:nil
          RequestType:Type
              timeOut:120
      EncodeParameter:NO];
}

#pragma mark shortcut request without timeOut and Encode
//Keys and Values block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
     KeysAndValues:(NSMutableDictionary *)Data
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
{
    return [self sendRequest:url
                     Headers:Headers
               KeysAndValues:Data
                       Image:images
                 RequestType:Type
                     timeOut:120
             EncodeParameter:NO];
}

//JSON block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
{
    [self sendRequest:url
              Headers:Headers
                 JSON:JSON
                Image:images
          RequestType:Type
              timeOut:120
      EncodeParameter:NO];
}

//Full block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
         Parameter:(NSString *)Param
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
{
    [self sendRequest:url
              Headers:Headers
            Parameter:Param
                Image:images
          RequestType:Type
              timeOut:120
      EncodeParameter:NO];
}

#pragma mark full request

//Keys and Values block request
-(BOOL)sendRequest:(NSURL*)url
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
    return [self sendRequest:url
                     Headers:Headers
                   Parameter:Parameter
                       Image:images
                 RequestType:Type
                     timeOut:timeOut
             EncodeParameter:Encoding];
}

//JSON block request
-(BOOL)sendRequest:(NSURL*)url
           Headers:(NSDictionary *)Headers
              JSON:(NSDictionary *)JSON
             Image:(NSMutableArray <UIImage *>*)images
       RequestType:(FARequestType)Type
           timeOut:(float)timeOut
   EncodeParameter:(BOOL)Encoding
{
    return [self sendRequest:url
                     Headers:Headers
                   Parameter:[FARequest GetJSON:JSON]
                       Image:images
                 RequestType:Type
                     timeOut:timeOut
             EncodeParameter:Encoding];
}

//Full block request
-(BOOL)sendRequest:(NSURL*)url
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
        [body appendData:[[NSString stringWithFormat:@"\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
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
         NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
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

@end
