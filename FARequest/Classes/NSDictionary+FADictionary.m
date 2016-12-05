//
//  NSDictionary+FADictionary.m
//  MyKolumn
//
//  Created by Fadi on 19/11/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "NSDictionary+FADictionary.h"
#import "NSArray+FAArray.h"
#import "NSDate+FADate.h"
#import <objc/runtime.h>

@implementation NSDictionary (FADictionary)

-(NSString*)generatClassWithName:(NSString *)Name
{
    NSString *result = @"//FadiSpliterString\n";
    result = [result stringByAppendingString:@"//\n"];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"//Created by FARequest on %@ \n",[[NSDate date] getStringWithFormat:@"dd/MM/yy"]]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"//Copyright © %i Fadi Abuzant. All rights reserved.  \n",(int)[[NSDate date] getYear]]];
    result = [result stringByAppendingString:@"//\n\n"];
    result = [result stringByAppendingString:@"#import <Foundation/Foundation.h> \n"];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"@interface %@ : NSObject \n",Name]];
    
    
    
    NSMutableArray <NSString*>*classes = [NSMutableArray new];
    
    for (NSString *key in [self allKeys]) {
        id arg = [self objectForKey:key];
        
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
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) int %@;\n",[self fixKeyName:key]]];
                    break;
                case kCFNumberFloat32Type:
                case kCFNumberFloat64Type:
                case kCFNumberCGFloatType:
                case kCFNumberFloatType:
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) float %@;\n",[self fixKeyName:key]]];
                    break;
                case kCFNumberDoubleType:
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) double %@;\n",[self fixKeyName:key]]];
                    break;
                case kCFNumberNSIntegerType:
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) int %@;\n",[self fixKeyName:key]]];
                    break;
                case kCFNumberCharType:
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic) bool %@;\n",[self fixKeyName:key]]];
                    break;
                default:
                    
                    break;
            }
            
        }
        else if ([arg isKindOfClass:[NSDate class]])
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSDate* %@;\n",[self fixKeyName:key]]];
        }
        else if ([arg isKindOfClass:[NSData class]])
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSData* %@;\n",[self fixKeyName:key]]];
        }
        else if ([arg isKindOfClass:[NSArray class]])
        {
            if ([arg count]) {
                if ([[arg objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain,setter=%@:) NSMutableArray<%@*>* %@;\n",
                                                              [self fixKeyName:key],
                                                              [self fixKeyName:key],
                                                              [self fixKeyName:key]]];
                    [classes addObject:[arg generatClassWithName:[self fixKeyName:key]]];
                    //add impport for new class
                    result = [result stringByReplacingOccurrencesOfString:@"#import <Foundation/Foundation.h> \n" withString:[NSString stringWithFormat:@"#import <Foundation/Foundation.h> \n#import \"%@.h\" \n",key]];
                } else {
                    result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSMutableArray* %@;\n",[self fixKeyName:key]]];
                }
                
                
            }
        }
        else if ([arg isKindOfClass:[NSDictionary class]])
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) %@* %@;\n",
                                                      [self fixKeyName:key],
                                                      [self fixKeyName:key]]];
            [classes addObject:[arg generatClassWithName:[self fixKeyName:key]]];
            //add impport for new class
            result = [result stringByReplacingOccurrencesOfString:@"#import <Foundation/Foundation.h> \n" withString:[NSString stringWithFormat:@"#import <Foundation/Foundation.h> \n#import \"%@.h\" \n",key]];
        }
        else
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"@property (nonatomic,retain) NSString* %@;\n",[self fixKeyName:key]]];
        }
        
    }
    
    //    result = [result stringByAppendingString:@"//Note : if you want to change property name add getter=keyName (keyName value name from JSON)\n"];
    //    result = [result stringByAppendingString:[NSString stringWithFormat:@"//Class %@ End <<<<<<<<<<<<<<<<<<<<<<< * \n\n",Name]];
    result = [result stringByAppendingString:@"@end\n\n"];
    
    
    for (NSString *otherClass in classes) {
        result = [result stringByAppendingString:otherClass];
    }
    
    return result;
}

-(void)createClassesFile:(NSString*)data
{
    NSMutableArray <NSString*>*newClasses = [NSMutableArray new];
    for (NSString *classString in [data componentsSeparatedByString:@"//FadiSpliterString\n"]) {
        if (classString.length) {
            @try {
                NSString *className = [classString substringWithRange:
                                       NSMakeRange([classString rangeOfString:@"@interface "].location,
                                                   [[classString substringFromIndex:[classString rangeOfString:@"@interface "].location] rangeOfString:@" \n"].location)];
                BOOL found = NO;
                for (int i=0; i<newClasses.count; i++) {
                    if ([newClasses[i] containsString:className]) {
                        NSString *result = newClasses[i];
                        
                        //                        NSString *imports = [classString substringWithRange:
                        //                                               NSMakeRange([classString rangeOfString:@"#import <Foundation/Foundation.h> \n"].location,
                        //                                                           [classString rangeOfString:@"@interface"].location - [classString rangeOfString:@"#import <Foundation/Foundation.h> \n"].location )];
                        //
                        //                        result = [result stringByReplacingOccurrencesOfString:@"#import <Foundation/Foundation.h> \n" withString:imports];
                        //
                        //                        NSString *properties = [classString substringWithRange:
                        //                                             NSMakeRange([classString rangeOfString:className].location,
                        //                                                         [classString rangeOfString:@"@end"].location - [classString rangeOfString:className].location )];
                        //
                        //                        result = [result stringByReplacingOccurrencesOfString:className withString:properties];
                        
                        for (NSString *line in [[classString componentsSeparatedByString:@"\n"] reverseObjectEnumerator]) {
                            if (line.length &&
                                ![result containsString:line] &&
                                [line hasPrefix:@"#import"]) {
                                
                                result = [result stringByReplacingOccurrencesOfString:@"#import <Foundation/Foundation.h> \n" withString:[NSString stringWithFormat:@"#import <Foundation/Foundation.h> \n%@ \n",line]];
                                
                            }
                            else if (line.length &&
                                     ![result containsString:line] &&
                                     [line hasPrefix:@"@property"])
                            {
                                result = [result stringByReplacingOccurrencesOfString:className withString:[NSString stringWithFormat:@"%@ \n%@ ",className,line]];
                            }
                        }
                        
                        newClasses[i] = result;
                        found = YES;
                        break;
                    }
                }
                if (!found) {
                    [newClasses addObject:classString];
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    //    for (NSString *classString in [data componentsSeparatedByString:@"//FadiSpliterString\n"]) {
    for (NSString *classString in newClasses) {
        if (classString.length) {
            @try {
                NSString *className = [classString substringWithRange:
                                       NSMakeRange([classString rangeOfString:@"@interface "].location + [classString rangeOfString:@"@interface "].length,
                                                   [classString rangeOfString:@" :"].location - ([classString rangeOfString:@"@interface "].location + [classString rangeOfString:@"@interface "].length))];
                //.h
                NSError *error;
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",className]];
                [classString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                NSLog(@"%@ file location in (%@)",[NSString stringWithFormat:@"%@.h",className],filePath);
                
                //.m
                NSString *implement = @"//\n";
                implement = [implement stringByAppendingString:[NSString stringWithFormat:@"//Created by FARequest on %@ \n",[[NSDate date] getStringWithFormat:@"dd/MM/yy"]]];
                implement = [implement stringByAppendingString:[NSString stringWithFormat:@"//Copyright © %i Fadi Abuzant. All rights reserved.  \n",(int)[[NSDate date] getYear]]];
                implement = [implement stringByAppendingString:@"//\n\n"];
                
                implement = [implement stringByAppendingString:[NSString stringWithFormat:@"#import \"%@.h\" \n",className]];
                implement = [implement stringByAppendingString:[NSString stringWithFormat:@"@implementation %@ \n",className]];
                implement = [implement stringByAppendingString:@"//\n@end\n"];
                
                filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",className]];
                [implement writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                NSLog(@"%@ file location in (%@)",[NSString stringWithFormat:@"%@.m",className],filePath);
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    }
    
}

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
                else if ([arg isKindOfClass:[NSArray class]] || [arg isKindOfClass:[NSMutableArray class]])
                {
                    [((NSMutableDictionary*)self) setObject:[arg dictionaryArray:&*error] forKey:name];
                }
                else if ([arg isKindOfClass:[NSString class]] ||
                         [arg isKindOfClass:[NSDate class]] ||
                         [arg isKindOfClass:[NSData class]] ||
                         [arg isKindOfClass:[NSDictionary class]] ||
                         [arg isKindOfClass:[NSMutableDictionary class]])
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
        //fix keys in dictionary
        NSMutableDictionary *fixedDictionary = [self fixKeyNames];
        
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
                else if([fixedDictionary objectForKey:propertyGetter])
                    value = [fixedDictionary objectForKey:propertyGetter];
                else if([fixedDictionary objectForKey:propertyName])
                    value = [fixedDictionary objectForKey:propertyName];
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

-(NSString*)fixKeyName:(NSString*)key
{
    //    NSString *unfilteredString = @"!@#$%^&*()_+|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
    return [[key componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
}

-(NSMutableDictionary*)fixKeyNames
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *key in self.allKeys)
        [result setObject:[self objectForKey:key] forKey:[self fixKeyName:key]];
    return result;
}

@end
