//
//  BBObservationEditController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBObservationEditController.h"

@implementation BBObservationEditController

@synthesize observation = _observation;
@synthesize observationEditView = _observationEditView;
@synthesize editingMedia = _editingMedia;
@synthesize locationManager = _locationManager;
@synthesize currentUserCoordinate = _currentUserCoordinate;
@synthesize spinner = _spinner;
@synthesize currentLocationActivityIndicatorView = _currentLocationActivityIndicatorView;

#pragma mark -
#pragma mark - Setup and Render

-(BBObservationEditController*)initWithMedia:(BBMediaEdit*)observationMedia {
    [BBLog Log:@"BBObservationEditController.initWithMedia:"];
    
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    self.observation = [[BBSightingEdit alloc]init];
    self.observation.createdOn = [NSDate date];
    [self.observation.media addObject:observationMedia];
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBObservationEditController.loadView"];
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.observationEditView = [[BBSightingEditView alloc]initWithDelegate:self];
    self.view = self.observationEditView;
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBObservationEditController.viewWillAppear"];
    
    // perhaps here we load the map...
    BBLocationSelectController *locationSelectController = [[BBLocationSelectController alloc]initWithDelegate:self];
    MGLine *locationPickerLine = [MGLine lineWithLeft:locationSelectController.view right:nil size:CGSizeMake(280, 240)];

    [((BBSightingEditView*)self.view).locationTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view).locationTable.bottomLines addObject:locationPickerLine];
    [((BBSightingEditView*)self.view) scrollToView:locationPickerLine withMargin:8];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBObservationEditController.viewDidLoad"];
    
    [super viewDidLoad];
}

-(void)pauseScrolling {
    ((BBSightingEditView*)self.view).scrollEnabled = NO;
}

-(void)resumeScrolling {
    ((BBSightingEditView*)self.view).scrollEnabled = YES;
}

#pragma mark -
#pragma mark - Title

-(NSString*)title {
    [BBLog Log:@"BBObservationEditController.title"];
    
    return self.observation.title;
}

-(void)changeTitle {
    [BBLog Log:@"BBObservationEditController.changeTitle"];
    
    self.observation.title = self.observationEditView.titleTextField.text;
}

-(void)changeTitle:(NSString *)title {
    [BBLog Log:@"BBObservationEditController.title"];
    
    self.observation.title = title;
}

#pragma mark -
#pragma mark - CreatedOn

-(NSDate*)createdOn {
    [BBLog Log:@"BBObservationEditController.createdOn"];
    
    return self.observation.createdOn;
}

-(void)createdOnStartEdit {
    [BBLog Log:@"BBObservationEditController.createdOnStartEdit"];
    
    [self pauseScrolling];
    ((BBSightingEditView*)self.view).observedOnTable.onTap=^{};
    
    BBDateSelectController *dateSelector = [[BBDateSelectController alloc]initWithDelegate:self];
    MGLine *datePickerLine = [MGLine lineWithSize:CGSizeMake(280, 256)];
    datePickerLine.middleItems = (id)dateSelector.view;
    [((BBSightingEditView*)self.view).observedOnTable.bottomLines addObject:datePickerLine];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
    [((BBSightingEditView*)self.view) scrollToView:datePickerLine withMargin:8];
}

-(void)updateCreatedOn:(NSDate*)date {
    [BBLog Log:@"BBObservationEditController.updateCreatedOn:"];
    
    if(date != nil) {
        self.observation.createdOn = date;
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        ((BBSightingEditView*)self.view).observedOnLabel.text = [dateFormatter stringFromDate:self.observation.createdOn];
    }
}

-(void)createdOnStopEdit {
    [BBLog Log:@"BBObservationEditController.createdOnStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).observedOnTable.onTap=^{[((BBSightingEditView*)self.view).controller createdOnStartEdit];};
    
    [((BBSightingEditView*)self.view).observedOnTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

#pragma mark -
#pragma mark - Media

-(void)showCamera {
    [BBLog Log:@"BBContributionController.showCamera"];
    
    //self.contributionType = BBContributionNone;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing the Camera"
                                                        message:@"The device doesn't support a Camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.app.navController popViewControllerAnimated:NO];
    }
}

-(void)showLibrary {
    [BBLog Log:@"BBContributionController.showLibrary"];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing the photo library"
                                                        message:@"The device doesn't support the photo library"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.app.navController popViewControllerAnimated:NO];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [BBLog Log:@"BBContributionController.imagePickerController:"];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* image;
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        [BBLog Log:@"BBContributionController: source is library"];
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else
    {
        [BBLog Log:@"BBContributionController: source is edited image"];
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    BBMediaEdit *mediaEdit = [[BBMediaEdit alloc]init];
    mediaEdit.image = image;
    
    // add this to the list of media in our observation model
    [_observation.media addObject:mediaEdit];
    
    // view will need to redraw this region
    [_observationEditView addMediaItem:mediaEdit];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [BBLog Log:@"BBContributionController.imagePickerControllerDidCancel"];
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(NSArray*)media {
    return self.observation.media;
}

-(void)addMedia {
    [BBLog Log:@"BBObservationEditController.addMedia"];
    
    // display the action sheet, or somthing of that kind..
}

-(void)editMedia:(BBMediaEdit*)media {
    [BBLog Log:@"BBObservationEditController.edit"];
    
    self.editingMedia = media;
    
    BBMediaEditController *mediaEditController = [[BBMediaEditController alloc]initWithDelegate:self
                                                                                       andMedia:self.editingMedia];
    
    [self.app.navController pushViewController:mediaEditController animated:NO];
}

// BBMediaEdit is going to require a client side identifier/guid of some sort, or a local tracking variable
-(void)saveMediaEdit {
    
}

-(void)cancelMediaEdit {
    
}

#pragma mark -
#pragma mark - Category

-(NSString*)category {
    return _observation.category;
}

-(void)updateCategory:(BBCategory*)category {
    _observation.category = category.name;
    
    BBSightingEditView *this = (BBSightingEditView*)self.view;
    [this.categoryTable.middleLines removeAllObjects];
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [category.name lowercaseString]];
    
    PhotoBox *photo = [PhotoBox mediaForImage:[UIImage imageNamed:iconPath] size:CGSizeMake(40,40)];
    MGLine *categoryLine = [MGLine lineWithLeft:photo right:category.name size:CGSizeMake(200, 50)];
    
    [this.categoryTable.middleLines addObject:categoryLine];
    [this layoutWithSpeed:0.3 completion:nil];
}

-(void)categoryStopEdit {
    [BBLog Log:@"BBObservationEditController.categoryStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).categoryTable.onTap=^{[((BBSightingEditView*)self.view).controller categoryStartEdit];};
    
    [((BBSightingEditView*)self.view).categoryTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

-(NSArray*)getCategories {
    [BBLog Log:@"BBObservationEditController.getCategories"];
    
    return self.app.appData.categories;
}

-(void)categoryStartEdit {
    [BBLog Log:@"BBObservationEditController.categoryOnStartEdit"];
    
    [self pauseScrolling];
    ((BBSightingEditView*)self.view).categoryTable.onTap=^{};
    
    BBCategoryPickerController *categoryPicker = [[BBCategoryPickerController alloc]initWithDelegate:self];
    MGLine *categoryPickerLine = [MGLine lineWithSize:CGSizeMake(280, 256)];
    categoryPickerLine.middleItems = (id)categoryPicker.view;
    
    [((BBSightingEditView*)self.view).categoryTable.bottomLines addObject:categoryPickerLine];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
    [((BBSightingEditView*)self.view) scrollToView:((BBSightingEditView*)self.view).categoryTable withMargin:8];
}

#pragma mark -
#pragma mark - Projects

-(void)stopAddingProjects {
    [BBLog Log:@"BBObservationEditController.stopAddingProjects"];
    
    [self resumeScrolling];
    BBSightingEditView *this = (BBSightingEditView*)self.view;
    
    this.projectsTable.onTap=^{[((BBSightingEditView*)self.view).controller startAddingProjects];};
    
    [this.projectsTable.bottomLines removeAllObjects];
    [this layoutWithSpeed:0.3 completion:nil];
}

-(void)startAddingProjects {
    [BBLog Log:@"BBObservationEditController.startAddingProjects"];
    
    [self pauseScrolling];
    
    BBProjectSelectController *projectSelector = [[BBProjectSelectController alloc]initWithDelegate:self];
    MGLine *projectSelectorLine = [MGLine lineWithSize:CGSizeMake(280,256)];
    [projectSelectorLine.middleItems addObject:projectSelector.view];
    
    BBSightingEditView *this = (BBSightingEditView*)self.view;
    //MGLine *testLine = [MGLine lineWithLeft:@"LEFT" right:@"RIGHT" size:CGSizeMake(240,100)];
    //[this.projectsTable.middleLines addObject:testLine];
    
    //[this.projectsTable.bottomLines addObject:projectSelectorLine];
    //this.projectsTable.onTap=^{};
    
    //[this scrollToView:projectSelectorLine withMargin:8];
    [this addSubview:projectSelectorLine];
}

-(NSArray*)getSightingProjects {
    [BBLog Log:@"BBObservationEditController.getSightingProjects"];
    
    return _observation.projects;
}

-(void)removeSightingProject:(NSString*)projectId {
    [BBLog Log:@"BBObservationEditController.removeProject:"];
    
    
}

-(void)addSightingProject:(NSString *)projectId {
    [BBLog Log:@"BBObservationEditController.addSightingProject:"];
    
    
}

#pragma mark -
#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    [BBLog Log:@"BBObservationEditController.locationManager:didUpdateLocation:"];
    
    CLLocation *location = [locations lastObject];
    self.observation.location = CGPointMake(location.coordinate.latitude, location.coordinate.longitude);
    [(BBSightingEditView*)self.view updateLatLongDisplay:self.observation.location];
    [self performCoordinateGeocode:location];
    
    [manager stopUpdatingLocation];
}

-(void)locationStartEdit {
    [BBLog Log:@"BBObservationEditController.locationStartEdit"];
    
    //[self pauseScrolling];
    ((BBSightingEditView*)self.view).locationTable.onTap=^{};
    
    BBLocationSelectController *locationSelectController = [[BBLocationSelectController alloc]initWithDelegate:self];
    //[self.app.navController pushViewController:locationSelectController animated:NO];
    
    MGLine *locationPickerLine = [MGLine lineWithLeft:locationSelectController.view right:nil size:CGSizeMake(280, 240)];
    locationPickerLine.backgroundColor = [UIColor redColor];
    //UIView *locationPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 240)];
    
    //[locationPickerView addSubview:locationSelectController.view];
    //[locationPickerLine addSubview:locationPickerView];
    
    [((BBSightingEditView*)self.view).locationTable.bottomLines addObject:locationPickerLine];
    //locationPickerLine.x = 0;
    //locationPickerLine.y = 0;
    [((BBSightingEditView*)self.view) scrollToView:locationPickerLine withMargin:8];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

-(void)locationStopEdit {
    [BBLog Log:@"BBObservationEditController.locationStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).locationTable.onTap=^{[((BBSightingEditView*)self.view).controller locationStartEdit];};
    
    if([self.app.navController.topViewController isKindOfClass:[BBLocationSelectController class]])
    {
        [self.app.navController popViewControllerAnimated:NO];
    }
}

-(CGPoint)getLocationLatLon {
    [BBLog Log:@"BBObservationEditController.getLocationLatLon"];

    return self.observation.location;
}

-(void)updateLocationLatLon:(CGPoint)location {
    [BBLog Log:@"BBObservationEditController.updateLocationLatLon:"];

    self.observation.location = location;
}

-(NSString*)getLocationAddress {
    [BBLog Log:@"BBObservationEditController.getLocationAddress"];

    return self.observation.address;
}

-(void)updateLocationAddress:(NSString*)address {
    [BBLog Log:@"BBObservationEditController.updateLocationAddress:"];

    self.observation.address = address;
}

-(void)performCoordinateGeocode:(CLLocation*)location {

    __block BBSightingEditView *view = (BBSightingEditView*)self.view;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        NSArray *resultantAddress = [NSArray arrayWithArray:placemarks];
        CLPlacemark *place = [resultantAddress lastObject];
        NSString* address = [NSString stringWithFormat:@"%@, %@ %@ %@", place.thoroughfare, place.locality, place.administrativeArea, place.country];
        
        [BBLog Log:[NSString stringWithFormat:@"Address: %@", address]];
        [self updateLocationAddress:address];
        [view updateLocationAddress:address];
    }];
    
}

#pragma mark -
#pragma mark - Save or Cancel Observation

-(void)save {
    [BBLog Log:@"BBObservationEditController.save"];
    
}

-(void)cancel {
    [BBLog Log:@"BBObservationEditController.cancel"];
    
    [self.app.navController popViewControllerAnimated:NO];
    // notify new sighting cancelled.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createSightingCancel" object:nil];
}

#pragma mark -
#pragma mark - Delegation and Event Handling

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBObservationEditController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end