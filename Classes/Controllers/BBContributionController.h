/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBControllerBase.h"


@class BBContributionController;


typedef enum {
    BBContributionCamera,
    BBContributionLibrary,
    BBContributionRecord,
    BBContributionNone
} ContributionType;


@interface BBContributionController : BBControllerBase <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

-(BBContributionController*)initWithCamera;
-(BBContributionController*)initWithLibrary;
-(BBContributionController*)initWithRecord;

@property (nonatomic) ContributionType contributionType;

@end