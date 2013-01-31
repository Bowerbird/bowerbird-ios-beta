/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "UIView+Categories.h"


@class BBHeaderController;


@interface BBUserHeadingView : MGBox

@property (nonatomic,weak) UIButton *menuBtn;
@property (nonatomic,weak) UIButton *actionBtn;
@property (nonatomic,strong) UILabel *headingLabel;

-(BBUserHeadingView *)initWithSize:(CGSize)size
                     andTitle:(NSString *)title;

-(void)setHeadingText:(NSString*)heading;

@end