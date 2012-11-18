//
//  BBObservationView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBSightingEditView.h"

@implementation BBSightingEditView 

@synthesize controller = _controller;
@synthesize categoryPickerView = _categoryPickerView;
@synthesize titleTextField = _titleTextField;
@synthesize locationLabel = _locationLabel;
@synthesize projectPickerView = _projectPickerView;
@synthesize addMediaButton = _addMediaButton;
@synthesize changeLocationButton = _changeLocationButton;
@synthesize observedOnLabel = _observedOnLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize mediaBox = _mediaBox;

@synthesize titleTable = _titleTable,
            mediaTable = _mediaTable,
       observedOnTable = _observedOnTable,
         locationTable = _locationTable,
         categoryTable = _categoryTable,
         projectsTable = _projectsTable,
           actionTable = _actionTable;

#pragma mark -
#pragma mark - Setup and Config

-(BBSightingEditView*)initWithDelegate:(id<BBSightingEditDelegateProtocol>)delegate asObservation:(BOOL)isObservation {
    [BBLog Log:@"BBSightingEditView.initWithMedia:andDelegate:"];
    
    self = [BBSightingEditView scrollerWithSize:CGSizeMake(320, 480)];
    self.contentLayoutMode = MGLayoutTableStyle;
    _controller = delegate;
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    [self displayViewControls:isObservation];
    
    return self;
}

-(void)displayViewControls:(BOOL)forObservation {
    [BBLog Log:@"BBSightingEditView.displayViewControls"];
    
    [self displayTitleTable];
    [self displayObservedOnTable];
    if(forObservation) {
        [self displayMediaTable];
    }
    [self displayCategoryTable];
    [self displayLocationTable];
    [self displayProjectsTable];
    [self displayActionTable];
    
    [self layoutWithSpeed:0.2 completion:nil];
}

#pragma mark -
#pragma mark - Observation Form's Component Tables

-(void)displayTitleTable {
    [BBLog Log:@"BBSightingEditView.displayTitleTable"];
    
    _titleTable = [self createTableWithHeading:@"Title"];
    _titleTextField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40) andPlaceholder:@"Add a description" andDelegate:self];
    [_titleTextField setReturnKeyType:UIReturnKeyDone];
    [_titleTextField  addTarget:self
                         action:@selector(changeTitle:)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    MGLine *titleLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    titleLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [titleLine.middleItems addObject:_titleTextField];
    [_titleTable.middleLines addObject: titleLine];
    
    [self.boxes addObject:_titleTable];
}

-(void)displayObservedOnTable {
    [BBLog Log:@"BBSightingEditView.displayObservedOnTable"];
    
    _observedOnTable = [self createTableWithHeading:@"Observed On"];
    _observedOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    _observedOnLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [_observedOnTable.middleLines addObject:[MGLine lineWithLeft:self.observedOnLabel right:nil size:CGSizeMake(280, 30)]];
    _observedOnTable.onTap = ^{[self.controller createdOnStartEdit];};
    
    [self.boxes addObject:_observedOnTable];
}

-(void)displayMediaTable {
    [BBLog Log:@"BBSightingEditView.displayMediaTable"];
    
    _mediaTable = [self createTableWithHeading:@"Media"];
    NSArray* mediaItems = [self.controller media];
    MGBox *mediaBox = [MGBox boxWithSize:CGSizeMake(280,120)];
    mediaBox.contentLayoutMode = MGLayoutGridStyle;
    for (BBMediaEdit* mediaEdit in mediaItems)
    {
        PhotoBox *photo = [PhotoBox mediaForImage:mediaEdit.image size:CGSizeMake(80, 80)];
        [mediaBox.boxes addObject:photo];
    }
    [_mediaTable.middleLines addObject:mediaBox];
    if(mediaItems.count < MAX_MEDIA_PER_SIGHTING)// if we haven't reached upper limit (3) display an add more..
    {
        UIButton *addCameraPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"+ Camera" withBlock:^(void){[self.controller showCamera];}];
        UIButton *addLibraryPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"+ Library" withBlock:^(void){[self.controller showLibrary];}];
        MGLine *addMediaLine = [MGLine lineWithLeft:addCameraPhoto right:addLibraryPhoto size:CGSizeMake(280, 60)];
        [_mediaTable.bottomLines addObject:addMediaLine];
    }
    
    [self.boxes addObject:_mediaTable];
}

-(void)displayCategoryTable {
    [BBLog Log:@"BBSightingEditView.displayCategoryTable"];
    
    _categoryTable = [self createTableWithHeading:@"Category"];
    _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
    [_categoryTable.middleLines addObject:[MGLine lineWithLeft:_categoryLabel right:nil size:CGSizeMake(280, 30)]];
    _categoryTable.onTap = ^{[self.controller categoryStartEdit];};
    
    [self.boxes addObject:_categoryTable];
}

-(void)displayLocationTable {
    [BBLog Log:@"BBSightingEditView.displayLocationTable"];
    
    _locationTable = [self createTableWithHeading:@"Location"];
    CGPoint latLon = [self.controller getLocationLatLon];
    _locationLatitude = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _locationLatitude.text = [ NSString stringWithFormat:@"%f", latLon.x];
    _locationLongitude = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _locationLongitude.text = [NSString stringWithFormat:@"%f", latLon.y];
    _locationAddress = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
    _locationAddress.lineBreakMode = UILineBreakModeWordWrap;
    _locationAddress.numberOfLines = 0;
    _locationAddress.text = [NSString stringWithFormat:@"%@", _controller.getLocationAddress];
    MGLine *latLine = [MGLine lineWithLeft:@"Latitude:" right:_locationLatitude size:CGSizeMake(280, 30)];
    MGLine *lonLine = [MGLine lineWithLeft:@"Longitude:" right:_locationLongitude size:CGSizeMake(280, 30)];
    MGLine *addressLine = [MGLine lineWithLeft:@"Address" right:_locationAddress size:CGSizeMake(280, 60)];
    [_locationTable.middleLines addObject:latLine];
    [_locationTable.middleLines addObject:lonLine];
    [_locationTable.middleLines addObject:addressLine];
    //_locationTable.onTap = ^{[self.controller locationStartEdit];};
    
    [self.boxes addObject:_locationTable];
}

-(void)displayProjectsTable {
    [BBLog Log:@"BBSightingEditView.displayProjectsTable"];
    
    _projectsTable = [self createTableWithHeading:@"Projects"];

    NSArray *projectsInSighting = [_controller getSightingProjects]; // projects the observation is currently In.
    
    for (BBProject* project in projectsInSighting) {
        
        BBImage* projectImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *projectAvatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        projectAvatar.margin = UIEdgeInsetsZero;
  
        MGLine *projectLine = [MGLine lineWithLeft:projectAvatar right:[UIImage imageNamed:@"arrow.png"] size:CGSizeMake(280, 50)];
        [projectLine.middleItems addObject:project.name];
        
        projectLine.onTap=^{
            // remove thy self from this table o lordy
            
            // tell the controller to remove from the observation, and add back to the list of projects to choose from.. redraw with no animation.
        };
        
        [_projectsTable.middleLines addObject:projectLine];
      }
    
    if(projectsInSighting.count <= 0) {
        [_projectsTable.middleLines addObject:[MGLine lineWithLeft:@"No Projects in Sighting" right:nil]];
    }
    
    // click to show the projects the observation is not in..
    _projectsTable.onTap = ^{[self.controller startAddingProjects];};
    

    [self.boxes addObject:_projectsTable];
    [self layoutWithSpeed:0.2 completion:nil];
}

-(void)displayActionTable {
    [BBLog Log:@"BBSightingEditView.displayActionTable"];
    
    _actionTable = [self createTableWithHeading:@"Action"];
    UIButton *cancel = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"Cancel" withBlock:^(void){[self.controller cancel];}];
    UIButton *save = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"Save" withBlock:^(void){[self.controller save];}];
    MGLine *actionLine = [MGLine lineWithLeft:save right:cancel size:CGSizeMake(280, 60)];
    [_actionTable.bottomLines addObject:actionLine];
    
    [self.boxes addObject:_actionTable];
}

-(void)addSightingProject:(BBProject*)project {
    // add a new row to the projects table...
}

-(MGTableBoxStyled*)createTableWithHeading:(NSString*)heading {
    return [BBUIControlHelper createMGTableBoxStyledWithSize:SIGHTING_TABLE_SIZE
                                                          andBGColor:[UIColor whiteColor]
                                                          andHeading:heading
                                                          andPadding:EDGE_10_PADDING];
}

#pragma mark -
#pragma mark - Delegate and Protocol interaction


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_controller updateTitle];
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    return YES;
//}

// if we encounter a newline character return
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    // enter closes the keyboard
//    if ([string isEqualToString:@"\n"])
//    {
//        [textField resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

// trigger changes to the model via the controller protocols
-(void)changeTitle:(NSString*)title {
    [self.dataSource changeTitle:title];
}

-(void)changeAddress:(NSString*)address {
    [self.dataSource changeAddress:address];
}

-(void)changeObservationDate:(id)sender {
    //[self.dataSource changeDate:self.datePicker.date];
}

-(void)changeLocation:(CGPoint)location {
    [self.dataSource changeLocation:location];
}

-(void)changeCategory:(NSString*)category {
    [self.dataSource changeCategory:category];
}

-(void)removeMediaItem:(BBMediaEdit*)media {
    [self.dataSource removeMedia:media];
}

-(void)addProject:(NSString*)projectId {
    [self.dataSource addProject:projectId];
}

-(void)removeProject:(NSString*)projectId {
    [self.dataSource removeProject:projectId];
}

-(void)addMediaItem:(BBMediaEdit *)media {
    // empty the media table's middle lines and start again:
    NSArray* mediaItems = [self.controller media];
    MGBox *mediaBox = [MGBox boxWithSize:CGSizeMake(280,120)];
    mediaBox.contentLayoutMode = MGLayoutGridStyle;

    [_mediaTable.middleLines removeAllObjects];
    [_mediaTable.bottomLines removeAllObjects];
    for (BBMediaEdit* mediaEdit in mediaItems)
    {
        PhotoBox *photo = [PhotoBox mediaForImage:mediaEdit.image size:CGSizeMake(80, 80)];
        [mediaBox.boxes addObject:photo];
    }
    [_mediaTable.middleLines addObject:mediaBox];
    if(mediaItems.count < MAX_MEDIA_PER_SIGHTING)// if we haven't reached upper limit (3) display an add more..
    {
        UIButton *addCameraPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"+ Camera" withBlock:^(void){[self.controller showCamera];}];
        UIButton *addLibraryPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 40) andTitle:@"+ Library" withBlock:^(void){[self.controller showLibrary];}];
        MGLine *addMediaLine = [MGLine lineWithLeft:addCameraPhoto right:addLibraryPhoto size:CGSizeMake(280, 60)];
        [_mediaTable.bottomLines addObject:addMediaLine];
    }
    [self layoutWithSpeed:0.2 completion:nil];
}

#pragma mark -
#pragma mark - Utilities and Helpers

-(void)updateLatLongDisplay:(CGPoint)location {
    self.locationLatitude.text = [NSString stringWithFormat:@"%f", location.x];
    self.locationLongitude.text = [NSString stringWithFormat:@"%f", location.y];
}

-(void)updateLocationAddress:(NSString*)address {
    self.locationAddress.text = [NSString stringWithFormat:@"%@", address];
}

@end