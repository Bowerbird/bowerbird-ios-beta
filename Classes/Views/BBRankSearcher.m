/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBRankSearcher.h"
#import "BBHelpers.h"
#import "BBUIControlHelper.h"
#import "NMCustomLabel.h"
#import "NMCustomLabelStyle.h"
#import "BBClassification.h"


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
    
    [self displayControls];
    
    return self;
}

-(void)displayControls {
    [BBLog Log:@"BBRankSearcher.displayControls"];
    
    searchParameters = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 200)];
    
    // add search box
    MGBox *searchBox = [MGBox boxWithSize:CGSizeMake(300, 50)];
    UITextField *searchTextField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 300, 40) andPlaceholder:@"Start typing to search..." andDelegate:self];
    [searchTextField addTarget:self action:@selector(changeSearchQuery:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.returnKeyType = UIReturnKeyDone;
    
    MGLine *searchTextFieldLine = [MGLine lineWithLeft:searchTextField right:nil size:CGSizeMake(300,40)];
    searchTextFieldLine.underlineType = MGUnderlineNone;
    searchTextFieldLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [searchBox.boxes addObject:searchTextFieldLine];
    searchResults = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 100)];
    
    [self.boxes addObject:searchBox];
    [self.boxes addObject:searchResults];
    [self layout];
}

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
    
    MGTableBoxStyled *this = searchResults;
    this.backgroundColor = [UIColor whiteColor];
    [searchResults.middleLines removeAllObjects];
    
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
        
        NMCustomLabel *highlightedText = [[NMCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 230, 120)];
        highlightedText.text = highlightedRank;

        [highlightedText setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]]];
        [highlightedText setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15] color:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]] forKey:@"bold_style"];
        highlightedText.kern = -0.5;
        highlightedText.lineHeight = 18;
        
        PhotoBox *categoryIcon = [BBUIControlHelper createCategoryImageBoxForCategory:classification.category withSize:CGSizeMake(40, 40)];
        categoryIcon.margin = UIEdgeInsetsMake(5, 5, 70, 5);
        MGLine *classificationLine = [MGLine lineWithLeft:categoryIcon right:highlightedText size:CGSizeMake(300,130)];
        
        classificationLine.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        classificationLine.onTap = ^{[_controller setSelectedClassification:classification];};
        
        [this.middleLines addObject:classificationLine];
    }
    
    [self layout];
}

-(NSString *)trimWhitespace {
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    
    NSString *result = [mStr copy];
    return result;
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