/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBRankDelegateProtocol.h"
#import "MGHelpers.h"


@interface BBRankBrowser : MGScrollView <
    BBRankDelegateProtocol
>

-(BBRankBrowser*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate;

-(void)displayRanks:(NSArray*)ranks;

-(void)displayRankLoader;


@end