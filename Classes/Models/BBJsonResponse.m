/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBJsonResponse.h"


@implementation BBJsonResponse


#pragma mark -
#pragma mark - Member Accessors


@synthesize success = _success;


-(BOOL)success { return _success; }
-(void)setSuccess:(BOOL)success { _success = success; }


@end