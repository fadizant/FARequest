//
//  FARequestObject.h
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import <Foundation/Foundation.h>
#import "FARequestConfiguration.h"
#import "FARequestMediaFile.h"

@class FARequest;
@interface FARequestObject : NSObject

#pragma mark - Property
@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) NSString *parameter;
@property (nonatomic,retain) NSString *notificationKey;
@property (nonatomic,retain) NSMutableArray<FARequestMediaFile*> *mediaFiles;
@property (nonatomic,retain) FARequestConfiguration *configuration;
@property (nonatomic) id completed;

#pragma mark   get (Download)

@property (nonatomic,retain) NSString *saveInFolder;
@property (nonatomic,retain) NSString *saveWithName;
@property (nonatomic,retain) NSString *saveWithExtension;
@property (nonatomic) BOOL overWrite;

#pragma mark - Method

#pragma mark With Default Configuration

-(instancetype)initWithUrl:(NSURL*)url;

-(instancetype)initWithUrl:(NSURL*)url
                 Parameter:(NSString *)parameter;

-(instancetype)initWithUrl:(NSURL*)url
       DictionaryParameter:(NSMutableDictionary *)dictionaryParam;

-(instancetype)initWithUrl:(NSURL*)url
             JSONParameter:(NSMutableDictionary *)JSONParameter;

#pragma mark With Custom Configuration

-(instancetype)initWithUrl:(NSURL*)url
             Configuration:(FARequestConfiguration *)configuration;

-(instancetype)initWithUrl:(NSURL*)url
                 Parameter:(NSString *)parameter
             Configuration:(FARequestConfiguration *)configuration;

-(instancetype)initWithUrl:(NSURL*)url
       DictionaryParameter:(NSMutableDictionary *)dictionaryParam
             Configuration:(FARequestConfiguration *)configuration;

-(instancetype)initWithUrl:(NSURL*)url
             JSONParameter:(NSMutableDictionary *)JSONParameter
             Configuration:(FARequestConfiguration *)configuration;

#pragma mark - get (Download)
-(instancetype)initWithUrl:(NSURL*)url
              SaveInFolder:(NSString *)saveInFolder
              SaveWithName:(NSString *)saveWithName
         SaveWithExtension:(NSString *)saveWithExtension
                 OverWrite:(BOOL)overWrite;

-(NSURL*)docDirectoryURL;

-(NSString*)filePath;

-(NSURL*)fileURL;

-(BOOL)fileExist;

-(BOOL)removeFile;
@end
