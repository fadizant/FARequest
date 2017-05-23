//
//  NSArray+FAArray.m
//  Gloocall
//
//  Created by Fadi on 30/12/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "NSArray+FAArray.h"
#import "NSDictionary+FADictionary.h"
#import <objc/runtime.h>

@implementation NSArray (FAArray)
-(NSString*)generatClassWithName:(NSString *)Name
{
    if ([[self objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        return [[self objectAtIndex:0] generatClassWithName:Name];
    } else {
        NSString *result = [NSString stringWithFormat:@"//Class %@ * >>>>>>>>>>>>>>>>>>>>>>>> \n",Name];
        result = [result stringByAppendingString:@"//Note : if you want to change property name add getter=keyName (keyName value name from JSON)"];
        
        NSMutableArray <NSString*>*classes = [NSMutableArray new];
        
        for (NSString *key in [[self objectAtIndex:0] allKeys]) {
            id arg = [[self objectAtIndex:0] objectForKey:key];
            
            if ([arg isKindOfClass:[NSNumber class]]) {
                //NSNumber *someNSNumber = [[NSNumber alloc]initWithUnsignedShort:[(NSNumber *)arg unsignedShortValue]];
                
                NSNumber *someNSNumber = (NSNumber*)arg;
                
                CFNumberType numberType = CFNumberGetType((CFNumberRef)someNSNumber);
                switch (numberType) {
                    case kCFNumberSInt8Type:
                    case kCFNumberSInt16Type:
                    case kCFNumberSInt32Type:
                    case kCFNumberSInt64Type:
                    case kCFNumberIntType:
                        result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) int %@;\n",key]];
                        break;
                    case kCFNumberFloat32Type:
                    case kCFNumberFloat64Type:
                    case kCFNumberCGFloatType:
                    case kCFNumberFloatType:
                        result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) float %@;\n",key]];
                        break;
                    case kCFNumberDoubleType:
                        result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) double %@;\n",key]];
                        break;
                    case kCFNumberNSIntegerType:
                        result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) int %@;\n",key]];
                        break;
                    case kCFNumberCharType:
                        result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) char %@;\n",key]];
                        break;
                    default:
                        
                        break;
                }
                
            }
            else if ([arg isKindOfClass:[NSDate class]])
            {
                result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSDate* %@;\n",key]];
            }
            else if ([arg isKindOfClass:[NSData class]])
            {
                result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSData* %@;\n",key]];
            }
            else if ([arg isKindOfClass:[NSArray class]])
            {
                result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain,setter=%@:) NSMutableArray<%@*>* %@;\n",key,key,key]];
                [classes addObject:[arg generatClassWithName:key]];
            }
            else if ([arg isKindOfClass:[NSDictionary class]])
            {
                result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) %@* %@;\n",key,key]];
                [classes addObject:[arg generatClassWithName:key]];
            }
            else
            {
                result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSString* %@;\n",key]];
            }
            
        }
        
        result = [result stringByAppendingString:[NSString stringWithFormat:@"//Class %@ End <<<<<<<<<<<<<<<<<<<<<<< * \n",Name]];
        
        for (NSString *otherClass in classes) {
            result = [result stringByAppendingString:otherClass];
        }
        
        return result;
    }
}

-(void)createClassesFile:(NSString*)data
{
    NSDictionary *createClassesFile = [NSDictionary new];
    [createClassesFile createClassesFile:data];
}

-(NSMutableArray*)dictionaryArray:(NSError**)error
{
    @try {
        
        NSMutableArray *object = [[NSMutableArray alloc]init];
        if (self.count) {
            
            
            for (int i = 0; i < self.count; i++) {
                @try {
                    id arg = [self objectAtIndex:i];
                    NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                    if(!arg)
                        continue;
                    
                    if ([arg isKindOfClass:[NSNumber class]]) {
                        //NSNumber *someNSNumber = [[NSNumber alloc]initWithUnsignedShort:[(NSNumber *)arg unsignedShortValue]];
                        
                        NSNumber *someNSNumber = (NSNumber*)arg;
                        
                        CFNumberType numberType = CFNumberGetType((CFNumberRef)someNSNumber);
                        switch (numberType) {
                            case kCFNumberSInt8Type:
                            case kCFNumberSInt16Type:
                            case kCFNumberSInt32Type:
                            case kCFNumberSInt64Type:
                            case kCFNumberIntType:
                                //                            [item setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                                [object addObject:[NSNumber numberWithInt:[arg intValue]]];
                                break;
                            case kCFNumberFloat32Type:
                            case kCFNumberFloat64Type:
                            case kCFNumberCGFloatType:
                            case kCFNumberFloatType:
                                //                            [item setObject:[NSNumber numberWithFloat:[arg floatValue]] forKey:name];
                                [object addObject:[NSNumber numberWithFloat:[arg intValue]]];
                                break;
                            case kCFNumberDoubleType:
                                //                            [item setObject:[NSNumber numberWithDouble:[arg doubleValue]] forKey:name];
                                [object addObject:[NSNumber numberWithDouble:[arg intValue]]];
                                break;
                            case kCFNumberNSIntegerType:
                                //                            [item setObject:[NSNumber numberWithInteger:[arg integerValue]] forKey:name];
                                [object addObject:[NSNumber numberWithInteger:[arg intValue]]];
                                break;
                            case kCFNumberCharType:
                                //                            [item setObject:[NSNumber numberWithBool:[arg boolValue]] forKey:name];
                                [object addObject:[NSNumber numberWithBool:[arg intValue]]];
                                break;
                            default:
                                //                            [item setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                                [object addObject:[NSNumber numberWithInt:[arg intValue]]];
                                break;
                        }
                        
                    }
                    else if ([arg isKindOfClass:[NSString class]] ||
                             [arg isKindOfClass:[NSDate class]])
                    {
                        [object addObject:arg];
                    }
                    else
                    {
                        //[((NSMutableDictionary*)self) setObject:arg forKey:name];
                        [item dictionaryFromObject:arg Error:&*error];
                        [object addObject:item];
                    }
                    
                    
                    
                }
                @catch (NSException *exception) {
                    *error = [NSError errorWithDomain:@"FADictionary" code:-101 userInfo:nil];
                }
                @finally {
                    
                }
            }
            
            
        }
        
        return object;
        
    }
    @catch (NSException *exception) {
        return [[NSMutableArray alloc]init];
    }
    @finally {
        
    }
}

-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error
{
    @try {
        NSMutableArray *object = [[NSMutableArray alloc]init];
        for (int i=0; i<self.count; i++) {
            id item = [self objectAtIndex:i];
            if([item isKindOfClass:[NSDictionary class]]){
                id newItem = [[class alloc]init];
                newItem = [((NSDictionary*)item) fillThisObject:newItem Error:error];
                [object addObject:newItem];
            }
            else
            {
                id newItem = [[class alloc]init];
                if ([newItem isKindOfClass:[NSNumber class]]) {
                    item = [item isEqual:[NSNull null]] || !item ? 0 : item;
                    
                    [object addObject:(NSNumber*)item];
                }
                else if ([newItem isKindOfClass:[NSString class]] ||
                         [newItem isKindOfClass:[NSDate class]])
                {
                    [object addObject:item];
                }
                else
                {
                    newItem = item;
                    [object addObject:newItem];
                }
            }
        }
        return object;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//fix duplicate items
-(NSMutableArray*)addArrayWithoutDuplicateByProparty:(NSString*)propartyName Array:(NSMutableArray*)array{
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:self];
    for (id object in array) {
        @try {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %%@",propartyName] , [object valueForKey:propartyName]];
            NSArray *filteredArray = [mutableArray filteredArrayUsingPredicate:predicate];
            if (filteredArray.count) {
                //update array item if found
                [mutableArray replaceObjectAtIndex:[self indexOfObject:filteredArray.firstObject] withObject:object];
            } else {
                //add item if not exist
                [mutableArray addObject:object];
            }
        } @catch (NSException *exception) {
            [mutableArray addObject:object];
        } @finally {
            
        }
        
    }
    return mutableArray;
}

@end
