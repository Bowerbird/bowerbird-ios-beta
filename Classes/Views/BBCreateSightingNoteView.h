/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBSightingNoteEditDelegateProtocol.h"
#import "MGHelpers.h"


@class BBClassification;


@interface BBCreateSightingNoteView : MGScrollView

@property (nonatomic,weak) id<BBSightingNoteEditDelegateProtocol> controller;

-(BBCreateSightingNoteView*)initWithDelegate:(id<BBSightingNoteEditDelegateProtocol>)delegate
                                     andSize:(CGSize)size;

-(void)displayIdentification:(BBClassification*)classification;

-(void)displayDescriptions;

-(void)displayTags;

@end