/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@class BBObservation;


@interface BBVoteCreate : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* subIdentifier;
@property (nonatomic,strong) NSString* contributionType;
@property (nonatomic,strong) NSString* subContributionType;
@property (nonatomic,strong) NSNumber* score;

-(id)initWithObservation:(BBObservation*)observation
                andScore:(NSNumber*)score;

-(void)increment;
-(void)decrement;


@end