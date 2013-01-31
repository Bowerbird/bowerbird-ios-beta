/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBMediaEdit;


@protocol BBSightingDataSource <NSObject>

@optional
-(void)changeTitle:(NSString*)title;
-(NSString*)title;
-(void)addMedia:(BBMediaEdit*)media;
-(void)removeMedia:(BBMediaEdit*)media;
-(NSArray*)media;
-(void)changeLocation:(CGPoint)location;
-(CGPoint)location;
-(void)changeAddress:(NSString*)address;
-(NSString*)address;
-(void)addProject:(NSString*)projectId;
-(void)removeProject:(NSString*)projectId;
-(NSArray*)projects;
-(void)changeCategory:(NSString*)category;
-(NSString*)category;
-(void)changeDate:(NSDate*)date;
-(NSDate*)createdOn;

@end