/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBGroupHubClient.h"

@interface BBGroupHubClient()
-(void)ensureConnectionExists;
@end

@implementation BBGroupHubClient

@synthesize   groupHub = _groupHub;


static BBGroupHubClient* bowerbirdGroupHubClient = nil;

+(BBGroupHubClient*)sharedInstance
{
    if(bowerbirdGroupHubClient == nil)
    {
        bowerbirdGroupHubClient = [[super allocWithZone:NULL]init];
    }
    
    return bowerbirdGroupHubClient;
}

-(void)ensureConnectionExists
{
    self.connection = [SRHubConnection connectionWithURL:[BBConstants RootUriString]];
    self.groupHub = [self.connection createProxy:@"GroupHub"];
    
    [self.groupHub on:@"newActivity"
             perform:self
             selector:@selector(newActivity:)];
    
    [self.connection setDelegate:self];
    [self.connection start];
}

-(void)newActivity:(id)payload
{
    // trigger a whole bunch of events for the activity
}

@end