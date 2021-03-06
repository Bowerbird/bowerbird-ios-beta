/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Display a map pin pointing the location for a sighting
 
 -----------------------------------------------------------------------------------------------*/


#import "BBDisplayLocationController.h"
#import "PDLocation.h"
#import "MapPoint.h"
#import "BBSightingDetailController.h"
#import "BBUIControlHelper.h"


@implementation BBDisplayLocationController {
    PDLocation *pointLocation;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize mapView = _mapView,
            tapGesture = _tapGesture;


#pragma mark -
#pragma mark - Constructors


-(id)initWithLocation:(PDLocation*)location {
    
    self = [super init];
    
    if(self) {
        pointLocation = location;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


- (void)loadView {
    self.view = [self displayMapInBox];
}

-(void)viewWillAppear:(BOOL)animated {
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(MGBox*)displayMapInBox {
    MGBox *mapBox = [MGBox boxWithSize:CGSizeMake(320, [self screenSize].height/2)];
    mapBox.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    CoolMGButton *backBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 320, 50)
                                                            andTitle:@"Back to Sighting"
                                                           withBlock:^{
        //[((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popToViewController:self.parentViewController animated:NO];
        [[self navigationController] popViewControllerAnimated:NO];
    }];
    
    CGRect frame = CGRectMake(0, 50, [self screenSize].width, [self screenSize].height - 50);
    
    self.mapView = [[MKMapView alloc]initWithFrame:frame];
    [mapBox addSubview:backBtn];
    [mapBox addSubview:self.mapView];
    
    MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:pointLocation.location
                                                        title:pointLocation.name
                                                     subTitle:pointLocation.description];
    
    [self.mapView addAnnotation:mapPoint];
    MKCoordinateRegion region = [self regionThatFitsAllLocations:pointLocation];
    [self.mapView setRegion:region];
    
    return mapBox;
}

- (MKCoordinateRegion)regionThatFitsAllLocations:(PDLocation *)location {
    float Lat_Min = location.location.latitude -1, Lat_Max = location.location.latitude + 1;
    float Long_Max = location.location.longitude + 1, Long_Min = location.location.longitude - 1;
    
    CLLocationCoordinate2D min = CLLocationCoordinate2DMake(Lat_Min, Long_Min);
    CLLocationCoordinate2D max = CLLocationCoordinate2DMake(Lat_Max, Long_Max);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max.latitude + min.latitude) / 2.0, (max.longitude + min.longitude) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    return region;
}


@end