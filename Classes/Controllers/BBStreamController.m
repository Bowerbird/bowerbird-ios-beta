/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Container for all Pageable request/responses. Home and Project streams, project list etc
 
 -----------------------------------------------------------------------------------------------*/


#import "BBStreamController.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "BBMediaResource.h"
#import "BBObservation.h"
#import "MGHelpers.h"
#import "PhotoBox.h"
#import "BBSightingDetailController.h"
#import "BBSightingItemController.h"
#import "PhotoBox.h"
#import "BBUIControlHelper.h"
#import "BBAppDelegate.h"
#import "BBStreamView.h"
#import "BBArrowView.h"
#import "BBProjectItemController.h"
#import "BBActivityController.h"
#import "BBTableViewCell.h"
#import "BBHelpers.h"
#import "BBPaginator.h"
#import "BBActivityPaginator.h"
#import "BBProjectPaginator.h"
#import "BBSightingPaginator.h"
#import "BBActivity.h"
#import "BBActivityArray.h"


@interface BBStreamController()

@property (nonatomic, strong) BBStreamView *scroller; // view
@property (nonatomic, strong) UITableView *tableView; // table
@property (nonatomic, retain) RKPaginator *paginator; // model
@property (nonatomic, strong) id<BBStreamProtocol> controller; // parent controller (HomeController in this case)
@property (nonatomic, strong) NSMutableDictionary *streamItemSizesCache; // dictionary of subview sizes
@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic) int fetchBatch;

@end


@implementation BBStreamController {
    UIActivityIndicatorView *progress;
    NSString *groupId;
    MGBox *progressBox;
    MGBox* queriedBox;
    BOOL isJoinable;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize paginator = _paginator,
            scroller = _scroller,
            controller = _controller,
            streamItemSizesCache = _streamItemSizesCache,
            tableView = _tableView,
            tableItems = _tableItems,
            fetchBatch = _fetchBatch,
            loading = _loading,
            noMoreResultsAvail = _noMoreResultsAvail;


#pragma mark -
#pragma mark - Constructors


-(id)init {
    
    self = [super init];
    
    if(self) {
        self.tableItems = [[NSMutableArray alloc]init];
        self.loading = NO;
        self.noMoreResultsAvail = NO;
        self.fetchBatch = 0;
    }
    
    return self;
}

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithUserAndDelegate:"];
    
    self = [self init];
    
    if(self) {
        _controller = delegate;
        
        [self setPaginatorForStream:@""];
        
        [self loadRequest];
    }
    
    [self loadView];
    
    return self;
}

-(BBStreamController*)initWithGroup:(NSString*)groupIdentifier
                        andDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithGroup:andDelegate:"];
    
    self = [self init];
    
    if(self) {
        _controller = delegate;
        groupId = groupIdentifier;
        
        [self setPaginatorForStream:groupIdentifier];
        
        [self loadRequest];
    }
    
    [self loadView];
    
    return self;
}

-(BBStreamController*)initWithGroupForBrowsing:(NSString*)groupIdentifier
                                   andDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithGroupForBrowsing:andDelegate:"];
    
    self = [self init];
    
    if(self) {
        _controller = delegate;
        groupId = groupIdentifier;
        isJoinable = YES;
        
        [self setPaginatorForStream:groupIdentifier];
        
        [self loadRequest];
    }
    
    [self loadView];
        
    return self;
}

-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithProjectsAndDelegate:"];
    
    self = [self init];
    
    if(self){
        _controller = delegate;

        [self setPaginatorForStream:@"projects"];
        
        [self loadRequest];
    }
    
    [self loadView];
    
    return self;
}

-(BBStreamController*)initWithFavouritesAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithProjectsAndDelegate:"];
    
    self = [self init];
    
    if(self){
        _controller = delegate;
        
        [self setPaginatorForStream:@"favourites"];
        
        [self loadRequest];
    }
    
    [self loadView];
    
    return self;
}

-(void)setPaginatorForStream:(NSString*)streamName {
    
    [BBLog Log:@"BBStreamController.setPaginatorForStream:"];
    [BBLog Debug:@"streamName:" withMessage:streamName];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *streamUrl = [NSString stringWithFormat:@"http://api.bowerbird.org.au/%@?PageSize=:perPage&Page=:currentPage&X-Requested-With=XMLHttpRequest", streamName];
    
    if (!self.paginator) {
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        RKObjectMapping *paginationMapping = nil;
        
        // TODO: Create response descriptors for these puppies:
        
        if([streamName isEqualToString:@"favourites"]){ // sightings
            paginationMapping = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
            
            self.paginator = [[BBSightingPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                       paginationMapping:paginationMapping
                                                     responseDescriptors:nil
                                                             andDelegate:weakSelf];
        }
        else if([streamName isEqualToString:@"projects"]){
            paginationMapping = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
            
            self.paginator = [[BBProjectPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                      paginationMapping:paginationMapping
                                                    responseDescriptors:nil
                                                            andDelegate:weakSelf];
        }
        else {
            paginationMapping = [RKObjectMapping mappingForClass:[BBPaginator class]];
            
            /*
            RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBActivity class]]
                                                                                       pathPattern:nil
                                                                                           keyPath:@"PagedListItems"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
            */
            
            RKResponseDescriptor *activitiesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBActivityPaginator class]]
                                                                                                         pathPattern:nil
                                                                                                             keyPath:nil
                                                                                                         statusCodes:[NSIndexSet indexSetWithIndex:200]];
            
            self.paginator = [[BBActivityPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                       paginationMapping:paginationMapping
                                                     responseDescriptors:[[NSArray alloc] initWithObjects:activitiesResponseDescriptor, nil]
                                                             andDelegate:weakSelf];
        }
        
        self.paginator.perPage = 20;
        
        [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            [weakSelf.tableItems addObjectsFromArray:objects];
            //[weakSelf.tableItems addObjectsFromArray:((BBActivityPaginator*)paginator).activities];
            
            [weakSelf.tableView reloadData];
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
    }
}

/*
-(void)setPaginatorForStream:(NSString*)streamName {
    
    [BBLog Log:@"BBStreamController.setPaginatorForStream:"];
    [BBLog Debug:@"streamName:" withMessage:streamName];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *streamUrl = [NSString stringWithFormat:@"http://api.bowerbird.org.au/%@?PageSize=:perPage&Page=:currentPage&X-Requested-With=XMLHttpRequest", streamName];
    
    if (!self.paginator) {
        

        RKObjectMapping *paginationMapping = nil;
        RKResponseDescriptor *responseDescriptor = nil;
        
        // TODO: Create response descriptors for these puppies:
        
        if([streamName isEqualToString:@"favourites"]){ // sightings

            responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBSighting class]]
                                                                         pathPattern:nil
                                                                             keyPath:@"Model.Sightings.PageListItems"
                                                                         statusCodes:[NSIndexSet indexSetWithIndex:200]];
            
            paginationMapping = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];

            self.paginator = [[BBSightingPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                       paginationMapping:paginationMapping
                                                     responseDescriptors:[[NSArray alloc]initWithObjects:responseDescriptor, nil]
                                                             andDelegate:weakSelf];
        }
        else if([streamName isEqualToString:@"projects"]){
            
            responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBProject class]]
                                                                         pathPattern:nil
                                                                             keyPath:@"Model.Projects.PageListItems"
                                                                         statusCodes:[NSIndexSet indexSetWithIndex:200]];
            
            paginationMapping = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
            
            self.paginator = [[BBProjectPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                       paginationMapping:paginationMapping
                                                     responseDescriptors:[[NSArray alloc]initWithObjects:responseDescriptor, nil]
                                                             andDelegate:weakSelf];
        }
        else {
            paginationMapping = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
          
            RKResponseDescriptor *activitiesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBActivityPaginator class]]
                                                                         pathPattern:nil
                                                                             keyPath:nil
                                                                         statusCodes:[NSIndexSet indexSetWithIndex:200]];
            
            self.paginator = [[BBActivityPaginator alloc]initWithRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:streamUrl]]
                                                       paginationMapping:paginationMapping
                                                     responseDescriptors:[[NSArray alloc]initWithObjects:activitiesResponseDescriptor, nil]
                                                             andDelegate:weakSelf];
            
        }
        
        self.paginator.perPage = 20;
        
        [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            [weakSelf.tableItems addObjectsFromArray:objects];
            [weakSelf.tableView reloadData];
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
    }
}
*/

//        RKResponseDescriptor *response = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBSightingPaginator class]]
//                                                                                 pathPattern:streamUrl
//                                                                                     keyPath:nil
//                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//        
//        __weak typeof(self) weakSelf = self;
//
//        NSURL *paginatorURL = [NSURL URLWithString:streamUrl relativeToURL:[BBConstants RootUri]];
//        
//        if([streamName isEqualToString:@"favourites"]){ // sightings
//            
//            
//            self.paginator = [[BBSightingPaginator alloc]initWithPatternURL:[[NSURLRequest alloc]initWithURL:paginatorURL]
//                                                            mappingProvider:[RKObjectMapping mappingForClass:[BBSightingPaginator class]]
//                                                                andDelegate:self];
//            
//        }
//        else if([streamName isEqualToString:@"projects"]){ 
//            self.paginator = [[BBProjectPaginator alloc]initWithPatternURL:[[NSURLRequest alloc]initWithURL:paginatorURL]
//                                                            mappingProvider:[RKObjectMapping mappingForClass:[BBProjectPaginator class]]
//                                                                andDelegate:self];
//            
//        }
//        else {
//            
//            self.paginator = [[BBActivityPaginator alloc]initWithRequest:[[NSURLRequest alloc]initWithURL:paginatorURL]
//                                                       paginationMapping:[RKObjectMapping mappingForClass:[BBActivityPaginator class]]
//                                                     responseDescriptors:[NSArray arrayWithObject:[RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[BBActivityPaginator class]]
//                                                                                                                                          pathPattern:@"/authenticate"
//                                                                                                                                              keyPath:nil
//                                                                                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]]
//                                                             andDelegate:self];
//            
//            self.paginator.perPage = 20; 
//            
//            [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
//                
//                if (page == 1) {
//                    [weakSelf.tableItems removeAllObjects];
//                }
//                [weakSelf.tableItems addObjectsFromArray:objects];
//                [weakSelf.tableView reloadData];
//                
//            } failure:^(RKPaginator *paginator, NSError *error) {
//                NSLog(@"Failure: %@", error);
//            }];
//        }
    //}
    
    //[_paginator loadPage:1];
    
//}

-(void)loadRequest {
    [BBLog Log:@"BBStreamController.loadRequest"];
    
    self.fetchBatch++;
    
    [self.paginator loadPage:self.fetchBatch];
    
    //[self.paginator setPaginatorLoading:YES];
    self.loading = YES;
}


#pragma mark -
#pragma mark - Renderers


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    [BBLog Log:[NSString stringWithFormat:@"BBStreamController.observeValueForKeyPath: %@ object: %@", keyPath, object]];
}

-(void)displayItems {
    //[self.tableView reloadData];
    //[self.tableView beginUpdates];
    [self.view setNeedsDisplay];
}

-(void)loadView {
    [BBLog Log:@"BBStreamController.loadView"];
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, size.height)
                                             style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view = self.tableView;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.controller displayStreamView:(UITableView*)self.view];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBStreamController.viewDidLoad:"];
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    __weak BBStreamController *stream = self;
    
    if(![_paginator isKindOfClass:[BBProjectPaginator class]]){
        
        self.tableView.pullToRefreshView.backgroundColor = [UIColor blackColor];
        
        __block NSString *groupIdentifier = [groupId copy];
        
        [((BBStreamView*)self.view) addPullToRefreshWithActionHandler:^{
            
            __weak NSString* url;
          
            /*
            // hit the server for the newest group results:
            if(groupIdentifier && ![groupIdentifier isEqualToString:@""]) {
                url = [NSString stringWithFormat:@"%@/%@?%@&NewerThan=%@",[BBConstants RootUriString], groupIdentifier, [BBConstants AjaxQuerystring], [stream.paginator.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath :url
                                                                  delegate:stream.paginator];
            }
            // hit the server for the newest user results:
            else {
                url = [NSString stringWithFormat:@"%@?%@&NewerThan=%@",[BBConstants RootUriString], [BBConstants AjaxQuerystring], [stream.paginator.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url
                                                                  delegate:stream.paginator];
            }
            */
            //stream.requestWasPullLatest = YES;
            //stream.latestFetchedActivityNewer = [NSDate getCurrentUTCDate]; // set latest fetch to now for future fetches
            //stream.latestFetchedActivityNewerLocalTime = [NSDate date];
        }];
    }

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
        
        stream.tableView.infiniteScrollingView.backgroundColor = [UIColor blackColor];
        stream.tableView.infiniteScrollingView.arrowColor = [UIColor whiteColor];
        stream.tableView.infiniteScrollingView.textColor = [UIColor whiteColor];
        
        //[stream.paginator handlePaginatorLoadNextPage];
        [stream loadRequest];
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsPullToRefresh = YES;
 }

-(void)viewWillAppear:(BOOL)animated {
    //((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

-(void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBContainerController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(MGBox*)displayStreamItem:(id)item {
    [BBLog Log:@"BBStreamController.displayStreamItem:"];

    MGBox *box;
    
    if([item isKindOfClass:[BBActivity class]])
    {
        BBActivity *activity = (BBActivity*)item;
        
        BBActivityController *activityController = [[BBActivityController alloc]initWithActivity:activity];
        
        box = (MGBox*)activityController.view;
    }
    else if([item isKindOfClass:[BBProject class]])
    {
        BBProject *project = (BBProject*)item;
        
        BBProjectItemController *projectItemController = [[BBProjectItemController alloc]initWithProject:project];
        
        box = (MGBox*)projectItemController.view;
    }
    else if([item isKindOfClass:[BBObservation class]])
    {
        BBObservation *observation = (BBObservation*)item;
        
        BBSightingItemController *sightingItemController = [[BBSightingItemController alloc]initWithObservation:observation];
        
        box = (MGBox*)sightingItemController.view;
    }
    else
    {
        // empty box - unknown activity type
        box = [MGBox box];
    }
    
    [box layout];
    
    return box;
}

- (void)scrollViewWillEndDragging:(UITableView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger index = lrintf(targetContentOffset->x/_tableView.height);
    targetContentOffset->x = index * _tableView.height;
}


#pragma mark -
#pragma mark - UI Helpers


-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBStreamController"];
    
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark UITableViewDataSource


-(void)addItemsToTableDataSource:(NSArray*)items {
    [BBLog Log:@"BBStreamController.addItemsToDataSource"];
    
    // start by getting the last index and therefore, the index point for inserting
    int index = self.tableItems.count > 0 ? self.tableItems.count -1 : 0;
    
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
    
    for (id object in items) {
        [self.tableItems insertObject:object atIndex:index];
        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        index ++;
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [BBLog Log:@"BBStreamController.numberOfSectionsInTableView:"];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    [BBLog Log:@"BBStreamController.numberOfRowsInSection:"];
    
    [BBLog Debug:[NSString stringWithFormat:@"Stream Model Item Count: %i", self.tableItems.count]];
    
    return self.tableItems.count + 1; // additional cell for loading more... no more records at the bottom
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [BBLog Log:@"tableView:cellForRowAtIndexPath:"];
    [BBLog Log:[NSString stringWithFormat:@"tableView Cell: %i", indexPath.row]];
    
    NSString *identifier = @"Cell";
    
    // Only starts populating the table if data source is not empty.
    if (self.tableItems.count != 0 && indexPath.row < self.tableItems.count) {
        id item = [self.tableItems objectAtIndex:indexPath.row];

        MGBox *box = [self displayStreamItem:item];
        box.margin = UIEdgeInsetsMake(0, 5, 5, 0);
        
        MGBox *wrapper = [MGBox boxWithSize:CGSizeMake(320, box.height + 10)];
        wrapper.backgroundColor = [UIColor blackColor];
        [wrapper.boxes addObject:box];
        [wrapper layout];
        
        BBTableViewCell *cell;// = (BBTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil || (cell.height != wrapper.height)) {
            cell = [[BBTableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row >= (self.tableItems.count - (self.paginator.perPage/2)) &&
           !self.loading &&
           !self.noMoreResultsAvail)
        {
            self.loading = YES;
            [self loadRequest];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.contentView addSubview:wrapper];
            [cell setNeedsDisplay];
        });
        
        return cell;
    }
    else {

        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:identifier];
        // The currently requested cell is the last cell.
        if (!self.noMoreResultsAvail) {
            
            cell.textLabel.text = @"Loading...";
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.textColor = [UIColor colorWithRed:0.65f
                                                       green:0.65f
                                                        blue:0.65f
                                                       alpha:1.00f];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            return cell;
        } else {
            // If there are no results available, display @"Loading More..." in the last cell
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.text = @"That's all!";
            cell.textLabel.textColor = [UIColor colorWithRed:0.65f
                                                       green:0.65f
                                                        blue:0.65f
                                                       alpha:1.00f];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            return cell;
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [BBLog Log:@"tableView:heightForRowAtIndexPath:"];
    [BBLog Log:[NSString stringWithFormat:@"tableView Cell: %i", indexPath.row]];
    
    // if this is the last row, pass back a fixed height:
    if([indexPath row] == self.tableItems.count) {
        return 20;
    }
        
    if(![self.streamItemSizesCache objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]) {
    
        MGBox *box = [self displayStreamItem:[self.tableItems objectAtIndex:[indexPath row]]];
        
        queriedBox = box;
        
        // add enough size for margins (5 top and bottom) and round off the size to avoid antialaising
        float boxHeight = (int)(box.height + 10);
        
        [self.streamItemSizesCache setObject:[[NSNumber alloc]initWithFloat:boxHeight] forKey:[NSString stringWithFormat:@"%i", indexPath.row]];
        
        return boxHeight;
    }
    
    return [((NSNumber*)[self.streamItemSizesCache objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]) floatValue];
}

-(NSMutableDictionary*)streamItemSizesCache {
    if(!_streamItemSizesCache) _streamItemSizesCache = [[NSMutableDictionary alloc]init];
    
    return _streamItemSizesCache;
}


#pragma mark -
#pragma mark - Delegates and Event Handling


-(void)pagingLoadingComplete {
    [self.tableView.infiniteScrollingView stopAnimating];
    
    [SVProgressHUD dismiss];
}

-(void)pageLoadingStarted {
    [_tableView.infiniteScrollingView startAnimating];
}

-(void)pullToRefreshCompleted {
    [_tableView.pullToRefreshView stopAnimating];
}


@end