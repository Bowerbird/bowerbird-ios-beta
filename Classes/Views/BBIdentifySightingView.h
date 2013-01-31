/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <UIKit/UIKit.h>
#import "BBIdentifySightingProtocol.h"
#import "MGHelpers.h"
#import "BBClassification.h"


@interface BBIdentifySightingView : MGScrollView

@property (nonatomic,weak) id<BBIdentifySightingProtocol> controller;

-(BBIdentifySightingView*)initWithDelegate:(id<BBIdentifySightingProtocol>)delegate
                                     andSize:(CGSize)size;

-(void)displayIdentification:(BBClassification*)classification;

@end