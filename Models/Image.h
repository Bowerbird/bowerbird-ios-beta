/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "NSNumber+ConvertMethods.h"
#import "BowerBirdConstants.h"
#import "RequestDataFromServer.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ImageLoaded.h"


@interface Image : NSObject <RequestDataFromServer>

@property (retain) ASINetworkQueue *networkQueue;
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* imageDimensionName;
@property (nonatomic,strong) NSString* fileName;
@property (nonatomic,strong) NSString* relativeUri;
@property (nonatomic,strong) NSString* format;
@property (nonatomic,strong) NSNumber* width;
@property (nonatomic,strong) NSNumber* height;
@property (nonatomic,strong) NSString* extension;
@property (nonatomic,strong) UIImage* image;

-(id)initWithJson:(NSDictionary *)dictionary
  havingImageName:(NSString*)imageName
 fetchingImageNow:(BOOL)fetchImageNow
   notifyComplete:(id)delegate;

@end