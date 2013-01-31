/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBMediaEdit, BBProject;


@interface BBSightingEdit : NSObject


@property (nonatomic,strong) NSString* category;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) NSMutableArray *media;
@property (nonatomic,strong) NSMutableArray *mediaResourceIds;
@property CGPoint location;
@property (nonatomic,strong) NSString* address;
@property BOOL isHidden;
@property (nonatomic,strong) NSArray* projects;
@property (nonatomic,strong) NSMutableSet *projectsObservationIsIn, *projectsObservationIsNotIn;
-(void)addProject:(BBProject *)project;
-(void)removeProject:(BBProject *)project;
-(NSDictionary*)buildPostModel;


@end