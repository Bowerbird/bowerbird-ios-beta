/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBHelpers.h"
#import "BBProject.h"
#import "BBPaginator.h"
#import "BBActivityPaginator.h"
#import "BBProjectPaginator.h"
#import "BBActivity.h"


@interface BBPaginator()

@property BOOL requestWasPullLatest;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewer;
@property (nonatomic, strong) NSDate *latestFetchedActivityOlder;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewerLocalTime;
@property BOOL paginatorIsLoading;
@property (nonatomic, weak) id<BBStreamControllerDelegate> controller;

@end


@implementation BBPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize items = _items;
@synthesize pageCount = _pageCount;
@synthesize currentPage = _currentPage;
@synthesize requestWasPullLatest = _requestWasPullLatest;
@synthesize latestFetchedActivityNewer = _latestFetchedActivityNewer;
@synthesize latestFetchedActivityOlder = _latestFetchedActivityOlder;
@synthesize paginatorIsLoading = _paginatorIsLoading;
@synthesize controller = _controller;


-(NSMutableArray*)items {
    if(!_items) _items = [[NSMutableArray alloc]init];
    return _items;
}
-(void)setItems:(NSMutableArray *)items { _items = items; }
-(void)addItem:(NSObject*)item { [self.items addObject:item]; }
-(void)removeItem:(NSObject*)item { [self.items removeObject:item]; }
-(BOOL)moreItemsExist { return self.currentPage < self.pageCount; }
-(void)setPageCount:(NSUInteger)pageCount { _pageCount = pageCount; }
-(void)setCurrentPage:(NSUInteger)currentPage { _currentPage = currentPage; }
-(void)setPaginatorLoading:(BOOL)loading { _paginatorIsLoading = loading; }


#pragma mark -
#pragma mark - Constructors


-(id)initWithPatternURL:(RKURL *)patternURL
        mappingProvider:(RKObjectMappingProvider *)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate {

    self = [super initWithPatternURL:patternURL mappingProvider:mappingProvider];
    
    if(self) {
        self.controller = delegate;
        self.latestFetchedActivityOlder = [NSDate getCurrentUTCDate];
        self.latestFetchedActivityNewer = [NSDate getCurrentUTCDate];
        self.latestFetchedActivityNewerLocalTime = [NSDate date];
    }
    
    return self;
}


#pragma mark -
#pragma mark - Delegation and Event Handling for Paginator


-(void)paginator:(RKObjectPaginator *)paginator
  didLoadObjects:(NSArray *)objects
         forPage:(NSUInteger)page {
    [BBLog Log:@"BBPaginator.paginator:didLoadObjects:forPage"];
    
    self.paginatorIsLoading = NO;
    
    [self.controller pagingLoadingComplete];
    
    [BBLog Log:[NSString stringWithFormat:@"%@ %@ Page:%i", @"Paginator objects:", objects, page]];
    
    if([[objects objectAtIndex:0] isKindOfClass:[BBActivityPaginator class]]) {
        BBActivityPaginator *paginator = (BBActivityPaginator*)[objects objectAtIndex:0];
        NSArray *items = paginator.activities;
        [self processPaginator:items];
    }
    else if([[objects objectAtIndex:0] isKindOfClass:[BBProjectPaginator class]]) {
        BBProjectPaginator *paginator = (BBProjectPaginator*)[objects objectAtIndex:0];
        NSArray *items = paginator.projects;
        [self processPaginator:items];
    }
}

-(void)paginator:(RKObjectPaginator *)paginator
    willLoadPage:(NSUInteger)page
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBPaginator.paginator:willLoadPage:objectLoader:"];
    RKURL *url = paginator.patternURL;
    
    // hack to overwrite the paging parameter with the propper page number: http://stackoverflow.com/questions/11751880/how-to-fetch-pages-of-results-with-restkit
    loader.resourcePath = [NSString stringWithFormat:@"%@&OlderThan=%@", [url.resourcePath stringByReplacingOccurrencesOfString:@"Page=1" withString:[NSString stringWithFormat:@"Page=%i", page]], [self.latestFetchedActivityOlder dateAsJsonUtcString]];
}

-(void)paginator:(RKObjectPaginator *)paginator
didFailWithError:(NSError *)error
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBPaginator.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];

    _paginatorIsLoading = NO;
    
    [self.controller pagingLoadingComplete];
}

-(void)handlePaginatorLoadNextPage {
    if([self moreItemsExist] && !_paginatorIsLoading)
    {
        _paginatorIsLoading = YES;
        
        [self.controller pageLoadingStarted];

        [self loadNextPage];
    }
}

-(void)processPaginator:(NSArray*)paginatorItems {
    [BBLog Log:@"BBPaginator.processPaginator:"];
    
    // if we haven't already displayed this item, push it to the view
    for(id item in paginatorItems) {
        if(([item isKindOfClass:[BBActivity class]] || [item isKindOfClass:[BBProject class]]) && ![self.items containsObject:item])
        {
            [self.items addObject:item];
        }
    }
    
    [self.controller displayItems];
    
    self.requestWasPullLatest = NO;
    
    // TODO. make the controller 'Observe' the collection to detect redraw requirements.
    
    [BBLog Log:[NSString stringWithFormat:@"Paginator item count: %i", self.items.count]];
}

-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}


@end