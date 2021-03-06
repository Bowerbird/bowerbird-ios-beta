/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBLog : NSObject


+(void)Log:(id)message;

+(void)Debug:(id)message;

+(void)Debug:(id)payload withMessage:(NSString*)message;

+(void)Error:(id)message;

+(void)LogStringArray:(NSArray*)params;


@end