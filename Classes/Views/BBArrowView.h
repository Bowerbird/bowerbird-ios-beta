/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <UIKit/UIKit.h>


typedef enum {
    BBArrowBack,
    BBArrowNext
} BBArrowType;


@interface BBArrowView : UIView


- (id)initWithFrame:(CGRect)frame
       andDirection:(BBArrowType)direction
     andArrowColour:(UIColor*)colour
        andBgColour:(UIColor*)bgColour;


@end