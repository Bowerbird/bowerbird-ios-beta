//
//  BBStreamController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBStreamController.h"

@implementation BBStreamController{
    UIImage *arrow, *back;
}

#pragma mark -
#pragma mark - Setup and Render

-(void)loadView {
    [BBLog Log:@"BBStreamController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
}

- (void)viewDidLoad {
    [BBLog Log:@"BBStreamController.viewDidLoad"];
    
    [super viewDidLoad];
    arrow = [UIImage imageNamed:@"arrow.png"];
    back = [UIImage imageNamed:@"back.png"];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
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

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBStreamController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBStreamController.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}

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