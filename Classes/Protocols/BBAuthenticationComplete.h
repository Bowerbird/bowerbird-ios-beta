/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for notifying UI that Authentication Request has been processed
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@class BBUser;

@protocol BBAuthenticationComplete <NSObject>

-(void)UserAuthenticated:(BBUser*)user;

@end