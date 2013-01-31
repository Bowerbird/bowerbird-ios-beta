/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingPaginator.h"


@implementation BBSightingPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize sightings = _sightings;

-(void)setSightings:(NSArray *)sightings { _sightings = sightings; }
-(NSArray*)sightings {
    if(!_sightings)_sightings = [[NSArray alloc]init];
    return _sightings;
}
-(NSUInteger)countOfSightings { return [_sightings count]; }
-(id)objectInSightingsAtIndex:(NSUInteger)index { return [_sightings objectAtIndex:index]; }


#pragma mark -
#pragma mark - Constructors


-(id)initWithPatternURL:(RKURL *)patternURL
        mappingProvider:(RKObjectMappingProvider *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate {
    
    self = [super initWithPatternURL:patternURL mappingProvider:mappingProvider andDelegate:delegate];
    
    return self;
}


#pragma mark -
#pragma mark - Delegation and Event Handling for paging


- (void) objectLoader:(RKObjectLoader *)loader
          willMapData:(inout __autoreleasing id *)mappableData {
    NSMutableDictionary* model = [[*mappableData objectForKey: @"Model"] mutableCopy];
    NSDictionary* pagedResult = [model objectForKey:@"Sightings"];
    
    self.perPage = [[pagedResult objectForKey: @"PageSize"] intValue];
    self.pageCount = ([[pagedResult objectForKey: @"TotalResultCount"] intValue] / [[pagedResult objectForKey: @"PageSize"] intValue]) + 1;
    self.currentPage = [[pagedResult objectForKey: @"Page"] intValue];
}


-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}


@end