/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingItemController.h"
#import "BBObservation.h"
#import "BBUser.h"
#import "BBMediaResource.h"
#import "BBUIControlHelper.h"
#import "BBSightingDetailController.h"


@interface BBSightingItemController ()

@property (nonatomic,strong) BBObservation* observation;

@end


@implementation BBSightingItemController


#pragma mark -
#pragma mark - Member Accessors


@synthesize observation = _observation;


#pragma mark -
#pragma mark - Constructors


-(id)initWithObservation:(BBObservation*)observation {
    
    self = [super init];
    
    if (self){
        _observation = observation;
    }
    
    return self;
}

#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBSightingItemController.loadView:"];
    
    self.view = [self render];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark -
#pragma mark - Utilities and Helpers


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(MGBox*)render {
    [BBLog Log:@"BBSightingItemController.render"];
    
    BBObservation *observation = self.observation;
    
    MGTableBox *info = [MGTableBox boxWithSize:IPHONE_OBSERVATION];
    info.backgroundColor = [UIColor whiteColor];
    
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    info.padding = UIEdgeInsetsZero;
    
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:observation.user.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    MGLine *activityDescription = [MGLine lineWithMultilineLeft:[NSString stringWithFormat:@"%@ observed %@",observation.user.name, [observation.observedOnDate timeAgo]]
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
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:[[BBSightingDetailController alloc]initWithSightingIdentifier:observation.identifier] animated:YES];
    };
    
    [info.topLines addObject:userProfileWithArrow];
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:observation.media
                                                                 withPrimary:observation.primaryMedia
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH,250)
                                                            displayingThumbs:NO]];
    
    MGLine *title = [MGLine lineWithLeft:observation.title
                                   right:nil
                                    size:CGSizeMake(IPHONE_STREAM_WIDTH, 30)];
    title.padding = UIEdgeInsetsMake(0, 10, 5, 10);
    title.font = HEADER_FONT;
    title.underlineType = MGUnderlineNone;
    [info.middleLines addObject:title];
    
    return info;
}


@end