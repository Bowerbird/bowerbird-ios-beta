/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface BBMapPoint : NSObject <MKAnnotation> {
    NSString *title;
    CLLocationCoordinate2D coordinate;
}


// A new designated initializer for instances of MapPoint
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

// This is a required property from MKAnnotation
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate; 

// This is an optional property from MKAnnotation
@property (nonatomic, copy) NSString *title;


@end