/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 High-level routing VC to display an activity in a stream. Passes based on Activity Type to a
 more specialised controller - Sighting, SightingNote, Identification or Post.
 
 -----------------------------------------------------------------------------------------------*/


#import "BBActivityController.h"
#import "BBSightingActivityController.h"
#import "BBSightingNoteActivityController.h"
#import "BBIdentificationActivityController.h"
#import "BBPostActivityController.h"
#import "BBActivity.h"


@interface BBActivityController ()

@property (nonatomic,strong) BBActivity* activity;

@end


@implementation BBActivityController


#pragma mark -
#pragma mark - Member Accessors


@synthesize activity = _activity;


#pragma mark -
#pragma mark - Constructors


- (id)initWithActivity:(BBActivity*)activity {
    [BBLog Log:@"BBActivityController.initWithActivity:"];
    
    self = [super init];
    
    if(self) {
        self.activity = activity;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    
    MGBox *box;
    
    if([self.activity.type isEqualToString:@"sightingadded"])
    {
        BBSightingActivityController *sightingActivityController = [[BBSightingActivityController alloc]initWithSightingActivity:self.activity];
        
        box = (MGBox*)sightingActivityController.view;
    }
    
    else if([self.activity.type isEqualToString:@"sightingnoteadded"])
    {
        BBSightingNoteActivityController *sightingNoteActivityController = [[BBSightingNoteActivityController alloc]initWithSightingNoteActivity:self.activity];
        
        box = (MGBox*)sightingNoteActivityController.view;
    }
    else if([self.activity.type isEqualToString:@"identificationadded"])
    {
        BBIdentificationActivityController *identificationActivityController = [[BBIdentificationActivityController alloc]initWithIdentificationActivity:self.activity];

        box = (MGBox*)identificationActivityController.view;
    }
    else if([self.activity.type isEqualToString:@"postadded"])
    {
        BBPostActivityController *postActivityController = [[BBPostActivityController alloc] initWithPostActivity:self.activity];
        
        box = (MGBox*)postActivityController.view;
    }
    
    else {
        // activity has been deleted:
        
        NSString *message = self.activity.deleted;
        
        MGLine *itemDeleted = [MGLine lineWithMultilineLeft:message right:nil width:300 minHeight:40];
        itemDeleted.leftItemsTextAlignment = NSTextAlignmentCenter;
        box = [MGBox boxWithSize:itemDeleted.size];
        [box.boxes addObject:itemDeleted];
    }
    
    self.view = box;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end