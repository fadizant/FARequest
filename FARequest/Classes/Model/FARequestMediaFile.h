//
//  FARequestMediaFile.h
//
//  Created by Fadi Abuzant on 3/16/18.
//

#import <Foundation/Foundation.h>

@interface FARequestMediaFile : NSObject

#pragma mark - property
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *filename;
@property (nonatomic,retain) NSString *mimetype;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSData *file;
@property (nonatomic,retain) NSString *filePath;

#pragma mark - method
- (instancetype)initWithName:(NSString *)name Image:(UIImage*)image;

- (instancetype)initWithName:(NSString *)name File:(NSData*)file;

- (instancetype)initWithName:(NSString *)name FilePath:(NSString*)filePath;

- (instancetype)initWithName:(NSString *)name File:(NSData*)file Filename:(NSString*)filename;

- (instancetype)initWithName:(NSString *)name FilePath:(NSString*)filePath Filename:(NSString*)filename Mimetype:(NSString*)mimetype;

@end

#pragma mark - MIME types
// source = https://www.iana.org/assignments/media-types/media-types.xhtml
#pragma mark image
#define FARequestMediaTypeJPEG                      @"image/jpeg"
#define FARequestMediaTypePNG                       @"image/png"
#define FARequestMediaTypeGIF                       @"image/gif"
#define FARequestMediaTypeSVG                       @"image/svg+xml"
#define FARequestMediaTypeBMP                       @"image/bmp"
#define FARequestMediaTypeWEBP                      @"image/webp"
#define FARequestMediaTypeTIFF                      @"image/tiff"
#define FARequestMediaTypePSD                       @"image/vnd.adobe.photoshop"

#pragma mark video
#define FARequestMediaTypeMP4                       @"video/mp4"
#define FARequestMediaTypeMP4V                      @"video/mp4v"
#define FARequestMediaTypeOGGVideo                  @"video/ogg"
#define FARequestMediaTypeWEBMVideo                 @"video/webm"
#define FARequestMediaTypeAVI                       @"video/avi"
#define FARequestMediaTypeQUICKTIME                 @"video/quicktime"
#define FARequestMediaTypeMPGVideo                  @"video/mpg"
#define FARequestMediaTypeMPEGVideo                 @"video/mpeg"
#define FARequestMediaType3GPPVideo                 @"video/3gpp"
#define FARequestMediaTypeMOV                       @"video/quicktime"

#pragma mark audio
#define FARequestMediaTypeMIDI                      @"audio/midi"
#define FARequestMediaTypeMPEGAudio                 @"audio/mpeg"
#define FARequestMediaTypeWEBMAudio                 @"audio/webm"
#define FARequestMediaTypeOGGAudio                  @"audio/ogg"
#define FARequestMediaTypeWAV                       @"audio/wav"
#define FARequestMediaTypeMP3                       @"audio/mp3"
#define FARequestMediaType3GPPAudio                 @"audio/3gpp"
#define FARequestMediaTypeAIFF                      @"audio/aiff"
#define FARequestMediaTypeM4A                       @"audio/m4a"


#pragma mark application
#define FARequestMediaTypePDF                       @"application/pdf"
#define FARequestMediaTypeOCTET_STREAM              @"application/octet-stream"
#define FARequestMediaTypeXHTML                     @"application/xhtml+xml"
#define FARequestMediaTypeXML                       @"application/xml"
#define FARequestMediaTypePKCS12                    @"application/pkcs12"
#define FARequestMediaTypeVND                       @"application/vnd"
#define FARequestMediaTypeZIP                       @"application/zip"
#define FARequestMediaTypeJAVA_ARCHIVE              @"application/java-archive"
#define FARequestMediaTypeTAR                       @"application/tar"
#define FARequestMediaTypeRAR                       @"application/application/x-rar-compressed"
#define FARequestMediaTypeDOC                       @"application/msword"
#define FARequestMediaTypeXLS                       @"application/vnd.ms-excel"
#define FARequestMediaTypePPT                       @"application/vnd.ms-powerpoint"


#pragma mark text
#define FARequestMediaTypePLAIN                     @"text/plain"
#define FARequestMediaTypeHTML                      @"text/html"
#define FARequestMediaTypeCSS                       @"text/css"
#define FARequestMediaTypeJAVASCRIPT                @"text/javascript"
#define FARequestMediaTypeRTF                       @"text/rtf"
#define FARequestMediaTypePHP                       @"text/php"


#pragma mark - Document Types
// source = https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
#define FADocumentTypeALL                           @"public.content"
#define FADocumentTypePDF                           @"com.adobe.pdf"
#define FADocumentTypePSD                           @"com.adobe.photoshop-​image"
#define FADocumentTypeAI                            @"com.adobe.illustrator.ai-​image"
#define FADocumentTypeGIF                           @"com.compuserve.gif"
#define FADocumentTypeBMP                           @"com.microsoft.bmp"
#define FADocumentTypeICO                           @"com.microsoft.ico"
#define FADocumentTypeDOC                           @"com.microsoft.word.doc"
#define FADocumentTypeXLS                           @"com.microsoft.excel.xls"
#define FADocumentTypePPT                           @"com.microsoft.powerpoint.​ppt"
#define FADocumentTypeWAV                           @"com.microsoft.waveform-​audio"
#define FADocumentTypeWMV                           @"com.microsoft.windows-​media-wmv"
#define FADocumentTypeWMP                           @"com.microsoft.windows-​media-wmp"
#define FADocumentTypeWMA                           @"com.microsoft.windows-​media-wma"
#define FADocumentTypeASX                           @"com.microsoft.advanced-​stream-redirector"
#define FADocumentTypeSGI                           @"com.sgi.sgi-image"
#define FADocumentTypeRM                            @"com.real.realmedia"
#define FADocumentTypeRAM                           @"com.real.realaudio"
#define FADocumentTypeSIT                           @"com.allume.stuffit-archive"
#define FADocumentTypeM4A                           @"public.mpeg-4-audio"
#define FADocumentTypeMP3                           @"public.mp3"
#define FADocumentType3GP                           @"public.3gpp"
#define FADocumentTypeMP4                           @"public.mpeg-4"
#define FADocumentTypeMPG                           @"public.mpeg"
#define FADocumentTypeAVI                           @"public.avi"
#define FADocumentTypeMOV                           @"com.apple.quicktime-movie "
#define FADocumentTypeVIDEO                         @"public.video"
#define FADocumentTypeTAR                           @"public.tar-archive"
#define FADocumentTypeJAR                           @"com.sun.java-archive"
#define FADocumentTypeTXT                           @"public.plain-text"
#define FADocumentTypeRTF                           @"public.rtf"
#define FADocumentTypeZIP                           @"com.pkware.zip-archive"
