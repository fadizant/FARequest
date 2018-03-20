//
//  FARequestObject.m
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import "FARequestObject.h"
#import "FARequest.h"

@implementation FARequestObject

#pragma mark With Default Configuration
-(instancetype)initWithUrl:(NSURL*)url{
    return [self initWithUrl:url
                    Configuration:[FARequest defaultConfiguration].clone];
}

-(instancetype)initWithUrl:(NSURL*)url
         Parameter:(NSString *)parameter{
    return [self initWithUrl:url
                        Parameter:parameter
                    Configuration:[FARequest defaultConfiguration].clone];
}

-(instancetype)initWithUrl:(NSURL*)url
DictionaryParameter:(NSMutableDictionary *)dictionaryParam{
    return [self initWithUrl:url
              DictionaryParameter:dictionaryParam
                    Configuration:[FARequest defaultConfiguration].clone];
}

-(instancetype)initWithUrl:(NSURL*)url
     JSONParameter:(NSMutableDictionary *)JSONParameter{
    return [self initWithUrl:url
                    JSONParameter:JSONParameter
                    Configuration:[FARequest defaultConfiguration].clone];
}

#pragma mark With Custom Configuration

-(instancetype)initWithUrl:(NSURL*)url
     Configuration:(FARequestConfiguration *)configuration{
    self = [super init];
    if (self) {
        self.url = url;
        self.parameter = @"";
        self.configuration = configuration;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL*)url
         Parameter:(NSString *)parameter
     Configuration:(FARequestConfiguration *)configuration{
    self = [super init];
    if (self) {
        self.url = url;
        self.parameter = parameter;
        self.configuration = configuration;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL*)url
DictionaryParameter:(NSMutableDictionary *)dictionaryParam
     Configuration:(FARequestConfiguration *)configuration{
    NSString *parameter = @"";
    if (dictionaryParam) {
        for (NSString* key in dictionaryParam.allKeys) {
            parameter = [parameter stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dictionaryParam objectForKey:key]]];
        }
        parameter = parameter ? [parameter substringToIndex:parameter.length-1] : @"";
    }
    
    self = [super init];
    if (self) {
        self.url = url;
        self.parameter = parameter;
        self.configuration = configuration;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL*)url
     JSONParameter:(NSMutableDictionary *)JSONParameter
     Configuration:(FARequestConfiguration *)configuration{
    self = [super init];
    if (self) {
        self.url = url;
        self.parameter = [FARequestHelper GetJSON:JSONParameter];
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - get (Download)
-(instancetype)initWithUrl:(NSURL*)url
              SaveInFolder:(NSString *)saveInFolder
              SaveWithName:(NSString *)saveWithName
         SaveWithExtension:(NSString *)saveWithExtension
                 OverWrite:(BOOL)overWrite{
    self = [super init];
    if (self) {
        self.url = url;
        self.saveInFolder = saveInFolder;
        self.saveWithName = saveWithName;
        self.saveWithExtension = saveWithExtension;
        self.overWrite = overWrite;
        self.configuration = [FARequest defaultConfiguration].clone;
    }
    return self;
}

-(NSURL*)docDirectoryURL{
    if (!self.saveInFolder)
        return nil;
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docDirectoryURL = [URLs objectAtIndex:0];
    
    docDirectoryURL = [docDirectoryURL URLByAppendingPathComponent:self.saveInFolder isDirectory:YES];
    
    return docDirectoryURL;
}

-(NSString*)filePath
{
    if (![self fileURL])
        return nil;
    
    return [[self fileURL] path];
}

-(NSURL*)fileURL
{
    if (![self docDirectoryURL] || !self.saveWithName)
        return nil;
    
    NSString *destinationFilename ;
    if (self.saveWithExtension && ![self.saveWithExtension isEqualToString:@""]) {
        destinationFilename = [NSString stringWithFormat:@"%@.%@",self.saveWithName,self.saveWithExtension];
    } else {
        destinationFilename = [NSString stringWithFormat:@"%@",self.saveWithName];
    }
    return [[self docDirectoryURL] URLByAppendingPathComponent:destinationFilename];
}

-(BOOL)fileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:[self filePath]];
}

-(BOOL)removeFile
{
    @try {
        if ([self fileExist]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
            if (!error) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
        
    } @catch (NSException *exception) {
        return NO;
    } @finally {
        
    }
}
@end
