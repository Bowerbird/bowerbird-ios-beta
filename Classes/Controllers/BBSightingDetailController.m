//
//  BBSightingController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 17/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBSightingDetailController.h"

static CGRect MapOriginalFrame;
static CGRect MapFullFrame;

@protocol BBLocationSelectDelegate <NSObject>
    
@end


@interface BBSightingDetailController()

@property (nonatomic,strong) BBSighting* sighting;
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic, strong) NSArray *locations;
-(MGBox*)displayMapInBox;
- (void)showAnnotationsOnMapWithLocations:(NSArray *)aLocations;
- (MKCoordinateRegion)regionThatFitsAllLocations:(PDLocation *)location;
@end

@implementation BBSightingDetailController {
    MGScrollView* sightingView;
    UIImage *arrow, *back;
    PhotoBox *fullSizeImage;
}

@synthesize mapView = _mapView;
@synthesize sighting = _sighting;
@synthesize identifier = _identifier;

#pragma mark -
#pragma mark - Setup and Render

-(BBSightingDetailController*)initWithSightingIdentifier:(NSString*)identifier {

    self = [super init];
    
    _identifier = identifier;
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBSightingDetailController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [UIColor blackColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    sightingView = (MGScrollView*)self.view;
    self.mapView = [[MKMapView alloc]init];
    
    // LOAD THIS OBSERVATION FROM THE SERVER
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/%@?%@", [BBConstants RootUriString], _identifier, @"X-Requested-With=XMLHttpRequest"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
    
    [SVProgressHUD showWithStatus:@"Loading Sighting"];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBSightingDetailController.viewDidLoad"];
    
    [super viewDidLoad];
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    back = [UIImage imageNamed:@"back.png"];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

#pragma mark -
#pragma mark - Utilities and Helpers

-(void)displaySighting {
    [BBLog Log:@"BBSightingDetailController.displaySighting"];
    
    // CONTAINER AND MODEL
    MGTableBox *info = [MGTableBox boxWithSize:[self screenSize]];
    info.backgroundColor = [UIColor whiteColor];
    BBObservation *observation = (BBObservation*)_sighting;

    // HEADING
    [info.topLines addObject:[self createHeaderLineWithDescription:_sighting.title]];

    // MEDIA
    [info.middleLines addObject:[self displayMedia:observation]];
    
    // USER
    [info.middleLines addObject:[self sightingUser:observation]];
    
    // CATEGORY
    [info.middleLines addObject:[self sightingCategory:observation.category]];
    
    // MAP
    [info.middleLines addObject:[self displayMapInBox]];
    
    // Add the Sighting to the View
    [sightingView.boxes addObject:info];    
    
    // NOTES
    for (BBObservationNote *observationNote in observation.notes) {
        [sightingView.boxes addObject:[self addObservationNote:observationNote]];
    }
    
    // CONTROLS
    [sightingView.boxes addObject:[self addDescribeIdentifyButtons:observation]];
    
    [sightingView layoutWithSpeed:0.3 completion:nil];
}

-(MGLine*)sightingCategory:(NSString*)category {
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [category lowercaseString]];
    PhotoBox *photo = [PhotoBox mediaForImage:[UIImage imageNamed:iconPath] size:CGSizeMake(50,50)];
    MGLine *categoryNameLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"Category: %@", category] right:nil size:CGSizeMake(210, 50)];
    categoryNameLine.underlineType = MGUnderlineNone;
    categoryNameLine.font = HEADER_FONT;
    MGLine *categoryLine = [MGLine lineWithLeft:photo right:categoryNameLine size:CGSizeMake(280, 50)];
    categoryLine.margin = UIEdgeInsetsMake(0, 0, 10, 10);
    categoryLine.underlineType = MGUnderlineNone;
    
    return categoryLine;
}

-(MGLine*)sightingUser:(BBObservation*)observation {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDate dateFormatHumanReadable]];
    
    // USER
    MGLine *userWhoAddedSighting = [self createUserProfileLineForUser:observation.user
                                                      withDescription:[NSString stringWithFormat:@"%@\nsighted %@", observation.user.name, [dateFormatter stringFromDate:observation.observedOnDate]]
                                                              forSize:CGSizeMake(IPHONE_STREAM_WIDTH-20, 60)];
    
    userWhoAddedSighting.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    userWhoAddedSighting.font = HEADER_FONT;

    return userWhoAddedSighting;
}

-(MGLine*)sightingNoteUser:(BBUser*)user forNote:(BBObservationNote*)note {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDate dateFormatHumanReadable]];
    
    // USER
    MGLine *userWhoAddedSighting = [self createUserProfileLineForUser:user
                                                      withDescription:[NSString stringWithFormat:@"%@\ndescribed %@", user.name, [dateFormatter stringFromDate:note.createdOn]]
                                                              forSize:CGSizeMake(IPHONE_STREAM_WIDTH-20, 60)];
    
    userWhoAddedSighting.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    userWhoAddedSighting.font = HEADER_FONT;
    
    return userWhoAddedSighting;
}

-(MGLine*)createHeaderLineWithDescription:(NSString*)description {
    
    MGBox *backArrow = [self getBackArrow];
    backArrow.margin = UIEdgeInsetsMake(0, 10, 0, 0);
    
    BBObservation *observation = (BBObservation*)_sighting;
    
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = [self screenSize].width - backArrow.width - horizontalPaddingTotalWidth;
    MGLine *descriptionLine = [MGLine multilineWithText:observation.title
                                               font:HEADER_FONT
                                              width:descriptionWidth
                                            padding:UIEdgeInsetsMake(15, horizontalPaddingTotalWidth/2, 0, horizontalPaddingTotalWidth/2)];
    
    // HEADER
    MGLine *header = [MGLine lineWithLeft:backArrow
                                    right:descriptionLine
                                     size:CGSizeMake([self screenSize].width, 60)];
    
    header.underlineType = MGUnderlineNone;
    header.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];;
    header.onTap =^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
    };
    
    return header;
}

-(MGLine *)createUserProfileLineForUser:(BBUser*)usr
                        withDescription:(NSString*)desc
                                forSize:(CGSize)size {
    [BBLog Log:@"BBUIControlHelper.createUserProfileDescriptionForUser"];
    
    // AVATAR
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:usr.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    // parameterise the allowable size for the description line. Allows caller to put an arrow to the left or right of the user profile.
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = size.width - 50 - horizontalPaddingTotalWidth;
    
    // ACTIVITY DISCRIPTION
    MGLine *description = [MGLine multilineWithText:desc
                                               font:HEADER_FONT
                                              width:descriptionWidth
                                            padding:UIEdgeInsetsMake(15, 0, 0, horizontalPaddingTotalWidth)];
    
    description.underlineType = MGUnderlineNone;
    
    // COMBINED AVATAR AND DESCRIPTION
    MGLine *user = [MGLine lineWithLeft:avatar
                                  right:description size:size];
    
    user.underlineType = MGUnderlineNone;
    
    return user;
}

-(MGBox*)displayMapInBox {
    MGBox *mapBox = [MGBox boxWithSize:CGSizeMake(300, [self screenSize].height/2)];
    
    mapBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.mapView = [[MKMapView alloc]initWithFrame:mapBox.frame];
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    [mapBox addSubview:self.mapView];
    
    MapOriginalFrame = self.mapView.frame;
    MapFullFrame = CGRectMake(0, 0, [self screenSize].width, [self screenSize].height);
    
    PDLocation *location = [[PDLocation alloc] initWithName:_sighting.title
                                                description:_sighting.address
                                                andLocation:CLLocationCoordinate2DMake(_sighting.latitude,_sighting.longitude)];
    
    __weak UINavigationController *nav = self.navigationController;
    mapBox.onTap = ^{
        BBDisplayLocationController *locationController = [[BBDisplayLocationController alloc]initWithLocation:location];
        [nav pushViewController:locationController animated:NO];
    };
    
    MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:location.location title:location.name subTitle:location.description];
    [self.mapView addAnnotation:mapPoint];
    MKCoordinateRegion region = [self regionThatFitsAllLocations:location];
    [self.mapView setRegion:region];
    
    MGBox *locationBox = [MGBox boxWithSize:CGSizeMake(300, 100)];
    locationBox.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    
    BBObservation *observation = (BBObservation*)_sighting;

    // LATITUDE
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Latitude:"
                                                                     andRightText:[NSString stringWithFormat:@"%f", observation.latitude]
                                                                        andHeight:30
                                                                     andLeftWidth:100
                                                                    andRightWidth:200]];
    
    
    // LONGITUDE
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Longitude:"
                                                                     andRightText:[NSString stringWithFormat:@"%f", observation.longitude]
                                                                        andHeight:30
                                                                     andLeftWidth:100
                                                                    andRightWidth:200]];
    
    //MGLine *addressLine = [MGLine lineWithLeft:@"Address:" multilineRight:observation.address width:300 minHeight:30];
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Address:"
                                                                      andRightText:observation.address
                                                                         andHeight:30
                                                                      andLeftWidth:100
                                                                     andRightWidth:200]];
    
    MGBox *mapWrapperBox = [MGBox box];
    [mapWrapperBox.boxes addObject:mapBox];
    [mapWrapperBox.boxes addObject:locationBox];
    
    return mapWrapperBox;
}

-(MGBox*)displayMedia:(BBObservation*)observation {
    
    MGBox *mediaWrapperBox = [MGBox box];
    
    BBImage *fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240"
                                                      fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    MGBox* currentImageBox = [MGBox box];
    currentImageBox.width = 300;
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:CGSizeMake(300, 240)];
    [currentImageBox.boxes addObject:currentPic];
    
    [mediaWrapperBox.boxes addObject:currentImageBox];
    MGBox *thumbs = [MGBox box];
    thumbs.width = 300;
    thumbs.contentLayoutMode = MGLayoutGridStyle;
    // add the thumb nails
    if(observation.media.count > 1)
    {
        // take the current box out - add the new box
        for (__block BBMedia* m in observation.media) {
            PhotoBox *thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.imageMedia].uri
                                            size:(CGSizeMake(90, 90))];
            thumb.onTap = ^{
                [self displayFullSizeImage:m toReplace:currentPic];
            };
            [thumbs.boxes addObject:thumb];
        }
    }
    [mediaWrapperBox.boxes addObject:thumbs];

    return mediaWrapperBox;
}

-(MKCoordinateRegion)regionThatFitsAllLocations:(PDLocation *)location {
    float Lat_Min = location.location.latitude -1, Lat_Max = location.location.latitude + 1;
    float Long_Max = location.location.longitude + 1, Long_Min = location.location.longitude - 1;
    
    CLLocationCoordinate2D min = CLLocationCoordinate2DMake(Lat_Min, Long_Min);
    CLLocationCoordinate2D max = CLLocationCoordinate2DMake(Lat_Max, Long_Max);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max.latitude + min.latitude) / 2.0, (max.longitude + min.longitude) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    return region;
}

-(void)displayFullSizeImage:(BBMedia*)media
                  toReplace:(PhotoBox*)content {
    [BBLog Log:@"BBSightingDetailController.displayFullSizeImage"];
    
    BBImage *fullSize = [self getImageWithDimension:@"Constrained240"
                                        fromArrayOf:media.mediaResource.imageMedia];
    
    BBImage *originalSize = [self getImageWithDimension:@"Original"
                                            fromArrayOf:media.mediaResource.imageMedia];
    
    PhotoBox *fullSizePhoto = [PhotoBox mediaFor:fullSize.uri
                                            size:CGSizeMake(300, 240)];
    
    
    __weak UINavigationController *nav = self.navigationController;
    fullSizePhoto.onTap = ^{
        BBDisplayFullImageController *fullImageController = [[BBDisplayFullImageController alloc]initWithImage:originalSize];
        [nav pushViewController:fullImageController animated:NO];
    };
    
    MGBox *section = (id)content.parentBox;
    [section.boxes removeAllObjects];
    [section.boxes addObject:fullSizePhoto];
    
    
    [section layoutWithSpeed:0.0 completion:nil];
}

-(MGTableBox*)addObservationNote:(BBObservationNote*)observationNote {
    
    MGTableBox *note = [MGTableBox boxWithSize:CGSizeMake(320, 100)];
    note.backgroundColor = [UIColor whiteColor];
    //note.margin = UIEdgeInsetsMake(5, 5, 5, 0);
       
    // IDENTIFICATION
    if(observationNote.identification) {
        [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        [note.middleLines addObject:[BBUIControlHelper createIdentification:observationNote.identification
                                                                    forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
    }
    
    // TAXONOMY
    if(![observationNote.taxonomy isEqualToString:@""]) {
        [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        MGLine *taxa = [MGLine multilineWithText:observationNote.taxonomy
                                            font:DESCRIPTOR_FONT
                                           width:IPHONE_STREAM_WIDTH
                                         padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxa.underlineType = MGUnderlineNone;
        [note.middleLines addObject:taxa];
    }
    
    // DESCRIPTIONS
    if(observationNote.descriptionCount > 0) {
        
        for (BBSightingNoteDescription* description in observationNote.descriptions) {
            
            [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:description.label
                                                                             forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            
            MGLine *descriptionLine = [MGLine multilineWithText:description.text
                                                           font:DESCRIPTOR_FONT
                                                          width:IPHONE_STREAM_WIDTH
                                                        padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            descriptionLine.underlineType = MGUnderlineNone;
            
            [note.middleLines addObject:descriptionLine];
        }
        
    }
    
    // TAGS
    if(observationNote.tagCount > 0) {
        [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Tags"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        // grab tags from controller
        NSArray *tags = [observationNote.allTags componentsSeparatedByString:@","];
        MGBox *tagBox;
        
        DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
        [tagList setTags:tags];
        
        double minHeight = tagList.fittedSize.height;
        
        tagBox = [MGBox boxWithSize:CGSizeMake(280, minHeight)];
        tagBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
        [tagBox addSubview:tagList];
        
        [note.middleLines addObject:tagBox];
    }
        
    // USER
    [note.bottomLines addObject:[self sightingNoteUser:observationNote.user forNote:observationNote]];
    
    return note;
}

-(MGBox*)addDescribeIdentifyButtons:(BBObservation*)observation {
    
    CoolMGButton *describeButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 155, 60) andTitle:@"Describe" withBlock:^{
        BBCreateSightingNoteController *createNoteController = [[BBCreateSightingNoteController alloc]initWithSightingId:observation.identifier];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:createNoteController animated:NO];
    }];
    
    describeButton.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    MGBox *describeBox = [MGBox boxWithSize:CGSizeMake(160, 50)];
    [describeBox.boxes addObject:describeButton];
    
    CoolMGButton *identifyButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 155, 60) andTitle:@"Identifiy" withBlock:^{
        BBIdentifySightingController *identifySightingController = [[BBIdentifySightingController alloc]initWithSightingId:observation.identifier];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:identifySightingController animated:NO];
    }];
    
    identifyButton.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    MGBox *identifyBox = [MGBox boxWithSize:CGSizeMake(160, 50)];
    [identifyBox.boxes addObject:identifyButton];
    
    MGBox *describeIdentifyBox = [MGBox boxWithSize:CGSizeMake(320, 50)];
    describeIdentifyBox.contentLayoutMode = MGLayoutGridStyle;
    [describeIdentifyBox.boxes addObject:describeBox];
    [describeIdentifyBox.boxes addObject:identifyBox];
    
    return describeIdentifyBox;
}

#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBSightingDetailController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBSightingDetailController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBSightingDetailController.objectLoader:didFailWithError:"];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}

-(void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBSightingDetailController.objectLoaderDidFinishLoading:"];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBSightingDetailController.objectLoader:didLoadObject:"];
    
    [SVProgressHUD dismiss];
    
    if([object isKindOfClass:[BBObservation class]]) {
        _sighting = object;
        [self displaySighting];
    }
}

-(MGBox*)getBackArrow {
    // Set up reusable forward and back arrows
    UIView *backArrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                         andDirection:BBArrowBack
                                       andArrowColour:[UIColor colorWithRed:0.26 green:0.57 blue:0.88 alpha:1.0]
                                          andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(backArrow.width, backArrow.height)];
    [arrowWrapper addSubview:backArrow];
    
    return arrowWrapper;
}

@end