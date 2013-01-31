/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <RestKit/RestKit.h>
#import "BBModelId.h"


@interface BBProjectId : BBModelId <
    RKObjectLoaderDelegate
>

-(id)initWithProjectId:(NSString *)identifier;

@end