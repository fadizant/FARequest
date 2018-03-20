//
//  FAViewController.m
//  FARequest
//
//  Created by fadizant on 09/16/2016.
//  Copyright (c) 2016 fadizant. All rights reserved.
//

#import "FAViewController.h"
#import <MobileCoreServices/MobileCoreServices.h> // needed for video types
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface FAViewController ()

@end

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    uploeadImageType = enumNumberOfImagesOne;
    downloadVideoType = enumNumberOfVideosOne;
    
    self.progressView1.progress = 0;
    self.progressView2.progress = 0;
    self.progressView3.progress = 0;
    
    self.textView.text = @"";
    
    // Default configuration
    [FARequest setDefaultConfiguration:[[FARequestConfiguration alloc]initWithRequestType:FARequestTypeGET
                                                                                   Header:nil
                                                                                   Object:nil
                                                                                 UseCashe:NO
                                                                                 Encoding:NO
                                                                                  TimeOut:120]];
    
    // semple request
    [FARequest sendWithRequestObject:[[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]] RequestCompleted:^(FAResponse *response) {
        if (response.responseCode == FAResponseStatusOK) {
            self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
            NSLog([response.JSONResult description]);
        }
    }];
    
    //Status handler
    [FARequest setStatusHandler:@{@FAResponseStatusOK:@"successful"}];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successful:)
                                                 name:[FARequest notificationNameFromKey:@FAResponseStatusOK]
                                               object:nil];
    
    FARequestObject *requestObject1 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject1.configuration.object = @1;
    
    FARequestObject *requestObject2 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject2.configuration.object = @2;
    
    FARequestObject *requestObject3 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject3.configuration.object = @3;
    
    FAQueueRequest * queue = [[FAQueueRequest alloc] initWithQueue:[[NSMutableArray alloc] initWithArray:@[requestObject1,requestObject2,requestObject3]]];
    
    [queue sendWithRequestCompleted:^(FARequestObject *request, FAResponse *response) {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n Qeueu number = %i",[request.configuration.object intValue]]];
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
    } Completed:^(BOOL successful) {
        NSLog(@"Finished %d",successful);
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n Finished %d",successful]];
        [FARequest setStatusHandler:[NSMutableDictionary new]];
    } Stopped:^{
        NSLog(@"Stopped");
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[FARequest notificationNameFromKey:@FAResponseStatusOK]
                                                  object:nil];
}

- (void) successful:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:[FARequest notificationNameFromKey:@FAResponseStatusOK]]){
        FARequestObject *request = [notification.userInfo objectForKey:FARequestNotificationRequest];
        FAResponse *response = [notification.userInfo objectForKey:FARequestNotificationResponse];
        requestCompleted requestCompleted = [notification.userInfo objectForKey:FARequestNotificationRequestCompleted];
        NSLog(@"From Notifications Request number = %i  and code = %i",[request.configuration.object intValue], response.responseCode);
        
        if ([request.configuration.object intValue] == 2) {
            request.configuration.object = @200;
            [FARequest sendWithRequestObject:request
                            RequestCompleted:^(FAResponse *newResponse) {
                                requestCompleted(newResponse);
                            }];
        }
    }
    
}


- (IBAction)pickImage:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload images" message:@"Choose the way you want to upload" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"One image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        uploeadImageType = enumNumberOfImagesOne;
        [self pickImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Three images at once" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        uploeadImageType = enumNumberOfImagesThreeInOne;
        [self pickImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Three images parallel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        uploeadImageType = enumNumberOfImagesThreeParallel;
        [self pickImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Three images in queue (One by one)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        uploeadImageType = enumNumberOfImagesThreeQueue;
        [self pickImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)pickImage{
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.allowsEditing = NO;
    pickerView.delegate = self;
    [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (IBAction)uploadVideo:(UIButton *)sender {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.modalPresentationStyle = UIModalPresentationCurrentContext;
    // This code ensures only videos are shown to the end user
    pickerView.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    pickerView.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    [self presentViewController:pickerView animated:YES completion:nil];
    
}

- (IBAction)uploadPDF:(UIButton *)sender {
    
    //https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
    UIDocumentMenuViewController *pick = [[UIDocumentMenuViewController alloc]initWithDocumentTypes:@[FADocumentTypeALL/*@"com.adobe.pdf",@"com.microsoft.word.doc"*/] inMode:UIDocumentPickerModeImport];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

- (IBAction)downloadButton:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Download video" message:@"Choose the way you want to download" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"One video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        downloadVideoType = enumNumberOfVideosOne;
        [self downloadVideo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Three videos parallel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        downloadVideoType = enumNumberOfVideosThreeParallel;
        [self downloadVideo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Three videos in queue (One by one)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        downloadVideoType = enumNumberOfVideosThreeQueue;
        [self downloadVideo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (img) {
        [self sendWithImage:img];
    }else{
        // This is the NSURL of the video object
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //        NSLog([info objectForKey:UIImagePickerControllerReferenceURL]);
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[info valueForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
            NSLog(@"%lu",(unsigned long)[data length]);
            
            [self sendWithVideo:data];
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
        }];
        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - doc
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    NSLog(url.absoluteString);
    [self sendWithPDF:url];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - upload
-(void) sendWithImage:(UIImage*) image{
    
    [_loadingIndicatorView startAnimating];
    
    switch (uploeadImageType) {
        case enumNumberOfImagesOne:
        {
            FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]];
            request.configuration.requestType = FARequestTypePOST;
            FARequestMediaFile *media1 = [[FARequestMediaFile alloc] initWithName:@"multifiles" Image:image];
            
            request.mediaFiles = @[media1];
            
            self.progressView1.progress = 0;
            self.progressView2.progress = 0;
            self.progressView3.progress = 0;
            
            self.textView.text = @"";
            
            [FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
                NSLog(@"progress = %f",progress);
                self.progressView1.progress = progress;
            } RequestCompleted:^(FAResponse *response) {
                if (response.responseCode == FAResponseStatusOK) {
                    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
                }
                [_loadingIndicatorView stopAnimating];
            }];
        }
            break;
        case enumNumberOfImagesThreeInOne:
        {
            FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                        DictionaryParameter:@{@"text":@"test"}];
            request.configuration.requestType = FARequestTypePOST;
            FARequestMediaFile *media1 = [FARequestMediaFile new];
            media1.image = image;
            media1.name = @"multifiles";
            media1.filename = @"multifiles1.jpeg";
            
            FARequestMediaFile *media2 = [FARequestMediaFile new];
            media2.image = image;
            media2.name = @"multifiles";
            media2.filename = @"multifiles2.jpeg";
            
            FARequestMediaFile *media3 = [FARequestMediaFile new];
            media3.image = image;
            media3.name = @"multifiles";
            media3.filename = @"multifiles3.jpeg";
            
            request.mediaFiles = @[media1,media2,media3];
            
            self.progressView1.progress = 0;
            self.progressView2.progress = 0;
            self.progressView3.progress = 0;
            
            self.textView.text = @"";
            
            [FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
                NSLog(@"progress = %f",progress);
                self.progressView1.progress = progress;
            } RequestCompleted:^(FAResponse *response) {
                if (response.responseCode == FAResponseStatusOK) {
                    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
                }
                [_loadingIndicatorView stopAnimating];
            }];
        }
            break;
        case enumNumberOfImagesThreeQueue:
        {
            
            FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                        DictionaryParameter:@{@"text":@"test"}];
            request.configuration.requestType = FARequestTypePOST;
            FARequestMediaFile *media1 = [FARequestMediaFile new];
            media1.image = image;
            media1.name = @"multifiles";
            media1.filename = @"multifiles1.jpeg";
            
            FARequestMediaFile *media2 = [FARequestMediaFile new];
            media2.image = image;
            media2.name = @"multifiles";
            media2.filename = @"multifiles2.jpeg";
            
            FARequestMediaFile *media3 = [FARequestMediaFile new];
            media3.image = image;
            media3.name = @"multifiles";
            media3.filename = @"multifiles3.jpeg";
            
            request.mediaFiles = @[media1];//,media2,media3];
            request.configuration.object = self.progressView1;
            
            self.progressView1.progress = 0;
            self.progressView2.progress = 0;
            self.progressView3.progress = 0;
            
            self.textView.text = @"";
            
            FARequestObject *request1 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                         DictionaryParameter:@{@"text":@"test"}];
            request1.configuration.requestType = FARequestTypePOST;
            request1.mediaFiles = @[media2];
            request1.configuration.object = self.progressView2;
            
            FARequestObject *request2 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                         DictionaryParameter:@{@"text":@"test"}];
            request2.configuration.requestType = FARequestTypePOST;
            request2.mediaFiles = @[media3];
            request2.configuration.object = self.progressView3;
            
            FAQueueRequest *queue = [[FAQueueRequest alloc]initWithQueue:[[NSMutableArray alloc] initWithArray:@[request,request1,request2]]];
            [queue sendWithRequestCompleted:^(FARequestObject *request, FAResponse *response) {
                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
            } Progress:^(FARequestObject *request, float progress) {
                if (request.configuration.object && [request.configuration.object isKindOfClass:[UIProgressView class]]){
                    ((UIProgressView*)request.configuration.object).progress = progress;
                }
            } Completed:^(BOOL successful) {
                NSLog(@"complete = %d",successful);
                [_loadingIndicatorView stopAnimating];
            } Stopped:^{
                NSLog(@"Stopped");
                [_loadingIndicatorView stopAnimating];
            }];
            
        }
            break;
        case enumNumberOfImagesThreeParallel:
        {
            
            FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                        DictionaryParameter:@{@"text":@"test"}];
            request.configuration.requestType = FARequestTypePOST;
            FARequestMediaFile *media1 = [FARequestMediaFile new];
            media1.image = image;
            media1.name = @"multifiles";
            media1.filename = @"multifiles1.jpeg";
            
            FARequestMediaFile *media2 = [FARequestMediaFile new];
            media2.image = image;
            media2.name = @"multifiles";
            media2.filename = @"multifiles2.jpeg";
            
            FARequestMediaFile *media3 = [FARequestMediaFile new];
            media3.image = image;
            media3.name = @"multifiles";
            media3.filename = @"multifiles3.jpeg";
            
            request.mediaFiles = @[media1];//,media2,media3];
            
            self.progressView1.progress = 0;
            self.progressView2.progress = 0;
            self.progressView3.progress = 0;
            
            self.textView.text = @"";
            
            [FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
                NSLog(@"progress = %f",progress);
                self.progressView1.progress = progress;
            } RequestCompleted:^(FAResponse *response) {
                if (response.responseCode == FAResponseStatusOK) {
                    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
                }
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                FARequestObject *request1 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                             DictionaryParameter:@{@"text":@"test"}];
                request1.configuration.requestType = FARequestTypePOST;
                request1.mediaFiles = @[media2];
                
                [FARequest sendWithRequestObject:request1 RequestProgress:^(float progress) {
                    NSLog(@"progress = %f",progress);
                    self.progressView2.progress = progress;
                } RequestCompleted:^(FAResponse *response) {
                    if (response.responseCode == FAResponseStatusOK) {
                        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
                    }
                }];
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                FARequestObject *request2 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                             DictionaryParameter:@{@"text":@"test"}];
                request2.configuration.requestType = FARequestTypePOST;
                request2.mediaFiles = @[media3];
                
                [FARequest sendWithRequestObject:request2 RequestProgress:^(float progress) {
                    NSLog(@"progress = %f",progress);
                    self.progressView3.progress = progress;
                } RequestCompleted:^(FAResponse *response) {
                    if (response.responseCode == FAResponseStatusOK) {
                        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];//[response.JSONResult description];
                    }
                    [_loadingIndicatorView stopAnimating];
                }];
            });
        }
            break;
        default:
            break;
    }
    
    
    
    
    
}

-(void) sendWithVideo:(NSData*) data{
    [_loadingIndicatorView startAnimating];
    
    FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                DictionaryParameter:@{@"text":@"test"}];
    request.configuration.requestType = FARequestTypePOST;
    FARequestMediaFile *media1 = [FARequestMediaFile new];
    media1.file = data;
    media1.name = @"onefile";
    //    media1.filename = @"onefile.mp4";
    //    media1.mimetype = FARequestMediaTypeMP4;
    
    request.mediaFiles = @[media1];
    
    self.progressView1.progress = 0;
    self.progressView2.progress = 0;
    self.progressView3.progress = 0;
    [FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
        NSLog(@"progress = %f",progress);
        self.progressView1.progress = progress;
    } RequestCompleted:^(FAResponse *response) {
        if (response.responseCode == FAResponseStatusOK) {
            self.textView.text = [response.JSONResult description];
            if ([response.JSONResult isKindOfClass:[NSDictionary class]]) {
                if ([[response.JSONResult objectForKey:@"Media"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* media in ((NSArray*)[response.JSONResult objectForKey:@"Media"])) {
                        NSLog([media objectForKey:@"mediaUrl"]);
                    }
                    
                }
            }
        }
        [_loadingIndicatorView stopAnimating];
    }];
}

-(void) sendWithPDF:(NSURL*) url{
    [_loadingIndicatorView startAnimating];
    
    FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"http://168.144.38.45:8097/NewController/addMedia"]
                                                DictionaryParameter:@{@"text":@"test"}];
    request.configuration.requestType = FARequestTypePOST;
    FARequestMediaFile *media1 = [FARequestMediaFile new];
    media1.filePath = url.absoluteString;
    media1.name = @"onefile";
    //    media1.filename = @"onefile.pdf";
    //    media1.mimetype = FARequestMediaTypePDF;
    
    request.mediaFiles = @[media1];
    
    self.progressView1.progress = 0;
    self.progressView2.progress = 0;
    self.progressView3.progress = 0;
    [FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
        NSLog(@"progress = %f",progress);
        self.progressView1.progress = progress;
    } RequestCompleted:^(FAResponse *response) {
        if (response.responseCode == FAResponseStatusOK) {
            self.textView.text = [response.JSONResult description];
            if ([response.JSONResult isKindOfClass:[NSDictionary class]]) {
                if ([[response.JSONResult objectForKey:@"Media"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* media in ((NSArray*)[response.JSONResult objectForKey:@"Media"])) {
                        NSLog([media objectForKey:@"mediaUrl"]);
                    }
                    
                }
            }
        }
        [_loadingIndicatorView stopAnimating];
    }];
}

#pragma mark - download
-(void)downloadVideo{
    [_loadingIndicatorView startAnimating];
    self.progressView1.progress = 0;
    self.progressView2.progress = 0;
    self.progressView3.progress = 0;
    
    self.textView.text = @"";
    
    switch (downloadVideoType) {
        case enumNumberOfVideosOne:
        {
            [FARequest getWithRequestObject:[[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                                    SaveInFolder:@"Download"
                                                                    SaveWithName:@"video"
                                                               SaveWithExtension:@"mp4"
                                                                       OverWrite:YES]
                            RequestProgress:^(float progress) {
                                self.progressView1.progress = progress;
                            } RequestCompleted:^(FAResponse *response) {
                                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
                                
                                if (response.responseCode == FAResponseStatusOK && !response.error) {
                                    NSURL *videoURL = [NSURL fileURLWithPath:[response.JSONResult description]];
                                    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
                                    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
                                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                                    playerViewController.player = player;
                                    //[playerViewController.player play];//Used to Play On start
                                    [self presentViewController:playerViewController animated:YES completion:nil];
                                }
                                
                                [_loadingIndicatorView stopAnimating];
                                
                            }];
        }
            break;
        case enumNumberOfVideosThreeParallel:
        {
            [FARequest getWithRequestObject:[[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                                    SaveInFolder:@"Download"
                                                                    SaveWithName:@"video"
                                                               SaveWithExtension:@"mp4"
                                                                       OverWrite:YES]
                            RequestProgress:^(float progress) {
                                self.progressView1.progress = progress;
                            } RequestCompleted:^(FAResponse *response) {
                                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
                                
                            }];
            
            [FARequest getWithRequestObject:[[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                                    SaveInFolder:@"Download"
                                                                    SaveWithName:@"video1"
                                                               SaveWithExtension:@"mp4"
                                                                       OverWrite:YES]
                            RequestProgress:^(float progress) {
                                self.progressView2.progress = progress;
                            } RequestCompleted:^(FAResponse *response) {
                                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
                                
                            }];
            
            [FARequest getWithRequestObject:[[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                                    SaveInFolder:@"Download"
                                                                    SaveWithName:@"video2"
                                                               SaveWithExtension:@"mp4"
                                                                       OverWrite:YES]
                            RequestProgress:^(float progress) {
                                self.progressView3.progress = progress;
                            } RequestCompleted:^(FAResponse *response) {
                                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
                                
                                if (response.responseCode == FAResponseStatusOK && !response.error) {
                                    NSURL *videoURL = [NSURL fileURLWithPath:[response.JSONResult description]];
                                    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
                                    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
                                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                                    playerViewController.player = player;
                                    //[playerViewController.player play];//Used to Play On start
                                    [self presentViewController:playerViewController animated:YES completion:nil];
                                }
                                
                                [_loadingIndicatorView stopAnimating];
                                
                            }];
        }
            break;
        case enumNumberOfVideosThreeQueue:
        {
            NSMutableArray <FARequestObject*>* items = [NSMutableArray new];
            FARequestObject *item = [[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                            SaveInFolder:@"Download"
                                                            SaveWithName:@"video"
                                                       SaveWithExtension:@"mp4"
                                                               OverWrite:YES];
            item.configuration.object = self.progressView1;
            [items addObject:item];

            FARequestObject *item2 = [[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                            SaveInFolder:@"Download"
                                                            SaveWithName:@"video2"
                                                       SaveWithExtension:@"mp4"
                                                               OverWrite:YES];
            item2.configuration.object = self.progressView2;
            [items addObject:item2];
            
            FARequestObject *item3 = [[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                            SaveInFolder:@"Download"
                                                            SaveWithName:@"video3"
                                                       SaveWithExtension:@"mp4"
                                                               OverWrite:YES];
            item3.configuration.object = self.progressView3;
            [items addObject:item3];
            
            __block NSString *path = @"";
            
            FAQueueRequest *queue = [[FAQueueRequest alloc]initWithQueue:items];
            
            [queue getWithRequestCompleted:^(FARequestObject *request, FAResponse *response) {
                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@",[response.JSONResult description]]];
                path = [response.JSONResult description];
            } Progress:^(FARequestObject *request, float progress) {
                if (request.configuration.object && [request.configuration.object isKindOfClass:[UIProgressView class]]){
                    ((UIProgressView*)request.configuration.object).progress = progress;
                }
            } Completed:^(BOOL successful) {
                if (successful) {
                    NSURL *videoURL = [NSURL fileURLWithPath:path];
                    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
                    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    playerViewController.player = player;
                    //[playerViewController.player play];//Used to Play On start
                    [self presentViewController:playerViewController animated:YES completion:nil];
                }
                
                [_loadingIndicatorView stopAnimating];
            } Stopped:^{
                NSLog(@"Stopped");
                [_loadingIndicatorView stopAnimating];
            }];
            
        }
            break;
        default:
            break;
    }
    
}
@end
