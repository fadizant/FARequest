//
//  FAViewController.m
//  FARequest
//
//  Created by fadizant on 09/16/2016.
//  Copyright (c) 2016 fadizant. All rights reserved.
//

#import "FAViewController.h"
//#import "github.h"

@interface FAViewController ()

@end

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    //generat classes from API
//    [FARequest sendParameterRequestWithUrl:[NSURL URLWithString:@"https://api.github.com/repos/hadley/ggplot2/commits"]
//                                 Parameter:@""
//                               RequestType:FARequestTypeGET
//                          requestCompleted:^(id JSONResult, int responseCode , id object) {
//                              if (responseCode == 200) {
////                                  [JSONResult createClassesFile:[JSONResult generatClassWithName:@"github"]];
////                                  NSMutableArray <github*> *obj = [JSONResult fillWithClass:[github class] Error:nil];
////                                  NSLog(@"%@",obj.description);
//                              }
//                          }];
    
    //check internet connection
//    reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
//    [reachability startNotifier];
    
    [FARequest setEncryptionKey:@"myEncryptionKey"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    if([FARequest networkStatus] != NotReachable)
        [self send];

}

- (void) handleNetworkChange:(NSNotification *)notice
{
    if (notice.name == kReachabilityChangedNotification) {
        switch ([FARequest networkStatus]) {
            case NotReachable:
            {NSLog(@"no");}
                break;
            case ReachableViaWiFi:
            {NSLog(@"wifi"); [self send];}
                break;
            case ReachableViaWWAN:
            {NSLog(@"cell"); [self send];}
                break;
            default:
                break;
        }
    }
}

-(void)send
{
    [FARequest sendRequestWithUrl:[NSURL URLWithString:@"https://httpbin.org/get?name=fadiabuzant&age=29"]
                      RequestType:FARequestTypeGET
                 requestCompleted:^(id JSONResult, int responseCode , id object ,BOOL hasCache) {
                     if (responseCode == 200) {
                         NSLog(@"%@",[JSONResult generatClassWithName:@"httpbin"]);
                         
                         NSLog(@"Block respons Name = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"name"]);
                         NSLog(@"Block respons age = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"age"]);
                     }
                 }];
    
    FARequest *request = [[FARequest alloc]initWithParent:self Tag:0];
    [request sendParameterRequestWithUrl:[NSURL URLWithString:@"https://httpbin.org/get?name=fadi&age=29"]
                                 Headers:nil
                               Parameter:@""
                             RequestType:FARequestTypeGET];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FARequestCompleted:)
                                                 name:@"FARequestCompleted"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestCompleted:(id)JSONResult responseCode:(int)responseCode Tag:(int)tag
{
    if (responseCode == 200) {
        NSLog(@"Delegate respons Name = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"name"]);
        NSLog(@"Delegate respons age = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"age"]);
    }
}

- (void) FARequestCompleted:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"FARequestCompleted"])
    {
        id JSONResult = notification.userInfo[@"result"];
        int responseCode = [notification.userInfo[@"responseCode"] intValue];
        //        id object = notification.userInfo[@"object"];
        
        if (responseCode == 200) {
            NSLog(@"Notification respons Name = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"name"]);
            NSLog(@"Notification respons age = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"age"]);
        }
    }
    
}

@end
