//
//  NSDictionary+FADictionary.m
//  MyKolumn
//
//  Created by Fadi on 19/11/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "NSDictionary+FADictionary.h"
#import "NSArray+FAArray.h"
#import <objc/runtime.h>

@implementation NSDictionary (FADictionary)

- (void)dictionaryFromObject:(id)object Error:(NSError**)error
{
    @try {
        
        //get properties and values from object
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
        
        NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
        
        NSMutableArray * propertyNames = [info objectForKey:@"propertyNames"];
        NSMutableArray * propertyTypes = [info objectForKey:@"propertyTypes"];
        NSMutableArray * propertyGetters = [info objectForKey:@"propertyGetters"];
        NSMutableArray * propertySetters = [info objectForKey:@"propertySetters"];
        
        free(properties);
        
        //get properties and values from super class of object
        Class superClass = [object superclass];
        while (superClass != [NSObject class]) {
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList(superClass, &propertyCount);
            
            NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
            
            [propertyNames addObjectsFromArray:[info objectForKey:@"propertyNames"]];
            [propertyTypes addObjectsFromArray:[info objectForKey:@"propertyTypes"]];
            [propertyGetters addObjectsFromArray:[info objectForKey:@"propertyGetters"]];
            [propertySetters addObjectsFromArray:[info objectForKey:@"propertySetters"]];
            
            free(properties);
            
            
            superClass = [superClass superclass];
        }

        NSMutableArray * propertyValues = [[NSMutableArray alloc]init];
        for (NSString* prop in propertyNames)
            if([object valueForKey:prop] && ![[object valueForKey:prop] isEqual:[NSNull null]])
                [propertyValues addObject:[object valueForKey:prop]];
            else
                [propertyValues addObject:@""];
        
        
        for (int i = 0; i < propertyNames.count; i++) {
            @try {
                id arg = [propertyValues objectAtIndex:i];
                
                if(!arg)
                    continue;
                
                NSString *name = [propertyNames objectAtIndex:i];
                NSString *getter = [propertyGetters objectAtIndex:i];
                
                if (![getter isEqualToString:@""]) {
                    name = getter;
                }
                
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
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                            break;
                        case kCFNumberFloat32Type:
                        case kCFNumberFloat64Type:
                        case kCFNumberCGFloatType:
                        case kCFNumberFloatType:
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithFloat:[arg floatValue]] forKey:name];
                            break;
                        case kCFNumberDoubleType:
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithDouble:[arg doubleValue]] forKey:name];
                            break;
                        case kCFNumberNSIntegerType:
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithInteger:[arg integerValue]] forKey:name];
                            break;
                        case kCFNumberCharType:
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithBool:[arg boolValue]] forKey:name];
                            break;
                        default:
                            [((NSMutableDictionary*)self) setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                            break;
                    }
                    
                }
                else if ([arg isKindOfClass:[NSString class]] ||
                         [arg isKindOfClass:[NSDate class]] ||
                         [arg isKindOfClass:[NSData class]] ||
                         [arg isKindOfClass:[NSArray class]] ||
                         [arg isKindOfClass:[NSDictionary class]])
                    [((NSMutableDictionary*)self) setObject:arg forKey:name];
                else
                {
                    NSMutableDictionary *object = [[NSMutableDictionary alloc]init];
                    [object dictionaryFromObject:arg Error:&*error];
                    [((NSMutableDictionary*)self) setObject:object forKey:name];
                }
                
                
            }
            @catch (NSException *exception) {
                if(error != NULL)
                *error = [NSError errorWithDomain:@"FADictionary" code:-101 userInfo:nil];
            }
            @finally {
                
            }
        }
        
        
    }
    @catch (NSException *exception) {
        if(error != NULL)
        *error = [NSError errorWithDomain:@"FADictionary" code:-100 userInfo:nil];
    }
    @finally {
        
    }
}

-(id)fillThisObject:(id)object Error:(NSError**)error
{
    @try {
        //id object = [[myClass alloc]init];
        
        //get properties and values from object
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
        
        NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
        
        NSMutableArray * propertyNames = [info objectForKey:@"propertyNames"];
        NSMutableArray * propertyTypes = [info objectForKey:@"propertyTypes"];
        NSMutableArray * propertyGetters = [info objectForKey:@"propertyGetters"];
        NSMutableArray * propertySetters = [info objectForKey:@"propertySetters"];
        
        free(properties);
        
        //get properties and values from super class of object
        Class superClass = [object superclass];
        while (superClass != [NSObject class]) {
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList(superClass, &propertyCount);
            
            NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
            
            [propertyNames addObjectsFromArray:[info objectForKey:@"propertyNames"]];
            [propertyTypes addObjectsFromArray:[info objectForKey:@"propertyTypes"]];
            [propertyGetters addObjectsFromArray:[info objectForKey:@"propertyGetters"]];
            [propertySetters addObjectsFromArray:[info objectForKey:@"propertySetters"]];
            
            free(properties);

            
            superClass = [superClass superclass];
        }
        
        NSString *errorName = @"";
        for (int i = 0; i < propertyNames.count; i++) {
            @try {
                NSString *propertyName = [propertyNames objectAtIndex:i];
                NSString *propertyType = [propertyTypes objectAtIndex:i];
                NSString *propertyGetter = [propertyGetters objectAtIndex:i];
                NSString *propertySetter = [propertySetters objectAtIndex:i];
                
                errorName = propertyName ? propertyName : propertySetter;
                
                id value;
                if ([self objectForKey:propertyGetter])
                    value = [self objectForKey:propertyGetter];
                else if([self objectForKey:propertyName])
                    value = [self objectForKey:propertyName];
                else
                    continue;
                
                
                if ([value isEqual:[NSNull null]])
                    continue;
                
                if ([value isKindOfClass:[NSArray class]] ||
                    [value isKindOfClass:[NSMutableArray class]]
                    ) {
//                    NSMutableArray *contant = [object valueForKey:propertyName];
//                    Class classType = contant.elemantClass;
                    
                    if (!NSClassFromString(propertySetter))
                    {
                        NSLog(@"Please add elemant class name in setter in NSMutableArray properte to know what class to parse this array");
                        continue;
                    }
                    
//                    NSMutableArray *contant = [[NSMutableArray alloc]init];
//                    id element = [[NSClassFromString(propertySetter) alloc]init];
//                    
//                    
//                    for (NSDictionary *obj in value) {
//                        id item = [obj fillThisObject:element Error:&*error];
//                        [contant addObject:item];
//                    }
                    
                    
                    NSMutableArray *contant = [[NSMutableArray alloc]init];
                    contant = [value fillWithClass:[NSClassFromString(propertySetter) class] Error:&*error];
                    [object setValue:contant forKey:propertyName];
                    
                }
                else if ([value isKindOfClass:[NSNumber class]]) {
                    value = [value isEqual:[NSNull null]] || !value ? 0 : value;
                    
                    [object setValue:(NSNumber*)value forKey:propertyName];
                }
                else if ([propertyType isEqualToString:@"NSString"] ||
                         [propertyType isEqualToString:@"NSDate"])
                {
                    [object setValue:value forKey:propertyName];
                }
                else
                {
                    id element = [[NSClassFromString(propertyType) alloc] init];
                    id obj = [self valueForKey:propertyName];
                    if ([obj isEqual:[NSNull null]])
                        continue;
                    
                    id item = [obj fillThisObject:element Error:&*error];
                    
                    [object setValue:item forKey:propertyName];
                }
                
                
            }
            @catch (NSException *exception) {
                if(error != NULL)
                {
                *error = [NSError errorWithDomain:errorName code:-101 userInfo:nil];
                }
            }
            @finally {
                
            }
        }
        
        
        return object;
        
    }
    @catch (NSException *exception) {
        if(error != NULL)
        *error = [NSError errorWithDomain:@"FADictionary" code:-100 userInfo:nil];
        return nil;
    }
    @finally {
        
    }
}

-(NSDictionary*)getObjectInfoWithProperties:(objc_property_t *)properties propertyCount:(int) propertyCount
{
    NSMutableDictionary *Info = [[NSMutableDictionary alloc]init];
    @try {
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
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    } @finally {
        
    }
    return Info;
}
@end
