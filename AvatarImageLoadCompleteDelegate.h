/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for notifying calling objects when their avatars have finished loading
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@protocol AvatarImageLoadCompleteDelegate <NSObject>

@optional

-(void)ImageFinishedLoading:(NSString *)imageDimensionName
             forAvatarOwner:(id)avatarOwner;

@end