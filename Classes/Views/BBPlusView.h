/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <UIKit/UIKit.h>


@interface BBPlusView : UIView


- (id)initWithFrame:(CGRect)frame
        andBgColour:(UIColor*)bgColour
      andPlusColour:(UIColor*)plusColour
        andPlusSize:(float)plusSize;


@end