/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BBLocationEditDelegateProtocol.h"
#import "BBControllerBase.h"


@class BBLocationSelectView;


@interface BBLocationSelectController : BBControllerBase <
    BBLocationEditDelegateProtocol
    ,CLLocationManagerDelegate
    ,MKMapViewDelegate
>

@property (nonatomic,retain) id controller; // parent controller
@property (nonatomic,strong) BBLocationSelectView *locationSelectView; // da view

-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate; // setup with pointer to parent


@end