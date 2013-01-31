/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "MGScrollView.h"
#import "BBStreamProtocol.h"
#import "MGHelpers.h"


@interface BBStreamView : MGScrollView

@property (nonatomic,strong) UIView *tableFooterView;

-(BBStreamView*)initWithDelegate:(id<BBStreamProtocol>)delegate andSize:(CGSize)size;

-(void)renderStreamItem:(MGBox*)boxItem
                  atTop:(BOOL)displayAtTop;

@end