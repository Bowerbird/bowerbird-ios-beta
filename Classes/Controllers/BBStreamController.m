//
//  BBStreamController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//
// for help refer to http://restkit.org/api/master/Classes/RKURL.html

#import "BBStreamController.h"

@class BBStreamProtocol;

@interface BBStreamController()

@property (nonatomic, strong) BBStreamView *scroller; // view
@property (nonatomic, retain) BBPaginator *paginator; // model
@property (nonatomic, strong) id<BBStreamProtocol> controller; // parent controller (HomeController)

@end

@implementation BBStreamController{
    UIImage *arrow, *back;
    float previousContentOffset;
    int previousLastItemIndex;
}

@synthesize paginator = _paginator;
@synthesize scroller = _scroller;
@synthesize controller = _controller;

#pragma mark -
#pragma mark - Initializers

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    
    [SVProgressHUD showWithStatus:@"Loading Activity"];
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    
    [dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    
    return self;
}

-(BBStreamController*)initWithGroup:(NSString*)groupId andDelegate:(id<BBStreamProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    
    [SVProgressHUD showWithStatus:@"Loading Activity"];
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"/%@?PageSize=:perPage&Page=:page", groupId]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    [dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
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
    
    [SVProgressHUD showWithStatus:@"Loading Projects"];
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:@"/projects?PageSize=:perPage&Page=:page"];
    
    // And a dictionary containing values:
    //NSMutableDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", @"1", @"page", nil];
    //[dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    //RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:myURL//interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    _paginator.delegate = self;
    [_paginator loadPage:1];
    
    return self;
}

#pragma mark -
#pragma mark - Setup and Render

-(void)loadView {
    [BBLog Log:@"BBStreamController.loadView"];
    
    self.view = [[BBStreamView alloc]initWithDelegate:_controller
                                              andSize:[self screenSize]];  //[MGScrollView scrollerWithSize:[self screenSize]];
    
    ((BBStreamView*)self.view).delegate = self;
    
    [_controller displayStreamView:(BBStreamView*)self.view];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBStreamController.viewDidLoad"];
    
    [super viewDidLoad];
    arrow = [UIImage imageNamed:@"arrow.png"];
    back = [UIImage imageNamed:@"back.png"];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    [((BBStreamView*)self.view) layout];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [BBLog Log:@"BBStreamController.scrollViewDidScroll"];
    
    [BBLog Log:[NSString stringWithFormat:@"contentOffset.y:%f contentSize.height:%f", scrollView.contentOffset.y, scrollView.contentSize.height]];
    
    if(scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.size.height < 0)
    {
        BOOL scrollingDownward = previousContentOffset > scrollView.contentOffset.y;
    
        [self displayStreamActivity:scrollingDownward];
    }
    
    previousContentOffset = scrollView.contentOffset.y;
        
}
    
#pragma mark -
#pragma mark - Utilities and Helpers

-(void)displayActivities:(BBActivityPaginator*)pagedActivities {
    [BBLog Log:@"BBStreamController.displayActivities:"];
    
    for(BBActivity *activity in pagedActivities.activities)
    {
        if([activity.type isEqualToString:@"sightingadded"])
        {
            [self addObservation:activity];
        }
        else if([activity.type isEqualToString:@"sightingnoteadded"])
        {
            [self addSightingNote:activity];
        }
        // TODO: Add identification when refactor for splitting out is done.
    }
    
    if(pagedActivities.activities.count == 0)
    {
        MGLine *description = [MGLine multilineWithText:@"No Activity yet!" font:HEADER_FONT width:300 padding:UIEdgeInsetsMake(150, 50, 0, 0)];
        description.underlineType = MGUnderlineNone;
        description.textColor = [UIColor whiteColor];
        
        [((MGScrollView*)self.view).boxes addObject:description];
    }
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)displayProjects:(BBProjectPaginator*)pagedProjects {
    [BBLog Log:@"BBStreamController.displayProjects:"];
    
    for(BBProject *project in pagedProjects.projects)
    {
        [self addProject:project];
    }
    
    // Add more button:

    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)displaySightings:(BBSightingPaginator*)pagedSightings {
    [BBLog Log:@"BBStreamController.displaySightings:"];
    
    for(BBActivity *activity in pagedSightings.activities)
    {
        if([activity.type isEqualToString:@"observationadded"])
        {
            [self addObservation:activity];
        }
    }
    
    if(pagedSightings.activities.count == 0)
    {
        MGLine *description = [MGLine multilineWithText:@"No Activity yet!" font:HEADER_FONT width:300 padding:UIEdgeInsetsMake(150, 50, 0, 0)];
        
        [((MGScrollView*)self.view).boxes addObject:description];
    }
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)addSightingNote:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.addSightingNote"];
    
    MGScrollView *streamView = (MGScrollView*)self.view;
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    
    info.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observationNoteObservation.identifier] animated:YES];
    };
    
    // Add the User Profile to the top:
    MGLine *userProfile = [BBUIControlHelper createUserProfileLineForUser:activity.user
                                                          withDescription:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                                  forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
    
    MGLine *userProfileWithArrow = [MGLine lineWithLeft:userProfile right:arrow size:CGSizeMake(IPHONE_STREAM_WIDTH,60)];
    userProfileWithArrow.bottomPadding = 5;
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
    MGTableBoxStyled *subObservation = [BBUIControlHelper createSubObservation:activity.observationNoteObservation
                                                                       forSize:CGSizeMake(290, 200)];
    [info.bottomLines addObject:subObservation];
    
    [streamView.boxes addObject:info];
}

-(MGBox*)renderSightingNoteActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingNoteActivity"];
    
    //MGScrollView *streamView = (MGScrollView*)self.view;
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    
    info.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observationNoteObservation.identifier] animated:YES];
    };
    
    // Add the User Profile to the top:
    MGLine *userProfile = [BBUIControlHelper createUserProfileLineForUser:activity.user
                                                          withDescription:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                                  forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
    
    MGLine *userProfileWithArrow = [MGLine lineWithLeft:userProfile right:arrow size:CGSizeMake(IPHONE_STREAM_WIDTH,60)];
    userProfileWithArrow.bottomPadding = 5;
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
    MGTableBoxStyled *subObservation = [BBUIControlHelper createSubObservation:activity.observationNoteObservation
                                                                       forSize:CGSizeMake(290, 200)];
    [info.bottomLines addObject:subObservation];
    
    return info;
    
    //[streamView.boxes addObject:info];
}

-(void)addObservation:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.addObservation"];
    
    MGScrollView *streamView = (MGScrollView*)self.view;
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    
    MGLine *userProfile = [BBUIControlHelper createUserProfileLineForUser:activity.user
                                                          withDescription:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                                  forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
    
    
    MGLine *userProfileWithArrow = [MGLine lineWithLeft:userProfile right:arrow size:CGSizeMake(IPHONE_STREAM_WIDTH,60)];
    userProfileWithArrow.bottomPadding = 5;
    
    //userProfileWithArrow.underlineType = MGUnderlineNone;
    [info.topLines addObject:userProfileWithArrow];
    
    info.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observation.identifier] animated:YES];
    };
    
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:activity.observation.media
                                                                 withPrimary:activity.observation.primaryMedia
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH,270)
                                                            displayingThumbs:NO]];
       
    MGLine *title = [MGLine lineWithLeft:activity.observation.title right:nil size:CGSizeMake(IPHONE_STREAM_WIDTH, 40)];
    title.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    title.font = HEADER_FONT;
    title.underlineType = MGUnderlineNone;
    
    [info.middleLines addObject:title];
    [streamView.boxes addObject:info];
}

-(MGBox*)renderSightingActivity:(BBActivity*)activity {
    [BBLog Log:@"BBStreamController.renderSightingActivity"];
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    
    MGLine *userProfile = [BBUIControlHelper createUserProfileLineForUser:activity.user
                                                          withDescription:[NSString stringWithFormat:@"%@ %@",activity.description, [activity.createdOn timeAgo]]
                                                                  forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
    
    
    MGLine *userProfileWithArrow = [MGLine lineWithLeft:userProfile right:arrow size:CGSizeMake(IPHONE_STREAM_WIDTH,60)];
    userProfileWithArrow.bottomPadding = 5;
    
    //userProfileWithArrow.underlineType = MGUnderlineNone;
    [info.topLines addObject:userProfileWithArrow];
    
    info.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.observation.identifier] animated:YES];
    };
    
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:activity.observation.media
                                                                 withPrimary:activity.observation.primaryMedia
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH,270)
                                                            displayingThumbs:NO]];
    
    MGLine *title = [MGLine lineWithLeft:activity.observation.title right:nil size:CGSizeMake(IPHONE_STREAM_WIDTH, 40)];
    title.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    title.font = HEADER_FONT;
    title.underlineType = MGUnderlineNone;
    
    [info.middleLines addObject:title];
    
    return info;
}

-(void)addProject:(BBProject*)project {
    [BBLog Log:@"BBStreamController.addProject"];
    
    MGScrollView *streamView = (MGScrollView*)self.view;
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
                //loader.serializationMIMEType = RKMIMETypeJSON;
                //loader.params = d;
                //loader.mappingProvider =
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
                //loader.serializationMIMEType = RKMIMETypeJSON;
                //loader.params = d;
            }];
        }]];
    }
    
    [streamView.boxes addObject:info];
}

#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)paginator:(RKObjectPaginator *)paginator didLoadObjects:(NSArray *)objects forPage:(NSUInteger)page {
    [BBLog Log:@"BBStreamController.paginator:didLoadObjects:forPage"];

    [BBLog Log:[NSString stringWithFormat:@"%@ %@ Page:%i", @"Paginator objects:", objects, page]];
    
    if([[objects objectAtIndex:0] isKindOfClass:[BBActivityPaginator class]]) {
        BBActivityPaginator *activityPaginator = (BBActivityPaginator*)[objects objectAtIndex:0];
        
        for (BBActivity *activity in activityPaginator.activities) {
            // do something with activity
            [_paginator.items addObject:activity];
        }
    }
    
    // start displaying items heading downward from the start:
    [self displayStreamActivity:YES fromIndex:(page - 1)*10];
    
    // add the objects to the model and display them in the view:
    [SVProgressHUD dismiss];
}

-(void)paginator:(RKObjectPaginator *)paginator willLoadPage:(NSUInteger)page objectLoader:(RKObjectLoader *)loader {

    RKURL *url = paginator.patternURL;
    
    // hack to overwrite the paging parameter with the propper page number: http://stackoverflow.com/questions/11751880/how-to-fetch-pages-of-results-with-restkit
    loader.resourcePath = [url.resourcePath stringByReplacingOccurrencesOfString:@"Page=1" withString:[NSString stringWithFormat:@"Page=%i",page]];
}

/*
-(void)paginator:(RKObjectPaginator *)paginator willLoadPage:(NSUInteger)page objectLoader:(RKObjectLoader *)loader {
    
    [SVProgressHUD showWithStatus:@"Loading Activity"];
    
    // Given an RKURL initialized as:
    RKURL *myURL = [RKURL URLWithBaseURLString:[BBConstants RootUriString]
                                  resourcePath:[NSString stringWithFormat:@"%@&%@", @"/?PageSize=:perPage&Page=:page", [BBConstants AjaxQuerystring]]];
    
    // And a dictionary containing values:
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10", @"perPage", [NSString stringWithFormat:@"%i",page], @"page", nil];
    
    [dictionary addEntriesFromDictionary:[BBConstants AjaxRequestParams]];
    
    // A new RKURL can be constructed by interpolating the dictionary with the original URL
    RKURL *interpolatedURL = [myURL URLByInterpolatingResourcePathWithObject:dictionary];
    
    _paginator = [[BBActivityPaginator alloc]initWithPatternURL:interpolatedURL
                                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
    //_paginator.delegate = self;
    //[_paginator loadPage:page];
    [_paginator loadPage:page];
}
 */

-(void)paginator:(RKObjectPaginator *)paginator didFailWithError:(NSError *)error objectLoader:(RKObjectLoader *)loader {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}

-(void)displayStreamActivity:(BOOL)scrollingDownward fromIndex:(int)starting {
    
    BOOL weStillHaveRoomOnScrollView = YES;
    int itemsProcessed = 0;
    
    __block NSMutableArray *items = [[NSMutableArray alloc]init];
    [_paginator.items enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [items addObject:obj];
    }];
    
    if(!scrollingDownward) {
        // reverse the array:
        NSMutableArray *reverseItems = [[NSMutableArray alloc]init];
        for(id a in [items reverseObjectEnumerator]){
            [reverseItems addObject:a];
        }
        items = reverseItems;
    }

    for (id item in items) {
        
        if (weStillHaveRoomOnScrollView && itemsProcessed < _paginator.items.count)
        {
            itemsProcessed ++;
            
            if([item isKindOfClass:[BBActivity class]])
            {
                BBActivity *activity = (BBActivity*)item;
                if([activity.type isEqualToString:@"sightingadded"])
                {
                    MGBox* sightingActivityBox = [self renderSightingActivity:activity];
                    
                    weStillHaveRoomOnScrollView = [((BBStreamView*)self.view) renderStreamItem:sightingActivityBox
                                                                                   inDirection:scrollingDownward
                                                                                     forItemId:activity.identifier];
                }
                
                else if([activity.type isEqualToString:@"sightingnoteadded"])
                {
                    MGBox* sightingNoteActivityBox = [self renderSightingNoteActivity:activity];
                    
                    weStillHaveRoomOnScrollView = [((BBStreamView*)self.view) renderStreamItem:sightingNoteActivityBox
                                                                                   inDirection:scrollingDownward
                                                                                     forItemId:activity.identifier];
                }
            }
            else if([item isKindOfClass:[BBProject class]])
            {
                // sort that out next...
            }
        }
        else {
            break;
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void)displayStreamActivity:(BOOL)scrollingDownward {

    // going back in time, down the stream
    // items may not exist at point in time so display them
    int index;
    
    if(scrollingDownward)
    {
        // get the last item in the array
        NSString *lastItem = [((BBStreamView*)self.view) itemAtStreamTop];
        
        // if there are undisplayed items after this, display them, display a load more button, or load more and display a spinner.
        // get the index of the array for the item:
        index = [self arrayIndexOfItemWithId:lastItem];
        
        if(previousLastItemIndex == index) {
            // load the next paging list:
            [_paginator loadNextPage];
            [SVProgressHUD setStatus:@"Loading Next Page"];
        }
        
        previousLastItemIndex = index;
        
    }
    // going up the stream
    // items may have been popped off the stack so display them again if so:
    else
    {
        // get the first item in the array
        NSString *firstItem = [((BBStreamView*)self.view) itemAtStreamBottom];
        // if there are no items existing before this one, either check for latest or stop
        index = [self arrayIndexOfItemWithId:firstItem];
    }
    
    [self displayStreamActivity:scrollingDownward fromIndex:index];
}

-(int)arrayIndexOfItemWithId:(NSString*)itemId {
    
    __block int index = 0;
    [_paginator.items enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if([obj isKindOfClass:[BBActivity class]] && [((BBActivity*)obj).identifier isEqualToString:itemId]) {
            *stop = YES;
        }
        else if([obj isKindOfClass:[BBProject class]] && [((BBProject*)obj).identifier isEqualToString:itemId]) {
            *stop = YES;
        }
        
        index++;
    }];
    
    return index;
}

/* // Superceded by the Paginator delegate methods above.

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBStreamController.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    
    if([object isKindOfClass:[BBActivityPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBActivityPaginator Loaded"];
        
        
    }
    
    if([object isKindOfClass:[BBProjectPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBProjectPaginator Loaded"];
        

    }
    
    if([object isKindOfClass:[BBSightingPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBSightingPaginator Loaded"];
        

    }
    
}
 
*/

- (void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBContainerController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBStreamController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end