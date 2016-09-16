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
-(NSMutableArray*)dictionaryArray:(NSError**)error
{
    @try {
        
        NSMutableArray *object = [[NSMutableArray alloc]init];
        if (self.count) {
            
//        unsigned int propertyCount = 0;
//        objc_property_t * properties = class_copyPropertyList([[self objectAtIndex:0] class], &propertyCount);
//        
//        NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
//        
//        NSMutableArray * propertyNames = [info objectForKey:@"propertyNames"];
//        NSMutableArray * propertyGetters = [info objectForKey:@"propertyGetters"];
//        
//        free(properties);
            
        for (int i = 0; i < self.count; i++) {
            @try {
                id arg = [self objectAtIndex:i];
                NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                if(!arg)
                    continue;
                
//                NSString *name = [propertyNames objectAtIndex:i];
//                NSString *getter = [propertyGetters objectAtIndex:i];
//                
//                if (![getter isEqualToString:@""]) {
//                    name = getter;
//                }
                
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
        return [[NSMutableArray alloc]init];
    }
    @finally {
        
    }
}

-(NSDictionary*)getObjectInfoWithProperties:(objc_property_t *)properties propertyCount:(int) propertyCount
{
    NSMutableDictionary *Info = [[NSMutableDictionary alloc]init];
    NSMutableArray * propertyNames = [NSMutableArray array];
    NSMutableArray * propertyTypes = [NSMutableArray array];
    NSMutableArray * propertyGetters = [NSMutableArray array];
    NSMutableArray * propertySetters = [NSMutableArray array];
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString * name = [NSString stringWithUTF8String:property_getName(property)];
        //const char * type = property_getAttributes(property);
        NSString * typeName = [[[NSString stringWithUTF8String:property_copyAttributeValue( property, "T" )] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString * getterName = property_copyAttributeValue( property, "G" ) ?[NSString stringWithUTF8String:property_copyAttributeValue( property, "G" )] : @"";
        NSString * setterName = property_copyAttributeValue( property, "S" ) ? [[NSString stringWithUTF8String:property_copyAttributeValue( property, "S" )] stringByReplacingOccurrencesOfString:@":" withString:@""]: @"";
        
        //set values
        [propertyNames addObject:name];
        [propertyTypes addObject:typeName];
        [propertyGetters addObject:getterName];
        [propertySetters addObject:setterName];
        
    }
    
    [Info setObject:propertyNames forKey:@"propertyNames"];
    [Info setObject:propertyTypes forKey:@"propertyTypes"];
    [Info setObject:propertyGetters forKey:@"propertyGetters"];
    [Info setObject:propertySetters forKey:@"propertySetters"];
    
    return Info;
}

@end
