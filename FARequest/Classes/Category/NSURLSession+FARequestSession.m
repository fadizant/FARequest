//
//  NSURLSession+FARequestSession.m
//
//  Created by Fadi Abuzant on 3/17/18.
//

#import "NSURLSession+FARequestSession.h"
#import <objc/runtime.h>

static void * RequestCompletedKey = &RequestCompletedKey;
static void * RequestProgressKey = &RequestProgressKey;
static void * RequestObjectKey = &RequestObjectKey;

@implementation NSURLSession (FARequestSession)


- (requestCompleted)completed {
    return objc_getAssociatedObject(self, RequestCompletedKey);
}
- (void)setCompleted:(requestCompleted)completed {
    objc_setAssociatedObject(self, RequestCompletedKey, completed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (requestProgress)progress {
    return objc_getAssociatedObject(self, RequestProgressKey);
}
- (void)setProgress:(requestProgress)progress {
    objc_setAssociatedObject(self, RequestProgressKey, progress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (FARequestObject*)requestObject {
    return objc_getAssociatedObject(self, RequestObjectKey);
}
- (void)setRequestObject:(FARequestObject*)requestObject {
    objc_setAssociatedObject(self, RequestObjectKey, requestObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
