/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE: 
 
 This VC is used to display a project in a list. Allows users to join, leave or browse the project
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProjectItemController.h"
#import "BBProject.h"
#import "BBImage.h"
#import "BBProject.h"
#import "BBProjectId.h"
#import "BBMediaResource.h"
#import "BBAuthenticatedUser.h"
#import "BBUIControlHelper.h"


@interface BBProjectItemController ()

@property (nonatomic,strong) BBProject* project;

@end


@implementation BBProjectItemController


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
    
    self.view = [self render];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark - Utilities and Helpers


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MGBox*)render {
    [BBLog Log:@"BBStreamController.renderProject"];
    
    BBProject* project = self.project;
    
    //MGScrollView *streamView = (MGScrollView*)self.view;
    BBImage *avatarImage = [self getImageWithDimension:@"Square100" fromArrayOf:project.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:IPHONE_PROJECT_AVATAR_SIZE];
    
    MGLine *projectName = [MGLine lineWithLeft:project.name right:nil size:CGSizeMake(280, 40)];
    projectName.font = HEADER_FONT;
    
    NSString *multiLineDisplay = [NSString stringWithFormat:@"%i members \n%i observations \n%i posts", project.userCount, project.observationCount, project.postCount];
    MGLine *projectStats = [MGLine lineWithLeft:avatar multilineRight:multiLineDisplay width:290 minHeight:100];
    projectStats.underlineType = MGUnderlineNone;
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_PROJECT_DESCRIPTION];
    info.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [info.topLines addObject:projectName];
    [info.middleLines addObject:projectStats];
    
    MGLine *description = [MGLine lineWithMultilineLeft:project.description right:nil width:280 minHeight:30];
    description.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    description.underlineType = MGUnderlineNone;
    [info.middleLines addObject:description];
    
    BBApplication* appData = [BBApplication sharedInstance];
    BBProject* projectInUserList = [self getProjectWithIdentifier:project.identifier fromArrayOf:appData.authenticatedUser.projects];
    
    BBProjectId *projJoinLeave = [[BBProjectId alloc]initWithProjectId:project.identifier];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    if(projectInUserList) {
        
        CoolMGButton *leaveButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 290, 40) andTitle:@"Leave Project" withBlock:^ {
            [manager postObject:projJoinLeave delegate:projJoinLeave];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:self.project forKey:@"project"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectLeft" object:self userInfo:userInfo];
            
            [self.view setNeedsDisplay];
        }];
        
        [info.bottomLines addObject:leaveButton];
    }
    else
    {
        __weak BBProjectItemController *this = self;
        
        CoolMGButton *joinButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Join" withBlock:^{
            [manager postObject:projJoinLeave delegate:projJoinLeave];
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:self.project forKey:@"project"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectJoined" object:self userInfo:userInfo];
            
            [this.view setNeedsDisplay];
        }];
        
        CoolMGButton *browseButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Browse" withBlock:^{
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            [userInfo setObject:[NSString stringWithString:project.identifier] forKey:@"groupId"];
            [userInfo setObject:[NSString stringWithString:project.name] forKey:@"name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBrowseTapped" object:self userInfo:userInfo];
        }];

        MGLine *joinBrowseLine = [MGLine lineWithLeft:browseButton right:joinButton size:CGSizeMake(290, 40)];
        
        [info.bottomLines addObject:joinBrowseLine];
    }
    
    return info;
}


@end