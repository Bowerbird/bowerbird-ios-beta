/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBControllerBase.h"


@class BBSightingNoteDescription, BBSightingNoteDescriptionCreate;


@interface BBSightingNoteEditDescriptionController : BBControllerBase <
    UITextFieldDelegate
>

-(BBSightingNoteEditDescriptionController *)initWithDescription:(BBSightingNoteDescription*)description;
-(BBSightingNoteEditDescriptionController *)initWithDescriptionEdit:(BBSightingNoteDescriptionCreate*)editDesc;

@end