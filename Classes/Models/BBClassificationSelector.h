/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBClassification;


@interface BBClassificationSelector : NSObject


@property (nonatomic,strong) BBClassification* currentClassification;
@property (nonatomic,strong) NSString* currentRank;
@property (nonatomic,strong) NSArray* ranksToQuery;


-(BBClassificationSelector*)initWithClassification:(BBClassification*)classification
                                    andCurrentRank:(NSString*)currentRank;

-(NSString*)getNextRankQuery;

-(NSString*)getPreviousRankQuery;


@end