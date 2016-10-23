//
//  FAViewController.h
//  FARequest
//
//  Created by fadizant on 09/16/2016.
//  Copyright (c) 2016 fadizant. All rights reserved.
//

@import UIKit;
#import "FARequest.h"

@interface FAViewController : UIViewController<FARequestDelegate>
{
    Reachability* reachability;
}
@end
