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
#import "BBSightingPaginator.h"
#import "BBActivity.h"
#import "BBObservation.h"
#import "SVProgressHUD.h"


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


-(id)initWithPatternURL:(id)patternURL
        mappingProvider:(id)mappingProvider
            andDelegate:(id<BBStreamControllerDelegate>)delegate {

    self = [super initWithRequest:(NSURLRequest *)patternURL paginationMapping:(RKObjectMapping *)mappingProvider responseDescriptors:<#(NSArray *)#>
    
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


/*
             -(void)request:(id)request
             didReceiveData:(NSInteger)bytesReceived
         totalBytesReceived:(NSInteger)totalBytesReceived
totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive {
    [BBLog Log:[NSString stringWithFormat:@"bytes received: %d total received: %d total to receive: %d", bytesReceived, totalBytesReceived, totalBytesExpectedToReceive]];
                 
     double progress = ((double)totalBytesReceived/(double)totalBytesExpectedToReceive)*100;
     //double fileSize = (double)totalBytesExpectedToWrite/10485760;// added additional factor of ten to bytes denomenator in MB as too big by about 10 X
     
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
     [formatter setRoundingMode:NSNumberFormatterRoundUp];
     [formatter setGeneratesDecimalNumbers:YES];
     [formatter setMaximumFractionDigits:1];
     
     [SVProgressHUD setStatus:[NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithDouble:progress]], @"%"]];
     
     if(progress == 100){
         [SVProgressHUD dismiss];
     }
}

-(void)paginator:(id)paginator
  didLoadObjects:(NSArray *)objects
         forPage:(NSUInteger)page {
    [BBLog Log:@"BBPaginator.paginator:didLoadObjects:forPage"];
    
    self.paginatorIsLoading = NO;
    
    [self.controller pagingLoadingComplete];
    
    //BOOL noMorePages = paginator.currentPage == paginator.pageCount;
    
    //[self.controller setNoMoreResultsAvail:noMorePages];
    
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
    else if([[objects objectAtIndex:0] isKindOfClass:[BBSightingPaginator class]]) {
        BBSightingPaginator *paginator = (BBSightingPaginator*)[objects objectAtIndex:0];
        NSArray *items = paginator.sightings;
        [self processPaginator:items];
    }
    
    
    
}

-(void)paginator:(id)paginator
    willLoadPage:(NSUInteger)page
    objectLoader:(id)loader {
    [BBLog Log:@"BBPaginator.paginator:willLoadPage:objectLoader:"];
    RKURL *url = paginator.patternURL;
    
    // hack to overwrite the paging parameter with the propper page number: http://stackoverflow.com/questions/11751880/how-to-fetch-pages-of-results-with-restkit
    loader.resourcePath = [NSString stringWithFormat:@"%@&OlderThan=%@", [url.resourcePath stringByReplacingOccurrencesOfString:@"Page=1"
                                                                                                                     withString:[NSString stringWithFormat:@"Page=%i", page]], [self.latestFetchedActivityOlder dateAsJsonUtcString]];
}

-(void)paginator:(RKObjectPaginator *)paginator
didFailWithError:(NSError *)error
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBPaginator.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];

    self.paginatorIsLoading = NO;
    [self.controller setLoading:NO];
    
    [self.controller pagingLoadingComplete];
}

// this has probably been made obsolete
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
    
    NSMutableArray *addToStream = [[NSMutableArray alloc]init];
    
    // if we haven't already displayed this item, push it to the view
    for(id item in paginatorItems) {
        if(([item isKindOfClass:[BBActivity class]] ||
            [item isKindOfClass:[BBProject class]] ||
            [item isKindOfClass:[BBObservation class]]) //&&
           //![self.items containsObject:item]
           )
        {
            //[self.items addObject:item];
            [addToStream addObject:item];
        }
    }
    
    //[self.controller displayItems];
    [self.controller addItemsToTableDataSource:addToStream];
    [self.controller setLoading:NO];
    
    self.requestWasPullLatest = NO;
    
    // TODO. make the controller 'Observe' the collection to detect redraw requirements.
    
    [BBLog Log:[NSString stringWithFormat:@"Paginator item count: %i", self.items.count]];
}
 */

-(void)dealloc {
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
}


@end