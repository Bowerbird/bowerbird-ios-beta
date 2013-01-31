/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBDatePickerDelegateProtocol.h"


@class BBDateSelectView;


@interface BBDateSelectController : BBControllerBase <BBDatePickerDelegateProtocol>

@property (nonatomic,retain) id controller;
@property (nonatomic,strong) BBDateSelectView *dateSelectView;

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate;
-(NSDate*)createdOn;
-(void)updateCreatedOn:(NSDate*)date;
-(void)createdOnStopEdit;

@end