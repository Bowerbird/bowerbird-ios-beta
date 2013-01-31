/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBBowerBirdHeaderLogo.h"


@implementation BBBowerBirdHeaderLogo


+(MGTableBox*)BowerBirdLogoHeading {
    
    MGTableBox *bbLogoBox = [MGTableBox boxWithSize:CGSizeMake(300, 100)];

    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-negative.png"]];
    MGLine *bowerbirdLogo = [MGLine lineWithLeft:bowerbirdImage right:nil size:CGSizeMake(300,100)];
    
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    
    [bbLogoBox.boxes addObject:bowerbirdLogo];
    
    return bbLogoBox;
}


@end