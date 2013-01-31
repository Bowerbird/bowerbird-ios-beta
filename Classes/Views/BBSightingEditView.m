/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingEditView.h"
#import "BBProject.h"
#import "CoolMGButton.h"
#import "PhotoBox.h"
#import "UIView+MGEasyFrame.h"
#import "BBGuidGenerator.h"
#import "BBMediaEdit.h"
#import "BBSightingEditView.h"
#import "BBMediaResource.h"


@implementation BBSightingEditView 


@synthesize controller = _controller,
            categoryPickerView = _categoryPickerView,
            titleTextField = _titleTextField,
            locationLabel = _locationLabel,
            projectPickerView = _projectPickerView,
            addMediaButton = _addMediaButton,
            changeLocationButton = _changeLocationButton,
            observedOnLabel = _observedOnLabel,
            categoryLabel = _categoryLabel,
            mediaBox = _mediaBox,
            titleTable = _titleTable,
            mediaTable = _mediaTable,
            observedOnTable = _observedOnTable,
            locationTable = _locationTable,
            categoryTable = _categoryTable,
            projectsTable = _projectsTable,
            actionTable = _actionTable;


#pragma mark -
#pragma mark - Constructors


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
    
    MGTableBox *titleTableWrapper = [MGTableBox boxWithSize:CGSizeMake(320, 40)];
    MGLine *titleTableWrapperHeader = [MGLine lineWithLeft:@"Title"
                                                       right:nil
                                                        size:CGSizeMake(300, 30)];
    titleTableWrapperHeader.underlineType = MGUnderlineNone;
    titleTableWrapperHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [titleTableWrapper.topLines addObject:titleTableWrapperHeader];
    
    _titleTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    _titleTextField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                                   andPlaceholder:@"Add a description.."
                                                      andDelegate:self];
    [_titleTextField setReturnKeyType:UIReturnKeyDone];
    [_titleTextField  addTarget:self
                         action:@selector(changeTitle:)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    MGLine *titleLine = [MGLine lineWithSize:CGSizeMake(290, 60)];
    titleLine.padding = UIEdgeInsetsMake(10, 10, 10, 0);
    [titleLine.middleItems addObject:_titleTextField];
    [_titleTable.middleLines addObject: titleLine];
    _titleTable.backgroundColor = [UIColor whiteColor];
    [titleTableWrapper.middleLines addObject:_titleTable];
    
    [self.boxes addObject:titleTableWrapper];
}

-(void)displayObservedOnTable {
    [BBLog Log:@"BBSightingEditView.displayObservedOnTable"];
    
    MGTableBox *observedOnTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *observedOnTableHeader = [MGLine lineWithLeft:@"Observed On"
                                                     right:nil
                                                      size:CGSizeMake(300, 30)];
    observedOnTableHeader.underlineType = MGUnderlineNone;
    observedOnTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [observedOnTableWrapper.topLines addObject:observedOnTableHeader];
    _observedOnTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    _observedOnTable.backgroundColor = [UIColor whiteColor];
    _observedOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 40)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    _observedOnLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    MGLine *observedOnLine = [MGLine lineWithLeft:self.observedOnLabel
                                            right:nil
                                             size:CGSizeMake(280, 60)];
    observedOnLine.padding = UIEdgeInsetsMake(10, 10, 10, 0);
    [_observedOnTable.middleLines addObject:observedOnLine];
    _observedOnTable.onTap = ^{[self.controller createdOnStartEdit];};
    [observedOnTableWrapper.middleLines addObject:_observedOnTable];
    
    [self.boxes addObject:observedOnTableWrapper];
}

-(void)displayMediaTable {
    [BBLog Log:@"BBSightingEditView.displayMediaTable"];
    
    MGTableBox *mediaTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *mediaTableHeader = [MGLine lineWithLeft:@"Media"
                                                   right:nil
                                                    size:CGSizeMake(300, 30)];
    mediaTableHeader.underlineType = MGUnderlineNone;
    mediaTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [mediaTableWrapper.topLines addObject:mediaTableHeader];
    _mediaTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
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
        CoolMGButton *addCameraPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                                       andTitle:@"+ Camera"
                                                                      withBlock:^(void){[self.controller showCamera];}];
        addCameraPhoto.margin = UIEdgeInsetsMake(0, 10, 10, 10);
        CoolMGButton *addLibraryPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                                        andTitle:@"+ Library"
                                                                       withBlock:^(void){[self.controller showLibrary];}];
        addLibraryPhoto.margin = UIEdgeInsetsMake(0, 0, 10, 10);
        MGLine *addMediaLine = [MGLine lineWithLeft:addCameraPhoto
                                              right:addLibraryPhoto
                                               size:CGSizeMake(300, 60)];
        [_mediaTable.bottomLines addObject:addMediaLine];
    }
    _mediaTable.backgroundColor = [UIColor whiteColor];
    [mediaTableWrapper.middleLines addObject:_mediaTable];
    
    [self.boxes addObject:mediaTableWrapper];
}

-(void)displayCategoryTable {
    [BBLog Log:@"BBSightingEditView.displayCategoryTable"];
    
    MGTableBox *categoryTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *categoryTableHeader = [MGLine lineWithLeft:@"Category"
                                              right:nil
                                               size:CGSizeMake(300, 30)];
    categoryTableHeader.underlineType = MGUnderlineNone;
    categoryTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [categoryTableWrapper.topLines addObject:categoryTableHeader];
    _categoryTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
    if([[_controller getCategory] isEqualToString:@""] || [_controller getCategory] == nil)
    {
        _categoryLabel.text = @"Choose a category..";
    }
    MGLine *categoryLine = [MGLine lineWithLeft:_categoryLabel
                                          right:nil
                                           size:CGSizeMake(280, 60)];
    categoryLine.margin = UIEdgeInsetsMake(0, 10, 10, 0);
    [_categoryTable.middleLines addObject:categoryLine];
    _categoryTable.onTap = ^{[self.controller categoryStartEdit];};
    _categoryTable.backgroundColor = [UIColor whiteColor];
    [categoryTableWrapper.middleLines addObject:_categoryTable];
    
    [self.boxes addObject:categoryTableWrapper];
}

-(void)displayLocationTable {
    [BBLog Log:@"BBSightingEditView.displayLocationTable"];
    
    MGTableBox *locationTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *locationTableHeader = [MGLine lineWithLeft:@"Location"
                                                 right:nil
                                                  size:CGSizeMake(300, 30)];
    locationTableHeader.underlineType = MGUnderlineNone;
    locationTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [locationTableWrapper.topLines addObject:locationTableHeader];
    _locationTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
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
    MGLine *addressLine = [MGLine lineWithLeft:@"Address:" right:_locationAddress size:CGSizeMake(280, 60)];
    [_locationTable.middleLines addObject:latLine];
    [_locationTable.middleLines addObject:lonLine];
    [_locationTable.middleLines addObject:addressLine];
    _locationTable.backgroundColor = [UIColor whiteColor];
    _locationTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [locationTableWrapper.middleLines addObject:_locationTable];
    
    [self.boxes addObject:locationTableWrapper];
}

-(void)displayProjectsTable {
    [BBLog Log:@"BBSightingEditView.displayProjectsTable"];
    
    MGTableBox *projectsTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *projectsTableHeader = [MGLine lineWithLeft:@"Projects"
                                                 right:nil
                                                  size:CGSizeMake(300, 30)];
    projectsTableHeader.underlineType = MGUnderlineNone;
    projectsTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [projectsTableWrapper.topLines addObject:projectsTableHeader];
    _projectsTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    _projectsTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    NSArray *projectsInSighting = [_controller getSightingProjects]; // projects the observation is currently In.
    /*
    if(projectsInSighting.count == 0)
    {
        MGLine *addProjectsLine = [MGLine lineWithLeft:@"No Projects Selected.." right:nil size:CGSizeMake(280, 30)];
        addProjectsLine.underlineType = MGUnderlineNone;
        [_projectsTable.middleLines addObject:addProjectsLine];
    }
    */
    for (BBProject* project in projectsInSighting)
    {
        BBImage* projectImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *projectAvatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        projectAvatar.margin = UIEdgeInsetsZero;
        MGLine *projectLine = [MGLine lineWithLeft:projectAvatar right:[UIImage imageNamed:@"arrow.png"] size:CGSizeMake(280, 50)];
        [projectLine.middleItems addObject:project.name];
        projectLine.onTap=^{
            // remove thy self from this table o lordy
            [_controller removeSightingProject:project.identifier];
            // tell the controller to remove from the observation, and add back to the list of projects to choose from.. redraw with no animation.
        };
        
        [_projectsTable.middleLines addObject:projectLine];
    }
    
    if(projectsInSighting.count <= 0) {
        [_projectsTable.middleLines addObject:[MGLine lineWithLeft:@"No Projects in Sighting" right:nil]];
    }
    
    CoolMGButton *addProjectsButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 280, 40) andTitle:@"Add Projects" withBlock:^(void){
        [_controller startAddingProjects];
    }];
    [_projectsTable.bottomLines addObject:addProjectsButton];
    
    [projectsTableWrapper.middleLines addObject:_projectsTable];
    

    [self.boxes addObject:projectsTableWrapper];
    [self layoutWithSpeed:0.2 completion:nil];
}

-(void)displayActionTable {
    [BBLog Log:@"BBSightingEditView.displayActionTable"];
    
    MGTableBox *actionTableWrapper = [MGTableBox boxWithSize:CGSizeMake(310, 40)];
    MGLine *actionTableHeader = [MGLine lineWithLeft:@"Action"
                                                 right:nil
                                                  size:CGSizeMake(300, 30)];
    actionTableHeader.underlineType = MGUnderlineNone;
    actionTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 0);
    [actionTableWrapper.topLines addObject:actionTableHeader];
    _actionTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 200)];
    UIButton *cancel = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 135, 40) andTitle:@"Cancel" withBlock:^(void){[self.controller cancel];}];
    //cancel.margin = UIEdgeInsetsMake(0, 10, 10, 10);
    UIButton *save = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 0, 135, 40) andTitle:@"Save" withBlock:^(void){[self.controller save];}];
    //save.margin = UIEdgeInsetsMake(0, 10, 10, 10);
    MGLine *actionLine = [MGLine lineWithLeft:save right:cancel size:CGSizeMake(280, 60)];
    [_actionTable.bottomLines addObject:actionLine];
    _actionTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [actionTableWrapper.middleLines addObject:_actionTable];
    
    [self.boxes addObject:actionTableWrapper];
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

-(void)addMediaItem:(BBMediaEdit *)media{
    // empty the media table's middle lines and start again:
    NSArray* mediaItems = [self.controller media];
    MGBox *mediaBox = [MGBox boxWithSize:CGSizeMake(280,120)];
    mediaBox.contentLayoutMode = MGLayoutGridStyle;

    [_mediaTable.middleLines removeAllObjects];
    [_mediaTable.bottomLines removeAllObjects];
    for (BBMediaEdit* mediaEdit in mediaItems)
    {
        PhotoBox *photo = [PhotoBox mediaForImage:mediaEdit.image size:CGSizeMake(80, 80)];
        // add an overlay to show that the image is uploading:
        [mediaBox.boxes addObject:photo];
    }
    mediaBox.padding = UIEdgeInsetsMake(10, 10, 10, 0);
    [_mediaTable.middleLines addObject:mediaBox];
    
    if(mediaItems.count < MAX_MEDIA_PER_SIGHTING)// if we haven't reached upper limit (3) display an add more..
    {
        CoolMGButton *addCameraPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                                       andTitle:@"+ Camera"
                                                                      withBlock:^(void){[self.controller showCamera];}];
        addCameraPhoto.margin = UIEdgeInsetsMake(0, 10, 10, 10);
        
        CoolMGButton *addLibraryPhoto = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 135, 40)
                                                                        andTitle:@"+ Library"
                                                                       withBlock:^(void){[self.controller showLibrary];}];
        addLibraryPhoto.margin = UIEdgeInsetsMake(0, 0, 10, 10);
        
        MGLine *addMediaLine = [MGLine lineWithLeft:addCameraPhoto
                                              right:addLibraryPhoto
                                               size:CGSizeMake(300, 60)];
        
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