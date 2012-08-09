/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for notifying calling objects when the user has finished loading
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "UserMOdel.h"

@class UserModel;

@protocol UserLoadCompleteDelegate <NSObject>

-(void)UserLoaded:(UserModel*)user;

@end
