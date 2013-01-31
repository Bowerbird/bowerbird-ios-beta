/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@protocol BBProjectSelectDelegateProtocol <NSObject>

@optional
-(void)addSightingProject:(NSString*)projectId;
-(void)removeSightingProject:(NSString*)projectId;
-(NSArray*)getSightingProjects;
-(NSArray*)getUsersProjects;
-(void)stopAddingProjects;

@end