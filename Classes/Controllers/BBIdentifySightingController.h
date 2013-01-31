/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBControllerBase.h"
#import <RestKit/RestKit.h>
#import "BBIdentifySightingProtocol.h"


@class BBIdentifySightingEdit;


@interface BBIdentifySightingController : BBControllerBase <
     BBIdentifySightingProtocol
    ,RKObjectLoaderDelegate
>

@property (nonatomic,strong) BBIdentifySightingEdit *identifySighting;

-(BBIdentifySightingController*)initWithSightingId:(NSString*)sightingId;

@end