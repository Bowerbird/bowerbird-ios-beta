/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 This VC is used to display Join/Leave/Browse buttons in a project item vc 
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProjectJoinLeaveController.h"
#import "BBProjectItemController.h"
#import "BBProject.h"
#import "BBImage.h"
#import "BBProject.h"
#import "BBProjectId.h"
#import "BBMediaResource.h"
#import "BBAuthenticatedUser.h"
#import "BBUIControlHelper.h"


@interface BBProjectJoinLeaveController ()

@property (nonatomic,strong) BBProject* project;

@end


@implementation BBProjectJoinLeaveController {
    BOOL isAMember;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize project = _project;


#pragma mark -
#pragma mark - Constructors


-(id)initWithProject:(BBProject*)project {
    [BBLog Log:@"BBProjectItemController.initWithProject:"];
    
    self = [super init];
    
    if(self) {
        self.project = project;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBProject.loadView:"];
    
    [self determineMembership];
    
    self.view = [self render];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self render];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)determineMembership {
    
    BBApplication* appData = [BBApplication sharedInstance];
    BBProject* projectInUserList = [self getProjectWithIdentifier:self.project.identifier fromArrayOf:appData.authenticatedUser.projects];
    
    if(projectInUserList) isAMember = YES;
}


-(MGLine*)render {
    
    MGLine *joinBrowseLine;
    
    BBProjectId *projJoinLeave = [[BBProjectId alloc]initWithProjectId:self.project.identifier];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    //manager.serializationMIMEType = RKMIMETypeJSON;
    //manager.acceptMIMEType = RKMIMETypeJSON;
    
    if(isAMember) {
        
        CoolMGButton *leaveButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 290, 40) andTitle:@"Leave Project" withBlock:^ {
            //[manager deleteObject:projJoinLeave delegate:projJoinLeave];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:self.project forKey:@"project"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectLeft" object:self userInfo:userInfo];
            
            [self updateParentController];
        }];
        
        joinBrowseLine = [MGLine lineWithLeft:leaveButton right:nil size:CGSizeMake(290, 40)];
    }
    else
    {
        CoolMGButton *joinButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Join" withBlock:^{
            //[manager postObject:projJoinLeave delegate:projJoinLeave];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:self.project forKey:@"project"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectJoined" object:self userInfo:userInfo];
            
            [self updateParentController];
        }];
        
        CoolMGButton *browseButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Browse" withBlock:^{
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            [userInfo setObject:[NSString stringWithString:self.project.identifier] forKey:@"groupId"];
            [userInfo setObject:[NSString stringWithString:self.project.name] forKey:@"name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBrowseTapped" object:self userInfo:userInfo];
        }];
        
        joinBrowseLine = [MGLine lineWithLeft:browseButton right:joinButton size:CGSizeMake(290, 40)];
    }
    
    return joinBrowseLine;
}

-(void)updateParentController {
    [(BBProjectItemController*)self.parentViewController displayJoinLeaveController];
};


@end