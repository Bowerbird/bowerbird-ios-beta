//
//  BBRankBrowser.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 5/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBRankBrowser.h"

@interface BBRankBrowser()

@property (nonatomic,strong) id<BBRankDelegateProtocol> controller;

@end

@implementation BBRankBrowser {
    MGBox* currentClassification;
    MGTableBoxStyled* classificationBrowser;
    MGBox* loader;
    MBProgressHUD *progress;
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
    MGLine *classificationChooserTitle = [MGLine lineWithLeft:@"Classification" right:nil size:CGSizeMake(280, 30)];
    classificationChooserTitle.underlineType = MGUnderlineNone;
    classificationChooserTitle.font = HEADER_FONT;
    classificationChooserTitle.padding = UIEdgeInsetsMake(5, 5, 0, 0);
    //[classificationChooser.topLines addObject:classificationChooserTitle];
    [classificationChooser.middleLines addObject:[BBUIControlHelper createSelectedClassification:selectedClassification forSize:CGSizeMake(300, 120)]];

    if(selectedClassification.category) {
        CoolMGButton *chooseClassification = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 290, 40) andTitle:@"Select this Identification" withBlock:^{
            
            [_controller setSelectedClassification:selectedClassification];
            // fire up a dictionary
            // post a notification... 
        }];
        
        chooseClassification.margin = UIEdgeInsetsMake(0, 10, 10, 10);
        [classificationChooser.bottomLines addObject:chooseClassification];
        // we can show the "Use this species" button
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