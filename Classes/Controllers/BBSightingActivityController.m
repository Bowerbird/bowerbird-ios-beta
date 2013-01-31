/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingActivityController.h"
#import "BBSightingDetailController.h"
#import "BBActivity.h"
#import "BBImage.h"
#import "BBUser.h"
#import "BBMediaResource.h"
#import "BBObservation.h"
#import "BBUIControlHelper.h"


@interface BBSightingActivityController ()

@property (nonatomic,strong) BBActivity* activity;

@end


@implementation BBSightingActivityController


#pragma mark -
#pragma mark - Constructors


-(id)initWithSightingActivity:(BBActivity *)sightingActivity {
    self = [super init];
    if (self) {

        self.activity = sightingActivity;
        
    }
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    self.view = [self render];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(MGBox*)render {
    [BBLog Log:@"BBStreamController.renderSighting"];
    
    BBActivity *activity = self.activity;
    
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


@end