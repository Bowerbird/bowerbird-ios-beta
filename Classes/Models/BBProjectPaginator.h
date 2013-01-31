/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBStreamControllerDelegate.h"
#import "BBPaginator.h"


@interface BBProjectPaginator : BBPaginator


@property (nonatomic,retain) NSArray* projects;


-(id)initWithPatternURL:(RKURL *)patternURL
        mappingProvider:(RKObjectMappingProvider *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate;


@end