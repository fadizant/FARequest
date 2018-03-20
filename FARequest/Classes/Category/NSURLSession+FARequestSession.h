//
//  NSURLSession+FARequestSession.h
//
//  Created by Fadi Abuzant on 3/17/18.
//

#import <Foundation/Foundation.h>
#import "FARequest.h"

@interface NSURLSession (FARequestSession)

@property (nonatomic) requestCompleted completed;
@property (nonatomic) requestProgress progress;
@property (nonatomic,retain) FARequestObject *requestObject;

@end
