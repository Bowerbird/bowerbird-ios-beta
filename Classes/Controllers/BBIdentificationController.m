//
//  BBIdentificationController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 4/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBIdentificationController.h"

@interface BBIdentificationController ()

@end

@implementation BBIdentificationController

@synthesize identification = _identification;

-(void)loadView {
    [BBLog Log:@"BBIdentificationController.loadView"];
    
    // create the view for this container
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelIdentification) name:@"cancelIdentification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setClassificationForNote:) name:@"classificationSelectedForNote" object:nil];
    
    //classificationSelectedForNote
    [self displayControls];
}

-(void)displayControls {
    [BBLog Log:@"BBIdentificationController.displayControls:"];
    
    MGTableBoxStyled *identificationTable = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 140)];
    MGLine *identificationTableHeader = [MGLine lineWithLeft:@"Add an identification" right:nil size:CGSizeMake(300, 30)];
    identificationTableHeader.underlineType = MGUnderlineNone;
    identificationTableHeader.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    identificationTableHeader.font = HEADER_FONT;
    [identificationTable.topLines addObject:identificationTableHeader];
    
    CoolMGButton *search = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Search" withBlock:^{
        BBClassificationSearchController *searchController = [[BBClassificationSearchController alloc]init];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:searchController animated:YES];
    }];
    search.margin = UIEdgeInsetsMake(20, 10, 10, 0);
    //[identificationTable.middleLines addObject:search];
    
    CoolMGButton *browse = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Browse" withBlock:^{
        BBClassificationBrowseController *browseController = [[BBClassificationBrowseController alloc]init];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:browseController animated:YES];
    }];
    browse.margin = UIEdgeInsetsMake(20, 10, 10, 0);
    //[identificationTable.middleLines addObject:browse];
    MGLine *searchBrowseLine = [MGLine lineWithLeft:search right:browse size:CGSizeMake(300, 40)];
    searchBrowseLine.underlineType = MGUnderlineNone;
    [identificationTable.middleLines addObject:searchBrowseLine];
    
    MGTableBoxStyled *actionTable = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 140)];
    MGLine *actionTableHeader = [MGLine lineWithLeft:@"Action" right:nil size:CGSizeMake(300, 30)];
    actionTableHeader.underlineType = MGUnderlineNone;
    actionTableHeader.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionTableHeader.font = HEADER_FONT;
    [actionTable.topLines addObject:actionTableHeader];
    
    
    CoolMGButton *save = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Save" withBlock:^{
        //[self cancelNote];
    }];
    save.margin = UIEdgeInsetsMake(20, 10, 10, 0);
    
    CoolMGButton *cancel = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 140, 40) andTitle:@"Cancel" withBlock:^{
        [self cancelNote];
    }];
    cancel.margin = UIEdgeInsetsMake(20, 10, 10, 0);
    
    MGLine *saveCancelLine = [MGLine lineWithLeft:save right:cancel size:CGSizeMake(300, 40)];
    saveCancelLine.underlineType = MGUnderlineNone;
    [actionTable.middleLines addObject:saveCancelLine];
    
    [((MGScrollView*)self.view).boxes addObject:identificationTable];
    [((MGScrollView*)self.view).boxes addObject:actionTable];
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

// Display the current identification
-(void)setCurrentIdentification:(BBIdentification*)identification {
    /*
     This would be implemented along with a delegate method and a custom view
     if identification is indeed displayed on this page..
     */
    
}

-(void)cancelIdentification {
    //[((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    [self.navigationController popToViewController:self animated:NO];
}

-(void)setClassificationForNote:(NSNotification *) notification
{
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBClassification *classification = [userInfo objectForKey:@"classification"];
    
    MGBox *currentClassification = [BBUIControlHelper createSelectedClassification:classification forSize:CGSizeMake(300, 120)];
    
    [((MGScrollView*)self.view).boxes addObject:currentClassification];
    // On some kind of model, we'll set the classification as the identification...
    
    [(MGScrollView*)self.view layout];
}


-(void)cancelNote {
    [self.navigationController popViewControllerAnimated:NO];
}

@end