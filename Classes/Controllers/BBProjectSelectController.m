/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Allows a user to choose projects they are a member of to add to a created sighting
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProjectSelectController.h"
#import "BBImage.h"
#import "BBProject.h"
#import "MGHelpers.h"
#import "BBHelpers.h"
#import "BBUIControlHelper.h"
#import "BBAppDelegate.h"
#import "BBAuthenticatedUser.h"
#import "BBMediaResource.h"


@implementation BBProjectSelectController {
    MGTableBoxStyled *projectTable;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize controller = _controller,
            projects = _projects;


#pragma mark -
#pragma mark - Constructors


-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate {
    [BBLog Log:@"BBProjectSelectController.initWithDelegate"];
    
    self = [super init];
    
    _controller = delegate;
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBProjectSelectController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
}

-(void)viewDidLoad {
    [BBLog Log:@"BBProjectSelectController.viewDidLoad"];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBProjectSelectController.viewWillAppear"];
    
    [self displayViewControls];
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                   style: UIBarButtonItemStyleBordered
                                                                  target: self
                                                                  action: nil];
    
    self.navigationItem.backBarButtonItem = backButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action:@selector(cancelTapped)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.title = @"Add Projects";
    
    // this may need to be in loadView
    [(MGScrollView*)self.view layout];
}


#pragma mark -
#pragma mark - Helpers and Utilities


-(void)cancelTapped {
    [_controller stopAddingProjects];
}

-(void)displayViewControls {
    [BBLog Log:@"BBProjectSelectController.displayViewControls"];

    
    MGTableBox *projectsTableWrapper = [MGTableBox boxWithSize:CGSizeMake(320, 40)];
    MGLine *projectsTableWrapperHeader = [MGLine lineWithLeft:@"Projects"
                                                     right:nil
                                                      size:CGSizeMake(300, 30)];
    projectsTableWrapperHeader.underlineType = MGUnderlineNone;
    projectsTableWrapperHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [projectsTableWrapper.topLines addObject:projectsTableWrapperHeader];
    
    projectTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 40)];
    projectTable.bottomPadding = 10;
    [self displayProjects];
    
    CoolMGButton *done = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 300, 40)
                                                         andTitle:@"Finished"
                                                        withBlock:^{[_controller stopAddingProjects];}];
    
    MGLine *doneButtonLine = [MGLine lineWithLeft:done right:nil size:CGSizeMake(300, 60)];
    doneButtonLine.underlineType = MGUnderlineNone;
    doneButtonLine.margin = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [projectsTableWrapper.middleLines addObject:projectTable];
    [projectsTableWrapper.bottomLines addObject:doneButtonLine];
    [((MGScrollView*)self.view).boxes addObject:projectsTableWrapper];
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)displayProjects {
    
    _projects = [BBCollectionHelper getUserProjects:[_controller getSightingProjects] inYesNotInNo:NO];
    [projectTable.middleLines removeAllObjects];
    
    for (BBProject *project in _projects) {
        BBImage* projectImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *avatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        avatar.margin = UIEdgeInsetsZero;
        MGLine *projectTextDescription = [MGLine lineWithLeft:project.name right:nil size:CGSizeMake(230, 40)];
        projectTextDescription.underlineType = MGUnderlineNone;
        __weak MGLine *projectDescription = [MGLine lineWithLeft:avatar right:projectTextDescription size:CGSizeMake(280, 40)];
        projectDescription.onTap=^{
            [_controller addSightingProject:project.identifier];
            [projectDescription removeFromSuperview];
            [projectTable layoutWithSpeed:0.3 completion:nil];          
            [self displayProjects];
        };
        projectDescription.underlineType = MGUnderlineNone;
        projectDescription.margin = UIEdgeInsetsMake(10, 10, 0, 0);
        [projectTable.middleLines addObject:projectDescription];
    }
    
    if(_projects.count < 1) {
        MGLine *noMoreProjects = [MGLine lineWithLeft:@"No more projects to add!" right:nil size:CGSizeMake(200, 40)];
        noMoreProjects.font = HEADER_FONT;
        noMoreProjects.margin = UIEdgeInsetsMake(10, 10, 0, 10);
        [projectTable.middleLines addObject:noMoreProjects];
    }
    
    [((MGScrollView*)self.view) layoutWithSpeed:0.3 completion:nil];
}


#pragma mark -
#pragma mark - Delegate and Event Handling


-(NSArray*)getUsersProjects {
    [BBLog Log:@"BBProjectSelectController.getUsersProjects"];
    
    BBApplication *appData = [BBApplication sharedInstance];
    
    return appData.authenticatedUser.projects;
}

-(void)addSightingProject:(NSString*)projectId {
    [BBLog Log:@"BBProjectSelectController.addSightingProject:"];
    
    [_controller addSightingProject:projectId];
}

-(void)removeSightingProject:(NSString*)projectId {
    [BBLog Log:@"BBProjectSelectController.removeSightingProject:"];
    
    [_controller removeSightingProject:projectId];
}

-(NSArray*)getSightingProjects {
    [BBLog Log:@"BBProjectSelectController.getSightingProjects"];
    
    return [_controller getSightingProjects];
}

-(void)stopAddingProjects {
    
}


@end