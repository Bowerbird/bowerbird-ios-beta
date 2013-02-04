/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassificationBrowseController.h"
#import "BBClassificationSelector.h"
#import "BBClassificationPaginator.h"
#import "BBRankBrowser.h"
#import "BBClassification.h"

/*
@implementation UINavigationBar (custom)

-(UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    BBAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.navController popViewControllerAnimated:NO];
    
    return delegate.navController.navigationItem;
}

@end
*/

@implementation BBClassificationBrowseController {
    BBClassificationSelector *currentIdentification;
    BBClassificationBrowseController *nextClassificationBrowseController;
    MGTableBoxStyled *classificationBrowser;
    MGBox *currentIdentificationBox;
    BOOL isCustom;
}


#pragma mark -
#pragma mark - Constructors


-(id)init {
    [BBLog Log:@"BBClassificationBrowseController.init"];
 
    self = [super init];
    
    if(self){
        currentIdentification = [[BBClassificationSelector alloc]initWithDelegate:self];
    }
    
    return self;
}

-(id)initWithClassification:(BBClassificationSelector*)classification
                   asCustom:(BOOL)custom {
    [BBLog Log:@"BBClassificationBrowseController.initWithIdentification"];
    
    self = [super init];
    
    if(self){
        currentIdentification = classification;
        isCustom = custom;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBClassificationBrowseController.loadView"];

    self.view = [[BBRankBrowser alloc]initWithDelegate:self];
    self.view.backgroundColor = [self backgroundColor];
    
    [currentIdentification getRanks];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
}

-(void)viewDidLoad {
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Cancel"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(cancelClicked)];
    
    self.navigationItem.rightBarButtonItem = btnCancel;
    
    if(currentIdentification.currentClassification != nil && currentIdentification.currentClassification.name != nil) {
        self.title = currentIdentification.currentClassification.name;
    }
    else {
        self.title = @"Identification";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];

    [self.navigationItem setBackBarButtonItem: backButton];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)cancelClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelIdentification" object:nil userInfo:nil];
}

-(void)displayRanks:(NSArray*)ranks {
    
    BBRankBrowser* view;
    
    if(nextClassificationBrowseController) {
        view = (BBRankBrowser*)nextClassificationBrowseController.view;
    }
    else {
        view = (BBRankBrowser*)self.view;
    }
    
    [view displayRanks:ranks];
}


#pragma mark -
#pragma mark - Protocol Implementation


-(BBClassification*)getCurrentClassification {
    [BBLog Log:@"BBClassificationBrowseController.getCurrentClassification:"];
    
    return currentIdentification.currentClassification;
}

-(void)loadNextRankForClassification:(BBClassification*)classification {
    [BBLog Log:@"BBClassificationBrowseController.loadNextRank"];
    
    BBClassificationSelector *nextClassificationSelector = [[BBClassificationSelector alloc]initWithClassification:classification
                                                                                                    andCurrentRank:[currentIdentification getNextRankQuery]
                                                                                                       andDelegate:self];
    
    nextClassificationBrowseController = [[BBClassificationBrowseController alloc]initWithClassification:nextClassificationSelector
                                                                                                asCustom:isCustom];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:nextClassificationBrowseController animated:NO];
}

-(void)setSelectedClassification:(BBClassification*)classification {
    //currentIdentification.currentClassification = classification;
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:classification forKey:@"classification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"identificationSelected" object:self userInfo:userInfo];
}


@end