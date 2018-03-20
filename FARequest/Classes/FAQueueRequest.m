//
//  FAQueueRequest.m
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import "FAQueueRequest.h"
#import "FARequest.h"

@implementation FAQueueRequest

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stop = NO;
        finished = NO;
        self.queue = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithQueue:(NSMutableArray <FARequestObject*>*)queue
{
    self = [super init];
    if (self) {
        self.stop = NO;
        finished = NO;
        self.queue = queue;
    }
    return self;
}

#pragma mark - Queue
// Queues are first-in-first-out, so we remove objects from the head
- (FARequestObject*) dequeue {
    if ([self.queue count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self.queue objectAtIndex:0];
    if (headObject != nil) {
        [self.queue removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(FARequestObject*)requestObject {
    [self.queue addObject:requestObject];
    //this method automatically adds to the end of the array
}

#pragma mark - Send
// send all items
-(void)sendWithRequestCompleted:(queueCompleted)queueCompleted Completed:(completed)successful Stopped:(stopped)stop{
    [self sendWithRequestCompleted:queueCompleted Progress:nil Completed:successful Stopped:stop];
}


-(void)sendWithRequestCompleted:(queueCompleted)queueCompleted Progress:(progress)queueProgress Completed:(completed)successful Stopped:(stopped)stop{
    if (self.stop) {
        stop();
        return;
    }
    
    //get item from queue
    FARequestObject *nextObject = [self dequeue];
    if (nextObject) {
        BOOL connect = [FARequest sendWithRequestObject:nextObject RequestProgress:^(float progress) {
            if (queueProgress) {
                queueProgress(nextObject,progress);
            }
        } RequestCompleted:^(FAResponse *response) {
            if (self.stop) {
                stop();
                return;
            }else {
                // send process is completed to queue
                queueCompleted(nextObject,response);
                // start dequeue next item
                [self sendWithRequestCompleted:queueCompleted Progress:queueProgress Completed:successful Stopped:stop];
            }
        }];
        if (!connect) {
            successful(NO);
            finished = true;
            return;
        }
    }else if (!finished) {
        // if there is no item to dequeue (finished)
        successful(YES);
    }
}

#pragma mark - Get
-(void)getWithRequestCompleted:(queueCompleted)queueCompleted Completed:(completed)successful Stopped:(stopped)stop{
    [self getWithRequestCompleted:queueCompleted Progress:nil Completed:successful Stopped:stop];
}

-(void)getWithRequestCompleted:(queueCompleted)queueCompleted Progress:(progress)queueProgress Completed:(completed)successful Stopped:(stopped)stop{
    if (self.stop) {
        stop();
        return;
    }
    
    //get item from queue
    FARequestObject *nextObject = [self dequeue];
    if (nextObject) {
        BOOL connect = [FARequest getWithRequestObject:nextObject RequestProgress:^(float progress) {
            if (queueProgress) {
                queueProgress(nextObject,progress);
            }
        } RequestCompleted:^(FAResponse *response) {
            if (self.stop) {
                stop();
                return;
            }else {
                // send process is completed to queue
                queueCompleted(nextObject,response);
                // start dequeue next item
                [self getWithRequestCompleted:queueCompleted Progress:queueProgress Completed:successful Stopped:stop];
            }
        }];
        if (!connect) {
            successful(NO);
            finished = true;
            return;
        }
    }else if (!finished) {
        // if there is no item to dequeue (finished)
        successful(YES);
    }
}

@end
