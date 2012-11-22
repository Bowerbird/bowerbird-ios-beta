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
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayActivities:(BBActivityPaginator*)pagedActivities
{
    [BBLog Log:@"BBStreamController.displayActivities:"];
    
    for(BBActivity *activity in pagedActivities.activities)
    {
        if([activity.type isEqualToString:@"sightingadded"])
        {
            [self addObservation:activity];
        }
    }
    
    if(pagedActivities.activities.count == 0)
    {
        MGLine *description = [MGLine multilineWithText:@"No Activity yet!" font:HEADER_FONT width:300 padding:UIEdgeInsetsMake(150, 50, 0, 0)];
        
        [((MGScrollView*)self.view).boxes addObject:description];
    }
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)displayProjects:(BBProjectPaginator*)pagedProjects
{
    [BBLog Log:@"BBStreamController.displayProjects:"];
    
    for(BBProject *project in pagedProjects.projects)
    {
        [self addProject:project];
    }
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}


-(void)displaySightings:(BBSightingPaginator*)pagedSightings
{
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


-(void)addObservation:(BBActivity*)activity
{
    [BBLog Log:@"BBStreamController.addObservation"];
    
    MGScrollView *streamView = (MGScrollView*)self.view;
    
    BBImage *primaryMediaImage = [self getImageWithDimension:@"Constrained240" fromArrayOf:activity.observation.primaryMedia.mediaResource.imageMedia];
    BBImage *avatarImage = [self getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_AVATAR_SIZE];
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    MGLine *description = [MGLine multilineWithText:activity.description font:nil width:140 padding:UIEdgeInsetsMake(10, 5, 0, 0)];
    MGLine *user = [MGLine lineWithLeft:avatar right:description size:CGSizeMake(200, 60)];
    MGLine *userDescription = [MGLine lineWithLeft:user right:arrow size:CGSizeMake(280, 60)];
    [info.topLines addObject:userDescription];
    PhotoBox *photo = [PhotoBox mediaFor:primaryMediaImage.uri size:IPHONE_OBSERVATION];
    photo.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithActivity:activity] animated:YES];
    };
    userDescription.onTap = ^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithActivity:activity] animated:YES];
    };
    photo.backgroundColor = [UIColor brownColor];
    MGLine *media = [MGLine lineWithLeft:photo right:nil size:CGSizeMake(300, 270)];
    [info.middleLines addObject:media];
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
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_PROJECT_DESCRIPTION];
    info.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [info.topLines addObject:projectName];
    [info.middleLines addObject:projectStats];
    
    MGLine *description = [MGLine lineWithMultilineLeft:project.description right:nil width:270 minHeight:30];
    description.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [info.middleLines addObject:description];
    
    BBApplication* appData = [BBApplication sharedInstance];
    BBProject* projectInUserList = [self getProjectWithIdentifier:project.identifier fromArrayOf:appData.authenticatedUser.projects];
    
    BBModelId *projJoinLeave = [[BBModelId alloc]init];
    projJoinLeave.identifier = project.identifier;
    
    //NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
    //[d setObject:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    //[d setObject:project.identifier forKey:@"identifier"];
    //[d setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
    
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