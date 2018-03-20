//
//  FARequestMediaFile.m
//
//  Created by Fadi Abuzant on 3/16/18.
//

#import "FARequestMediaFile.h"

@implementation FARequestMediaFile

- (instancetype)initWithName:(NSString *)name Image:(UIImage*)image
{
    self = [super init];
    if (self) {
        self.name = name;
        self.image = image;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name File:(NSData*)file
{
    self = [super init];
    if (self) {
        self.name = name;
        self.file = file;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name FilePath:(NSString*)filePath
{
    self = [super init];
    if (self) {
        self.name = name;
        self.filename = [NSString stringWithFormat:@"%@.jpg",name];
        self.filePath = filePath;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name File:(NSData*)file Filename:(NSString*)filename
{
    self = [super init];
    if (self) {
        self.name = name;
        self.file = file;
        self.filename = filename;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name FilePath:(NSString*)filePath Filename:(NSString*)filename Mimetype:(NSString*)mimetype
{
    self = [super init];
    if (self) {
        self.name = name;
        self.filePath = filePath;
        self.filename = filename;
        self.mimetype = mimetype;
    }
    return self;
}

@end
