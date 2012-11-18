//
//  BBProjectSelectController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBProjectSelectController.h"

@implementation BBProjectSelectController {
    MGScrollView *projectSelectView;
}


@synthesize controller = _controller;
@synthesize projects = _projects;

-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate {
    [BBLog Log:@"BBProjectSelectController.initWithDelegate"];
    
    self = [super init];
    
    _controller = delegate;
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBProjectSelectController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [UIColor whiteColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    projectSelectView = (MGScrollView*)self.view;
}


-(void)viewDidLoad {
    [BBLog Log:@"BBProjectSelectController.viewDidLoad"];
    
    [super viewDidLoad];
    
    //_projects = [BBCollectionHelper getUserProjects:[_controller getSightingProjects] inYesNotInNo:NO];
    
    //[self displayViewControls];
}


-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBProjectSelectController.viewWillAppear"];
    
    // this may have changed since last view display
    
    [self displayViewControls];
}


-(void)displayViewControls {
    [BBLog Log:@"BBProjectSelectController.displayViewControls"];
    
    _projects = [BBCollectionHelper getUserProjects:[_controller getSightingProjects] inYesNotInNo:NO];
    
    MGTableBox *projectTable = [BBUIControlHelper createMGTableBoxWithSize:CGSizeMake(280, 50)
                                                           andBGColor:[UIColor whiteColor]
                                                           andHeading:@"Add a Project"
                                                           andPadding:UIEdgeInsetsZero];
    
    for (BBProject *project in _projects) {
        BBImage* projectImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *avatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        avatar.margin = UIEdgeInsetsZero;
        
        __weak MGLine *projectDescription = [MGLine lineWithLeft:avatar right:project.name size:CGSizeMake(250, 40)];
        projectDescription.onTap=^{
            [_controller addSightingProject:project.identifier];
            [projectDescription removeFromSuperview];
        };
        [projectTable.middleLines addObject:projectDescription];
    }
    
    if(_projects.count <= 0) {
        [projectTable.middleLines addObject:[MGLine lineWithLeft:@"No more to add" right:nil size:CGSizeMake(200, 40)]];
    }
    
    CoolMGButton *done = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40)
                                                         andTitle:@"Done"
                                                        withBlock:^{[_controller stopAddingProjects];}];
    
    [projectTable.bottomLines addObject:[MGLine lineWithLeft:nil right:done size:CGSizeMake(280, 40)]];
    [projectSelectView.boxes addObject:projectTable];
    //[projectSelectView.boxes addObject:done];
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

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

-(void)startAddingProjects {
    
}

@end