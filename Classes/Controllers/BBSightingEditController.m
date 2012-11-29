
//  BBObservationEditController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBSightingEditController.h"

@interface BBSightingEditController()

@property (nonatomic,retain) NSMutableDictionary* addedMedia;

@end

@implementation BBSightingEditController {
    BOOL isObservation;
}

@synthesize observation = _observation;
@synthesize observationEditView = _observationEditView;
@synthesize editingMedia = _editingMedia;
@synthesize locationManager = _locationManager;
@synthesize currentUserCoordinate = _currentUserCoordinate;
@synthesize spinner = _spinner;
@synthesize currentLocationActivityIndicatorView = _currentLocationActivityIndicatorView;
@synthesize addedMedia = _addedMedia;
@synthesize mediaResourceBoxes = _mediaResourceBoxes;

#pragma mark -
#pragma mark - Setup and Render

-(BBSightingEditController*)initWithMedia:(BBMediaEdit*)observationMedia {
    [BBLog Log:@"BBSightingEditController.initWithMedia:"];
    
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    isObservation = YES;
    _addedMedia = [[NSMutableDictionary alloc]init];
    _observation = [[BBSightingEdit alloc]init];
    _observation.createdOn = [NSDate date];
        
    [_observation addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [_observation addObserver:self forKeyPath:@"category" options:NSKeyValueObservingOptionNew context:NULL];
    
    /* -- REMOVING THE DEPENDENCY ON SIGNALR
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaResourceUploaded:)
                                                 name:@"notifyMediaResourceUploaded"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaResourceUploadFailed:)
                                                 name:@"notifyMediaResourceUploadFailed"
                                               object:nil];
    
     */
    
    [self addImageToObservation:observationMedia];
    
    return self;
}

-(BBSightingEditController*)initAsRecord {
    [BBLog Log:@"BBSightingEditController.initAsRecord:"];
    
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    isObservation = NO;
    
    _observation = [[BBSightingEdit alloc]init];
    _observation.createdOn = [NSDate date];
    
    [_observation addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [_observation addObserver:self forKeyPath:@"category" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBSightingEditController.loadView"];
    
    self.observationEditView = [[BBSightingEditView alloc]initWithDelegate:self asObservation:isObservation];
    self.view = self.observationEditView;
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBSightingEditController.viewWillAppear"];
    
    // perhaps here we load the map...
    BBLocationSelectController *locationSelectController = [[BBLocationSelectController alloc]initWithDelegate:self];
    MGLine *locationPickerLine = [MGLine lineWithLeft:locationSelectController.view right:nil size:CGSizeMake(280, 240)];
    
    [self validateForm];

    [((BBSightingEditView*)self.view).locationTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view).locationTable.bottomLines addObject:locationPickerLine];
    [((BBSightingEditView*)self.view) scrollToView:locationPickerLine withMargin:8];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBSightingEditController.viewDidLoad"];
    
    [super viewDidLoad];
}

-(void)pauseScrolling {
    ((BBSightingEditView*)self.view).scrollEnabled = NO;
}

-(void)resumeScrolling {
    ((BBSightingEditView*)self.view).scrollEnabled = YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self validateForm];
}

-(BOOL)validateForm {
    
    // empty the validation area of the view
    BBSightingEditView* this = (BBSightingEditView*)self.view;
    BOOL isValid = YES;
    
    [this.actionTable.middleLines removeAllObjects];
    
    if(_observation.category == nil || [_observation.category isEqualToString:@""]) {
        [this.actionTable.middleLines addObject:[MGLine lineWithLeft:@"Choose a Category" right:nil size:CGSizeMake(280, 30)]];
        isValid = NO;
    }
    
    if(_observation.title == nil || [_observation.title isEqualToString:@""]){
        [this.actionTable.middleLines addObject:[MGLine lineWithLeft:@"Add a Title" right:nil size:CGSizeMake(280, 30)]];
        isValid = NO;
    }
    
    [this layoutWithSpeed:0.3 completion:nil];
    
    return isValid;
}

#pragma mark -
#pragma mark - Title

-(NSString*)title {
    [BBLog Log:@"BBSightingEditController.title"];
    
    return self.observation.title;
}

-(void)updateTitle {
    [BBLog Log:@"BBSightingEditController.changeTitle"];
    
    self.observation.title = self.observationEditView.titleTextField.text;
}

-(void)changeTitle:(NSString *)title {
    [BBLog Log:@"BBSightingEditController.title"];
    
    self.observation.title = title;
}

#pragma mark -
#pragma mark - CreatedOn

-(NSDate*)createdOn {
    [BBLog Log:@"BBObservationEditController.createdOn"];
    
    return self.observation.createdOn;
}

-(void)createdOnStartEdit {
    [BBLog Log:@"BBSightingEditController.createdOnStartEdit"];
    
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
    [BBLog Log:@"BBSightingEditController.updateCreatedOn:"];
    
    if(date != nil) {
        self.observation.createdOn = date;
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        ((BBSightingEditView*)self.view).observedOnLabel.text = [dateFormatter stringFromDate:self.observation.createdOn];
    }
}

-(void)createdOnStopEdit {
    [BBLog Log:@"BBSightingEditController.createdOnStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).observedOnTable.onTap=^{[((BBSightingEditView*)self.view).controller createdOnStartEdit];};
    
    [((BBSightingEditView*)self.view).observedOnTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

#pragma mark -
#pragma mark - Media

-(void)showCamera {
    [BBLog Log:@"BBSightingEditController.showCamera"];
    
    //self.contributionType = BBContributionNone;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
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
 
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    }
}

-(void)showLibrary {
    [BBLog Log:@"BBSightingEditController.showLibrary"];
    
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

        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [BBLog Log:@"BBSightingEditController.imagePickerController:"];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [image normalizedImage];
    
    // if the camera didn't come from the library, save it there
    if(picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    BBMediaEdit *mediaEdit = [[BBMediaEdit alloc]initWithImage:image];
    
    [self addImageToObservation:mediaEdit];
}
    
-(void)addImageToObservation:(BBMediaEdit*)mediaEdit {
    [BBLog Log:@"BBSightingEditController.addImageToObservation:"];
    
    // now we have an image, we'll upload it setting this object up as a listener for completion:
    BBMediaResourceCreate *mediaResourceCreate = [[BBMediaResourceCreate alloc]initWithMedia:mediaEdit forUsage:@"contribution"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    //RKObjectMapping *map = [[manager mappingProvider] serializationMappingForClass:[BBMediaResourceCreate class]];
    //manager.serializationMIMEType = RKMIMETypeJSON;
    //[manager.mappingProvider setSerializationMapping:map forClass:[BBMediaResourceCreate class]];
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Uploading"]];
    
    //RKObjectLoader *loader =
    [manager postObject:mediaResourceCreate usingBlock:^(RKObjectLoader *loader) {
        loader.delegate = self;
        RKObjectMapping *map = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBMediaResourceCreate class]];
        NSError *error = nil;
        NSDictionary *d = [[RKObjectSerializer serializerWithObject:mediaResourceCreate mapping:map] serializedObject:&error];
        RKParams *p = [RKParams paramsWithDictionary:d];
        [p setData:mediaResourceCreate.file MIMEType:@"image/jpeg" forParam:@"file"];
        loader.params = p;
        loader.objectMapping = [[manager mappingProvider] objectMappingForClass:[BBJsonResponse class]];
    }];
    
    
    /*
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading Media";
    [HUD show:YES];
    */
    
    /* commented to test a lighter-weight attempt to post and process server json success response...
    [manager postObject:mediaResourceCreate usingBlock:^(RKObjectLoader *loader){
        RKObjectMapping *map = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBMediaResourceCreate class]];
        NSError *error = nil;
        NSDictionary *d = [[RKObjectSerializer serializerWithObject:mediaResourceCreate mapping:map] serializedObject:&error];
        
        RKParams *p = [RKParams paramsWithDictionary:d];
        [p setData:mediaResourceCreate.file MIMEType:@"image/jpeg" forParam:@"file"];
        loader.params = p;
        
        loader.objectMapping = [manager.mappingProvider objectMappingForClass:[BBJsonResponse class]];
        
        loader.delegate = self;
    }];
    */
    
    // add this to the list of media in our observation model
    [_observation.media addObject:mediaEdit];
}

-(void)mediaResourceUploadFailed:(NSNotification*)notification {
    [BBLog Log:@"BBSightingEditController.mediaResourceUploadFailed:"];
    
    // display an exclamation mark or something.
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [BBLog Log:@"BBSightingEditController.imagePickerControllerDidCancel"];
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(NSArray*)media {
    return self.observation.media;
}

-(void)addMedia {
    [BBLog Log:@"BBSightingEditController.addMedia"];
    
    // display the action sheet, or somthing of that kind..
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
    [BBLog Log:@"BBSightingEditController.categoryStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).categoryTable.onTap=^{[((BBSightingEditView*)self.view).controller categoryStartEdit];};
    
    [((BBSightingEditView*)self.view).categoryTable.bottomLines removeAllObjects];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

-(NSArray*)getCategories {
    [BBLog Log:@"BBSightingEditController.getCategories"];
    
    BBApplication *appData = [BBApplication sharedInstance];
    return appData.categories;
}

-(void)categoryStartEdit {
    [BBLog Log:@"BBSightingEditController.categoryOnStartEdit"];
    
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
    [BBLog Log:@"BBSightingEditController.stopAddingProjects"];
    
    [self resumeScrolling];
    BBSightingEditView *this = (BBSightingEditView*)self.view;
    
    this.projectsTable.onTap=^{[((BBSightingEditView*)self.view).controller startAddingProjects];};
    
    [this.projectsTable.bottomLines removeAllObjects];
    [this layoutWithSpeed:0.3 completion:nil];
}

-(void)startAddingProjects {
    [BBLog Log:@"BBSightingEditController.startAddingProjects"];
    
    //[self pauseScrolling];
    
    BBProjectSelectController *projectSelector = [[BBProjectSelectController alloc]initWithDelegate:self];
    //MGLine *projectSelectorLine = [MGLine lineWithSize:CGSizeMake(280,150)];
    MGLine *projectSelectorLine = [MGLine lineWithMultilineLeft:nil right:nil width:280 minHeight:150];
    
    //MGLine *projectSelectorLine = [MGLine line];
    [projectSelectorLine.middleItems addObject:projectSelector.view];
    
    BBSightingEditView *this = (BBSightingEditView*)self.view;
    this.projectsTable.onTap=^{};
    
    [((BBSightingEditView*)self.view).projectsTable.bottomLines addObject:projectSelectorLine];
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
    [((BBSightingEditView*)self.view) scrollToView:projectSelectorLine withMargin:8];
}

-(NSArray*)getSightingProjects {
    [BBLog Log:@"BBSightingEditController.getSightingProjects"];
    
    return _observation.projects;
}

-(void)removeSightingProject:(NSString*)projectId {
    [BBLog Log:@"BBSightingEditController.removeProject:"];
    
    BBProject *proj = [BBCollectionHelper getUserProjectById:projectId];
    
    [_observation removeProject:proj];
    
    [self drawCurrentSightingProjects];
}

-(void)addSightingProject:(NSString *)projectId {
    [BBLog Log:@"BBSightingEditController.addSightingProject:"];
    
    BBProject *proj = [BBCollectionHelper getUserProjectById:projectId];
    
    if(proj){
        [_observation addProject:proj];
        
        [self drawCurrentSightingProjects];
    } 
}

-(void)drawCurrentSightingProjects {
    [BBLog Log:@"BBSightingEditController.drawCurrentSightingProjects"];
    
    [((BBSightingEditView*)self.view).projectsTable.middleLines removeAllObjects];

    for (BBProject* proj in _observation.projects) {
        
        BBImage* projectImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:proj.avatar.imageMedia];
        PhotoBox *avatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        avatar.margin = UIEdgeInsetsZero;
        
        MGLine *projectDescription = [MGLine lineWithLeft:avatar right:proj.name size:CGSizeMake(100, 40)];
        [((BBSightingEditView*)self.view).projectsTable.middleLines addObject:projectDescription];
    }
    [((BBSightingEditView*)self.view) layoutWithSpeed:0.3 completion:nil];
}

#pragma mark -
#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    [BBLog Log:@"BBSightingEditController.locationManager:didUpdateLocation:"];
    
    CLLocation *location = [locations lastObject];
    self.observation.location = CGPointMake(location.coordinate.latitude, location.coordinate.longitude);
    [(BBSightingEditView*)self.view updateLatLongDisplay:self.observation.location];
    [self performCoordinateGeocode:location];
    
    [manager stopUpdatingLocation];
}

-(void)locationStartEdit {
    [BBLog Log:@"BBSightingEditController.locationStartEdit"];
    
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
    [BBLog Log:@"BBSightingEditController.locationStopEdit"];
    
    [self resumeScrolling];
    ((BBSightingEditView*)self.view).locationTable.onTap=^{[((BBSightingEditView*)self.view).controller locationStartEdit];};
    
    if([((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.topViewController isKindOfClass:[BBLocationSelectController class]])
    {
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    }
}

-(CGPoint)getLocationLatLon {
    [BBLog Log:@"BBSightingEditController.getLocationLatLon"];

    return self.observation.location;
}

-(void)updateLocationLatLon:(CGPoint)location {
    [BBLog Log:@"BBSightingEditController.updateLocationLatLon:"];

    self.observation.location = location;
}

-(NSString*)getLocationAddress {
    [BBLog Log:@"BBSightingEditController.getLocationAddress"];

    return self.observation.address;
}

-(void)updateLocationAddress:(NSString*)address {
    [BBLog Log:@"BBSightingEditController.updateLocationAddress:"];

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
        NSString* address = [NSString stringWithFormat:@"%@,%@%@%@",
                             place.thoroughfare != nil ? [NSString stringWithFormat:@" %@", place.thoroughfare] : @"",
                             place.locality != nil ? [NSString stringWithFormat:@" %@", place.locality] : @"",
                             place.administrativeArea != nil ? [NSString stringWithFormat:@" %@", place.administrativeArea] : @"",
                             place.country != nil ? [NSString stringWithFormat:@" %@", place.country] : @""];
        
        [BBLog Log:[NSString stringWithFormat:@"Address: %@", address]];
        [self updateLocationAddress:address];
        [view updateLocationAddress:address];
    }];
}

#pragma mark -
#pragma mark - Save or Cancel Observation

-(void)save {
    [BBLog Log:@"BBSightingEditController.save"];
    
    BBObservationCreate *observation = [[BBObservationCreate alloc]init];
    observation.title = _observation.title;
    observation.observedOn = _observation.createdOn;
    observation.category = _observation.category;
    observation.latitude = [NSString stringWithFormat:@"%f", _observation.location.x];
    observation.longitude = [NSString stringWithFormat:@"%f", _observation.location.y];
    observation.address = _observation.address;
    observation.isIdentificationRequired = YES;
    observation.anonymiseLocation = NO;
    __block NSMutableArray* projectIds = [[NSMutableArray alloc]init];
    [_observation.projects enumerateObjectsUsingBlock:^(BBProject *obj, NSUInteger idx, BOOL *stop) {
        [projectIds addObject:obj.identifier];
    }];
    observation.projectIds = [[NSArray alloc]initWithArray:projectIds];
    
    BBApplication *app = [BBApplication sharedInstance];
    
    int counter = 1;
    NSMutableArray *newMedia = [[NSMutableArray alloc]init];
    
    //for (NSString* mediaResourceId in _observation.mediaResourceIds) {
    for (BBMediaEdit* media in _observation.media) {
        BBObservationMediaCreate *observationMedia = [[BBObservationMediaCreate alloc]init];
        //observationMedia.mediaResourceId = mediaResourceId;
        observationMedia.key = media.key;
        observationMedia.licence = app.authenticatedUser.defaultLicence;
        observationMedia.isPrimaryMedia = counter == 1;
        observationMedia.description = @"Observed in the field using the BowerBird App";
        [newMedia addObject:observationMedia];
        counter ++;
    }
    observation.media = [[NSArray alloc]initWithArray:newMedia];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    //RKObjectMapping *map = [[manager mappingProvider] serializationMappingForClass:[BBObservationCreate class]];
    manager.serializationMIMEType = RKMIMETypeJSON;
    //[manager.mappingProvider setSerializationMapping:map forClass:[BBObservationCreate class]];
    
    // display HUD..
    //[SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Saving Observation"]];
    
    //NSString *observationCreateUrl = [NSString stringWithFormat:@"%@/%@", [BBConstants RootUriString], @"observations/create"];
    //[manager sendObject:observation toResourcePath:observationCreateUrl usingBlock:^(RKObjectLoader *loader) {
    [manager postObject:observation usingBlock:^(RKObjectLoader *loader) {
        
        // map native object to dictionary of key values
        RKObjectMapping *map = [[manager mappingProvider] serializationMappingForClass:[BBObservationCreate class]];
        NSError *error = nil;
        NSDictionary *d = [[RKObjectSerializer serializerWithObject:observation mapping:map] serializedObject:&error];
        
        // convert key value dictionary to json data object
        NSError *e;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:d options:0 error:&e];
        
        // convert json data object to a string
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        loader.params = [RKRequestSerialization serializationWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON];
    }];
}

-(void)observationSent {
    [BBLog Log:@"Observation finished sending"];
}

#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBSightingEditController.objectLoaderDidFailWithError:"];
    
    [BBLog Log:error.localizedDescription];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    [BBLog Log:@"BBSightingEditController.request:didFailLoadWithError:"];
    
    [BBLog Log:[NSString stringWithFormat:@"%@%@", @"ERROR:", error.localizedDescription]];
    
    [SVProgressHUD dismiss];
}

-(void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [BBLog Log:@"BBSightingEditController.request:didLoadResponse"];

    [BBLog Log:response.bodyAsString];
    
    
    if ([response isOK] && [response isJSON])
    {
        NSError* error = nil;
        id obj = [response parsedBody:&error];
        
        //RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthentication class]];
        RKObjectMapping *jsonResponseMap = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
        id mappedObject = [jsonResponseMap mappableObjectForData:obj];
        
        //id mappedObject = [authenticationMap mappableObjectForData:obj];
        // we have authenticated and are set to pull down the user's profile
        
        if([mappedObject isKindOfClass:[BBJsonResponse class]] && mappedObject != nil)
        {
            BBJsonResponse *serverJson = (BBJsonResponse*)mappedObject;
            
            if(serverJson.success)
            {
                [BBLog Log:@"Success"];
            }
            else {
                [BBLog Log:@"Failure"];
            }
        }
    }
    
    if([response isKindOfClass:[BBJsonResponse class]]){
        BBJsonResponse *result = (BBJsonResponse*)response;
        
        if(result.success){
            // the request was successfully completed
        }
        else {
            // the request was unsuccessful
        }
    }
    
}

-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBSightingEditController.objectLoaderDidLoadUnexpectedResponse"];

    [BBLog Log:objectLoader.response.bodyAsString];
}

-(void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBSightingEditController.objectLoaderDidFinishLoading:"];
    
    [SVProgressHUD dismiss];
    //[HUD show:NO];
    
    BBMediaEdit *media = [_observation.media lastObject];
    [_observationEditView addMediaItem:media];
}

-(void)processMappingResult:(RKObjectMappingResult *)result {
    [BBLog Log:@"BBSightingEditController.processMappingResult:"];
    
}

-(void)request:(RKRequest *)request didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive {
    [BBLog Log:[NSString stringWithFormat:@"bytes received: %d total received: %d total to receive: %d", bytesReceived, totalBytesReceived, totalBytesExpectedToReceive]];
}

-(void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    [BBLog Log:[NSString stringWithFormat:@"bytes written: %d total written: %d total to send: %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite]];
    
    double progress = ((double)totalBytesWritten/(double)totalBytesExpectedToWrite)*100;
    double fileSize = (double)totalBytesExpectedToWrite/10485760;// added additional factor of ten to bytes denomenator in MB as too big by about 10 X
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    [formatter setGeneratesDecimalNumbers:YES];
    [formatter setMaximumFractionDigits:1];
    
    [SVProgressHUD setStatus:[NSString stringWithFormat:@"%@%@%@Mb", [formatter stringFromNumber:[NSNumber numberWithDouble:progress]], @"% of ", [formatter stringFromNumber:[NSNumber numberWithDouble:fileSize]]]];
}

-(void)cancel {
    [BBLog Log:@"BBSightingEditController.cancel"];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
    
    // notify new sighting cancelled.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createSightingCancel" object:nil];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBSightingEditController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end