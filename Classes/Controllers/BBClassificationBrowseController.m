//
//  BBClassificationController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 3/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBClassificationBrowseController.h"

@implementation UINavigationBar (custom)

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated;
{
    BBAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.navController popViewControllerAnimated:NO];
    
    return delegate.navController.navigationItem;
}

@end


@implementation BBClassificationBrowseController {
    BBClassificationSelector *currentIdentification;
    MGTableBoxStyled *classificationBrowser;
    MGBox *currentIdentificationBox;
}

// do a first pass to load the first level ranks
-(id)init {
    [BBLog Log:@"BBClassificationBrowseController.init"];
 
    self = [super init];
    
    currentIdentification = [[BBClassificationSelector alloc]init];
    
    return self;
}


-(BBClassificationBrowseController*)initWithClassification:(BBClassificationSelector*)classification {
    [BBLog Log:@"BBClassificationBrowseController.initWithIdentification"];
    
    self = [super init];
    
    currentIdentification = classification;
    
    return self;
}


-(void)loadView {
    [BBLog Log:@"BBClassificationBrowseController.loadView"];

    self.view = [[BBRankBrowser alloc]initWithDelegate:self];
    self.view.backgroundColor = [self backgroundColor];
    
    [self getRanks];
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


-(void)cancelClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelIdentification" object:nil userInfo:nil];
}

-(void)getRanks {
    [BBLog Log:@"BBClassificationBrowseController.getNextRank"];
    
    NSString *query;
    
    if(currentIdentification.currentClassification) {
        query = [NSString stringWithFormat:@"query=%@&field=%@", currentIdentification.currentClassification.name, currentIdentification.currentRank];
    }
    else {
        query = [NSString stringWithFormat:@"query=&field=%@", currentIdentification.currentRank];
    }
    
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/species?%@&%@", [BBConstants RootUriString], query, @"X-Requested-With=XMLHttpRequest"];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
}


-(void)displayCurrentClassification {
    [BBLog Log:@"BBClassificationBrowseController.displayCurrentClassification"];
    
    //[((MGTableBoxStyled*)self.view).topLines addObject:[BBUIControlHelper createCurrentClassification:currentIdentification.currentClassification forSize:CGSizeMake(300, 100)]];
    
    
}


-(void)displayRankSelector:(NSArray *)ranks {
    [BBLog Log:@"BBClassificationBrowseController.displayRankSelector"];
    
    
}


#pragma mark -
#pragma mark - Protocol Implementation


-(void)loadRankForQuery:(NSString*)query {
    [BBLog Log:@"BBClassificationBrowseController.loadRankForQuery:"];
    
    
}

-(BBClassification*)getCurrentClassification {
    [BBLog Log:@"BBClassificationBrowseController.getCurrentClassification:"];
    
    return currentIdentification.currentClassification;
}


-(void)loadNextRankForClassification:(BBClassification*)classification {
    [BBLog Log:@"BBClassificationBrowseController.loadNextRank"];
    
    BBClassificationSelector *nextClassificationSelector = [[BBClassificationSelector alloc]initWithClassification:classification andCurrentRank:[currentIdentification getNextRankQuery]];
    
    BBClassificationBrowseController *nextClassificationBrowseController = [[BBClassificationBrowseController alloc]initWithClassification:nextClassificationSelector];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:nextClassificationBrowseController animated:NO];
}


-(void)setSelectedClassification:(BBClassification*)classification {
    //currentIdentification.currentClassification = classification;
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:classification forKey:@"classification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classificationSelectedForNote" object:self userInfo:userInfo];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBClassificationBrowseController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBClassificationBrowseController.objectLoader:didLoadObject"];
    
    BBRankBrowser* view = (BBRankBrowser*)self.view;
    
    // this ought to be a BBClassificationPaginator
    if([object isKindOfClass:[BBClassificationPaginator class]]) {
        [view displayRanks:((BBClassificationPaginator*)object).ranks];
    }
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBClassificationBrowseController.didLoadObjectDictionary"];

}

@end