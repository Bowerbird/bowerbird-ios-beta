/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBDatePickerDelegateProtocol.h"


@interface BBDateSelectView : UIView <
     BBDatePickerDelegateProtocol
>

@property (nonatomic,retain) id<BBDatePickerDelegateProtocol> controller;
@property (nonatomic,strong) UIDatePicker *datePicker;

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate;

@end