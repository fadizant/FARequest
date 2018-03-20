//
//  FAQueueRequest.h
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import <Foundation/Foundation.h>
#import "FARequestObject.h"
#import "FAResponse.h"

typedef void (^queueCompleted)(FARequestObject *request, FAResponse *response);
typedef void (^completed)(BOOL successful);
typedef void (^progress)(FARequestObject *request, float progress);
typedef void (^stopped)(void);

@interface FAQueueRequest : NSObject
{
    BOOL finished;
}

#pragma mark - Property
@property (nonatomic,retain) NSMutableArray <FARequestObject*> *queue;
@property (nonatomic) BOOL stop;

#pragma mark - init
- (instancetype)init;
- (instancetype)initWithQueue:(NSMutableArray <FARequestObject*>*)queue;

#pragma mark - Method
- (FARequestObject*) dequeue;
- (void) enqueue:(FARequestObject*)requestObject;

#pragma mark - Send
-(void)sendWithRequestCompleted:(queueCompleted)queueCompleted Completed:(completed)successful Stopped:(stopped)stop;
-(void)sendWithRequestCompleted:(queueCompleted)queueCompleted Progress:(progress)progress Completed:(completed)successful Stopped:(stopped)stop;

#pragma mark - Get
-(void)getWithRequestCompleted:(queueCompleted)queueCompleted Completed:(completed)successful Stopped:(stopped)stop;
-(void)getWithRequestCompleted:(queueCompleted)queueCompleted Progress:(progress)progress Completed:(completed)successful Stopped:(stopped)stop;
@end
