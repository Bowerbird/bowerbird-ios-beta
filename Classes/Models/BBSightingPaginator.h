/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BBPaginator.h"


@interface BBSightingPaginator : BBPaginator


@property (nonatomic,retain) NSMutableArray* sightings;


-(id)initWithPatternURL:(RKURL *)patternURL
        mappingProvider:(RKObjectMappingProvider *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate;


@end