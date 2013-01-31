/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@protocol BBSightingEditDelegateProtocol <NSObject>

@optional
-(void)updateTitle;
-(void)createdOnStartEdit;
-(NSArray*)media;
-(void)addMedia;
-(void)editMedia;
-(NSArray*)getSightingProjects;
-(void)removeSightingProject:(NSString*)projectId;
-(void)startAddingProjects;
-(void)stopAddingProjects;
-(void)editLocation;
-(CGPoint)getLocationLatLon;
-(NSString*)getLocationAddress;
-(void)locationStartEdit;
-(void)showCamera;
-(void)showLibrary;
-(void)categoryStartEdit;
-(NSString*)getCategory;
-(void)save;
-(void)cancel;
-(void)setUploadedMediaDisplayBox:(id)box toReferenceMedia:(NSString*)key;

@end