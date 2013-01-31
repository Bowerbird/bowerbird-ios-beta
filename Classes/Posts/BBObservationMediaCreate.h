/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBObservationMediaCreate : NSObject


@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* mediaResourceId;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* licence;
@property BOOL isPrimaryMedia;


@end