/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BBRankDelegateProtocol.h"


@class BBClassification;


@interface BBClassificationSelector : NSObject <
    RKObjectLoaderDelegate
>

@property (nonatomic,strong) BBClassification* currentClassification;
@property (nonatomic,strong) NSString* currentRank;
@property (nonatomic,strong) NSArray* ranksToQuery;
@property (nonatomic,weak) id<BBRankDelegateProtocol> controller;

-(BBClassificationSelector*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate;

-(BBClassificationSelector*)initWithClassification:(BBClassification*)classification
                                    andCurrentRank:(NSString*)currentRank
                                       andDelegate:(id<BBRankDelegateProtocol>)delegate;

-(void)getRanks;

-(NSString*)getNextRankQuery;

-(NSString*)getPreviousRankQuery;

@end