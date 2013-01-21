
//
//  BBStreamController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//
// for help refer to http://restkit.org/api/master/Classes/RKURL.html

//
//  BBStreamController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//
// for help refer to http://restkit.org/api/master/Classes/RKURL.html


#pragma mark -
#pragma mark - Using UIScrollView

/*

#import "BBStreamController.h"
#import "SVPullToRefresh.h"

@class BBStreamProtocol;

@interface BBStreamController()

@property (nonatomic, strong) BBStreamView *scroller; // view
@property (nonatomic, retain) BBPaginator *paginator; // model
@property (nonatomic, strong) id<BBStreamProtocol> controller; // parent controller (HomeController in this case)
@property BOOL requestWasPullLatest;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewer;
@property (nonatomic, strong) NSDate *latestFetchedActivityOlder;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewerLocalTime;

@end

@implementation BBStreamController{
    UIActivityIndicatorView *progress;
    BOOL paginatorIsLoading;
    NSString *groupId;
    MGBox *progressBox;
}

@synthesize paginator = _paginator;
@synthesize scroller = _scroller;
@synthesize controller = _controller;
@synthesize requestWasPullLatest = _requestWasPullLatest;
@synthesize latestFetchedActivityNewer = _latestFetchedActivityNewer;
// add last fetched activity newer attempt?
@synthesize latestFetchedActivityOlder = _latestFetchedActivityOlder;


#pragma mark -
#pragma mark - Initializers

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    self.latestFetchedActivityOlder = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewer = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewerLocalTime = [NSDate date];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    
    return self;
}

-(BBStreamController*)initWithGroup:(NSString*)groupIdentifier
                        andDelegate:(id<BBStreamProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    groupId = groupIdentifier;
    self.latestFetchedActivityOlder = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewer = [NSDate getCurrentUTCDate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"/%@%@&%@", groupId, @"?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    
    return self;
}

-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/projects?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBProjectPaginator alloc]initWithPatternURL:interpolatedURL
                                               mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    
    return self;
}

#pragma mark -
#pragma mark - Setup and Render UI and Events

-(void)loadView {
    [BBLog Log:@"BBStreamController.loadView"];
    
    self.view = [[BBStreamView alloc]initWithDelegate:_controller
                                              andSize:[self screenSize]];
    
    ((BBStreamView*)self.view).delegate = self;
    
    progress = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    progress.hidesWhenStopped = YES;
    
    [_controller displayStreamView:(BBStreamView*)self.view];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBStreamController.viewDidLoad"];
    
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    //__block BBStreamController *this = self;
    __weak BBStreamController *stream = self;
    
    // we only use this for activity streams - not for project streams:
    if(![_paginator isKindOfClass:[BBProjectPaginator class]]){
        __block NSString *groupIdentifier = [groupId copy];
        
        [((BBStreamView*)self.view) addPullToRefreshWithActionHandler:^{
            
            NSString* url;
            
            // hit the server for the newest group results:
            if(groupIdentifier && ![groupIdentifier isEqualToString:@""]) {
                url = [NSString stringWithFormat:@"%@/%@?%@&NewerThan=%@",[BBConstants RootUriString], groupIdentifier, [BBConstants AjaxQuerystring], [self.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url
                                                                  delegate:stream];
            }
            // hit the server for the newest user results:
            else {
                url = [NSString stringWithFormat:@"%@?%@&NewerThan=%@",[BBConstants RootUriString], [BBConstants AjaxQuerystring], [self.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url
                                                                  delegate:stream];
            }
            
            stream.requestWasPullLatest = YES;
            stream.latestFetchedActivityNewer = [NSDate getCurrentUTCDate]; // set latest fetch to now for future fetches
            stream.latestFetchedActivityNewerLocalTime = [NSDate date];
        }];
    }
    
    [((BBStreamView*)self.view) layout];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [BBLog Log:@"BBStreamController.scrollViewDidScroll"];
    
    [BBLog Log:[NSString stringWithFormat:@"contentOffset.y:%f contentSize.height:%f", scrollView.contentOffset.y, scrollView.contentSize.height]];
    
    if([self scrollerIsAboutToBottomOut] && [_paginator moreItemsExist] && !paginatorIsLoading)
    {
        // trigger the SVPullToRefresh view loader..
        
        // do UI stuff back in UI land
        dispatch_async(dispatch_get_main_queue(), ^{
            
            progressBox = [MGBox boxWithSize:CGSizeMake(100, 40)];
            progressBox.backgroundColor = [UIColor whiteColor];
            
            [progressBox addSubview:progress];
            [progress startAnimating];
            progressBox.backgroundColor = [UIColor blackColor];
            progressBox.leftMargin = 160 - progress.width/2;
            
            
            [((BBStreamView*)self.view) renderStreamItem:progressBox atTop:NO];
            [((BBStreamView*)self.view) scrollToView:progressBox withMargin:0];
        });
        
        [_paginator loadNextPage];
        paginatorIsLoading = YES;
    }
}

-(void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBContainerController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}

#pragma mark -
#pragma mark - Rendering Helpers

-(void)displayStreamItem:(id)item
                   atTop:(bool)displayAtTop
          scrollIntoView:(BOOL)scroll {
    
    MGBox *box;
    
    if([item isKindOfClass:[BBActivity class]])
    {
        BBActivity *activity = (BBActivity*)item;
        if([activity.type isEqualToString:@"sightingadded"])
        {
            //[_streamItemIds addObject:activity.identifier];
            box = [self renderSightingActivity:activity];
            
            [((BBStreamView*)self.view) renderStreamItem:box
                                                   atTop:displayAtTop];
        }
        
        else if([activity.type isEqualToString:@"sightingnoteadded"])
        {
            //[_streamItemIds addObject:activity.identifier];
            box = [self renderSightingNoteActivity:activity];
            
            [((BBStreamView*)self.view) renderStreamItem:box
                                                   atTop:displayAtTop];
        }
    }
    else if([item isKindOfClass:[BBProject class]])
    {
        BBProject *project = (BBProject*)item;
        box = [self renderProject:project];
        
        [((BBStreamView*)self.view) renderStreamItem:box
                                               atTop:displayAtTop];
    }
    
    // if we've paged some items, on adding the first item to the view, scroll the view to display it
    if(!displayAtTop && scroll)
    {
        [((BBStreamView*)self.view) scrollToView:box withMargin:0];
    }
}

-(MGBox*)renderSightingNoteActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingNoteActivity"];
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                          right:nil
                                                          width:240
                                                      minHeight:50];
    activityDescription.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    activityDescription.padding = UIEdgeInsetsZero;
    activityDescription.underlineType = MGUnderlineNone;
    
    MGBox *detailArrow = [self getForwardArrow];
    detailArrow.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    
    MGBox *userProfileWithArrow = [MGBox boxWithSize:CGSizeMake(310, 50)];
    userProfileWithArrow.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    userProfileWithArrow.contentLayoutMode = MGLayoutGridStyle;
    
    [userProfileWithArrow.boxes addObject:avatar];
    [userProfileWithArrow.boxes addObject:activityDescription];
    //[userProfileWithArrow.boxes addObject:detailArrow];

    [info.topLines addObject:userProfileWithArrow];
    
    BBObservationNote *observationNote = activity.observationNote;
    
    // show the identification
    if(observationNote.identification) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        [info.middleLines addObject:[BBUIControlHelper createIdentification:observationNote.identification forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
    }
    // show the taxonomy
    if(![observationNote.taxonomy isEqualToString:@""]) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        MGLine *taxa = [MGLine multilineWithText:observationNote.taxonomy font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxa.underlineType = MGUnderlineNone;
        [info.middleLines addObject:taxa];
    }
    // show descriptions
    if(observationNote.descriptionCount > 0) {
        
        for (BBSightingNoteDescription* description in observationNote.descriptions) {
            
            [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:description.label
                                                                             forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            
            MGLine *descriptionLine = [MGLine multilineWithText:description.text
                                                           font:DESCRIPTOR_FONT
                                                          width:IPHONE_STREAM_WIDTH
                                                        padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            descriptionLine.underlineType = MGUnderlineNone;
            
            [info.middleLines addObject:descriptionLine];
        }
    }
    // show tags
    if(observationNote.tagCount > 0) {
        
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Tags"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        // grab tags from controller
        NSArray *tags = [observationNote.allTags componentsSeparatedByString:@","];
        MGBox *tagBox;
        
        DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
        [tagList setTags:tags];
        
        double minHeight = tagList.fittedSize.height;
        
        tagBox = [MGBox boxWithSize:CGSizeMake(280, minHeight)];
        tagBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
        [tagBox addSubview:tagList];
        
        [info.middleLines addObject:tagBox];
    }
    
    // show the observation the note belongs to in summary form:
    MGTableBox *subObservation = [BBUIControlHelper createSubObservation:activity.observationNoteObservation
                                                                 forSize:CGSizeMake(300, 200)
                                                               withBlock:^{
                                                                   [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observationNoteObservation.identifier]
                                                                                                                                                          animated:YES];}];
    [info.bottomLines addObject:subObservation];
    
    return info;
    
    //[streamView.boxes addObject:info];
}

-(MGBox*)renderSightingActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingActivity"];
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                          right:nil
                                                          width:200
                                                      minHeight:50];
    activityDescription.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    activityDescription.padding = UIEdgeInsetsZero;
    activityDescription.underlineType = MGUnderlineNone;
    
    MGBox *detailArrow = [self getForwardArrow];
    detailArrow.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    
    MGBox *userProfileWithArrow = [MGBox boxWithSize:CGSizeMake(310, 50)];
    userProfileWithArrow.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    userProfileWithArrow.contentLayoutMode = MGLayoutGridStyle;
    
    [userProfileWithArrow.boxes addObject:avatar];
    [userProfileWithArrow.boxes addObject:activityDescription];
    [userProfileWithArrow.boxes addObject:detailArrow];
    
    userProfileWithArrow.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observation.identifier] animated:YES];
    };
    
    [info.topLines addObject:userProfileWithArrow];
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:activity.observation.media
                                                                 withPrimary:activity.observation.primaryMedia
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH,250)
                                                            displayingThumbs:NO]];
    
    MGLine *title = [MGLine lineWithLeft:activity.observation.title right:nil size:CGSizeMake(IPHONE_STREAM_WIDTH, 30)];
    title.padding = UIEdgeInsetsMake(0, 10, 5, 10);
    title.font = HEADER_FONT;
    title.underlineType = MGUnderlineNone;
    [info.middleLines addObject:title];
    
    return info;
}

-(MGBox*)renderProject:(BBProject*)project {
    [BBLog Log:@"BBStreamController.renderProject"];
    
    //MGScrollView *streamView = (MGScrollView*)self.view;
    BBImage *avatarImage = [self getImageWithDimension:@"Square100" fromArrayOf:project.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_PROJECT_AVATAR_SIZE];
    
    MGLine *projectName = [MGLine lineWithLeft:project.name right:nil size:CGSizeMake(280, 40)];
    projectName.font = HEADER_FONT;
    
    NSString *multiLineDisplay = [NSString stringWithFormat:@"%d members \n%d observations \n%d posts", project.memberCount, project.observationCount, project.postCount];
    MGLine *projectStats = [MGLine lineWithLeft:avatar multilineRight:multiLineDisplay width:280 minHeight:100];
    projectStats.underlineType = MGUnderlineNone;
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_PROJECT_DESCRIPTION];
    info.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [info.topLines addObject:projectName];
    [info.middleLines addObject:projectStats];
    
    MGLine *description = [MGLine lineWithMultilineLeft:project.description right:nil width:270 minHeight:30];
    description.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    description.underlineType = MGUnderlineNone;
    [info.middleLines addObject:description];
    
    BBApplication* appData = [BBApplication sharedInstance];
    BBProject* projectInUserList = [self getProjectWithIdentifier:project.identifier fromArrayOf:appData.authenticatedUser.projects];
    
    // pass the id to either the join or leave project method
    BBModelId *projJoinLeave = [[BBModelId alloc]init];
    projJoinLeave.identifier = project.identifier;
    
    if(projectInUserList) {
        [info.bottomLines addObject:[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 280, 40) andTitle:@"Leave Project" withBlock:^{
            NSString* resourcePath = [NSString stringWithFormat:@"%@/%@/leave",[BBConstants RootUriString], project.identifier];
            [[RKObjectManager sharedManager] sendObject:projJoinLeave toResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
                loader.delegate = self;
                loader.method = RKRequestMethodPOST;
            }];
        }]];
    }
    else
    {
        [info.bottomLines addObject:[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 280, 40) andTitle:@"Join Project" withBlock:^{
            NSString* resourcePath = [NSString stringWithFormat:@"%@/%@/join",[BBConstants RootUriString], project.identifier];
            [[RKObjectManager sharedManager] sendObject:projJoinLeave toResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
                loader.delegate = self;
                loader.method = RKRequestMethodPOST;
            }];
        }]];
    }
    
    return info;
}

#pragma mark -
#pragma mark - Delegation and Event Handling for Paginator

// Once the pagination has been received, send all the returned items for processing into the stream view
-(void)paginator:(RKObjectPaginator *)paginator
  didLoadObjects:(NSArray *)objects
         forPage:(NSUInteger)page {
    [BBLog Log:@"BBStreamController.paginator:didLoadObjects:forPage"];
    
    [SVProgressHUD dismiss];
    
    [progress stopAnimating];
    
    if(progressBox)
    {
        [progressBox removeFromSuperview];
        progressBox.height = 0;
        [((BBStreamView*)self.view) layout];
    }
    
    paginatorIsLoading = NO;
    
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

// prior to grabbing the paginated objects, append the current 'OlderThan' timestamp to maintain paging integrity
-(void)paginator:(RKObjectPaginator *)paginator
    willLoadPage:(NSUInteger)page
    objectLoader:(RKObjectLoader *)loader {
    
    RKURL *url = paginator.patternURL;
    
    // hack to overwrite the paging parameter with the propper page number: http://stackoverflow.com/questions/11751880/how-to-fetch-pages-of-results-with-restkit
    loader.resourcePath = [NSString stringWithFormat:@"%@&OlderThan=%@", [url.resourcePath stringByReplacingOccurrencesOfString:@"Page=1" withString:[NSString stringWithFormat:@"Page=%i", page]], [self.latestFetchedActivityOlder dateAsJsonUtcString]];
}

-(void)paginator:(RKObjectPaginator *)paginator
didFailWithError:(NSError *)error
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    paginatorIsLoading = NO;
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(progressBox)
        {
            [progressBox removeFromSuperview];
            [((BBStreamView*)self.view) layout];
        }
    });
}

-(void)processPaginator:(NSArray*)paginatorItems {
    [BBLog Log:@"BBStreamController.processPaginator:"];
    
    int itemCount = 0;
    // if we haven't already displayed this item, push it to the view
    for(id item in paginatorItems) {
        if(([item isKindOfClass:[BBActivity class]] || [item isKindOfClass:[BBProject class]]) && ![_paginator.items containsObject:item])
        {
            [_paginator.items addObject:item];
            [self displayStreamItem:item atTop:self.requestWasPullLatest scrollIntoView:itemCount == 0];
        }
        itemCount++;
    }
    
    // flush to default scrolling if pull to refresh was called
    self.requestWasPullLatest = NO;
}

#pragma mark -
#pragma mark - Delegation and Event Handling for Project leave/join button clicking

-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
    [[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    [[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:self.latestFetchedActivityNewer];
}

// This is really just a debugging method...
-(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBStreamController.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}

// fetch request for the latest stream items are processed here as a seperate, non-paginator response
-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBStreamController.didLoadObject"];
    
    if([object isKindOfClass:[BBActivityPaginator class]]) {
        // reverse the order so the items are popped onto the top of the UI scroll view with the oldest first.
        [self processPaginator:[[((BBActivityPaginator*)object).activities reverseObjectEnumerator] allObjects]];
    }
    
    [[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    [[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:self.latestFetchedActivityNewerLocalTime];
}

#pragma mark -
#pragma mark - UI Helpers

-(BOOL)scrollerIsAboutToBottomOut {
    
    BBStreamView *scrollView = (BBStreamView*)self.view;
    
    double distanceTilEmpty = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.size.height;
    
    [BBLog Log:[NSString stringWithFormat:@"Distance Til Empty: %f",distanceTilEmpty]];
    
    return (distanceTilEmpty) <= 0;
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBStreamController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MGBox*)getForwardArrow {
    UIView *arrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                         andDirection:BBArrowNext
                                       andArrowColour:[UIColor grayColor]
                                          andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(arrow.width, arrow.height)];
    [arrowWrapper addSubview:arrow];
    
    return arrowWrapper;
}

@end
*/

#pragma mark - 
#pragma mark - Using UITableView


#import "BBStreamController.h"
#import "SVPullToRefresh.h"

@class BBStreamProtocol;

@interface BBStreamController()

@property (nonatomic, strong) BBStreamView *scroller; // view
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) BBPaginator *paginator; // model
@property (nonatomic, strong) id<BBStreamProtocol> controller; // parent controller (HomeController in this case)
@property BOOL requestWasPullLatest;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewer;
@property (nonatomic, strong) NSDate *latestFetchedActivityOlder;
@property (nonatomic, strong) NSDate *latestFetchedActivityNewerLocalTime;

@property (nonatomic, strong) NSMutableDictionary *streamItemSizesCache;
@property BOOL paginatorIsLoading;

@end

@implementation BBStreamController {
    UIActivityIndicatorView *progress;
    NSString *groupId;
    MGBox *progressBox;
    MGBox* queriedBox;
}

@synthesize paginator = _paginator;
@synthesize scroller = _scroller;
@synthesize controller = _controller;
@synthesize requestWasPullLatest = _requestWasPullLatest;
@synthesize latestFetchedActivityNewer = _latestFetchedActivityNewer;
// add last fetched activity newer attempt?
@synthesize latestFetchedActivityOlder = _latestFetchedActivityOlder;
@synthesize tableView = _tableView;
@synthesize streamItemSizesCache = _streamItemSizesCache;
@synthesize paginatorIsLoading = _paginatorIsLoading;


#pragma mark -
#pragma mark - Initializers

-(NSMutableDictionary*)streamItemSizesCache {
    if(!_streamItemSizesCache) _streamItemSizesCache = [[NSMutableDictionary alloc]init];
    
    return _streamItemSizesCache;
}

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithUserAndDelegate:"];
    
    self = [super init];
    
    _controller = delegate;
    self.latestFetchedActivityOlder = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewer = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewerLocalTime = [NSDate date];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    _paginatorIsLoading = YES;

    return self;
}

-(BBStreamController*)initWithGroup:(NSString*)groupIdentifier
                        andDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithGroup:andDelegate:"];
    
    self = [super init];
    
    _controller = delegate;
    groupId = groupIdentifier;
    self.latestFetchedActivityOlder = [NSDate getCurrentUTCDate];
    self.latestFetchedActivityNewer = [NSDate getCurrentUTCDate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"/%@%@&%@", groupId, @"?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    _paginatorIsLoading = YES;
    
    return self;
}

-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate {
    [BBLog Log:@"BBStreamController.initWithProjectsAndDelegate:"];
    
    self = [super init];
    
    _controller = delegate;

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading Activity"];
    });
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/projects?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBProjectPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    _paginatorIsLoading = YES;
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [BBLog Log:@"BBStreamController.numberOfSectionsInTableView:"];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [BBLog Log:@"BBStreamController.numberOfRowsInSection:"];
    return _paginator.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [BBLog Log:@"tableView:cellForRowAtIndexPath:"];
    [BBLog Log:[NSString stringWithFormat:@"tableView Cell: %i", indexPath.row]];
//    
//
//    static NSString *sightingIdentifier = @"Sighting";
//    static NSString *noteIdentifier = @"Note";
//    static NSString *projectIdentifier = @"Project";
//    
//    NSString *identifier;
//    
//    id item = [_paginator.items objectAtIndex:indexPath.row];
//    
//    identifier = sightingIdentifier;
//    if([item isKindOfClass:BBActivity.class]){
//        BBActivity *activity = (BBActivity*)item;
//        if([activity.type isEqualToString:@"sightingadded"])
//        {
//            identifier = sightingIdentifier;
//        }
//        
//        else if([activity.type isEqualToString:@"sightingnoteadded"])
//        {
//            identifier = noteIdentifier;
//        }
//    }
//    else if([item isKindOfClass:BBProject.class]) {
//        identifier = projectIdentifier;
//    }
//
//    MGBox *box = [self displayStreamItem:item];
//    box.margin = UIEdgeInsetsMake(0, 5, 5, 0);
//    
//    MGBox *wrapper = [MGBox boxWithSize:CGSizeMake(320, box.height + 5)];
//    wrapper.backgroundColor = [UIColor blackColor];
//    [wrapper.boxes addObject:box];
//    [wrapper layout];
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
//    cell.backgroundColor = [UIColor blackColor];
//    
//    if (cell == nil || (cell.height != wrapper.height))
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        //cell = [[BBUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    
//    [cell.contentView addSubview:wrapper];
//    
//    return cell;
    
    
    //static NSString *CellIdentifier = @"Cell";
    //int nodeCount = [displayItems count];

    
    // Configure the cell...

    static NSString *sightingIdentifier = @"Sighting";
    static NSString *noteIdentifier = @"Note";
    static NSString *projectIdentifier = @"Project";
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark -
#pragma mark - Setup and Render UI and Events

-(void)loadView {
    [BBLog Log:@"BBStreamController.loadView"];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pagingEnabled = YES;
    
    self.view = _tableView;
    
    [_controller displayStreamView:(UITableView*)self.view];
}

- (void)viewDidLoad {
    [BBLog Log:@"BBStreamController.viewDidLoad:"];
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    //__block BBStreamController *this = self;
    __weak BBStreamController *stream = self;
    
    if(![_paginator isKindOfClass:[BBProjectPaginator class]]){
        
        __block NSString *groupIdentifier = [groupId copy];
        
        [((BBStreamView*)self.view) addPullToRefreshWithActionHandler:^{
            
            NSString* url;
            _tableView.pullToRefreshView.backgroundColor = [UIColor blackColor];
            
            // hit the server for the newest group results:
            if(groupIdentifier && ![groupIdentifier isEqualToString:@""]) {
                url = [NSString stringWithFormat:@"%@/%@?%@&NewerThan=%@",[BBConstants RootUriString], groupIdentifier, [BBConstants AjaxQuerystring], [self.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url
                                                                  delegate:stream];
            }
            // hit the server for the newest user results:
            else {
                url = [NSString stringWithFormat:@"%@?%@&NewerThan=%@",[BBConstants RootUriString], [BBConstants AjaxQuerystring], [self.latestFetchedActivityNewer dateAsJsonUtcString]];
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url
                                                                  delegate:stream];
            }
            
            stream.requestWasPullLatest = YES;
            stream.latestFetchedActivityNewer = [NSDate getCurrentUTCDate]; // set latest fetch to now for future fetches
            stream.latestFetchedActivityNewerLocalTime = [NSDate date];
        }];
    }
        
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        _tableView.infiniteScrollingView.backgroundColor = [UIColor blackColor];
        _tableView.infiniteScrollingView.arrowColor = [UIColor grayColor];
        
        [stream handlePaginatorLoadNextPage];
    }];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsPullToRefresh = YES;
}

-(void)handlePaginatorLoadNextPage {
    if([_paginator moreItemsExist] && !_paginatorIsLoading)
    {
        _paginatorIsLoading = YES;
        //[_tableView.infiniteScrollingView startAnimating];
        [_paginator loadNextPage];
    }
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
#pragma mark - Rendering Helpers

-(MGBox*)displayStreamItem:(id)item {
    [BBLog Log:@"BBStreamController.displayStreamItem:"];

    MGBox *box;
    
    if([item isKindOfClass:[BBActivity class]])
    {
        BBActivity *activity = (BBActivity*)item;
        if([activity.type isEqualToString:@"sightingadded"])
        {
            box = [self renderSightingActivity:activity];
        }
        
        else if([activity.type isEqualToString:@"sightingnoteadded"])
        {
            box = [self renderSightingNoteActivity:activity];
        }
    }
    else if([item isKindOfClass:[BBProject class]])
    {
        BBProject *project = (BBProject*)item;
        box = [self renderProject:project];
    }
    
    [box layout];
    
    return box;
}

-(MGBox*)renderSightingNoteActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingNoteActivity"];
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;

    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                          right:nil
                                                          width:240
                                                      minHeight:50];
    activityDescription.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    activityDescription.padding = UIEdgeInsetsZero;
    activityDescription.underlineType = MGUnderlineNone;
    
    MGBox *detailArrow = [self getForwardArrow];
    detailArrow.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    
    MGBox *userProfileWithArrow = [MGBox boxWithSize:CGSizeMake(310, 50)];
    userProfileWithArrow.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    userProfileWithArrow.contentLayoutMode = MGLayoutGridStyle;
    
    [userProfileWithArrow.boxes addObject:avatar];
    [userProfileWithArrow.boxes addObject:activityDescription];
    [info.topLines addObject:userProfileWithArrow];
    
    BBObservationNote *observationNote = activity.observationNote;
    
    // show the identification
    if(observationNote.identification) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        [info.middleLines addObject:[BBUIControlHelper createIdentification:observationNote.identification forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
    }
    // show the taxonomy
    if(![observationNote.taxonomy isEqualToString:@""]) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        MGLine *taxa = [MGLine multilineWithText:observationNote.taxonomy font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxa.underlineType = MGUnderlineNone;
        [info.middleLines addObject:taxa];
    }
    // show descriptions
    if(observationNote.descriptionCount > 0) {
        
        for (BBSightingNoteDescription* description in observationNote.descriptions) {
            
            [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:description.label
                                                                             forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            
            MGLine *descriptionLine = [MGLine multilineWithText:description.text
                                                           font:DESCRIPTOR_FONT
                                                          width:IPHONE_STREAM_WIDTH
                                                        padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            descriptionLine.underlineType = MGUnderlineNone;
            
            [info.middleLines addObject:descriptionLine];
        }
    }
    // show tags
    if(observationNote.tagCount > 0) {
        
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Tags"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        // grab tags from controller
        NSArray *tags = [observationNote.allTags componentsSeparatedByString:@","];
        MGBox *tagBox;
        
        DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
        [tagList setTags:tags];
        
        double minHeight = tagList.fittedSize.height;
        
        tagBox = [MGBox boxWithSize:CGSizeMake(280, minHeight)];
        tagBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
        [tagBox addSubview:tagList];
        
        [info.middleLines addObject:tagBox];
    }
    
    // show the observation the note belongs to in summary form:
    MGTableBox *subObservation = [BBUIControlHelper createSubObservation:activity.observationNoteObservation
                                                                       forSize:CGSizeMake(300, 200)
                                                                        withBlock:^{
                                                                            [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observationNoteObservation.identifier]
                                                                                                                                                                   animated:YES];}];
    [info.bottomLines addObject:subObservation];
    
    return info;
    
    //[streamView.boxes addObject:info];
}

-(MGBox*)renderSightingActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingActivity"];
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                          right:nil
                                                          width:200
                                                      minHeight:50];
    activityDescription.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    activityDescription.padding = UIEdgeInsetsZero;
    activityDescription.underlineType = MGUnderlineNone;
    
    MGBox *detailArrow = [self getForwardArrow];
    detailArrow.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    
    MGBox *userProfileWithArrow = [MGBox boxWithSize:CGSizeMake(310, 50)];
    userProfileWithArrow.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    userProfileWithArrow.contentLayoutMode = MGLayoutGridStyle;
    
    [userProfileWithArrow.boxes addObject:avatar];
    [userProfileWithArrow.boxes addObject:activityDescription];
    [userProfileWithArrow.boxes addObject:detailArrow];
    
    userProfileWithArrow.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observation.identifier] animated:YES];
    };
    
    [info.topLines addObject:userProfileWithArrow];
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:activity.observation.media
                                                                 withPrimary:activity.observation.primaryMedia
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH,250)
                                                            displayingThumbs:NO]];
    
    MGLine *title = [MGLine lineWithLeft:activity.observation.title right:nil size:CGSizeMake(IPHONE_STREAM_WIDTH, 30)];
    title.padding = UIEdgeInsetsMake(0, 10, 5, 10);
    title.font = HEADER_FONT;
    title.underlineType = MGUnderlineNone;
    [info.middleLines addObject:title];
    
    return info;
}

-(MGBox*)renderProject:(BBProject*)project {
    [BBLog Log:@"BBStreamController.renderProject"];
    
    //MGScrollView *streamView = (MGScrollView*)self.view;
    BBImage *avatarImage = [self getImageWithDimension:@"Square100" fromArrayOf:project.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_PROJECT_AVATAR_SIZE];
    
    MGLine *projectName = [MGLine lineWithLeft:project.name right:nil size:CGSizeMake(280, 40)];
    projectName.font = HEADER_FONT;
    
    NSString *multiLineDisplay = [NSString stringWithFormat:@"%d members \n%d observations \n%d posts", project.memberCount, project.observationCount, project.postCount];
    MGLine *projectStats = [MGLine lineWithLeft:avatar multilineRight:multiLineDisplay width:280 minHeight:100];
    projectStats.underlineType = MGUnderlineNone;
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_PROJECT_DESCRIPTION];
    info.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [info.topLines addObject:projectName];
    [info.middleLines addObject:projectStats];
    
    MGLine *description = [MGLine lineWithMultilineLeft:project.description right:nil width:270 minHeight:30];
    description.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    description.underlineType = MGUnderlineNone;
    [info.middleLines addObject:description];
    
    BBApplication* appData = [BBApplication sharedInstance];
    BBProject* projectInUserList = [self getProjectWithIdentifier:project.identifier fromArrayOf:appData.authenticatedUser.projects];
    
    // pass the id to either the join or leave project method
    BBModelId *projJoinLeave = [[BBModelId alloc]init];
    projJoinLeave.identifier = project.identifier;
    
    if(projectInUserList) {
        [info.bottomLines addObject:[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 280, 40) andTitle:@"Leave Project" withBlock:^{
            NSString* resourcePath = [NSString stringWithFormat:@"%@/%@/leave",[BBConstants RootUriString], project.identifier];
            [[RKObjectManager sharedManager] sendObject:projJoinLeave toResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
                loader.delegate = self;
                loader.method = RKRequestMethodPOST;
            }];
        }]];
    }
    else
    {
        [info.bottomLines addObject:[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 280, 40) andTitle:@"Join Project" withBlock:^{
            NSString* resourcePath = [NSString stringWithFormat:@"%@/%@/join",[BBConstants RootUriString], project.identifier];
            [[RKObjectManager sharedManager] sendObject:projJoinLeave toResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
                loader.delegate = self;
                loader.method = RKRequestMethodPOST;
            }];
        }]];
    }
    
    return info;
}

#pragma mark -
#pragma mark - Delegation and Event Handling for Paginator

// Once the pagination has been received, send all the returned items for processing into the stream view
-(void)paginator:(RKObjectPaginator *)paginator
  didLoadObjects:(NSArray *)objects
         forPage:(NSUInteger)page {
    [BBLog Log:@"BBStreamController.paginator:didLoadObjects:forPage"];
    
    [SVProgressHUD dismiss];
    _paginatorIsLoading = NO;
    [_tableView.infiniteScrollingView stopAnimating];
    
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

// prior to grabbing the paginated objects, append the current 'OlderThan' timestamp to maintain paging integrity
-(void)paginator:(RKObjectPaginator *)paginator
    willLoadPage:(NSUInteger)page
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBStreamController.paginator:willLoadPage:objectLoader:"];
    RKURL *url = paginator.patternURL;
    
    // hack to overwrite the paging parameter with the propper page number: http://stackoverflow.com/questions/11751880/how-to-fetch-pages-of-results-with-restkit
    loader.resourcePath = [NSString stringWithFormat:@"%@&OlderThan=%@", [url.resourcePath stringByReplacingOccurrencesOfString:@"Page=1" withString:[NSString stringWithFormat:@"Page=%i", page]], [self.latestFetchedActivityOlder dateAsJsonUtcString]];
}

-(void)paginator:(RKObjectPaginator *)paginator
didFailWithError:(NSError *)error
    objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    [SVProgressHUD showErrorWithStatus:error.description];
    _paginatorIsLoading = NO;
    [_tableView.infiniteScrollingView stopAnimating];
}

-(void)processPaginator:(NSArray*)paginatorItems {
    [BBLog Log:@"BBStreamController.processPaginator:"];
    
    // if we haven't already displayed this item, push it to the view
    for(id item in paginatorItems) {
        if(([item isKindOfClass:[BBActivity class]] || [item isKindOfClass:[BBProject class]]) && ![_paginator.items containsObject:item])
        {
            [_paginator.items addObject:item];
        }
    }

    // flush to default scrolling if pull to refresh was called
    //self.requestWasPullLatest = NO;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
    [BBLog Log:[NSString stringWithFormat:@"Paginator item count: %i", _paginator.items.count]];
}

#pragma mark -
#pragma mark - Delegation and Event Handling for Project leave/join button clicking

-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
    [_tableView.pullToRefreshView stopAnimating];
    
    [[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    [[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:self.latestFetchedActivityNewer];
}

    // This is really just a debugging method...
    -(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBStreamController.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}

// fetch request for the latest stream items are processed here as a seperate, non-paginator response
-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBStreamController.didLoadObject"];
    
    if([object isKindOfClass:[BBActivityPaginator class]]) {
        // reverse the order so the items are popped onto the top of the UI scroll view with the oldest first.
        [self processPaginator:[[((BBActivityPaginator*)object).activities reverseObjectEnumerator] allObjects]];
    }
    
    [[((BBStreamView*)self.view) pullToRefreshView] stopAnimating];
    [[((BBStreamView*)self.view) pullToRefreshView] setLastUpdatedDate:self.latestFetchedActivityNewerLocalTime];
}

#pragma mark -
#pragma mark - UI Helpers

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBStreamController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MGBox*)getForwardArrow {
    UIView *arrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                        andDirection:BBArrowNext
                                      andArrowColour:[UIColor grayColor]
                                         andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(arrow.width, arrow.height)];
    [arrowWrapper addSubview:arrow];
    
    return arrowWrapper;
}


-(BBImage*)getImageWithDimension:(NSString*)dimensionName fromArrayOf:(NSArray*)images {
    [BBLog Log:@"BBControllerBase.getImageWithDimension:fromArrayOf:"];
    
    __block BBImage *img;
    [images enumerateObjectsUsingBlock:^(BBImage* obj, NSUInteger idx, BOOL *stop)
     {
         if([obj.dimensionName isEqualToString:dimensionName])
         {
             img = obj;
             *stop = YES;
         }
     }];
    
    return img;
}


-(BBProject*)getProjectWithIdentifier:(NSString *)identifier fromArrayOf:(NSArray *)projects{
    [BBLog Log:@"BBControllerBase.getProjectWithIdentifier:fromArrayOf:"];
    
    __block BBProject *project;
    [projects enumerateObjectsUsingBlock:^(BBProject* proj, NSUInteger idx, BOOL *stop)
     {
         if([proj.identifier isEqualToString:identifier])
         {
             project = proj;
             *stop = YES;
         }
     }];
    
    return project;
}

@end