//
//  FARequestConfiguration.h
//
//  Created by Fadi Abuzant on 3/14/18.
//

#import <Foundation/Foundation.h>
#import "FARequestAuthorization.h"

@interface FARequestConfiguration : NSObject

typedef NS_ENUM(NSInteger, FARequestType) {
    FARequestTypeGET,
    FARequestTypePOST,
    FARequestTypePUT,
    FARequestTypeDELETE,
    FARequestTypePATCH,
};

#pragma mark - Property
@property (nonatomic) FARequestType requestType;
@property (nonatomic,retain) NSDictionary *header;
@property (nonatomic,retain) id object;
@property (nonatomic) BOOL useCashe;
@property (nonatomic) BOOL encoding;
@property (nonatomic) float timeOut;
@property (nonatomic,retain) FARequestAuthorization *authorization;

#pragma mark - Method
- (instancetype)initWithRequestType:(FARequestType)requestType;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding
                            TimeOut:(float)timeOut;

- (instancetype)initWithRequestType:(FARequestType)requestType
                             Header:(NSDictionary<NSString*,id>*)header
                             Object:(id)object
                           UseCashe:(BOOL)useCashe
                           Encoding:(BOOL)encoding
                            TimeOut:(float)timeOut
                      Authorization:(FARequestAuthorization*)authorization;

-(FARequestConfiguration*)clone;
@end
