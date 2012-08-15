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
@synthesize projects = _projects;

#pragma mark - Initializers and JSON readers

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.initWithJson:");
    
    self = [self init];
    
    self.delegate = delegate;
    self.identifier = [dictionary objectForKey:@"Id"];
    self.title = [dictionary objectForKey:@"Title"];
    self.observedOnDate = [NSDate ConvertFromJsonDate:[dictionary objectForKey:@"ObservedOnDate"]];
    // not grabbing time at this point
    self.address = [dictionary objectForKey:@"Address"];
    self.latitude = [[dictionary objectForKey:@"Latitude"] floatValue];
    self.longitude = [[dictionary objectForKey:@"Longitude"] floatValue];
    self.category = [dictionary objectForKey:@"Category"];
    self.isIdentificationRequired = [[dictionary objectForKey:@"IsIdentificationRequired"] boolValue];
    self.anonymiseLocation = [[dictionary objectForKey:@"AnonymiseLocation"] boolValue];
    self.user = [[User alloc]initWithJson:([dictionary objectForKey:@"User"]) andNotifyProjectLoaded:self];
    self.projects = [dictionary objectForKey:@"Projects"];
    
    
    MediaResource* mediaResourceReader = [[MediaResource alloc]init];
    [mediaResourceReader loadMediaFromJson:[dictionary objectForKey:@"Media"]];
    self.media = mediaResourceReader.mediaResources;
    self.primaryMedia = [[MediaResource alloc]initWithJson:[dictionary objectForKey:@"PrimaryMedia"] andNotifyDelegate:self];
    
    return self;
}

@end
