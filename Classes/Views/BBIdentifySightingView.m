//
//  BBIdentifySightingView.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBIdentifySightingView.h"

@implementation BBIdentifySightingView {
    MGTableBox *identificationTableWrapper;
    MGTableBoxStyled *actionTable, *identificationTable;
}

@synthesize controller = _controller;

-(BBIdentifySightingView*)initWithDelegate:(id<BBIdentifySightingProtocol>)delegate
                                     andSize:(CGSize)size{
    self = [super init];
    
    _controller = delegate;
    self.size = size;
    self.contentLayoutMode = MGLayoutTableStyle;
    [self displayControls];
    
    return self;
}

-(void)displayControls {
    [BBLog Log:@"BBCreateSightingNoteController.displayControls:"];
    
    identificationTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *identificationTableHeader = [MGLine lineWithLeft:@"Identification"
                                                       right:nil
                                                        size:CGSizeMake(300, 30)];
    identificationTableHeader.underlineType = MGUnderlineNone;
    identificationTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [identificationTableWrapper.topLines addObject:identificationTableHeader];
    
    [self displayIdentificationControls]; 
    
    MGTableBox *actionTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310,40)];
    MGLine *actionTableHeader = [MGLine lineWithLeft:@"Action"
                                               right:nil
                                                size:CGSizeMake(300, 30)];
    actionTableHeader.underlineType = MGUnderlineNone;
    actionTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [actionTableWrapper.topLines addObject:actionTableHeader];
    actionTable = [MGTableBoxStyled box];
    actionTable.width = 300;
    [actionTableWrapper.middleLines addObject:actionTable];
    [self displayActionControls];
    
    [self.boxes addObject:identificationTableWrapper];
    [self.boxes addObject:actionTableWrapper];
    [self layoutWithSpeed:0.3 completion:nil];
}

-(void)displayIdentificationControls {
    
    identificationTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 100)];
    [identificationTableWrapper.middleLines addObject:identificationTable];
    
    MGTableBoxStyled *searchTable = [MGTableBoxStyled box]; //boxWithSize:CGSizeMake(300, 200)];
    CoolMGButton *search = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                           andTitle:@"Search"
                                                          withBlock:^{[_controller searchClassifications];}];
    MGLine *searchLine = [MGLine lineWithLeft:search
                                        right:nil
                                         size:CGSizeMake(280, 40)];
    searchLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *searchText = [MGLine lineWithMultilineLeft:@"Type in the scientific or common name and choose your classification from the results"
                                                 right:nil
                                                 width:280
                                             minHeight:30];
    searchText.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    [searchTable.middleLines addObject:searchLine];
    [searchTable.middleLines addObject:searchText];
    
    MGTableBoxStyled *browseTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    CoolMGButton *browse = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                           andTitle:@"Browse"
                                                          withBlock:^{[_controller browseClassifications];}];
    MGLine *browseLine = [MGLine lineWithLeft:browse
                                        right:nil
                                         size:CGSizeMake(280, 40)];
    browseLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *browseText = [MGLine lineWithMultilineLeft:@"Select a classification by navigating the taxonomic ranks"
                                                 right:nil
                                                 width:280
                                             minHeight:30];
    browseText.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    [browseTable.middleLines addObject:browseLine];
    [browseTable.middleLines addObject:browseText];
    
    /*
    MGTableBoxStyled *createTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    CoolMGButton *create = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                           andTitle:@"Create"
                                                          withBlock:^{[_controller createClassification];}];
    MGLine *createLine = [MGLine lineWithLeft:create
                                        right:nil
                                         size:CGSizeMake(280, 40)];
    createLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *createText = [MGLine lineWithMultilineLeft:@"Provide a new classification for your identification"
                                                 right:nil
                                                 width:280
                                             minHeight:30];
    createText.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    [createTable.middleLines addObject:createLine];
    [createTable.middleLines addObject:createText];
    */
    
    [identificationTableWrapper.bottomLines addObject:searchTable];
    [identificationTableWrapper.bottomLines addObject:browseTable];
    //[identificationTableWrapper.bottomLines addObject:createTable];
}

-(void)displayActionControls {
    
    CoolMGButton *save = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                         andTitle:@"Save"
                                                        withBlock:^{[_controller save];}];
    save.margin = UIEdgeInsetsMake(0, 10, 10, 10);
    
    CoolMGButton *cancel = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                           andTitle:@"Cancel"
                                                          withBlock:^{[_controller cancel];}];
    cancel.margin = UIEdgeInsetsMake(0, 0, 10, 10);
    
    MGLine *saveCancelLine = [MGLine lineWithLeft:save
                                            right:cancel
                                             size:CGSizeMake(300, 60)];
    
    saveCancelLine.underlineType = MGUnderlineNone;
    [actionTable.middleLines addObject:saveCancelLine];
}

-(void)displayIdentification:(BBClassification*)classification {
    [identificationTable.middleLines removeAllObjects];
    [identificationTable.middleLines addObject:[BBUIControlHelper createCurrentClassification:classification forSize:CGSizeMake(300, 100)]];
    [self layout];
}

-(void)removeIdentification {
    [identificationTable.middleLines removeAllObjects];
    [self displayIdentificationControls];
}

@end
