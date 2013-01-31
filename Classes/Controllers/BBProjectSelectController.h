/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBProjectSelectDelegateProtocol.h"


@interface BBProjectSelectController : BBControllerBase <
    BBProjectSelectDelegateProtocol
>

@property (nonatomic,retain) id controller;
@property (nonatomic,strong) NSArray *projects;

-(NSArray*)getUsersProjects;
-(NSArray*)usersProjectsNotSelected;
-(NSArray*)getSightingProjects;
-(void)addSightingProject:(NSString*)projectId;
-(void)removeSightingProject:(NSString*)projectId;

-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate;

@end