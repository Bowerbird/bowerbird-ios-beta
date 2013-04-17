/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBStreamControllerDelegate.h"
#import "BBStreamProtocol.h"


@interface BBStreamController : UITableViewController  <
    UITableViewDelegate,
    UITableViewDataSource,
    UIGestureRecognizerDelegate,
    BBStreamControllerDelegate
>

    -(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate;

    -(BBStreamController*)initWithGroup:(NSString*)groupId
                            andDelegate:(id<BBStreamProtocol>)delegate;

    -(BBStreamController*)initWithGroupForBrowsing:(NSString*)groupIdentifier
                                       andDelegate:(id<BBStreamProtocol>)delegate;

    -(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate;

    -(BBStreamController*)initWithFavouritesAndDelegate:(id<BBStreamProtocol>)delegate;
    
    - (void)reloadTableViewDataSource;

    - (void)doneLoadingTableViewData;

@end