/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface BBObservationCreate : NSObject <
    RKObjectLoaderDelegate
>


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *observedOn;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *address;
@property BOOL isIdentificationRequired;
@property BOOL anonymiseLocation;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSArray *media;
@property (nonatomic, retain) NSArray *projectIds;


@end