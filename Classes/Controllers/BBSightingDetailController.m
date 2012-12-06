//
//  BBSightingController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 17/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBSightingDetailController.h"

@interface BBSightingDetailController()

-(void)displayMapInBox;
@property (nonatomic,strong) BBSighting* sighting;
@property (nonatomic,strong) NSString* identifier;
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
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    sightingView = (MGScrollView*)self.view;
    self.mapView = [[MKMapView alloc]init];
    
    // hit the server for the observation:
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/%@?%@", [BBConstants RootUriString], _identifier, @"X-Requested-With=XMLHttpRequest"];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
    
    [SVProgressHUD showWithStatus:@"Loading Sighting"];
}

- (void)viewDidLoad {
    [BBLog Log:@"BBSightingDetailController.viewDidLoad"];
    
    [super viewDidLoad];
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    back = [UIImage imageNamed:@"back.png"];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];

    //[self displaySighting];
    
    //[self displayImages];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    
    //((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.toolbarHidden = NO;
    
}

#pragma mark -
#pragma mark - Utilities and Helpers

-(void)displaySighting {
    [BBLog Log:@"BBSightingDetailController.displaySighting"];

    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    info.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    
    BBObservation *observation = (BBObservation*)_sighting;
    
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = 300 - back.size.width - horizontalPaddingTotalWidth;
    MGLine *description = [MGLine multilineWithText:observation.title font:HEADER_FONT width:descriptionWidth padding:UIEdgeInsetsMake(15, horizontalPaddingTotalWidth/2, 0, horizontalPaddingTotalWidth/2)];
    
    // HEADER
    MGLine *header = [MGLine lineWithLeft:back right:description size:CGSizeMake(300, 60)];
    header.underlineType = MGUnderlineNone;
    [info.topLines addObject:header];
    
    header.onTap =^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
    };
    
    // USER
    MGLine *userProfile = [BBUIControlHelper createUserProfileLineForUser:observation.user
                                                          withDescription:[NSString stringWithFormat:@"%@ sighted %@", observation.user.name, [observation.observedOnDate timeAgo]]
                                                                  forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
    [info.middleLines addObject:userProfile];
    
    // MEDIA
    [info.middleLines addObject:[BBUIControlHelper createMediaViewerForMedia:observation.media
                                                                withPrimary:observation.primaryMedia
                                                                    forSize:CGSizeMake(300,270)
                                                           displayingThumbs:YES]];
    
    // OBSERVED ON
    MGLine *observedOnLine = [BBUIControlHelper createTwoColumnRowWithleftText:@"Observed:"
                                                                  andRightText:observation.observedOnDate.description
                                                                     andHeight:30
                                                                  andLeftWidth:120
                                                                 andRightWidth:180];
    [info.middleLines addObject:observedOnLine];
    
    // CATEGORY
    MGLine *categoryLine = [BBUIControlHelper createTwoColumnRowWithleftText:@"Category:"
                                                                andRightText:observation.category
                                                                   andHeight:30
                                                                andLeftWidth:120
                                                               andRightWidth:180];
    [info.middleLines addObject:categoryLine];
    
    // LOCATION
    MGLine *latitudeLine = [BBUIControlHelper createTwoColumnRowWithleftText:@"Latitude:"
                                                                andRightText:[NSString stringWithFormat:@"%f", observation.latitude]
                                                                   andHeight:30
                                                                andLeftWidth:120
                                                               andRightWidth:180];
    [info.middleLines addObject:latitudeLine];
    
    MGLine *longitudeLine = [BBUIControlHelper createTwoColumnRowWithleftText:@"Longitude:"
                                                                andRightText:[NSString stringWithFormat:@"%f", observation.longitude]
                                                                   andHeight:30
                                                                andLeftWidth:120
                                                               andRightWidth:180];
    [info.middleLines addObject:longitudeLine];

//    MGLine *addressLineValue = [MGLine multilineWithText:observation.address font:DESCRIPTOR_FONT width:180 padding:UIEdgeInsetsZero];
//    MGLine *addressLineLabel = [MGLine lineWithLeft:@"Address:" right:nil size:CGSizeMake(100, 30)];
    MGLine *addressLine = [MGLine lineWithLeft:@"Address:" multilineRight:observation.address width:300 minHeight:30];
    [info.middleLines addObject:addressLine];
    
    // MAP
    
    [sightingView.boxes addObject:info];    
    
    // NOTES
    for (BBObservationNote *observationNote in observation.notes) {
        
        MGTableBoxStyled *note = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
        note.margin = UIEdgeInsetsMake(5, 5, 5, 0);

        // NOTES PERPETRATOR:
        // USER
        MGLine *userNoteProfile = [BBUIControlHelper createUserProfileLineForUser:observationNote.user
                                                              withDescription:[NSString stringWithFormat:@"%@ added a note %@", observationNote.user.name, [observationNote.createdOn timeAgo]]
                                                                      forSize:CGSizeMake(IPHONE_STREAM_WIDTH - arrow.size.width, 60)];
        [note.topLines addObject:userNoteProfile];
        
        // show the identification
        if(observationNote.identification) {
            [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            [note.middleLines addObject:[BBUIControlHelper createIdentification:observationNote.identification forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
        }
        // show the taxonomy
        if(![observationNote.taxonomy isEqualToString:@""]) {
            [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            MGLine *taxa = [MGLine multilineWithText:observationNote.taxonomy font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            taxa.underlineType = MGUnderlineNone;
            [note.middleLines addObject:taxa];
        }
        // show descriptions
        if(observationNote.descriptionCount > 0) {
            for (BBSightingNoteDescription *description in observationNote.descriptions) {
                [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:description.label forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
                MGLine *descriptionLine = [MGLine multilineWithText:description.text font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
                [note.middleLines addObject:descriptionLine];
            }
        }
        // show tags
        if(observationNote.tagCount > 0) {
            [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Tags" forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            MGLine *tagLine = [MGLine multilineWithText:observationNote.allTags font:DESCRIPTOR_FONT width:IPHONE_STREAM_WIDTH padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            tagLine.font = DESCRIPTOR_FONT;
            [note.middleLines addObject:tagLine];
        }
        
        [sightingView.boxes addObject:note];
    }
    
    MGBox *addNoteBox = [MGBox boxWithSize:CGSizeMake(320, 50)];
    addNoteBox.contentLayoutMode = MGLayoutGridStyle;
    
    /*
    CoolMGButton *identifyButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 60) andTitle:@"Identify" withBlock:^{
        BBIdentificationController *identificationController = [[BBIdentificationController alloc]init];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:identificationController animated:NO];
    }];
    identifyButton.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    [addNoteBox.boxes addObject:identifyButton];
    
    CoolMGButton *describeButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 60) andTitle:@"Describe" withBlock:^{
        //
    }];
    describeButton.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    [addNoteBox.boxes addObject:describeButton];
    
    CoolMGButton *tagButton =[BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 100, 60) andTitle:@"Tag" withBlock:^{
        //
    }];
     
    
    tagButton.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    [addNoteBox.boxes addObject:tagButton];
    */
    
    CoolMGButton *addNoteButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 310, 60) andTitle:@"Add a Note" withBlock:^{
        BBIdentificationController *identificationController = [[BBIdentificationController alloc]init];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:identificationController animated:NO];
    }];
    addNoteButton.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [addNoteBox.boxes addObject:addNoteButton];
    
    [sightingView.boxes addObject:addNoteBox];
    
    [sightingView layoutWithSpeed:0.3 completion:nil];
}

-(void)displayImages {
    [BBLog Log:@"BBSightingDetailController.displayImages"];
        
    BBObservation *observation = (BBObservation*)_sighting;
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    MGLine *description = [MGLine multilineWithText:observation.title font:HEADER_FONT width:260 padding:UIEdgeInsetsMake(10, 5, 0, 0)];
    MGLine *header = [MGLine lineWithLeft:back right:description size:CGSizeMake(300, 60)];
    header.x +=10;
    header.underlineType = MGUnderlineNone;
    
    [info.topLines addObject:header];
    header.onTap =^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
    };
    
    BBImage *fullSize = [self getImageWithDimension:@"Constrained240" fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    
    MGBox* currentImageBox = [MGBox boxWithSize:IPHONE_OBSERVATION];
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:IPHONE_OBSERVATION];
    [currentImageBox.boxes addObject:currentPic];
    [info.middleLines addObject:currentImageBox];
    MGBox *thumbs = [MGBox box];//boxWithSize:CGSizeMake(320, 50)];
    thumbs.parentBox.contentLayoutMode = MGLayoutGridStyle;
    thumbs.contentLayoutMode = MGLayoutGridStyle;
    //thumbs.sizingMode = MGResizingShrinkWrap;

    // add the thumb nails
    if(observation.media.count > 1)
    {
        // take the current box out - add the new box
        for (__block BBMedia* m in observation.media) {
            PhotoBox *thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square50" fromArrayOf:m.mediaResource.imageMedia].uri size:(CGSizeMake(50, 50))];
            thumb.onTap = ^{[self displayFullSizeImage:m toReplace:currentPic];};
            [thumbs.boxes addObject:thumb];
        }
    }
    [info.middleLines addObject:thumbs];
//    [info.bottomLines addObject:[self displayMapInBox]];
    [info.bottomLines addObject:[self getMapAsImageInPhotoBox]];
    [sightingView.boxes addObject:info];
    [sightingView layoutWithSpeed:0.3 completion:nil];
}

-(void)displayFullSizeImage:(BBMedia*)media toReplace:(PhotoBox*)content {
    [BBLog Log:@"BBSightingDetailController.displayFullSizeImage"];
    
    BBImage *fullSize = [self getImageWithDimension:@"Constrained240" fromArrayOf:media.mediaResource.imageMedia];
    MGBox *section = (id)content.parentBox;
    [section.boxes removeAllObjects];
    [section.boxes addObject:[PhotoBox mediaFor:fullSize.uri size:IPHONE_OBSERVATION]];
    [section layoutWithSpeed:0.0 completion:nil];
}

// push this to a helper 
-(PhotoBox*)getMapAsImageInPhotoBox {
    [BBLog Log:@"BBSightingDetailController.getMapAsImageInPhotoBox"];
    
    BBObservation *observation = (BBObservation*)_sighting;
    
    NSString *lat,*lon;
    lat = [[NSString alloc]initWithFormat: @"%f", observation.latitude];
    lon = [[NSString alloc]initWithFormat: @"%f", observation.longitude];
    
    NSString* mapUrl = [NSString stringWithFormat:@"%@%@,%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",lat,lon,@"&zoom=10&size=290x200&sensor=false"];
    
    PhotoBox *map = [PhotoBox mediaForMap:mapUrl size:(CGSizeMake(290, 210))];
    return map;
}

// display thmap
-(void)displayMapInBox {
    
    BBObservation *observation = (BBObservation*)_sighting;
    
    self.mapView.size = CGSizeMake(320, 240);
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(observation.latitude, observation.longitude)];
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
    
    //[MBProgressHUD HUDForView:<#(UIView *)#>]
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBSightingDetailController.objectLoader:didLoadObject:"];
    
    [SVProgressHUD dismiss];
    
    if([object isKindOfClass:[BBObservation class]]) {
        _sighting = object;
        [self displaySighting];
    }
}

@end