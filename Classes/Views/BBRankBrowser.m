/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBRankBrowser.h"
#import "BBHelpers.h"
#import "SVProgressHUD.h"
#import "BBUIControlHelper.h"
#import "BBClassification.h"


@interface BBRankBrowser()

@property (nonatomic,strong) id<BBRankDelegateProtocol> controller;

@end


@implementation BBRankBrowser {
    MGBox* currentClassification;
    MGTableBoxStyled* classificationBrowser;
    MGBox* loader;
}


@synthesize controller = _controller;


-(BBRankBrowser*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate {
    
    self = [super init];
    
    _controller = delegate;
    
    [self displayCurrentClassification];
    //[SVProgressHUD show];
    
    return self;
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

-(void)displayRankLoader {
    [SVProgressHUD show];
}

-(void)displayRanks:(NSArray*)ranks {
    [BBLog Log:@"BBRankBrowser.displayRanks"];
    
    MGTableBoxStyled *this = [MGTableBoxStyled boxWithSize:CGSizeMake(310, 100)];
    UIImage *arrow = [BBUIControlHelper arrow];

    for (BBClassification *classification in ranks) {
        NSString *nameLabel = [NSString stringWithFormat:@"%@ (%d)", classification.name, classification.speciesCount];
        MGLine *classificationLine = [MGLine lineWithLeft:nameLabel right:arrow size:CGSizeMake(300, 40)];
        classificationLine.padding = UIEdgeInsetsMake(0, 5, 5, 5);
        classificationLine.onTap = ^{[_controller loadNextRankForClassification:classification];};
        
        [this.middleLines addObject:classificationLine];
    }

    [SVProgressHUD dismiss];
    
    [self.boxes addObject:this];
    
    [self layout];
}


@end