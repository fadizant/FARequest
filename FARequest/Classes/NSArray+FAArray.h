//
//  NSArray+FAArray.h
//
//  Created by Fadi on 30/12/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FAArray)
-(NSString*)generatClassWithName:(NSString *)Name;
-(void)createClassesFile:(NSString*)data;
-(NSMutableArray*)dictionaryArray:(NSError**)error;
-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error;

//fix duplicate items
-(NSMutableArray*)addArrayWithoutDuplicateByProparty:(NSString*)propartyName Array:(NSMutableArray*)array;
@end
