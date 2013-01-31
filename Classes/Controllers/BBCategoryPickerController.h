/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBCategoryPickerDelegateProtocol.h"


@class BBCategoryPickerView;


@interface BBCategoryPickerController : BBControllerBase <
    BBCategoryPickerDelegateProtocol
>

@property (nonatomic,retain) id delegate; // parent controller
@property (nonatomic,strong) BBCategoryPickerView *categoryPickerView; // da view

-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate; // setup with pointer to parent
-(NSArray*)getCategories;
-(void)updateCategory:(NSString*)category; // pass new value up to delegate parent controller
-(void)categoryStopEdit; // we are finished editing so close this form


@end