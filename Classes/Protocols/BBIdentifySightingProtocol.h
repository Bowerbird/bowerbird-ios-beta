/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@protocol BBIdentifySightingProtocol <NSObject>

@required

-(void)searchClassifications;
-(void)browseClassifications;
-(void)createClassification;
-(void)removeClassification;
-(void)save;
-(void)cancel;

@end