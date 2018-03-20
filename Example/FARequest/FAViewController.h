//
//  FAViewController.h
//  FARequest
//
//  Created by fadizant on 09/16/2016.
//  Copyright (c) 2016 fadizant. All rights reserved.
//

@import UIKit;
#import "FARequest.h"

typedef NS_ENUM(NSInteger, enumNumberOfImages) {
    enumNumberOfImagesOne,
    enumNumberOfImagesThreeInOne,
    enumNumberOfImagesThreeQueue,
    enumNumberOfImagesThreeParallel,
};

typedef NS_ENUM(NSInteger, enumNumberOfVideos) {
    enumNumberOfVideosOne,
    enumNumberOfVideosThreeQueue,
    enumNumberOfVideosThreeParallel,
};

@interface FAViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate>{
    enumNumberOfImages uploeadImageType;
    enumNumberOfVideos downloadVideoType;
}


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView3;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *fileButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end
