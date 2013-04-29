/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMediaResourceCreate.h"
#import "BBMediaEdit.h"
#import "SVProgressHUD.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"
#import "BBValidationError.h"


@implementation BBMediaResourceCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize file = _file,
            usage = _usage,
            key = _key,
            type = _type,
            fileName = _fileName,
            errors = _errors;


-(NSData*)file { return _file; }
-(void)setFile:(NSData *)file { _file = file; }
-(NSString*)fileName { return _fileName; }
-(void)setFileName:(NSString *)fileName { _fileName = fileName; }
-(NSString*)usage { return _usage; }
-(void)setUsage:(NSString *)usage { _usage = usage; }
-(NSString*)key { return _key; }
-(void)setKey:(NSString *)key { _key = key; }
-(NSString*)type { return _type; }
-(void)setType:(NSString *)type { _type = type; }
-(void)setValue:(id)value forUndefinedKey:(NSString *)key { if([key isEqualToString:@"Key"]) self.key = value; }
-(BBValidationError*)errors { return _errors; }
-(void)setErrors:(BBValidationError *)errors { _errors = errors; }


#pragma mark -
#pragma mark - Constructors


-(BBMediaResourceCreate*)initWithMedia:(BBMediaEdit*)media
                              forUsage:(NSString*)usage {
    
    self = [super init];
    
    UIImage *fixedImage = [media.image normalizedImage];
    
    _file = UIImageJPEGRepresentation(fixedImage, 100);
    _type = @"file";
    _key = media.key;
    _usage = usage;
    
     // we don't have (easy) access to a native filename like the web client, so use the key.
    _fileName = [NSString stringWithFormat:@"%@.jpg", _key];
    
    return self;
}


@end