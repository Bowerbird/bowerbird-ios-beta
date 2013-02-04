/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Form to choose a sighting Note Description to add to the contribution
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingNoteAddDescriptionController.h"
#import "BBSightingNoteEditDescriptionController.h"
#import "MGHelpers.h"
#import "BBUIControlHelper.h"
#import "BBCollectionHelper.h"
#import "BBSightingNoteDescription.h"


@implementation BBSightingNoteAddDescriptionController {
    MGTableBox *descriptionTableWrapper;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize descriptionsNotSelected = _descriptionsNotSelected;


#pragma mark -
#pragma mark - Constructors


-(BBSightingNoteAddDescriptionController *)initWithDescriptions:(NSArray*)selectedDescriptions {
    [BBLog Log:@"BBSightingNoteAddDescriptionController.initWithDescriptions:"];
    
    self = [super init];
    
    // grab all the descriptions
    NSArray *allDescriptions = [BBSightingNoteDescription getSightingNoteDescriptions];
    
    // get a subset of descriptions which aren't in selectedDescriptions already
    __block NSMutableArray *displayDescriptions = [[NSMutableArray alloc]init];

    // find the descriptions that have not been added to the sighting yet
    [allDescriptions enumerateObjectsUsingBlock:^(BBSightingNoteDescription *d, NSUInteger idx, BOOL *stop) {
        __block BOOL found = NO;
        [selectedDescriptions enumerateObjectsUsingBlock:^(BBSightingNoteDescription *c, NSUInteger idx, BOOL *stop) {
            if([c.identifier isEqualToString:d.identifier]){
                found = YES;
                *stop = YES;
            }
        }];
        
        if(!found) [displayDescriptions addObject:d];
    }];
    
    _descriptionsNotSelected = [[NSArray alloc]initWithArray:displayDescriptions];
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    // create the scroll view with table displaying unselected descriptions
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    
    descriptionTableWrapper = [MGTableBox box];
    [self displayDescriptionsInTable];
    [((MGScrollView *)self.view).boxes addObject:descriptionTableWrapper];
    
    [(MGScrollView*)self.view layout];
}

-(void)displayDescriptionsInTable {
    // get the descriptions for each subset. Add to table under subset heading:
    NSArray *descriptionGroups = [[NSArray alloc]initWithObjects:@"lookslike",@"wherefound",@"whatitdoes",@"cultural",@"other", nil];
    
    // for each group, add a table to the description table wrapper.
    for (NSString* groupName in descriptionGroups) {
        
        // take the group name, grab the items, add them to the table under group name heading with tap action;
        NSArray *groupItems = [BBCollectionHelper getObjectsFromCollection:_descriptionsNotSelected
                                                               withKeyName:@"group"
                                                              equalToValue:groupName];
        
        if(groupItems.count > 0){
            
            MGTableBox *groupTable = [MGTableBox boxWithSize:CGSizeMake(300, 40)];
            groupTable.margin = UIEdgeInsetsMake(10, 0, 0, 0);
            
            // add this group to the list of groups:
            MGLine *groupHeading = [MGLine lineWithLeft:((BBSightingNoteDescription*)[groupItems objectAtIndex:0]).label right:nil size:CGSizeMake(300, 30)];
            groupHeading.padding = UIEdgeInsetsMake(5, 10, 5, 0);
            groupHeading.underlineType = MGUnderlineNone;
            [groupTable.topLines addObject:groupHeading];

            MGTableBoxStyled *groupItemTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 40)];
            
            for (BBSightingNoteDescription *description in groupItems) {
                MGLine *descriptionLine = [MGLine lineWithLeft:description.name right:[BBUIControlHelper arrow] size:CGSizeMake(300, 50)];
                descriptionLine.padding = UIEdgeInsetsMake(5, 5, 5, 5);
                descriptionLine.font = HEADER_FONT;
                [groupItemTable.middleLines addObject:descriptionLine];
                descriptionLine.onTap = ^{
                    BBSightingNoteEditDescriptionController *sightingNoteEditDescription = [[BBSightingNoteEditDescriptionController alloc]initWithDescription:description];
                    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:sightingNoteEditDescription animated:YES];
                };
            }
            
            [groupTable.middleLines addObject:groupItemTable];
            [descriptionTableWrapper.middleLines addObject:groupTable];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    self.title = @"Choose Description";
}


@end