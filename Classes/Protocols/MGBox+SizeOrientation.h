/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "MGBox.h"


@interface MGBox (SizeOrientation)

@property BOOL phone;
@property BOOL portrait;
@property (readonly) double deviceWidth;
@property (readonly) double deviceHeight;

-(void)setSizeAndOrientation:(UIInterfaceOrientation)orientation;

@end