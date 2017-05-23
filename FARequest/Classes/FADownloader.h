//
//  FADownloader.h
//  Kazoz
//
//  Created by Fadi on 8/3/16.
//  Copyright © 2016 apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol definition starts here
@protocol FADownloaderDelegate <NSObject>
@required
- (void) downloadCompleted:(BOOL)result Tag:(int)tag;
@optional
- (void) downloadprogress:(double)value Tag:(int)tag;
@end
@interface FADownloader : NSObject<NSURLSessionDelegate>
{
    // Delegate to respond back
    id <FADownloaderDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property int tag;

@property (nonatomic, retain) NSString *ID;

@property (nonatomic, retain) NSString *fileTitle;

@property (nonatomic, retain) NSString *downloadSource;

@property (nonatomic, retain) NSString *downloadFileType;

@property (nonatomic, retain) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, retain) NSData *taskResumeData;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic) BOOL downloadComplete;

@property (nonatomic) unsigned long taskIdentifier;

@property (nonatomic, strong) NSURL *docDirectoryURL;

@property (nonatomic, retain) NSString *folderName;

@property (nonatomic, strong) NSURLSession *session;

-(id)initWithFileTitle:(NSString *)title
                    id:(NSString*)_id
            FolderName:(NSString*)folderName
        DownloadSource:(NSString *)source
      DownloadFileType:(NSString *)FileType;
-(BOOL)fileExist;
-(BOOL)removeFile;
-(NSString*)filePath;
-(NSURL*)fileURL;
- (void)startOrPauseDownloading;

@end
