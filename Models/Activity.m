/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "Activity.h"

@interface Activity()

@property (nonatomic, weak) id<ActivityLoaded> delegate;
@property (nonatomic,strong) NSDictionary* activities;

@end

@implementation Activity

@synthesize networkQueue;
@synthesize delegate = _delegate;
@synthesize identifier = _identifier;
@synthesize type = _type;
@synthesize createdOn = _createdOn;
@synthesize order = _order;
@synthesize description = _description;
@synthesize user = _user;
@synthesize groups = _groups;
@synthesize observation = _observation;
@synthesize post = _post;
@synthesize observationNote = _observationNote;
@synthesize activities = _activities;


#pragma mark - Initializers and JSON readers

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.initWithJson:");
    
    self.delegate = delegate;
    self.identifier = [dictionary objectForKey:@"Id"];
    self.type = [dictionary objectForKey:@"Type"];
    self.createdOn = [NSDate ConvertFromJsonDate:[dictionary objectForKey:@"CreatedOnDate"]];
    self.order = [dictionary objectForKey:@"CreatedDateTimeOrder"];
    self.description = [dictionary objectForKey:@"Description"];
    self.user = [[User alloc]initWithJson:([dictionary objectForKey:@"User"]) andNotifyProjectLoaded:self];
    // groups
    self.observation = [[dictionary objectForKey:@"ObservationAdded"] objectForKey:@"Observation"];
    // post
    // observation note
    
    return self;
}

-(NSDictionary *)loadActivitiesFromJson:(NSArray *)array
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.loadProjectsFromJson:");
    
    NSMutableDictionary* activities = [[NSMutableDictionary alloc]init];
    for (id activityDictionary in array) {
        Activity* activity = [[Activity alloc]initWithJson:activityDictionary andNotifyDelegate:self.delegate];
        if(activity){
            [activities setObject:activity forKey: activity.identifier];
        }
    }
    
    return activities;
}


#pragma mark - Network methods for loading Projects

- (void)doGetRequest:(NSURL *)withUrl
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.doGetRequest:");
    
	[[self networkQueue] cancelAllOperations];
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:withUrl];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    
    [[self networkQueue] addOperation:request];
	[[self networkQueue] go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.requestFinished:");
    
	if ([[self networkQueue] requestsCount] == 0){
		[self setNetworkQueue:nil];
	}
    
    [self loadActivitiesFromJson:[[[[[[SBJSON alloc] init] objectWithString:[request responseString] error:nil] objectForKey:@"Model"] objectForKey:@"Activities"] objectForKey:@"PagedListItems"]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.requestFailed:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.queueFinished:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}

-(void)ImageFinishedLoading:(id)forOwner
{
    if([BowerBirdConstants Trace]) NSLog(@"Activity.ImageFinishedLoading:");
}

@end