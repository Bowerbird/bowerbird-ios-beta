/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBProjectPaginator.h"
#import "BBStreamControllerDelegate.h"


@interface BBProjectPaginator()

@property (nonatomic,weak) id<BBStreamControllerDelegate> delegate;

@end


@implementation BBProjectPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize projects = _projects,
            delegate = _delegate;


-(void)setProjects:(NSArray *)projects { _projects = projects; }
-(NSArray*)projects {
    if(!_projects)_projects = [[NSArray alloc]init];
    return _projects;
}
-(NSUInteger)countOfProjects { return [self.projects count]; }
-(id)objectInProjectsAtIndex:(NSUInteger)index { return [self.projects objectAtIndex:index]; }


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


- (void) objectLoader:(RKObjectLoader *)loader willMapData:(inout __autoreleasing id *)mappableData {
    NSMutableDictionary* model = [[*mappableData objectForKey: @"Model"] mutableCopy];
    NSDictionary* pagedResult = [model objectForKey:@"Projects"];
    
    self.perPage = [[pagedResult objectForKey: @"PageSize"] intValue];
    self.pageCount = ([[pagedResult objectForKey: @"TotalResultCount"] intValue] / [[pagedResult objectForKey: @"PageSize"] intValue]) + 1;
    self.currentPage = [[pagedResult objectForKey: @"Page"] intValue];
}


-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}


@end