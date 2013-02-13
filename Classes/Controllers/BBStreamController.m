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


@interface BBStreamController()

@property (nonatomic, strong) BBStreamView *scroller; // view
@property (nonatomic, strong) UITableView *tableView; // table
@property (nonatomic, retain) BBPaginator *paginator; // model
@property (nonatomic, strong) id<BBStreamProtocol> controller; // parent controller (HomeController in this case)
@property (nonatomic, strong) NSMutableDictionary *streamItemSizesCache; // dictionary of subview sizes

@end


@implementation BBStreamController {
    UIActivityIndicatorView *progress;
    NSString *groupId;
    MGBox *progressBox;
    MGBox* queriedBox;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize paginator = _paginator,
            scroller = _scroller,
            controller = _controller,
            streamItemSizesCache = _streamItemSizesCache,
            tableView = _tableView;


#pragma mark -
#pragma mark - Constructors


-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithUserAndDelegate:"];
    
    self = [super init];
    
    if(self) {
        _controller = delegate;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading Activity"];
        });
        
        // Given an RKURL initialized as:
        RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                      resourcePath:[NSString stringWithFormat:@"%@&%@", @"/?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
        
        // And a dictionary containing values:
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
        
        // A new RKURL can be constructed by interpolating the dictionary with the original URL
        RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
                
        [self.paginator addObserver:self forKeyPath:@"items" options:NSKeyValueChangeInsertion context:NULL];
        
        
        self.paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                    mappingProvider:[RKObjectManager sharedManager].mappingProvider
                                                        andDelegate:self];
        
        self.paginator.delegate = self.paginator;
        [self.paginator loadPage:1];
        [self.paginator setPaginatorLoading:YES];
    }
    
    return self;
}

-(BBStreamController*)initWithGroup:(NSString*)groupIdentifier
                        andDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithGroup:andDelegate:"];
    
    self = [super init];
    
    if(self) {
        _controller = delegate;
        groupId = groupIdentifier;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading Activity"];
        });
        
        // Given an RKURL initialized as:
        RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                      resourcePath:[NSString stringWithFormat:@"/%@%@&%@", groupId, @"?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
        
        // And a dictionary containing values:
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
        
        // A new RKURL can be constructed by interpolating the dictionary with the original URL
        RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
        
        self.paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                    mappingProvider:[RKObjectManager sharedManager].mappingProvider
                                                        andDelegate:self];
        
        self.paginator.delegate = self.paginator;
        [self.paginator loadPage:1];
        [self.paginator setPaginatorLoading:YES];
    }
    
    return self;
}

-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithProjectsAndDelegate:"];
    
    self = [super init];
    
    if(self){
        _controller = delegate;

        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading Projects"];
        });
        
        // Given an RKURL initialized as:
        RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                      resourcePath:[NSString stringWithFormat:@"%@&%@", @"/projects?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
        
        // And a dictionary containing values:
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
        
        // A new RKURL can be constructed by interpolating the dictionary with the original URL
        RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
        
        self.paginator = [[BBProjectPaginator alloc]initWithPatternURL:interpolatedURL
                                                   mappingProvider:[RKObjectManager sharedManager].mappingProvider
                                                       andDelegate:self];
        
        self.paginator.delegate = self.paginator;
        [self.paginator loadPage:1];
        [self.paginator setPaginatorLoading:YES];
    }
    
    return self;
}

-(BBStreamController*)initWithFavouritesAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithProjectsAndDelegate:"];
    
    self = [super init];
    
    if(self){
        _controller = delegate;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading Favourites"];
        });
        
        // Given an RKURL initialized as:
        RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                      resourcePath:[NSString stringWithFormat:@"%@&%@", @"/favourites?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
        
        // And a dictionary containing values:
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
        
        // A new RKURL can be constructed by interpolating the dictionary with the original URL
        RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
        
        self.paginator = [[BBSightingPaginator alloc]initWithPatternURL:interpolatedURL
                                                        mappingProvider:[RKObjectManager sharedManager].mappingProvider
                                                            andDelegate:self];
        
        self.paginator.delegate = self.paginator;
        [self.paginator loadPage:1];
        [self.paginator setPaginatorLoading:YES];
    }
    
    return self;
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
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

-(void)loadView {
    [BBLog Log:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    [BBLog Log:@"BBStreamController.loadView"];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, size.height)
                                             style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pagingEnabled = YES;
    
    _tableView.decelerationRate = 1;
    
    self.view = _tableView;
    self.view.backgroundColor = [UIColor blackColor];
    
    [_controller displayStreamView:(UITableView*)self.view];
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
        
        _tableView.pullToRefreshView.backgroundColor = [UIColor blackColor];
        
        __block NSString *groupIdentifier = [groupId copy];
        
        [((BBStreamView*)self.view) addPullToRefreshWithActionHandler:^{
            
            __weak NSString* url;
            
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
            
            //stream.requestWasPullLatest = YES;
            //stream.latestFetchedActivityNewer = [NSDate getCurrentUTCDate]; // set latest fetch to now for future fetches
            //stream.latestFetchedActivityNewerLocalTime = [NSDate date];
        }];
    }

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        stream.tableView.infiniteScrollingView.backgroundColor = [UIColor blackColor];
        stream.tableView.infiniteScrollingView.arrowColor = [UIColor whiteColor];
        stream.tableView.infiniteScrollingView.textColor = [UIColor whiteColor];
        
        [stream.paginator handlePaginatorLoadNextPage];
    }];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsPullToRefresh = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
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
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [BBLog Log:@"BBStreamController.numberOfSectionsInTableView:"];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    [BBLog Log:@"BBStreamController.numberOfRowsInSection:"];
    return _paginator.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [BBLog Log:@"tableView:cellForRowAtIndexPath:"];
    [BBLog Log:[NSString stringWithFormat:@"tableView Cell: %i", indexPath.row]];
    
    // Configure the cell...
    static NSString *sightingIdentifier = @"Sighting";
    static NSString *noteIdentifier = @"Note";
    static NSString *projectIdentifier = @"Project";
    static NSString *postIdentifier = @"Post";
    static NSString *identificationIdentifier = @"Identification";
    
    NSString *identifier = @"Cell";
    
    id item = [_paginator.items objectAtIndex:indexPath.row];
    
    identifier = sightingIdentifier;
    if([item isKindOfClass:BBActivity.class]){
        BBActivity *activity = (BBActivity*)item;
        if([activity.type isEqualToString:@"sightingadded"])
        {
            identifier = sightingIdentifier;
        }
        
        else if([activity.type isEqualToString:@"sightingnoteadded"])
        {
            identifier = noteIdentifier;
        }
        
        else if([activity.type isEqualToString:@"identificationadded"])
        {
            identifier = identificationIdentifier;
        }
        
        else if([activity.type isEqualToString:@"postadded"])
        {
            identifier = postIdentifier;
        }
    }
    else if([item isKindOfClass:BBProject.class]) {
        identifier = projectIdentifier;
    }
    
    MGBox *box = [self displayStreamItem:item];
    box.margin = UIEdgeInsetsMake(0, 5, 5, 0);
    
    MGBox *wrapper = [MGBox boxWithSize:CGSizeMake(320, box.height + 10)];
    wrapper.backgroundColor = [UIColor blackColor];
    [wrapper.boxes addObject:box];
    [wrapper layout];
    
    BBTableViewCell *cell = (BBTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil || (cell.height != wrapper.height)) {
        cell = [[BBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [cell.contentView addSubview:wrapper];
        
        [cell setNeedsDisplay];
    });
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [BBLog Log:@"tableView:heightForRowAtIndexPath:"];
    [BBLog Log:[NSString stringWithFormat:@"tableView Cell: %i", indexPath.row]];
    
    if(![self.streamItemSizesCache objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]) {
        
        MGBox *box = [self displayStreamItem:[[_paginator items] objectAtIndex:[indexPath row]]];
        
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
    [_tableView.infiniteScrollingView stopAnimating];
    
    [SVProgressHUD dismiss];
}

-(void)pageLoadingStarted {
    [_tableView.infiniteScrollingView startAnimating];
}

-(void)pullToRefreshCompleted {
    [_tableView.pullToRefreshView stopAnimating];
}


@end