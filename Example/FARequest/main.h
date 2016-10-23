//
//Created by FARequest on 19/10/16 
//Copyright © 2016 Fadi Abuzant. All rights reserved.  
//

#import <Foundation/Foundation.h> 
#import "maintenance.h" 
#import "type.h" 
#import "country.h" 
@interface main : NSObject 
@property (nonatomic,retain,setter=country:) NSMutableArray<country*>* country;
@property (nonatomic,retain,setter=type:) NSMutableArray<type*>* type;
@property (nonatomic,retain,setter=maintenance:) NSMutableArray<maintenance*>* maintenance;
@end

