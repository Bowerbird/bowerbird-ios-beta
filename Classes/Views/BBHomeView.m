/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBHomeView.h"
#import "BBHelpers.h"


@implementation BBHomeView


-(BBHomeView *)initWithSize:(CGSize)size {
    [BBLog Log:@"BBHomeView.initWithSize:"];
    
    self = [BBHomeView scrollerWithSize:size];
    self.tag = -1;
    self.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1];
    
    UIImage *logo = [UIImage imageNamed:@"background-icon.png"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logo];
    logoView.alpha = 0.5;
    
    logoView.center = CGPointMake(160, 220);
        
    [self addSubview:logoView];
    
    return self;
}


@end