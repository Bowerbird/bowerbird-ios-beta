/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "User.h"
#import "NSDate+ConvertMethods.h"

@interface Comment : NSObject

@property (nonatomic,strong) NSNumber* identifier;
@property (nonatomic,strong) NSString* sequentialId;
@property (nonatomic,strong) NSDate* commentedOn;
@property (nonatomic,strong) User* user;
@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSArray* comments;


-(Comment*)initWithJson:(NSDictionary*)comment;

-(NSArray*)loadCommentsFromJson:(NSArray*)array;

@end
