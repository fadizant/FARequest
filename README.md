# FARequest

[![CI Status](http://img.shields.io/travis/fadizant/FARequest.svg?style=flat)](https://travis-ci.org/fadizant/FARequest)
[![Version](https://img.shields.io/cocoapods/v/FARequest.svg?style=flat)](http://cocoapods.org/pods/FARequest)
[![License](https://img.shields.io/cocoapods/l/FARequest.svg?style=flat)](http://cocoapods.org/pods/FARequest)
[![Platform](https://img.shields.io/cocoapods/p/FARequest.svg?style=flat)](http://cocoapods.org/pods/FARequest)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
you may need to set your apple account in capabilities for icloud service if you need to test upload files.

## Features

#### Easy to use :
FARequest use closures to send your request, no need to make instance form it.

#### Default configuration :
You can set your default configuration to make your requests easier to use.

#### Status handler :
You can handle response status code in easy way by set keys for every status and handle this status when happened by Notification center using your keys, and you can also send new response to original closure to continue your work there.

#### Queue request :
in FARequest you can make queue by useing FAQueueRequest, you can stop queue any time.

#### Upload and download files With optional progress:
FARequest can make upload and download files more easier than ever, you can send image immediately or set file url or any file data and let FARequest complete your work for you. 
FARequest can download any file and save it for you in application document, you can get this file any time by stop override to get current file if exist.
You can use FAQueueRequest Feature to upload and download files too.

#### JSON response :
FARequest will return response as JSON if it's in JSON format, if not response will return as it.

## Samples
##### Simple request :
```ruby
// Objc
[FARequest sendWithRequestObject:[[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]] RequestCompleted:^(FAResponse *response) {
        if (response.responseCode == FAResponseStatusOK) {
            NSLog([response.JSONResult description]);
        }
    }];
    
// Swift4
FARequest.send(with: FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))) { (response) in
            if response?.responseCode == FAResponseStatusOK {
                print((response?.jsonResult as AnyObject).description)
            }
        }
```

##### Default configuration :
```ruby
// Objc
[FARequest setDefaultConfiguration:[[FARequestConfiguration alloc]initWithRequestType:FARequestTypeGET  Header:nil Object:nil UseCashe:NO  Encoding:NO TimeOut:120]];
    
// Swift4
FARequest.setDefaultConfiguration(FARequestConfiguration(requestType: .GET, header: nil, object: nil, useCashe: false, encoding: false, timeOut: 120))
```

##### Status handler :
```ruby
// Objc
[FARequest setStatusHandler:@{@FAResponseStatusOK:@"successful"}];
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(successful:)
                                             name:[FARequest notificationNameFromKey:@FAResponseStatusOK]
                                           object:nil];

// notification center method
- (void) successful:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:[FARequest notificationNameFromKey:@FAResponseStatusOK]]){
        FARequestObject *request = [notification.userInfo objectForKey:FARequestNotificationRequest];
        FAResponse *response = [notification.userInfo objectForKey:FARequestNotificationResponse];
        requestCompleted requestCompleted = [notification.userInfo objectForKey:FARequestNotificationRequestCompleted];
        // your work here
    }
}


// Swift4
FARequest.setStatusHandler([FAResponseStatusOK:"successful"])
NotificationCenter.default.addObserver(self, selector: #selector(successful(_:)), name: NSNotification.Name(rawValue: FARequest.notificationName(fromKey: FAResponseStatusOK as NSNumber)), object: nil)

// notification center method
@objc func successful(_ notification:NSNotification){
        if notification.name == NSNotification.Name(rawValue: FARequest.notificationName(fromKey: FAResponseStatusOK as NSNumber)) {
            let request = userInfo.object(forKey: FARequestNotificationRequest) as? FARequestObject
            let response = userInfo.object(forKey: FARequestNotificationResponse) as? FAResponse
            let requestCompleted = userInfo.object(forKey: FARequestNotificationRequestCompleted) as? requestCompleted
            // your work here
        }
    }
```

##### Queue request :
```ruby
// Objc
FARequestObject *requestObject1 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject1.configuration.object = @1;
    
    FARequestObject *requestObject2 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject2.configuration.object = @2;
    
    FARequestObject *requestObject3 = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"https://jsonplaceholder.typicode.com/posts/1"]];
    requestObject3.configuration.object = @3;
    
    FAQueueRequest * queue = [[FAQueueRequest alloc] initWithQueue:[[NSMutableArray alloc] initWithArray:@[requestObject1,requestObject2,requestObject3]]];
    
    [queue sendWithRequestCompleted:^(FARequestObject *request, FAResponse *response) {
        NSLog([response.JSONResult description]);
    } Completed:^(BOOL successful) {
        NSLog(@"Finished %d",successful);
    } Stopped:^{
        NSLog(@"Stopped");
    }];
    
// Swift4
let requestObject1 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject1?.configuration.object = 1
        
        let requestObject2 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject2?.configuration.object = 2
        
        let requestObject3 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject3?.configuration.object = 3
        
        
        let queue = FAQueueRequest.init(queue: NSMutableArray(array: [requestObject1 ?? FARequestObject(),
                                                                      requestObject2 ?? FARequestObject(),
                                                                      requestObject3 ?? FARequestObject()]));
        
        queue?.send(requestCompleted: { (request,response) in
            print((response?.jsonResult as AnyObject).description)
        }, completed: { (finish) in
            self.textView.text.append("\nFinished \(finish)")
        },stopped: {
            print("Stopped")
        })
```

##### Upload :
```ruby
// Objc
FARequestObject *request = [[FARequestObject alloc] initWithUrl:[[NSURL alloc] initWithString:@"SERVER_URL"]];
request.configuration.requestType = FARequestTypePOST;
//set image info 
FARequestMediaFile *media1 = [[FARequestMediaFile alloc] initWithName:@"file" Image:image];
request.mediaFiles = @[media1];

[FARequest sendWithRequestObject:request RequestProgress:^(float progress) {
    NSLog(@"progress = %f",progress);
} RequestCompleted:^(FAResponse *response) {
    if (response.responseCode == FAResponseStatusOK) {
        NSLog([response.JSONResult description]);
    }
}];
    
// Swift4
let request = FARequestObject.init(url: URL.init(string: "http://168.144.38.45:8097/NewController/addMedia"))
request?.configuration.requestType = .POST
request?.mediaFiles = [FARequestMediaFile.init(name: "file", image: image)]
FARequest.send(with: request, requestProgress: { (progress) in
    print("progress = \(progress)")
}) { (response) in
    if response?.responseCode == FAResponseStatusOK {
        print((response?.jsonResult as AnyObject).description)
    }
}
```

##### Download :
```ruby
// Objc
[FARequest getWithRequestObject:[[FARequestObject alloc] initWithUrl:[NSURL URLWithString:@"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"]
                                                                    SaveInFolder:@"Download"
                                                                    SaveWithName:@"video"
                                                               SaveWithExtension:@"mp4"
                                                                       OverWrite:YES]
                            RequestProgress:^(float progress) {
                                NSLog(@"progress = %f",progress);
                            } RequestCompleted:^(FAResponse *response) {
                                if (response.responseCode == FAResponseStatusOK) {
                                    NSLog([response.JSONResult description]);
                                }
                            }];
    
// Swift4
FARequest.getWith(FARequestObject.init(url: URL.init(string: "http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"),
                                               saveInFolder: "Download",
                                               saveWithName: "video",
                                               saveWithExtension: "mp4",
                                               overWrite: true),
                        requestProgress: { (progress) in
                            print("progress = \(progress)")
                        }) { (respons) in
                            if response?.responseCode == FAResponseStatusOK {
                                print((response?.jsonResult as AnyObject).description)
                            }
                        }
```

## Installation

FARequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FARequest"
```

## Author

fadizant, fadizant@hotmail.com

## License

FARequest is available under the MIT license. See the LICENSE file for more info.
