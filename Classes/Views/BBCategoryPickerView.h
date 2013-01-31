/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBCategoryPickerDelegateProtocol.h"


@interface BBCategoryPickerView : UIView <
    BBCategoryPickerDelegateProtocol
    ,UIPickerViewDataSource
    ,UIPickerViewDelegate
>

@property (nonatomic,retain) id<BBCategoryPickerDelegateProtocol> controller;
@property (nonatomic,strong) UIPickerView *categoryPicker;
@property (nonatomic,strong) NSArray* categories;

-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate;

@end