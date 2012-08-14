/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "Observation.h"

@interface Observation()

@property (nonatomic, weak) id<ObservationLoaded> delegate;

@end

@implementation Observation

@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize observedOnDate = _observedOnDate;
@synthesize address = _address;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize category = _category;
@synthesize isIdentificationRequired = _isIdentificationRequired;
@synthesize anonymiseLocation = _anonymiseLocation;
@synthesize media = _media;
@synthesize primaryMedia = _primaryMedia;
@synthesize user = _user;
@synthesize comments = _comments;


#pragma mark - Initializers and JSON readers

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate
{
    self = [self init];
    
    if([BowerBirdConstants Trace]) NSLog(@"Activity.initWithJson:");
    
    self.delegate = delegate;
    self.identifier = [dictionary objectForKey:@"Id"];
       
    
    self.user = [[User alloc]initWithJson:([dictionary objectForKey:@"User"]) andNotifyProjectLoaded:self];
    
    return self;
}




@end
