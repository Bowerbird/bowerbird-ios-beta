/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@class BBUser;


@interface BBAuthenticatedUser : NSObject <
    RKObjectLoaderDelegate
>


@property (nonatomic, retain) BBUser* user;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* projects;
@property (nonatomic, retain) NSArray* organisations;
@property (nonatomic, retain) NSArray* userProjects;
@property (nonatomic, retain) NSArray* memberships;
@property (nonatomic, retain) NSString* defaultLicence;


@end