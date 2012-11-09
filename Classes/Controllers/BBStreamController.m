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
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    
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
    self.app.navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayActivities:(BBActivityPaginator*)pagedActivities
{
    [BBLog Log:@"BBStreamController.displayActivities:"];
    
    for(BBActivity *activity in pagedActivities.activities)
    {
        if([activity.type isEqualToString:@"observationadded"])
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
    
    // this gets used to display the observation:
    BBImage *primaryMediaImage = [activity.observation.primaryMedia.mediaResource.imageMedia objectAtIndex:0];
    BBImage *avatarImage = [self getImageWithDimension:@"Square50" fromArrayOf:activity.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_AVATAR_SIZE];
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    MGLine *description = [MGLine multilineWithText:activity.description font:nil width:140 padding:UIEdgeInsetsMake(10, 5, 0, 0)];
    MGLine *user = [MGLine lineWithLeft:avatar right:description size:CGSizeMake(200, 60)];
    MGLine *userDescription = [MGLine lineWithLeft:user right:arrow size:CGSizeMake(280, 60)];
    [info.topLines addObject:userDescription];
    PhotoBox *photo = [PhotoBox mediaFor:primaryMediaImage.uri size:IPHONE_OBSERVATION];
    photo.onTap = ^{[self.app.navController pushViewController:[[BBSightingDetailController alloc]initWithActivity:activity] animated:YES];};
    userDescription.onTap = ^{[self.app.navController pushViewController:[[BBSightingDetailController alloc]initWithActivity:activity] animated:YES];};
    photo.backgroundColor = [UIColor brownColor];
    MGLine *media = [MGLine lineWithLeft:photo right:nil size:CGSizeMake(300, 270)];
    [info.middleLines addObject:media];
    [streamView.boxes addObject:info];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


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