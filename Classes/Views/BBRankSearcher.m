//
//  BBRankSearcher.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 6/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBRankSearcher.h"

@interface BBRankSearcher()

@property (nonatomic,strong) id<BBRankDelegateProtocol> controller;

@end

@implementation BBRankSearcher {
    MGBox* currentClassification;
    MGTableBoxStyled *searchResults;
    MGTableBoxStyled *searchParameters;
}

@synthesize controller = _controller;

-(BBRankSearcher*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate {
    
    self = [super init];
    
    _controller = delegate;
    //[self displayCurrentClassification];
    
    [self displayControls];
    
    return self;
}

-(void)displayControls {
    [BBLog Log:@"BBRankSearcher.displayControls"];
    
    searchParameters = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 200)];
    
    // add top level instructions
    MGBox *instructionBox = [MGBox boxWithSize:CGSizeMake(300, 100)];
    
    // add filter boxes
    MGBox *filterBox = [MGBox boxWithSize:CGSizeMake(300, 100)];
    
    // add search box
    MGBox *searchBox = [MGBox boxWithSize:CGSizeMake(300, 100)];
    UITextField *searchTextField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 300, 30) andPlaceholder:@"Start typing to search..." andDelegate:self];
    
    [searchTextField  addTarget:self
                         action:@selector(changeSearchQuery:)
               forControlEvents:UIControlEventEditingChanged];
    searchTextField.returnKeyType = UIReturnKeyDone;
    
    MGLine *searchTextFieldLine = [MGLine lineWithLeft:searchTextField right:nil size:CGSizeMake(300,40)];
    [searchBox.boxes addObject:searchTextFieldLine];
    
    searchResults = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 100)];
    
    [self.boxes addObject:searchBox];
    [self.boxes addObject:searchResults];
    [self layout];
}

// trigger changes to the model via the controller protocols
-(void)changeSearchQuery:(UITextField*)textField {
    [_controller loadRankForQuery:textField.text];
}

-(void)displayCurrentClassification {
    [BBLog Log:@"BBRankBrowser.displayCurrentClassification:"];
    
    BBClassification *selectedClassification = [_controller getCurrentClassification];
    MGTableBoxStyled *classificationChooser = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 120)];

    [classificationChooser.middleLines addObject:[BBUIControlHelper createSelectedClassification:selectedClassification forSize:CGSizeMake(300, 120)]];
    
    if(selectedClassification.category) {
        CoolMGButton *chooseClassification = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 290, 40) andTitle:@"Select this Identification" withBlock:^{
            
            [_controller setSelectedClassification:selectedClassification];
        }];
        
        chooseClassification.margin = UIEdgeInsetsMake(0, 10, 10, 10);
        [classificationChooser.bottomLines addObject:chooseClassification];
    }
    
    [self.boxes addObject:classificationChooser];
    [self layout];
}

-(void)displayRanks:(NSArray*)ranks forQuery:(NSString*)query {
    [BBLog Log:@"BBRankBrowser.displayRanks"];
    
    MGTableBoxStyled *this = searchResults;//[MGTableBoxStyled boxWithSize:CGSizeMake(310, 100)];
    [searchResults.middleLines removeAllObjects];
    UIImage *arrow = [BBUIControlHelper arrow];
    
    NSString*queryText = [query lowercaseString];
    
    for (BBClassification *classification in ranks) {
        
        NSString *highlightedName = [classification.name stringByReplacingOccurrencesOfString:queryText
                                                                                   withString:[NSString stringWithFormat:@"<span class='bold_style'>%@</span>", queryText]
                                                                                      options:NSCaseInsensitiveSearch
                                                                                        range:NSMakeRange(0, classification.name.length - 1)];
        
        NSString *highlightedTaxonomy = [classification.taxonomy stringByReplacingOccurrencesOfString:queryText
                                                                                   withString:[NSString stringWithFormat:@"<span class='bold_style'>%@</span>", queryText]
                                                                                      options:NSCaseInsensitiveSearch
                                                                                        range:NSMakeRange(0, classification.taxonomy.length - 1)];
        
        NSString *highlightedCommonName = [classification.allCommonNames stringByReplacingOccurrencesOfString:queryText
                                                                                                   withString:[NSString stringWithFormat:@"<span class='bold_style'>%@</span>", queryText]
                                                                                                      options:NSCaseInsensitiveSearch
                                                                                                        range:NSMakeRange(0, classification.allCommonNames.length > 0 ? classification.allCommonNames.length - 1 : 0)];
        
        NSString *highlightedRank = [NSString stringWithFormat:@"%@\nTaxonomy: %@\nCommon Names: %@", highlightedName, highlightedTaxonomy, highlightedCommonName];
        
        NMCustomLabel *highlightedText = [[NMCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
        highlightedText.text = highlightedRank;

        [highlightedText setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]]];
        [highlightedText setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] color:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]] forKey:@"bold_style"];
        highlightedText.kern = -0.5;
        highlightedText.lineHeight = 12;
        
        MGLine *classificationLine = [MGLine lineWithLeft:highlightedText right:arrow size:CGSizeMake(290,60)];
        
        classificationLine.padding = UIEdgeInsetsMake(0, 5, 5, 5);
        classificationLine.onTap = ^{[_controller setSelectedClassification:classification];};
        
        [this.middleLines addObject:classificationLine];
    }
    
    [self layout];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}


@end