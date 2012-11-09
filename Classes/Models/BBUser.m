/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@interface BBUser()

@property (nonatomic,strong) NSTimer* timer;
-(void)onTimerTick:(NSTimer *)timer;
-(void)startHeartbeatTimer;

@end

@implementation BBUser

@synthesize     identifier = _identifier,
                      name = _name,
            latestActivity = _latestActivity,
           latestHeartbeat = _latestHeartbeat,
                    avatar = _avatar,
                     timer = _timer,
                userStatus = _userStatus;


-(BBUser*)initWithObject:(id)user
{
    self = [self init];

    self.identifier = [user objectForKey:@"Id"];
    self.name = [user objectForKey:@"Name"];
    self.userStatus = online;
    [self updateLatestActivity:[user objectForKey:@"LatestActivity"]];
    [self updateLatestHearbeat:[user objectForKey:@"LatestHeartbeat"]];
    
    //[self setLatestHeartbeat:[NSDate date]];
    [self startHeartbeatTimer];
    
    return self;
}


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}


-(NSString*)identifier
{
    return _identifier;
}


-(void)setName:(NSString *)name
{
    _name = name;
}


-(NSString*)name
{
    return _name;
}


-(void)setAvatar:(BBMediaResource *)avatar
{
    _avatar = avatar;
}


-(BBMediaResource*)avatar
{
    return _avatar;
}


-(void)updateLatestActivity:(NSString *)latestActivity
{
    // parse the passed in date and set the status...
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setFormat:ISO8601DateFormatCalendar];
    [formatter setDefaultTimeZone:timeZone];
   
	formatter.parsesStrictly = YES;
    
    NSDate* date = [formatter dateFromString:latestActivity];
    [self setLatestActivity:date];
}


-(void)setLatestActivity:(NSDate *)latestActivity
{
    _latestActivity = latestActivity;   
}


-(NSDate*)latestActivity
{
    return _latestActivity;
}


-(void)updateLatestHearbeat:(NSString *)latestHearbeat
{
    // parse the passed in date and set the status...
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    [formatter setFormat:ISO8601DateFormatCalendar];
    [formatter setDefaultTimeZone:timeZone];
	formatter.parsesStrictly = YES;

    [self setLatestHeartbeat:[formatter dateFromString:latestHearbeat]];
}


-(void)setLatestHearbeat:(NSDate *)latestHeartbeat
{
    _latestHeartbeat = latestHeartbeat;
}


-(void)startHeartbeatTimer
{
    if(!self.timer || self.timer.isValid)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                      target:self
                                                    selector:@selector(onTimerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


-(void)stopHeartbeatTimer
{
    if(!self.timer || self.timer.isValid)
    {
        [self.timer invalidate];
    }
}


-(NSDate*)latestHeartbeat
{
    return _latestHeartbeat;
}


// as time passes, if the latest activity is not changing, change the status from online > away > offline.
-(void)onTimerTick:(NSTimer *)timer
{
    [self setLatestHearbeat:[NSDate date]];
    int activityInterval = [self.latestHeartbeat timeIntervalSinceDate:self.latestActivity];

    if(!activityInterval || activityInterval > 600) // ten minutes
    {
        if(self.userStatus != offline)
        {
            self.userStatus = offline;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    else if(activityInterval > 90)// a minute and a half
    {
        if(self.userStatus != away)
        {
            self.userStatus = away;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    else
    {
        if(self.userStatus != online)
        {
            self.userStatus = online;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    
    // call back to the mothership
    BBApplication* appData = [BBApplication sharedInstance];
    if([appData.user.identifier isEqualToString:self.identifier])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticatedUserStatusChanged" object:self];
    }
}


-(void)setNilValueForKey:(NSString *)theKey
{
//
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Id is the serverside representation of identifier.. had to change because of keyword id.
    if([key isEqualToString:@"Id"]) self.identifier = value;
}

@end