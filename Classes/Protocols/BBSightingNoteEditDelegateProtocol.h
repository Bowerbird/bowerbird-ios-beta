/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBSightingNoteDescription, BBSightingNoteDescriptionCreate;


@protocol BBSightingNoteEditDelegateProtocol <NSObject>

@required
-(void)startAddDescription;
-(void)endAddDescription;
-(void)addDescription:(BBSightingNoteDescription *)description;
-(void)removeDescription:(NSString *)descriptionIdentifier;
-(void)editDescription:(BBSightingNoteDescriptionCreate *)description;
-(NSArray*)getDescriptions;
-(void)startAddTag;
-(void)endAddTag;
-(void)addTag:(NSString*)tag;
-(void)removeTag:(NSString*)tag;
-(NSArray*)getTags;
-(void)save;
-(void)cancel;

@end