/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Displays an identification in a stream
 
 -----------------------------------------------------------------------------------------------*/


#import "BBIdentificationActivityController.h"
#import "BBSightingDetailController.h"
#import "BBImage.h"
#import "BBActivity.h"
#import "BBIdentification.h"
#import "BBUser.h"
#import "BBMediaResource.h"
#import "BBObservation.h"
#import "BBUIControlHelper.h"


@interface BBIdentificationActivityController ()

@property (nonatomic,strong) BBActivity *activity;

@end


@implementation BBIdentificationActivityController


#pragma mark -
#pragma mark - Constructors


- (id)initWithIdentificationActivity:(BBActivity*)activity
{
    self = [super init];
    if (self) {
        self.activity = activity;
    }
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    self.view = [self render];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark - Utilities and Helpers


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MGBox*)render {
    [BBLog Log:@"BBStreamController.renderSightingIdentification"];
    
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
    
    BBIdentification *identification = activity.identification;
    
    // show the identification
    if(identification) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        [info.middleLines addObject:[BBUIControlHelper createIdentification:identification forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
    }
    // show the taxonomy
    if(![identification.taxonomy isEqualToString:@""]) {
        [info.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        MGLine *taxa = [MGLine multilineWithText:identification.taxonomy font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxa.underlineType = MGUnderlineNone;
        [info.middleLines addObject:taxa];
    }
    
    // show the observation the note belongs to in summary form:
    MGTableBox *subObservation = [BBUIControlHelper createSubObservation:activity.identificationObservation
                                                                 forSize:CGSizeMake(300, 200)
                                                               withBlock:^
                                  {
                                      [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:activity.identificationObservation.identifier]
                                                                                                                             animated:YES];
                                  }];
    
    [info.bottomLines addObject:subObservation];
    
    return info;
}


@end