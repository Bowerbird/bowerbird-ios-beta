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

@end

@implementation BBSightingDetailController {
    MGScrollView* sightingView;
    UIImage *arrow, *back;
    PhotoBox *fullSizeImage;
}

@synthesize activity = _activity;
@synthesize mapView = _mapView;

#pragma mark -
#pragma mark - Setup and Render


-(BBSightingDetailController*)initWithActivity:(BBActivity*)activity {
    self = [super init];
    
    self.activity = activity;
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBSightingDetailController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    sightingView = (MGScrollView*)self.view;
    self.mapView = [[MKMapView alloc]init];
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

    [self displayImages];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayImages {
    [BBLog Log:@"BBSightingDetailController.displayImages"];
    
    MGTableBoxStyled *info = [MGTableBoxStyled boxWithSize:IPHONE_OBSERVATION];
    MGLine *description = [MGLine multilineWithText:self.activity.observation.title font:HEADER_FONT width:260 padding:UIEdgeInsetsMake(10, 5, 0, 0)];
    MGLine *header = [MGLine lineWithLeft:back right:description size:CGSizeMake(300, 60)];
    header.x +=10;
    [info.topLines addObject:header];
    header.onTap =^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
    };
    
    BBImage *fullSize = [self getImageWithDimension:@"Constrained240" fromArrayOf:self.activity.observation.primaryMedia.mediaResource.imageMedia];
    
    MGBox* currentImageBox = [MGBox boxWithSize:IPHONE_OBSERVATION];
    __block PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:IPHONE_OBSERVATION];
    [currentImageBox.boxes addObject:currentPic];
    [info.middleLines addObject:currentImageBox];
    MGBox *thumbs = [MGBox box];//boxWithSize:CGSizeMake(320, 50)];
    thumbs.parentBox.contentLayoutMode = MGLayoutGridStyle;
    thumbs.contentLayoutMode = MGLayoutGridStyle;
    //thumbs.sizingMode = MGResizingShrinkWrap;

    // add the thumb nails
    if(self.activity.observation.media.count > 1)
    {
        // take the current box out - add the new box
        for (__block BBMedia* m in self.activity.observation.media) {
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

-(PhotoBox*)getMapAsImageInPhotoBox
{
    NSString *lat,*lon;
    lat = [[NSString alloc]initWithFormat: @"%f", self.activity.observation.latitude];
    lon = [[NSString alloc]initWithFormat: @"%f", self.activity.observation.longitude];
    
    NSString* mapUrl = [NSString stringWithFormat:@"%@%@,%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",lat,lon,@"&zoom=10&size=290x200&sensor=false"];
    
    PhotoBox *map = [PhotoBox mediaForMap:mapUrl size:(CGSizeMake(290, 210))];
    return map;
}


// display thmap
-(void)displayMapInBox {
    self.mapView.size = CGSizeMake(320, 240);
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.activity.observation.latitude, self.activity.observation.longitude)];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBSightingDetailController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBSightingDetailController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end