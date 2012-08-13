/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This Class represents the activity of the various streams
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "User.h"
#import "Group.h"
#import "Observation.h"
#import "Post.h"
#import "ObservationNote.h"
#import "SBJSON.h"
#import "ActivityLoaded.h"
#import "NSString+ConvertMethods.h"
#import "NSDate+ConvertMethods.h"

@interface Activity : NSObject <RequestDataFromServer, ImageLoaded>

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) NSString* order;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) User* user;
@property (nonatomic,strong) NSDictionary* groups;
@property (nonatomic,strong) Observation* observation;
@property (nonatomic,strong) Post* post;
@property (nonatomic,strong) ObservationNote* observationNote;

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate;

@end
