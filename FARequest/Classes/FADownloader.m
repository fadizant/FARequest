//
//  FADownloader.m
//  Kazoz
//
//  Created by Fadi on 8/3/16.
//  Copyright © 2016 apprikot. All rights reserved.
//

#import "FADownloader.h"

@implementation FADownloader

-(id)initWithFileTitle:(NSString *)title
                    id:(NSString*)_id
            FolderName:(NSString*)folderName
        DownloadSource:(NSString *)source
      DownloadFileType:(NSString *)FileType{
    if (self == [super init]) {
        self.fileTitle = title;
        self.ID = _id;
        self.downloadSource = source;
        self.downloadFileType = FileType;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
        self.folderName = folderName;
        
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        self.docDirectoryURL = [URLs objectAtIndex:0];
        
        self.docDirectoryURL = [self.docDirectoryURL URLByAppendingPathComponent:self.folderName isDirectory:YES];
        
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 50;

        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
        
       
        
    }
    
    return self;
}

-(BOOL)fileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:[self filePath]];
}

-(BOOL)removeFile
{
    @try {
        if ([self fileExist]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
            if (!error) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
        
    } @catch (NSException *exception) {
        return NO;
    } @finally {
        
    }
}

-(NSString*)filePath
{
    return [[self fileURL] path];
}

-(NSURL*)fileURL
{
    NSString *destinationFilename ;
    if (self.downloadFileType && ![self.downloadFileType isEqualToString:@""]) {
        destinationFilename = [NSString stringWithFormat:@"%@.%@",self.ID,self.downloadFileType];
    } else {
        destinationFilename = [NSString stringWithFormat:@"%@",self.ID];
    }
   return [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
}

#pragma mark start
- (void)startOrPauseDownloading {

        // The isDownloading property of the fdi object defines whether a downloading should be started
        // or be stopped.
        if (!self.isDownloading) {
            // This is the case where a download task should be started.
            
            // Create a new task, but check whether it should be created using a URL or resume data.
            if (self.taskIdentifier == -1) {
                // If the taskIdentifier property of the fdi object has value -1, then create a new task
                // providing the appropriate URL as the download source.
                
                //self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.downloadSource]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadSource]];
                [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
                
                self.downloadTask = [self.session downloadTaskWithRequest:request];
                                     
                // Keep the new task identifier.
                self.taskIdentifier = self.downloadTask.taskIdentifier;
                
                // Start the task.
                [self.downloadTask resume];
            }
            else{
                // Create a new download task, which will use the stored resume data.
                self.downloadTask = [self.session downloadTaskWithResumeData:self.taskResumeData];
                [self.downloadTask resume];
                
                // Keep the new download task identifier.
                self.taskIdentifier = self.downloadTask.taskIdentifier;
            }
        }
        else{
            // Pause the task by canceling it and storing the resume data.
            [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                if (resumeData != nil) {
                    self.taskResumeData = [[NSData alloc] initWithData:resumeData];
                }
            }];
        }
        
        // Change the isDownloading property value.
        self.isDownloading = !self.isDownloading;
}


#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //create dir if not exist
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [path stringByAppendingPathComponent:self.folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    
    
    if ([fileManager fileExistsAtPath:[self filePath]]) {
        [fileManager removeItemAtURL:[self fileURL] error:nil];
    }
    

    //get fime size
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[location path] error:&error];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    if (fileSize <= 1) {
        [self.delegate downloadCompleted:NO Tag:self.tag];
        return;
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:[self fileURL]
                                        error:&error];
    
    if (success) {
        
        self.isDownloading = NO;
        self.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        self.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        self.taskResumeData = nil;
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
        if(self.delegate && [self.delegate respondsToSelector:@selector(downloadCompleted:Tag:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // update in main thread
                [self.delegate downloadCompleted:NO Tag:self.tag];
            });
        }
    }
    else {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths firstObject];
        path = [path stringByAppendingPathComponent:self.folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            [fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:NO
                                    attributes:nil
                                         error:nil];
        
        
        if ([fileManager fileExistsAtPath:[self filePath]]) {
            NSLog(@"Download finished successfully.");
            if(self.delegate && [self.delegate respondsToSelector:@selector(downloadCompleted:Tag:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // update in main thread
                    [self.delegate downloadCompleted:YES Tag:self.tag];
                });
            }
        }else{
            if(self.delegate && [self.delegate respondsToSelector:@selector(downloadCompleted:Tag:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // update in main thread
                    [self.delegate downloadCompleted:NO Tag:self.tag];
                });
            }
        }


    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            self.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            
            NSLog(@"Download progress for %@ at %f",self.fileTitle ,self.downloadProgress );
            
            // Get the progress view of the appropriate cell and update its progress.
            if(self.delegate && [self.delegate respondsToSelector:@selector(downloadprogress:Tag:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // update in main thread
                    [self.delegate downloadprogress:self.downloadProgress Tag:self.tag];
                });
            }
        }];
    }

}

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

@end
