/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCreateSightingNoteView.h"
#import "BBHelpers.h"
#import "BBUIControlHelper.h"
#import "BBSightingNoteDescriptionCreate.h"
#import "BBClassification.h"
#import "DWTagList.h"


@implementation BBCreateSightingNoteView {
    MGTableBoxStyled *identificationTable, *descriptionTable, *tagsTable, *actionTable;
}


@synthesize controller = _controller;


-(BBCreateSightingNoteView*)initWithDelegate:(id<BBSightingNoteEditDelegateProtocol>)delegate
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
 
    MGTableBox *descriptionTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *descriptionTableHeader = [MGLine lineWithLeft:@"Description"
                                                    right:nil
                                                     size:CGSizeMake(300, 30)];
    descriptionTableHeader.underlineType = MGUnderlineNone;
    descriptionTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [descriptionTableWrapper.topLines addObject:descriptionTableHeader];
    descriptionTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    [descriptionTableWrapper.middleLines addObject:descriptionTable];
    [self displayDescriptionControls];
    
    
    MGTableBox *tagsTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *tagsTableHeader = [MGLine lineWithLeft:@"Tags"
                                             right:nil
                                              size:CGSizeMake(300, 30)];
    tagsTableHeader.underlineType = MGUnderlineNone;
    tagsTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [tagsTableWrapper.topLines addObject:tagsTableHeader];
    tagsTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    [tagsTableWrapper.middleLines addObject:tagsTable];
    [self displayTagsControls];
    
    
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
    
    [self.boxes addObject:descriptionTableWrapper];
    [self.boxes addObject:tagsTableWrapper];
    [self.boxes addObject:actionTableWrapper];
    [self layoutWithSpeed:0.3 completion:nil];
}

-(void)displayDescriptionControls {
    CoolMGButton *addDescription = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                                   andTitle:@"Add Description" withBlock:^{
        [_controller startAddDescription];
    }];
    addDescription.margin = UIEdgeInsetsMake(10, 10, 10, 0);
    [descriptionTable.bottomLines addObject:addDescription];
}

-(void)displayTagsControls {
    CoolMGButton *addTag = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                           andTitle:@"Add Tags" withBlock:^{
        [_controller startAddTag];
    }];
    addTag.margin = UIEdgeInsetsMake(10, 10, 10, 0);
    [tagsTable.bottomLines addObject:addTag];
}

-(void)displayTags {
    [BBLog Log:@"BBCreateSightingView.displayTags"];

    // clear current tag view
    [tagsTable.middleLines removeAllObjects];

    // grab tags from controller
    NSArray *tags = [_controller getTags];
    
    if(tags) {
    
        DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
        [tagList setTags:tags];
    
        double minHeight = tagList.fittedSize.height;
        
        MGBox *tagBox = [MGBox boxWithSize:CGSizeMake(280, minHeight)];
        tagBox.margin = UIEdgeInsetsMake(10, 10, 0, 10);
        
        if(tagBox.subviews.count > 0 ){
            [[tagBox.subviews objectAtIndex:0] removeFromSuperview];
        }
        
        [tagBox addSubview:tagList];
    
        [tagsTable.middleLines addObject:tagBox];
    }
    
    [self layout];
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

-(void)displayDescriptions {
    [BBLog Log:@"BBCreateSightingView.displayDescriptions"];
    
    NSArray *descriptions = [_controller getDescriptions];
    [descriptionTable.middleLines removeAllObjects];
    
    // display descriptions
    for(BBSightingNoteDescriptionCreate *desc in descriptions)
    {
        __block BBSightingNoteDescription *sightingNoteDesc = [BBSightingNoteDescription getDescriptionByIdentifier:desc.key];
        
        MGLine *descriptionTitle = [MGLine lineWithLeft:sightingNoteDesc.name right:nil size:CGSizeMake(280, 30)];
        descriptionTitle.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        descriptionTitle.font = HEADER_FONT;
        
        MGLine *descriptionText = [MGLine lineWithMultilineLeft:desc.value right:nil width:280 minHeight:30];
        descriptionText.underlineType = MGUnderlineNone;
        descriptionText.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        
        if([_controller respondsToSelector:@selector(editDescription:)]) {
            descriptionTitle.onTap = ^{[_controller editDescription:desc];};
            descriptionText.onTap = ^{[_controller editDescription:desc];};
        }
        
        [descriptionTable.middleLines addObject:descriptionTitle];
        [descriptionTable.middleLines addObject:descriptionText];
    }
    
    [self layout];
}

@end