/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingNoteActivityController.h"
#import "BBSightingDetailController.h"
#import "BBImage.h"
#import "BBObservation.h"
#import "BBObservationNote.h"
#import "BBUser.h"
#import "BBActivity.h"
#import "BBMediaResource.h"
#import "BBUIControlHelper.h"
#import "DWTagList.h"


@interface BBSightingNoteActivityController ()

@property (nonatomic,strong) BBActivity* activity;

@end


@implementation BBSightingNoteActivityController


#pragma mark -
#pragma mark - Constructors


-(id)initWithSightingNoteActivity:(BBActivity*)activity {
    self = [super init];
    if (self) {
        self.activity = activity;
    }
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    self.view = (MGBox*)[self render];
}

- (void)viewDidLoad {
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
    
    [BBLog Log:@"BBStreamController.renderSightingNote"];
    
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
    
    BBObservationNote *observationNote = activity.observationNote;
    
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
}

@end