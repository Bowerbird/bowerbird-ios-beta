/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassificationSearchController.h"
#import "BBRankSearcher.h"
#import "BBClassificationPaginator.h"
#import "BBClassification.h"


@implementation BBClassificationSearchController {
    BBClassification *currentIdentification;
    BBClassification *classificationQuery;
    NSString* queryText;
}


#pragma mark -
#pragma mark - Constructors


-(id)init {
    [BBLog Log:@"BBClassificationSearchController.init"];
    
    self = [super init];
    
    currentIdentification = nil;
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBClassificationSearchController.loadView"];
    
    self.view = [[BBRankSearcher alloc]initWithDelegate:self];
    self.view.backgroundColor = [self backgroundColor];

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
    self.title = @"Identification";
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)cancelClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelIdentification"
                                                        object:nil
                                                      userInfo:nil];
}


#pragma mark - 
#pragma mark - Protocol Implementation


-(void)setSelectedClassification:(BBClassification*)classification {
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:classification forKey:@"classification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"identificationSelected"
                                                        object:self
                                                      userInfo:userInfo];
}

-(BBClassification*)getCurrentClassification {
    [BBLog Log:@"BBClassificationSearchController.getCurrentClassification:"];
    
    return currentIdentification;
}

-(void)loadRankForQuery:(NSString*)text {
    [BBLog Log:@"BBClassificationSearchController.loadRankForQuery:"];
    
    queryText = text;
    
    if(classificationQuery) classificationQuery = nil;
    
    classificationQuery = [[BBClassification alloc] initWithDelegate:self andQuery:text];
}

-(void)displayRanks:(NSArray*)ranks forQuery:(NSString *)query {
    
    BBRankSearcher* view = (BBRankSearcher*)self.view;
    
    [view displayRanks:ranks forQuery:queryText];
}


@end