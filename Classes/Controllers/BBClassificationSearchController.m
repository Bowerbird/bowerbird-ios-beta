//
//  BBClassificationSearchController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 4/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBClassificationSearchController.h"

@interface BBClassificationSearchController ()

@end

@implementation BBClassificationSearchController {
    BBClassification *currentIdentification;
    NSString* queryText;
}


// do a first pass to load the first level ranks
-(id)init {
    [BBLog Log:@"BBClassificationSearchController.init"];
    
    self = [super init];
    
    currentIdentification = nil;
    
    return self;
}


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


-(void)cancelClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelIdentification" object:nil userInfo:nil];
}



#pragma mark - 
#pragma mark - Protocol Implementation


-(void)setSelectedClassification:(BBClassification*)classification {
    //currentIdentification.currentClassification = classification;
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:classification forKey:@"classification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classificationSelectedForNote" object:self userInfo:userInfo];
}


-(BBClassification*)getCurrentClassification {
    [BBLog Log:@"BBClassificationBrowseController.getCurrentClassification:"];
    
    return currentIdentification;
}

-(void)loadRankForQuery:(NSString*)text {
    [BBLog Log:@"BBClassificationBrowseController.loadRankForQuery:"];
    
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
    
    NSString *query = [NSString stringWithFormat:@"query=%@&pagesize=50", text];
    
    queryText = text;
    
    [SVProgressHUD setStatus:@"Querying Species"];
    
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/species?%@&%@", [BBConstants RootUriString], query, @"X-Requested-With=XMLHttpRequest"];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
}

#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBClassificationSearchController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBClassificationSearchController.didLoadObjectDictionary"];

}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBClassificationBrowseController.didLoadObject"];
    
    BBRankSearcher* view = (BBRankSearcher*)self.view;
    
    // this ought to be a BBClassificationPaginator
    if([object isKindOfClass:[BBClassificationPaginator class]]) {
        [view displayRanks:((BBClassificationPaginator*)object).ranks forQuery:queryText];
    }
    
    [SVProgressHUD dismiss];
}

@end