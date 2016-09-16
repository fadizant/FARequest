//
//  FAViewController.m
//  FARequest
//
//  Created by fadizant on 09/16/2016.
//  Copyright (c) 2016 fadizant. All rights reserved.
//

#import "FAViewController.h"

@interface FAViewController ()

@end

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [FARequest sendRequest:[NSURL URLWithString:@"https://httpbin.org/get?name=fadi&age=29"]
                   Headers:nil
                 Parameter:@""
               RequestType:FARequestTypeGET
          requestCompleted:^(id JSONResult, int responseCode) {
              NSLog(@"Block respons Name = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"name"]);
              NSLog(@"Block respons age = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"age"]);
          }];
    
    FARequest *request = [[FARequest alloc]initWithParent:self Tag:0];
    [request sendRequest:[NSURL URLWithString:@"https://httpbin.org/get?name=fadi&age=29"]
                 Headers:nil
               Parameter:@""
             RequestType:FARequestTypeGET];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestCompleted:(id)JSONResult responseCode:(int)responseCode Tag:(int)tag
{
    NSLog(@"Delegate respons Name = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"name"]);
    NSLog(@"Delegate respons age = %@",[[JSONResult objectForKey:@"args"] objectForKey:@"age"]);
}

@end
