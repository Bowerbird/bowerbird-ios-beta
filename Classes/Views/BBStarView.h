/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <UIKit/UIKit.h>


typedef enum {
    BBFavouriteSelected,
    BBFavouriteNotSelected
} BBFavouriteType;


@interface BBStarView : UIView


- (id)initWithFrame:(CGRect)frame
   andFavouriteType:(BBFavouriteType)favourite
        andBgColour:(UIColor*)bgColour
        andStarSize:(float)starSize;


@end