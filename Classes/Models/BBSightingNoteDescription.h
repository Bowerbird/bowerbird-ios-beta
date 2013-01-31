/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBCreateSightingNoteView.h"


@interface BBSightingNoteDescription : NSObject


@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* group;
@property (nonatomic,strong) NSString* label;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* text;


-(BBSightingNoteDescription*)initWithProperties:(NSString*)descriptionId
                                          group:(NSString*)descriptionGroup
                                     groupLabel:(NSString*)descriptionGroupLabel
                                           name:(NSString*)descriptionName
                                    description:(NSString*)descriptionDescription;


+(NSArray*)getSightingNoteDescriptions;
+(BBSightingNoteDescription*)getDescriptionByIdentifier:(NSString*)identifier;


@end