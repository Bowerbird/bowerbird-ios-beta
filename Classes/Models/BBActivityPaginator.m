/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBActivityPaginator.h"
#import "BBHelpers.h"


@interface BBActivityPaginator()
@property (nonatomic,weak) id<BBStreamControllerDelegate> controller;
@end

@implementation BBActivityPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize activities = _activities,
            controller = _controller;

-(void)setActivities:(NSArray *)activities { _activities = activities; }
-(NSArray*)activities {
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities { return [self.activities count]; }
-(id)objectInActivitiesAtIndex:(NSUInteger)index { return [self.activities objectAtIndex:index]; }


#pragma mark - 
#pragma mark - Constructors


-(id)initWithPatternURL:(RKURL *)patternURL
        mappingProvider:(RKObjectMappingProvider *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate {
    
    self = [super initWithPatternURL:patternURL mappingProvider:mappingProvider andDelegate:delegate];
    
    return self;
}


#pragma mark -
#pragma mark - Delegation and Event Handling for pull to refresh


-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    //[SVProgressHUD showErrorWithStatus:error.description];
    //[_tableView.pullToRefreshView stopAnimating];
    [self.controller pullToRefreshCompleted];
    
    //[[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    //[[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:_paginator.latestFetchedActivityNewer];
}


    -(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBStreamController.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBStreamController.didLoadObject"];
    
    if([object isKindOfClass:[BBActivityPaginator class]]) {
        // reverse the order so the items are popped onto the top of the UI scroll view with the oldest first.
        //[self processPaginator:[[((BBActivityPaginator*)object).activities reverseObjectEnumerator] allObjects]];
    }
    
    //[[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    //[[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:self.latestFetchedActivityNewerLocalTime];
}


#pragma mark -
#pragma mark - Delegation and Event Handling for paging


- (void) objectLoader:(RKObjectLoader *)loader
          willMapData:(inout __autoreleasing id *)mappableData {
    NSMutableDictionary* model = [[*mappableData objectForKey: @"Model"] mutableCopy];
    NSDictionary* pagedResult = [model objectForKey:@"Activities"];
    
    self.perPage = [[pagedResult objectForKey: @"PageSize"] intValue];
    self.pageCount = ([[pagedResult objectForKey: @"TotalResultCount"] intValue] / [[pagedResult objectForKey: @"PageSize"] intValue]) + 1;
    self.currentPage = [[pagedResult objectForKey: @"Page"] intValue];
}


-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}


@end