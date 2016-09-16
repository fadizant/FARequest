//
//  NSArray+FAArray.h
//  Gloocall
//
//  Created by Fadi on 30/12/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FAArray)
-(NSMutableArray*)dictionaryArray:(NSError**)error;
-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error;
@end
